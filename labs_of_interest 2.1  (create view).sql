-- \i 'S:/NUS/Year Two/UROPS/My SQL/eicu/labs_of_interest 2.1  (create view).sql'


set search_path to xy, eicu, public;

-- match with patientunitstayid -- check labResultOffset +-24hrs 
-- step 1 join the two tables lab.patientunitstayid = p.patientunitstayid (inner join or left join? which one first?)\
-- step 2 limit labResultOffset <= 1440 and labResultOffset >= -1440 (1488=24hrs*60mins/hrs)

DROP MATERIALIZED VIEW IF EXISTS lab_1st_24h CASCADE;
CREATE MATERIALIZED VIEW lab_1st_24h as
select lab.patientunitstayid, icu.uniquepid, icu.age, icu.gender, icu.mort_icu, icu.los, lab.labName, lab.labResult,
CASE
    -- ##############
    -- #SANITY CHECK#
    -- ##############
     WHEN lab.labname = 'albumin' and lab.labresult >    10 THEN null -- g/dL 'ALBUMIN'
     
     --WHEN lab.labname = 'anion gap' and lab.labresult > 10000 THEN null -- mEq/L 'ANION GAP'
     --WHEN lab.labname = '-bands' and lab.labresult <     0 THEN null -- immature band forms, %
     --WHEN lab.labname = '-bands' and lab.labresult >   100 THEN null -- immature band forms, %
     
     WHEN lab.labname = 'bicarbonate' and lab.labresult > 10000 THEN null -- mEq/L 'BICARBONATE'
     WHEN lab.labname = 'HCO3' and lab.labresult > 10000 THEN null -- mEq/L 'BICARBONATE'
     
     --WHEN lab.labname = 'bilirubin' and lab.labresult >   150 THEN null -- mg/dL 'BILIRUBIN'
     
     WHEN lab.labname = 'chloride' and lab.labresult > 10000 THEN null -- mEq/L 'CHLORIDE'
     WHEN lab.labname = 'creatinine' and lab.labresult >   150 THEN null -- mg/dL 'CREATININE'
     WHEN lab.labname = 'glucose' and lab.labresult > 10000 THEN null -- mg/dL 'GLUCOSE'
     
     --WHEN lab.labname = 'Hct' and lab.labresult >   100 THEN null -- % 'HEMATOCRIT'
     
     WHEN lab.labname = 'Hgb' and lab.labresult >    50 THEN null -- g/dL 'HEMOGLOBIN'
     WHEN lab.labname = 'lactate' and lab.labresult >    50 THEN null -- mmol/L 'LACTATE'
     WHEN lab.labname = 'platelets x 1000' and lab.labresult > 10000 THEN null -- K/uL 'PLATELET'
     WHEN lab.labname = 'potassium' and lab.labresult >    30 THEN null -- mEq/L 'POTASSIUM'
     
     --WHEN lab.labname = 'PTT' and lab.labresult >   150 THEN null -- sec 'PTT'
     --WHEN lab.labname = 'PT - INR' and lab.labresult >    50 THEN null -- 'INR'
     --WHEN lab.labname = 'PT' and lab.labresult >   150 THEN null -- sec 'PT'
     
     WHEN lab.labname = 'sodium' and lab.labresult >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
     WHEN lab.labname = 'BUN' and lab.labresult >   300 THEN null -- 'BUN'
     WHEN lab.labname = 'WBC x 1000' and lab.labresult >  1000 THEN null -- 'WBC'

    -- ############
    -- #UNIT CHECK#
    -- ############
     WHEN lab.labname = 'BUN'  THEN lab.labresult*0.357

     WHEN lab.labname = 'calcium' and (labresult is not null) and (labmeasurenameinterface = 'mmol/L') THEN labResult/0.2495

    -- huan cheng not 
     WHEN lab.labname = 'ionized calcium' and not ((labresult is not null) and (labmeasurenameinterface = 'mmol/L') and (round(labresult,2) = cast (labresulttext as float)))THEN lab.labresult*0.2495
     
     --toujiquqiao 
     --WHEN lab.labname = 'ionized calcium' and (labresult > 2) THEN lab.labresult*0.2495
     
     --WHEN lab.labname = 'magnesium' THEN lab.labresult*0.41152

   ELSE lab.labresult
   END AS labdata,
    lab.labResultOffset,
case
    when lower(lab.labName) LIKE 'albumin%'         then 'ALBUMIN'                 
    when lower(lab.labName) LIKE 'bicarbonate'      then 'BICARBONATE'           
    when lower(lab.labName) LIKE 'bun'              then 'BUN'          
    when lower(lab.labName) LIKE 'calcium'          then 'CALCIUM'         
    when lower(lab.labName) LIKE 'ionized calcium'  then 'FREECALCIUM'               
    when lower(lab.labName) LIKE 'chloride'         then 'CHLORIDE'        
    when lower(lab.labName) LIKE 'magnesium'        then 'MAGNESIUM'         
    when lower(lab.labName) LIKE 'phosphate'        then 'PHOSPHATE'         
    when lower(lab.labName) LIKE 'hgb'              then 'HEMOGLOBIN'             
    when lower(lab.labName) LIKE 'sodium'           then 'SODIUM'      
    when lower(lab.labName) LIKE 'creatinine'       then 'CREATININE' 
    when lower(lab.labName) LIKE 'glucose'          then 'GLUCOSE'        
    when lower(lab.labName) LIKE 'platelets x 1000' then 'PLATELET'                
    when lower(lab.labName) LIKE 'potassium'        then 'POTASSIUM'         
    when lower(lab.labName) LIKE 'lactate'          then 'LACTATE'         
    when lower(lab.labName) LIKE 'wbc x 1000'       then 'WBC'   
    ELSE NULL 
    END as lablabel       

from lab
inner join first_icu icu on lab.patientunitstayid = icu.patientunitstayid 
where 
(
    lower(lab.labName) LIKE 'albumin%' or  
    lower(lab.labName) LIKE 'bicarbonate' or 
    lower(lab.labName) LIKE 'bun' or 
    lower(lab.labName) LIKE 'calcium' or
    lower(lab.labName) LIKE 'ionized calcium' or 
    lower(lab.labName) LIKE 'chloride' or 
    lower(lab.labName) LIKE 'magnesium' or
    lower(lab.labName) LIKE 'phosphate' or 
    lower(lab.labName) LIKE 'hgb' or 
    lower(lab.labName) LIKE 'sodium' or 
    lower(lab.labName) LIKE 'creatinine' or 
    lower(lab.labName) LIKE 'glucose' or
    lower(lab.labName) LIKE 'platelets x 1000' or -- platelets x 1000
    lower(lab.labName) LIKE 'potassium' or 
    lower(lab.labName) LIKE 'lactate' or  
    lower(lab.labName) LIKE 'wbc x 1000' -- WBC x 1000
)
and
(
    lab.labResultOffset <= 1440 and lab.labResultOffset >= -1440
);
--SELECT 3012746 old ver1
--select 3963667 touji set >2
--SELECT 3963667 current 


--select patientunitstayid, labname, labresult, 
--case WHEN labname = 'ionized calcium' THEN lab.labresult*0.2495 else null end as labdata 
--from lab where labname = 'ionized calcium' and labresult is not null order by labresult DESC limit 30;
