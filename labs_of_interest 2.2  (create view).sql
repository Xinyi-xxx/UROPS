set search_path to xy, eicu, public;


-- REVISED some values are stored in labresultTEXT only min(labdata), max(labdata) group by labName                     
DROP MATERIALIZED VIEW IF EXISTS lab_minmax CASCADE;
CREATE MATERIALIZED VIEW lab_minmax as
select 
patientunitstayid, uniquepid, 
max(age) as age,max(gender) as gender, max(mort_icu) as mort_icu, max(los) as los

,max(case when lablabel = 'ALBUMIN' then labdata else null end) as ALBUMIN_max
,min(case when lablabel = 'ALBUMIN' then labdata else null end) as ALBUMIN_min

,max(case when lablabel = 'BICARBONATE' then labdata else null end) as BICARBONATE_max
,min(case when lablabel = 'BICARBONATE' then labdata else null end) as BICARBONATE_min

,max(case when lablabel = 'BUN' then labresult else null end) as BUN_max
,min(case when lablabel = 'BUN' then labresult else null end) as BUN_min

,max(case when lablabel = 'CALCIUM' then labdata else null end) as CALCIUM_max
,min(case when lablabel = 'CALCIUM' then labdata else null end) as CALCIUM_min

,max(case when lablabel = 'FREECALCIUM' then labdata else null end) as FREECALCIUM_max
,min(case when lablabel = 'FREECALCIUM' then labdata else null end) as FREECALCIUM_min

,max(case when lablabel = 'CHLORIDE' then labdata else null end) as CHLORIDE_max
,min(case when lablabel = 'CHLORIDE' then labdata else null end) as CHLORIDE_min

,max(case when lablabel = 'MAGNESIUM' then labdata else null end) as MAGNESIUM_max
,min(case when lablabel = 'MAGNESIUM' then labdata else null end) as MAGNESIUM_min

,max(case when lablabel = 'PHOSPHATE' then labdata else null end) as PHOSPHATE_max
,min(case when lablabel = 'PHOSPHATE' then labdata else null end) as PHOSPHATE_min

,max(case when lablabel = 'HEMOGLOBIN' then labdata else null end) as HEMOGLOBIN_max
,min(case when lablabel = 'HEMOGLOBIN' then labdata else null end) as HEMOGLOBIN_min

,max(case when lablabel = 'SODIUM' then labdata else null end) as SODIUM_max
,min(case when lablabel = 'SODIUM' then labdata else null end) as SODIUM_min

,max(case when lablabel = 'CREATININE' then labdata else null end) as CREATININE_max
,min(case when lablabel = 'CREATININE' then labdata else null end) as CREATININE_min

,max(case when lablabel = 'GLUCOSE' then labdata else null end) as GLUCOSE_max
,min(case when lablabel = 'GLUCOSE' then labdata else null end) as GLUCOSE_min

,max(case when lablabel = 'PLATELET' then labdata else null end) as PLATELET_max
,min(case when lablabel = 'PLATELET' then labdata else null end) as PLATELET_min

,max(case when lablabel = 'POTASSIUM' then labdata else null end) as POTASSIUM_max
,min(case when lablabel = 'POTASSIUM' then labdata else null end) as POTASSIUM_min

,max(case when lablabel = 'LACTATE' then labdata else null end) as LACTATE_max
,min(case when lablabel = 'LACTATE' then labdata else null end) as LACTATE_min

,max(case when lablabel = 'WBC' then labdata else null end) as WBC_max
,min(case when lablabel = 'WBC' then labdata else null end) as WBC_min

from lab_1st_24h group by patientunitstayid, uniquepid;
-- old SELECT 135718
--new with labresultText SELECT 135726
--new with checked labresult 135728

--\copy (select * from lab_minmax) to 'S:\\NUS\\Year Two\\UROPS\\eicu_lab_minmax.csv' with csv



DROP MATERIALIZED VIEW IF EXISTS lab_minmax_adt CASCADE;
CREATE MATERIALIZED VIEW lab_minmax_adt as

with temptable as 
(
    select patientUnitStayID as pid, 
	case 
	WHEN age LIKE '> 89' THEN 90
	WHEN age LIKE '' THEN 0
	ELSE cast (age as integer) 
	END AS age_int 
	from lab_minmax
)

select * from lab_minmax 
inner join temptable on temptable.pid = lab_minmax.patientunitstayid
where temptable.age_int>15 order by age;
--SELECT 135592