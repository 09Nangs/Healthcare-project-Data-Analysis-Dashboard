SELECT * FROM health.`health care project - healthcare_dataset (1)`;

-- List of top 50 patients 
SELECT name, age, medical_condition
FROM `health care project - healthcare_dataset (1)`
ORDER BY name DESC
LIMIT 50;

SELECT DISTINCT 
	hospital
FROM `health care project - healthcare_dataset (1)`;
-- table of the name, age, billing_amount and date_of_admission for cancer patients 
SELECT
	name, age, medical_condition, billing_amount, date_of_admission
FROM `health care project - healthcare_dataset (1)`
WHERE medical_condition = 'cancer';

-- find average bill per medical condition
SELECT 
	medical_condition,
    AVG(billing_amount)
FROM`health care project - healthcare_dataset (1)`
GROUP BY medical_condition;
 
-- count patients by insurance providers
SELECT 
	insurance_provider,
    count(*)
FROM `health care project - healthcare_dataset (1)`
GROUP BY insurance_provider;

-- find condition with average bill > 20000
SELECT 
	medical_condition,
    AVG(billing_amount)
FROM `health care project - healthcare_dataset (1)`
GROUP BY medical_condition
HAVING AVG(billing_amount) > 20000;

-- finding hospital with more patients 
SELECT
	hospital,
    COUNT(*)
FROM `health care project - healthcare_dataset (1)`
GROUP BY hospital
HAVING COUNT(*);

-- Which blood type is more prevalent to cancer in women under the age of 30
SELECT
	h.name, h.age, h.blood_type, h.medical_condition
FROM `health care project - healthcare_dataset (1)` AS h
WHERE medical_condition = 'Cancer' AND age < 40
ORDER BY age DESC;


SELECT
  name,
  age,
  billing_amount,
  CASE
    WHEN age < 18 THEN 'Child'
    WHEN age BETWEEN 18 AND 60 THEN 'Adult'
    WHEN age > 60 THEN 'Senior'
    ELSE 'Old'
  END AS age_group,
  CASE
    WHEN billing_amount > 20000 THEN 'High'
    ELSE 'Normal'
  END AS billing_level
FROM `health care project - healthcare_dataset (1)`;

-- Hospitals where the average billing for cancer patients is above the overall cancer billing
-- CTE
-- 1st CTE calculates average bill per hospital only for cancer patients 
-- 2nd CTE calculate the overage average bill for all cancer patients across all hospitals
-- Joins the two CTES and return only hospitals where their average cancer billing is above the overall average

WITH cancer_avg_bills AS (
  SELECT hospital, AVG(billing_amount) AS avg_cancer_bill
  FROM `health care project - healthcare_dataset (1)`
  WHERE medical_condition = 'Cancer'
  GROUP BY hospital
),
overall_avg AS (
  SELECT AVG(billing_amount) AS overall_avg_bill
  FROM `health care project - healthcare_dataset (1)`
  WHERE medical_condition = 'Cancer'
)
SELECT c.hospital, c.avg_cancer_bill
FROM cancer_avg_bills c
JOIN overall_avg o
ON c.avg_cancer_bill > o.overall_avg_bill;


