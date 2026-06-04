-- =============================================
-- CREDIT RISK ANALYSIS — VIEWS
-- =============================================

-- Chapter 1
CREATE VIEW vw_loan_overview AS
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS total_loan_amount,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS total_defaults,
    SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) AS estimated_loss,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk;

-- Chapter 2
CREATE VIEW vw_default_by_age AS
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
GROUP BY age_group;

CREATE VIEW vw_default_by_income AS
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
GROUP BY income_group;

CREATE VIEW vw_default_by_home_ownership AS
SELECT
    person_home_ownership,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY person_home_ownership;

CREATE VIEW vw_default_by_employment AS
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
GROUP BY emp_group;

-- Chapter 3
CREATE VIEW vw_default_by_intent AS
SELECT
    loan_intent,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY loan_intent;

CREATE VIEW vw_default_by_grade AS
SELECT
    loan_grade,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY loan_grade;

CREATE VIEW vw_default_by_interest_rate AS
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
GROUP BY interest_group;

-- Chapter 4
CREATE VIEW vw_default_by_previous_default AS
SELECT
    cb_person_default_on_file,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk
GROUP BY cb_person_default_on_file;

CREATE VIEW vw_default_by_credit_history AS
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
GROUP BY credit_hist_group;
