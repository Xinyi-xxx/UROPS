set search_path to mimiciii;

DROP MATERIALIZED VIEW IF EXISTS firsticu_le_minmax CASCADE;
CREATE MATERIALIZED VIEW firsticu_le_minmax AS

SELECT 
subject_id, hadm_id, icustay_id, --itemid,

--is it so neccessary?
max(charttime) as charttime 
-- max(value) as lab_value, 
--max(valueuom) as valueuom, 
--max(lablabel) as lablabel

-- min(case when lablabel='ALBUMIN'      then valuenum else null end) as min_albumin,
-- min(case when lablabel='FREECALCIUM'  then valuenum else null end) as min_freecalcium,
-- min(case when lablabel='HEMOGLOBIN'   then valuenum else null end) as min_hemoglobin,
-- min(case when lablabel='PLATELET'     then valuenum else null end) as min_platelet,
-- max(case when lablabel='LACTATE'      then valuenum else null end) as max_lactate,
-- min(case when lablabel='BICARBONATE'  then valuenum else null end) as min_bicarbonate,
-- max(case when lablabel='BICARBONATE'  then valuenum else null end) as max_bicarbonate,
-- min(case when lablabel='BUN'          then valuenum else null end) as min_blood_urea_nitrogen,
-- max(case when lablabel='BUN'          then valuenum else null end) as max_blood_urea_nitrogen,
-- min(case when lablabel='CREATININE'   then valuenum else null end) as min_creatinine,
-- max(case when lablabel='CREATININE'   then valuenum else null end) as max_creatinine,
-- min(case when lablabel='CALCIUM'      then valuenum else null end) as min_calcium,
-- max(case when lablabel='CALCIUM'      then valuenum else null end) as max_calcium,
-- min(case when lablabel='MAGNESIUM'    then valuenum else null end) as min_magnesium,
-- max(case when lablabel='MAGNESIUM'    then valuenum else null end) as max_magnesium,
-- min(case when lablabel='PHOSPHATE'    then valuenum else null end) as min_phosphate,
-- max(case when lablabel='PHOSPHATE'    then valuenum else null end) as max_phosphate,
-- min(case when lablabel='POTASSIUM'    then valuenum else null end) as min_potassium,
-- max(case when lablabel='POTASSIUM'    then valuenum else null end) as max_potassium,
-- min(case when lablabel='SODIUM'       then valuenum else null end) as min_sodium,
-- max(case when lablabel='SODIUM'       then valuenum else null end) as max_sodium,
-- min(case when lablabel='GLUCOSE'      then valuenum else null end) as min_glucose,
-- max(case when lablabel='GLUCOSE'      then valuenum else null end) as max_glucose,
-- min(case when lablabel='WBC'          then valuenum else null end) as min_white_blood_cell,
-- max(case when lablabel='WBC'          then valuenum else null end) as max_white_blood_cell

  , max(case when lablabel = 'ANION GAP' then valuenum else null end) as ANIONGAP_max
  , min(case when lablabel = 'ANION GAP' then valuenum else null end) as ANIONGAP_min
  
  , max(case when lablabel = 'ALBUMIN' then valuenum else null end)   as ALBUMIN_max
  , min(case when lablabel = 'ALBUMIN' then valuenum else null end)   as ALBUMIN_min
  
  , max(case when lablabel = 'BICARBONATE' then valuenum else null end) as BICARBONATE_max
  , min(case when lablabel = 'BICARBONATE' then valuenum else null end) as BICARBONATE_min
  
  , max(case when lablabel = 'BILIRUBIN' then valuenum else null end) as BILIRUBIN_max
  , min(case when lablabel = 'BILIRUBIN' then valuenum else null end) as BILIRUBIN_min
  
  , max(case when lablabel = 'CREATININE' then valuenum else null end) as CREATININE_max
  , min(case when lablabel = 'CREATININE' then valuenum else null end) as CREATININE_min
  
  , max(case when lablabel = 'CHLORIDE' then valuenum else null end) as CHLORIDE_max
  , min(case when lablabel = 'CHLORIDE' then valuenum else null end) as CHLORIDE_min
  
  , max(case when lablabel = 'GLUCOSE' then valuenum else null end) as GLUCOSE_max
  , min(case when lablabel = 'GLUCOSE' then valuenum else null end) as GLUCOSE_min
  
  , max(case when lablabel = 'HEMATOCRIT' then valuenum else null end) as HEMATOCRIT_max
  , min(case when lablabel = 'HEMATOCRIT' then valuenum else null end) as HEMATOCRIT_min
  
  , max(case when lablabel = 'HEMOGLOBIN' then valuenum else null end) as HEMOGLOBIN_max
  , min(case when lablabel = 'HEMOGLOBIN' then valuenum else null end) as HEMOGLOBIN_min
  
  , max(case when lablabel = 'LACTATE' then valuenum else null end) as LACTATE_max
  , min(case when lablabel = 'LACTATE' then valuenum else null end) as LACTATE_min
  
  , max(case when lablabel = 'MAGNESIUM' then valuenum else null end) as MAGNESIUM_max
  , min(case when lablabel = 'MAGNESIUM' then valuenum else null end) as MAGNESIUM_min
  
  , max(case when lablabel = 'PHOSPHATE' then valuenum else null end) as PHOSPHATE_max
  , min(case when lablabel = 'PHOSPHATE' then valuenum else null end) as PHOSPHATE_min

  , max(case when lablabel = 'PLATELET' then valuenum else null end) as PLATELET_max
  , min(case when lablabel = 'PLATELET' then valuenum else null end) as PLATELET_min
  
  , max(case when lablabel = 'POTASSIUM' then valuenum else null end) as POTASSIUM_max
  , min(case when lablabel = 'POTASSIUM' then valuenum else null end) as POTASSIUM_min
  
  , max(case when lablabel = 'PTT' then valuenum else null end) as PTT_max
  , min(case when lablabel = 'PTT' then valuenum else null end) as PTT_min
  
  , max(case when lablabel = 'INR' then valuenum else null end) as INR_max
  , min(case when lablabel = 'INR' then valuenum else null end) as INR_min
  
  , max(case when lablabel = 'PT' then valuenum else null end) as PT_max
  , min(case when lablabel = 'PT' then valuenum else null end) as PT_min

  , max(case when lablabel = 'SODIUM' then valuenum else null end) as SODIUM_max
  , min(case when lablabel = 'SODIUM' then valuenum else null end) as SODIUM_min
  
  , max(case when lablabel = 'BUN' then valuenum else null end) as BUN_max
  , min(case when lablabel = 'BUN' then valuenum else null end) as BUN_min

  , max(case when lablabel = 'WBC' then valuenum else null end) as WBC_max
  , min(case when lablabel = 'WBC' then valuenum else null end) as WBC_min

  , max(case when lablabel = 'CALCIUM' then valuenum else null end) as CALCIUM_max
  , min(case when lablabel = 'CALCIUM' then valuenum else null end) as CALCIUM_min
  
  , max(case when lablabel = 'FREECALCIUM' then valuenum else null end) as FREECALCIUM_max
  , min(case when lablabel = 'FREECALCIUM' then valuenum else null end) as FREECALCIUM_min

FROM firsticu_wle
GROUP BY 
subject_id, hadm_id, icustay_id;