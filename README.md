## Credit Risk Analysis

Analysis of 32,000+ loan records to identify key risk 
factors that predict loan defaults.

**Tools:** PostgreSQL · Power BI

# Bank Loan Default Analysis

## Objective
Analyze 32,000+ loan records to identify key risk 
factors that predict whether a borrower will default 
on their loan.

## Questions Answered
- What is the overall default rate?
- Do lower income borrowers default more?
- Does employment length affect default risk?
- Which loan grades have highest default rates?
- Does previous default history predict future defaults?
- Does interest rate affect default likelihood?

## Data Cleaning
- Removed age outliers above 100 years
- Removed income outliers above 1,000,000
- Removed employment length outliers above 60 years
- Handled NULLs with COALESCE throughout analysis

## EDA Chapters
- Chapter 1: Overview — total loans, default rate, grade distribution
- Chapter 2: Who Defaults — age, income, home ownership, employment
- Chapter 3: Loan Characteristics — intent, grade, interest rate
- Chapter 4: Credit History — previous defaults, credit history length

## Key Findings
- Overall default rate: 21.82%
- Low income borrowers default at 47% — almost 1 in 2
- Higher interest rates strongly predict defaults
- Previous default history significantly increases risk
- No single factor causes default — always a combination

## Tools
PostgreSQL · Power BI
