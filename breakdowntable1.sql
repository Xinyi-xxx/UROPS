set search_path to mimiciii;

DROP MATERIALIZED VIEW IF EXISTS firsticu_adult CASCADE;
CREATE MATERIALIZED VIEW firsticu_adult as

WITH temptable AS
(
SELECT icu.subject_id, icu.hadm_id, icu.icustay_id, 
    icu.intime, icu.outtime, a.deathtime, icu.los,
	ROUND((cast(a.admittime as date) - cast(p.dob as date))/365.24, 2) as admit_age, p.gender, 
	icu.first_careunit, icu.last_careunit,

CASE when a.deathtime between icu.intime and icu.outtime THEN 1 ELSE 0 END AS mort_icu,
CASE when a.deathtime between a.admittime and a.dischtime THEN 1 ELSE 0 END AS mort_hosp, 

RANK() OVER (PARTITION BY icu.subject_id ORDER BY icu.intime) as icu_rank
	
FROM icustays icu
	
INNER JOIN patients p on p.subject_id = icu.subject_id 
INNER JOIN admissions a on a.subject_id = icu.subject_id AND icu.hadm_id = a.hadm_id

WHERE
ROUND((cast(a.admittime as date) - cast(p.dob as date))/365.24, 2) > 15
)

SELECT * FROM temptable WHERE icu_rank = 1;
