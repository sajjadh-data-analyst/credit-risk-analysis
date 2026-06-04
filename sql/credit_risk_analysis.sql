-- =============================================
-- BANK LOAN DEFAULT ANALYSIS
-- Author: Sajjad Hussain
-- Tools: PostgreSQL
-- Dataset: Credit Risk Dataset
-- =============================================


-- =============================================
-- TABLE CREATION
-- =============================================

CREATE TABLE credit_risk (
    person_age                 INT,
    person_income              INT,
    person_home_ownership      VARCHAR(20),
    person_emp_length          NUMERIC(5,1),
    loan_intent                VARCHAR(20),
    loan_grade                 VARCHAR(1),
    loan_amnt                  INT,
    loan_int_rate              NUMERIC(4,2),
    loan_status                INT CHECK (loan_status IN (0, 1)),
    loan_percent_income        NUMERIC(4,2),
    cb_person_default_on_file  VARCHAR(5),
    cb_person_cred_hist_length INT
);


-- =============================================
-- DATA CLEANING
-- =============================================

-- Check and remove age outliers
SELECT COUNT(*) FROM credit_risk WHERE person_age > 100;
DELETE FROM credit_risk WHERE person_age > 100;

-- Check and remove income outliers
SELECT MAX(person_income), MIN(person_income) FROM credit_risk;
SELECT COUNT(*) FROM credit_risk WHERE person_income > 1000000;
DELETE FROM credit_risk WHERE person_income > 1000000;

-- Check and remove employment length outliers
SELECT MAX(person_emp_length), MIN(person_emp_length) FROM credit_risk;
SELECT COUNT(*) FROM credit_risk WHERE person_emp_length > 60;
DELETE FROM credit_risk WHERE person_emp_length > 60;


-- =============================================
-- CHAPTER 1 — Overview
-- =============================================

-- Total loans
SELECT COUNT(*) AS total_loans FROM credit_risk;

-- Overall default rate
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS total_defaults,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk;

-- Loan grade distribution
SELECT
    loan_grade,
    COUNT(*) AS loan_count
FROM credit_risk
GROUP BY loan_grade
ORDER BY loan_count DESC;

-- Loan intent distribution
SELECT
    loan_intent,
    COUNT(*) AS loan_count
FROM credit_risk
GROUP BY loan_intent
ORDER BY loan_count DESC;


-- =============================================
-- CHAPTER 2 — Who Defaults?
-- =============================================

-- Default rate by age group
SELECT
    CASE
        WHEN person_age BETWEEN 20 AND 29 THEN 'Young (20s)'
        WHEN person_age BETWEEN 30 AND 39 THEN 'Adult (30s)'
        WHEN person_age BETWEEN 40 AND 49 THEN 'Middle Age (40s)'
        ELSE 'Senior (50+)'
    END AS age_group,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY age_group
ORDER BY default_rate DESC;

-- Default rate by home ownership
SELECT
    person_home_ownership,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY person_home_ownership
ORDER BY default_rate DESC;

-- Default rate by income group
SELECT
    CASE
        WHEN person_income < 30000 THEN 'Low (under 30K)'
        WHEN person_income BETWEEN 30000 AND 60000 THEN 'Lower Middle (30K-60K)'
        WHEN person_income BETWEEN 60001 AND 100000 THEN 'Upper Middle (60K-100K)'
        ELSE 'High (100K+)'
    END AS income_group,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY income_group
ORDER BY default_rate DESC;

-- Default rate by employment length
SELECT
    CASE
        WHEN person_emp_length < 2 THEN 'New (0-2 years)'
        WHEN person_emp_length BETWEEN 2 AND 5 THEN 'Established (2-5 years)'
        WHEN person_emp_length BETWEEN 5 AND 10 THEN 'Experienced (5-10 years)'
        ELSE 'Veteran (10+ years)'
    END AS emp_group,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY emp_group
ORDER BY default_rate DESC;


-- =============================================
-- CHAPTER 3 — Loan Characteristics
-- =============================================

-- Default rate by loan intent
SELECT
    loan_intent,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY loan_intent
ORDER BY default_rate DESC;

-- Default rate by loan grade
SELECT
    loan_grade,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY loan_grade
ORDER BY default_rate DESC;

-- Default rate by interest rate group
SELECT
    CASE
        WHEN loan_int_rate < 10 THEN 'Low (5-10%)'
        WHEN loan_int_rate BETWEEN 10 AND 15 THEN 'Medium (10-15%)'
        WHEN loan_int_rate BETWEEN 15 AND 20 THEN 'High (15-20%)'
        ELSE 'Very High (20%+)'
    END AS interest_group,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY interest_group
ORDER BY default_rate DESC;


-- =============================================
-- CHAPTER 4 — Credit History
-- =============================================

-- Default rate by previous default history
SELECT
    cb_person_default_on_file,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY cb_person_default_on_file
ORDER BY default_rate DESC;

-- Default rate by credit history length
SELECT
    CASE
        WHEN cb_person_cred_hist_length BETWEEN 2 AND 8 THEN 'Short (2-8 years)'
        WHEN cb_person_cred_hist_length BETWEEN 9 AND 16 THEN 'Medium (9-16 years)'
        WHEN cb_person_cred_hist_length BETWEEN 17 AND 23 THEN 'Long (17-23 years)'
        ELSE 'Very Long (24-30 years)'
    END AS credit_hist_group,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY credit_hist_group
ORDER BY default_rate DESC;





























