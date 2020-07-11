set search_path to mimiciii;

DROP MATERIALIZED VIEW IF EXISTS firsticu_wle CASCADE;
CREATE MATERIALIZED VIEW firsticu_wle AS

SELECT 
fa.icustay_id, fa.subject_id, fa.hadm_id,  fa.intime, fa.outtime, fa.deathtime, fa.los, fa.admit_age, fa.gender, fa.mort_icu,
fa.mort_hosp, fa.first_careunit, --fa.last_careunit,

le.charttime, le.itemid, le.value, le.valuenum, le.valueuom,

case    when le.itemid = 50868 then 'ANION GAP'
        when le.itemid = 50862 then 'ALBUMIN'
        when le.itemid = 50882 then 'BICARBONATE'
        when le.itemid = 50885 then 'BILIRUBIN'
        when le.itemid = 50912 then 'CREATININE'
        when le.itemid = 50806 then 'CHLORIDE'
        when le.itemid = 50902 then 'CHLORIDE'
        when le.itemid = 50809 then 'GLUCOSE'
        when le.itemid = 50931 then 'GLUCOSE'
        when le.itemid = 50810 then 'HEMATOCRIT'
        when le.itemid = 51221 then 'HEMATOCRIT'
        when le.itemid = 50811 then 'HEMOGLOBIN'
        when le.itemid = 51222 then 'HEMOGLOBIN'
        when le.itemid = 50813 then 'LACTATE'
        when le.itemid = 50960 then 'MAGNESIUM'
        when le.itemid = 50970 then 'PHOSPHATE'
        when le.itemid = 51265 then 'PLATELET'
        when le.itemid = 50822 then 'POTASSIUM'
        when le.itemid = 50971 then 'POTASSIUM'
        when le.itemid = 51275 then 'PTT'
        when le.itemid = 51237 then 'INR'
        when le.itemid = 51274 then 'PT'
        when le.itemid = 50824 then 'SODIUM'
        when le.itemid = 50983 then 'SODIUM'
        when le.itemid = 51006 then 'BUN'
        when le.itemid = 51300 then 'WBC'
        when le.itemid = 51301 then 'WBC'
        -- Calcium
        when le.itemid = 50893 then 'CALCIUM'
        -- Free calcium
        when le.itemid = 50808 then 'FREECALCIUM'
		ELSE NULL
        end AS lablabel

FROM firsticu_adult fa LEFT JOIN labevents le 
ON fa.subject_id = le.subject_id
AND fa.hadm_id = le.hadm_id
AND
(   le.itemid = 50868   
 OR le.itemid = 50862   
 OR le.itemid = 50882   
 OR le.itemid = 50885   
 OR le.itemid = 50912   
 OR le.itemid = 50806   
 OR le.itemid = 50902   
 OR le.itemid = 50809   
 OR le.itemid = 50931   
 OR le.itemid = 50810   
 OR le.itemid = 51221   
 OR le.itemid = 50811   
 OR le.itemid = 51222   
 OR le.itemid = 50813   
 OR le.itemid = 50960  
 OR le.itemid = 50970  
 OR le.itemid = 51265  
 OR le.itemid = 50822  
 OR le.itemid = 50971  
 OR le.itemid = 51275  
 OR le.itemid = 51237  
 OR le.itemid = 51274   
 OR le.itemid = 50824   
 OR le.itemid = 50983   
 OR le.itemid = 51006   
 OR le.itemid = 51300   
 OR le.itemid = 51301   
 OR le.itemid = 50893 
 OR le.itemid = 50808
 )
AND le.charttime >= (fa.intime - interval '24 hour' ) AND le.charttime <= (fa.intime + interval '24 hour' )
-- lab values cannot be 0 and cannot be negative
AND le.valuenum IS NOT null 
AND le.valuenum > 0 ;