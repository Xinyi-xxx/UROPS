set search_path to mimiciii;

DROP MATERIALIZED VIEW IF EXISTS firstlab_combined CASCADE;
CREATE MATERIALIZED VIEW firstlab_combined AS

SELECT 
wole.subject_id, wole.hadm_id, wole.icustay_id,
wole.intime, wole.outtime, wole.deathtime, wole.los, wole.admit_age, wole.gender, wole.mort_icu,
wole.mort_hosp, wole.first_careunit,

wole.oasis, 
wole.if_vasopressor, 
wole.if_mechvent,
wole.vasonum,


le.charttime
--le.itemid
--le.lablabel,
--le.min_albumin,
--le.min_freecalcium,
--le.min_hemoglobin,
--le.min_platelet,
--le.max_lactate,
--le.min_bicarbonate,
--le.max_bicarbonate,
--le.min_blood_urea_nitrogen,
--le.max_blood_urea_nitrogen,
--le.min_creatinine,
--le.max_creatinine,
--le.min_calcium,
--le.max_calcium,
--le.min_magnesium,
--le.max_magnesium,
--le.min_phosphate,
--le.max_phosphate,
--le.min_potassium,
--le.max_potassium,
--le.min_sodium,
--le.max_sodium,
--le.min_glucose,
--le.max_glucose,
--le.min_white_blood_cell,
--le.max_white_blood_cell

  , le.ANIONGAP_max
  , le.ANIONGAP_min
  , le.ALBUMIN_max
  , le.ALBUMIN_min
  , le.BICARBONATE_max
  , le.BICARBONATE_min
  , le.BILIRUBIN_max
  , le.BILIRUBIN_min
  , le.CREATININE_max
  , le.CREATININE_min
  , le.CHLORIDE_max
  , le.CHLORIDE_min
  , le.GLUCOSE_max
  , le.GLUCOSE_min  
  , le.HEMATOCRIT_max
  , le.HEMATOCRIT_min
  , le.HEMOGLOBIN_max
  , le.HEMOGLOBIN_min
  , le.LACTATE_max
  , le.LACTATE_min
  , le.MAGNESIUM_max
  , le.MAGNESIUM_min
  , le.PHOSPHATE_max
  , le.PHOSPHATE_min
  , le.PLATELET_max
  , le.PLATELET_min
  , le.POTASSIUM_max
  , le.POTASSIUM_min
  , le.PTT_max
  , le.PTT_min
  , le.INR_max
  , le.INR_min
  , le.PT_max
  , le.PT_min
  , le.SODIUM_max
  , le.SODIUM_min
  , le.BUN_max
  , le.BUN_min
  , le.WBC_max
  , le.WBC_min
  , le.CALCIUM_max
  , le.CALCIUM_min
  , le.FREECALCIUM_max
  , le.FREECALCIUM_min

FROM firsticu_wole wole
LEFT JOIN firsticu_le_minmax le
ON wole.icustay_id = le.icustay_id 
AND wole.subject_id = le.subject_id ;

-- what is wanted in the paper 
-- copy (select * from firstlab_combined) to 'S:/NUS/Year Two/UROPS/firstlab_xy.csv' DELIMITER ',' CSV HEADER;
-- subject_id, hadm_id, icustay_id, albumin_min, bicarbonate_max,bicarbonate_min,creatinine_max,creatinine_min,
-- glucose_max,glucose_min, hemoglobin_min,lactate_max,magnesium_max,magnesium_min,phosphate_max,phosphate_min,
-- platelet_min,potassium_max,potassium_min,sodium_max,sodium_min,bun_max, bun_min,wbc_max,wbc_min,calcium_max,calcium_min,freecalcium_min

-- include all max and min to make life easier
-- copy (select * from firstlab_combined) to 'S:/NUS/Year Two/UROPS/firstlab_xy.csv' DELIMITER ',' CSV HEADER 
-- subject_id, hadm_id, icustay_id, albumin_min, albumin_max, bicarbonate_max,bicarbonate_min,creatinine_max,creatinine_min,
-- glucose_max,glucose_min,hemoglobin_max, hemoglobin_min, lactate_max, lactate_min, magnesium_max,magnesium_min,phosphate_max,phosphate_min,
-- platelet_max, platelet_min, potassium_max, potassium_min, sodium_max, sodium_min, bun_max, bun_min,wbc_max,wbc_min,calcium_max,calcium_min,
-- freecalcium_max, freecalcium_min, chloride_max, chloride_min
-- 
-- copy (select subject_id, hadm_id, icustay_id, albumin_min, albumin_max, bicarbonate_max,bicarbonate_min,creatinine_max,creatinine_min,
-- glucose_max,glucose_min,hemoglobin_max, hemoglobin_min, lactate_max, lactate_min, magnesium_max,magnesium_min,phosphate_max,phosphate_min,
-- platelet_max, platelet_min, potassium_max, potassium_min, sodium_max, sodium_min, bun_max, bun_min,wbc_max,wbc_min,calcium_max,calcium_min,
-- freecalcium_max, freecalcium_min, chloride_max, chloride_min
--  from firstlab_combined) to 'S:/NUS/Year Two/UROPS/firstlab_xy_simp.csv' DELIMITER ',' CSV HEADER;

'''
copy (select subject_id, hadm_id, icustay_id, albumin_min, albumin_max, bicarbonate_max,bicarbonate_min,creatinine_max,creatinine_min,
glucose_max,glucose_min,hemoglobin_max, hemoglobin_min, lactate_max, lactate_min, magnesium_max,magnesium_min,phosphate_max,phosphate_min,
platelet_max, platelet_min, potassium_max, potassium_min, sodium_max, sodium_min, bun_max, bun_min,wbc_max,wbc_min,calcium_max,calcium_min,
freecalcium_max, freecalcium_min, chloride_max, chloride_min
from firstlab_combined where mort_icu=1) to 'S:/NUS/Year Two/UROPS/firstlab_xy_worst.csv' DELIMITER ',' CSV HEADER;
'''


'''
#get top 25 percent
select percentile_cont(0.25) within group (order by los) as percentile_25 from firstlab_combined;
 percentile_25
---------------
         1.184

copy (select subject_id, hadm_id, icustay_id, albumin_min, albumin_max, bicarbonate_max,bicarbonate_min,creatinine_max,creatinine_min,
glucose_max,glucose_min,hemoglobin_max, hemoglobin_min, lactate_max, lactate_min, magnesium_max,magnesium_min,phosphate_max,phosphate_min,
platelet_max, platelet_min, potassium_max, potassium_min, sodium_max, sodium_min, bun_max, bun_min,wbc_max,wbc_min,calcium_max,calcium_min,
freecalcium_max, freecalcium_min, chloride_max, chloride_min from firstlab_combined where los <= 1.184) to 'S:/NUS/Year Two/UROPS/firstlab_xy_best.csv' DELIMITER ',' CSV HEADER;
'''