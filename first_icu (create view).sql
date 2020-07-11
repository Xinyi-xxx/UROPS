set search_path to xy, eicu, public;

-- select first icu (get more demographic data if needed)
DROP MATERIALIZED VIEW IF EXISTS first_icu CASCADE;
CREATE MATERIALIZED VIEW first_icu as

with temptable as 
(select uniquepid, patientunitstayid, patienthealthsystemstayid, age, gender,
-- add info about icu mortality 
case when unitDischargeStatus like 'Expired' then 1 
     when unitDischargeStatus like 'Alive' then 0
     else null
     end as mort_icu,
-- add info about length of stay 
cast (unitDischargeOffset as float)/1440 as los,
rank() OVER (Partition by uniquepid ORDER BY hospitaladmityear) as rank_year,
rank() OVER (Partition by hospitaladmityear, uniquepid ORDER BY hospitaladmittime24) as rank_time24, 
rank() OVER (Partition by hospitaladmityear, hospitaladmittime24, uniquepid ORDER BY hospitaladmitoffset DESC) as rank_admitoffset,
hospitaladmityear,hospitaladmittime24, hospitaladmitoffset

from patient ORDER BY uniquepid)

select uniquepid, patientunitstayid, patienthealthsystemstayid, age, gender, mort_icu, los, hospitaladmityear,hospitaladmittime24, hospitaladmitoffset
from temptable where rank_year=1 and rank_time24=1 and rank_admitoffset=1;
-- SELECT 3635650

-- add info about mech vent, vaso press and severity score, 
    --table: apacheApsVar columns: vent
    --materialized view: pivoted_treatment_vasopressor columns: patientunitstayid | chartoffset | vasopressor
-- oasis 
    --table: apachePatientResult columns: patientUnitStayID, acutePhysiologyScore (APS similar to oasis), apacheScore
-- add info about first and last care unit 


DROP MATERIALIZED VIEW IF EXISTS first_icu_add CASCADE;
CREATE MATERIALIZED VIEW first_icu_add as

select icu.uniquepid, icu.patientunitstayid, icu.patienthealthsystemstayid, icu.age, icu.mort_icu, icu.los, icu.hospitaladmityear, icu.hospitaladmittime24, icu.hospitaladmitoffset 
, 
case when vp.chartoffset >= -1440 and vp.chartoffset<=1440 then 1 else 0 end as vasopressor, 
vp.chartoffset, apsv.vent --offset?
, aps.acutePhysiologyScore
from xy.first_icu icu 
left join public.pivoted_treatment_vasopressor vp on vp.patientunitstayid = icu.patientunitstayid 
left join eicu.apacheApsVar apsv on apsv.patientunitstayid = icu.patientunitstayid
left join eicu.apachePatientResult aps on aps.patientunitstayid = icu.patientunitstayid;

--select * from first_icu icu left join public.pivoted_treatment_vasopressor vp on vp.patientunitstayid = icu.patientunitstayid;



-- \i 'S:/NUS/Year Two/UROPS/My SQL/eicu/first_icu (create view).sql'
-- \i 'S:/NUS/Year Two/UROPS/My SQL/eicu/labs_of_interest 2.1  (create view).sql'
-- \i 'S:/NUS/Year Two/UROPS/My SQL/eicu/labs_of_interest 2.2  (create view).sql'