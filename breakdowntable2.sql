set search_path to mimiciii;

DROP MATERIALIZED VIEW IF EXISTS firsticu_wole CASCADE;
CREATE MATERIALIZED VIEW firsticu_wole AS

SELECT DISTINCT ON (fa.icustay_id) fa.icustay_id, fa.subject_id, fa.hadm_id,  fa.intime, fa.outtime, fa.deathtime, fa.los, fa.admit_age, fa.gender, fa.mort_icu,
fa.mort_hosp, fa.first_careunit, --fa.last_careunit,

os.oasis, 
CASE WHEN vp.endtime  >= (fa.intime - interval '24 hour') or vp.starttime <= (fa.outtime + interval '24 hour') then 'TRUE'
ELSE NULL 
END AS if_vasopressor, 
--if the use of mechanical ventilation is true
CASE WHEN vs.mechvent = 1.0 --AND (vd.endtime  >= (fa.intime - interval '24 hour') or vd.starttime <= (fa.outtime + interval '24 hour'))
THEN 1 ELSE 0 END AS if_mechvent,
vp.vasonum
	
FROM firsticu_adult fa

LEFT JOIN oasis os on fa.icustay_id = os.icustay_id 
LEFT JOIN vasopressordurations vp on vp.icustay_id = fa.icustay_id 
LEFT JOIN ventsettings vs on vs.icustay_id = fa.icustay_id
LEFT JOIN ventdurations vd on vd.icustay_id = fa.icustay_id;