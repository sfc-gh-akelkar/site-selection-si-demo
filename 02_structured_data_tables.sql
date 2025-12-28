/*******************************************************************************
 * MEDPACE SPONSOR INSIGHTS AGENT - STEP 2: STRUCTURED DATA TABLES
 * 
 * Purpose: Create and populate structured data tables for clinical trial
 *          enrollment metrics and site performance dashboards.
 * 
 * Tables Created:
 *   - TRIAL_ENROLLMENT_METRICS: Patient enrollment and screening data
 *   - SITE_PERFORMANCE_DASHBOARD: Site quality and compliance metrics
 * 
 * Sample Data: 5 unique Phase III oncology studies across 10 global sites
 * 
 * Role: SF_INTELLIGENCE_DEMO
 ******************************************************************************/

USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

/*******************************************************************************
 * TABLE 1: TRIAL_ENROLLMENT_METRICS
 * 
 * Contains enrollment and screening data for clinical trials, tracking
 * planned vs actual enrollment and screen failure rates per site.
 ******************************************************************************/

CREATE OR REPLACE TABLE TRIAL_ENROLLMENT_METRICS (
    ENROLLMENT_ID           NUMBER AUTOINCREMENT PRIMARY KEY
        COMMENT 'Unique identifier for each enrollment record.',
    STUDY_ID                VARCHAR(20) NOT NULL
        COMMENT 'Unique protocol identifier for the clinical study (e.g., MED-ONC-2024-001). Also known as Protocol Number or Trial ID.',
    SITE_NAME               VARCHAR(100) NOT NULL
        COMMENT 'Name of the clinical research site conducting the trial. May include hospital or institution name.',
    SITE_ID                 VARCHAR(20) NOT NULL
        COMMENT 'Unique site identifier code assigned by the sponsor.',
    SPONSOR_ID              VARCHAR(50) NOT NULL
        COMMENT 'Identifier for the pharmaceutical company or organization sponsoring the trial.',
    TRIAL_PHASE             VARCHAR(20) NOT NULL
        COMMENT 'Clinical trial phase designation (Phase I, Phase II, Phase III, Phase IV). Indicates the stage of drug development.',
    THERAPEUTIC_AREA        VARCHAR(50) NOT NULL
        COMMENT 'Medical specialty or disease area being studied (e.g., Oncology, Cardiology, Neurology).',
    INDICATION              VARCHAR(100) NOT NULL
        COMMENT 'Specific disease or condition being treated in the trial (e.g., Non-Small Cell Lung Cancer, Melanoma).',
    PLANNED_ENROLLMENT      NUMBER NOT NULL
        COMMENT 'Target number of patients to be enrolled at this site as per the protocol. Also known as Enrollment Target or Recruitment Goal.',
    ACTUAL_ENROLLMENT       NUMBER NOT NULL
        COMMENT 'The number of patients who have successfully passed screening and are randomized in the trial. Also known as Randomized Patients or Enrolled Subjects.',
    SCREEN_FAILURES         NUMBER NOT NULL
        COMMENT 'Number of patients who consented but failed screening criteria. High screen failure rates may indicate issues with site selection or protocol criteria.',
    ENROLLMENT_START_DATE   DATE NOT NULL
        COMMENT 'Date when patient enrollment began at this site. Also known as First Patient First Visit (FPFV) date.',
    ENROLLMENT_STATUS       VARCHAR(30) NOT NULL
        COMMENT 'Current enrollment status: ACTIVE (recruiting), COMPLETED (target met), PAUSED (temporarily halted), or CLOSED (permanently stopped).',
    COUNTRY                 VARCHAR(50) NOT NULL
        COMMENT 'Country where the clinical site is located.',
    REGION                  VARCHAR(30) NOT NULL
        COMMENT 'Geographic region: North America, Europe, Asia Pacific, Latin America, or Middle East/Africa.'
)
COMMENT = 'Trial enrollment metrics tracking patient recruitment, screening, and randomization data across all clinical sites. Key source for enrollment analytics and site performance comparisons.';

-- Insert sample data for 5 Phase III oncology studies across 10 global sites
INSERT INTO TRIAL_ENROLLMENT_METRICS (
    STUDY_ID, SITE_NAME, SITE_ID, SPONSOR_ID, TRIAL_PHASE, THERAPEUTIC_AREA,
    INDICATION, PLANNED_ENROLLMENT, ACTUAL_ENROLLMENT, SCREEN_FAILURES,
    ENROLLMENT_START_DATE, ENROLLMENT_STATUS, COUNTRY, REGION
) VALUES
    -- Study 1: MED-ONC-2024-001 (NSCLC Study)
    ('MED-ONC-2024-001', 'Memorial Sloan Kettering Cancer Center', 'SITE-001', 'PHARMA-ALPHA', 'Phase III', 'Oncology', 'Non-Small Cell Lung Cancer', 50, 42, 5, '2024-01-15', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-001', 'MD Anderson Cancer Center', 'SITE-002', 'PHARMA-ALPHA', 'Phase III', 'Oncology', 'Non-Small Cell Lung Cancer', 45, 38, 4, '2024-01-20', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-001', 'University College London Hospitals', 'SITE-003', 'PHARMA-ALPHA', 'Phase III', 'Oncology', 'Non-Small Cell Lung Cancer', 40, 35, 18, '2024-02-01', 'ACTIVE', 'United Kingdom', 'Europe'),
    ('MED-ONC-2024-001', 'Charité Berlin', 'SITE-004', 'PHARMA-ALPHA', 'Phase III', 'Oncology', 'Non-Small Cell Lung Cancer', 35, 28, 3, '2024-02-10', 'ACTIVE', 'Germany', 'Europe'),
    
    -- Study 2: MED-ONC-2024-002 (Melanoma Study)
    ('MED-ONC-2024-002', 'Cleveland Clinic', 'SITE-005', 'PHARMA-BETA', 'Phase III', 'Oncology', 'Advanced Melanoma', 60, 52, 6, '2024-03-01', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-002', 'Institut Gustave Roussy', 'SITE-006', 'PHARMA-BETA', 'Phase III', 'Oncology', 'Advanced Melanoma', 55, 48, 25, '2024-03-05', 'ACTIVE', 'France', 'Europe'),
    ('MED-ONC-2024-002', 'National Cancer Center Japan', 'SITE-007', 'PHARMA-BETA', 'Phase III', 'Oncology', 'Advanced Melanoma', 45, 40, 4, '2024-03-10', 'ACTIVE', 'Japan', 'Asia Pacific'),
    
    -- Study 3: MED-ONC-2024-003 (Breast Cancer Study)
    ('MED-ONC-2024-003', 'Dana-Farber Cancer Institute', 'SITE-008', 'PHARMA-GAMMA', 'Phase III', 'Oncology', 'Triple Negative Breast Cancer', 70, 58, 7, '2024-04-01', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-003', 'Hospital Universitario 12 de Octubre', 'SITE-009', 'PHARMA-GAMMA', 'Phase III', 'Oncology', 'Triple Negative Breast Cancer', 50, 42, 22, '2024-04-10', 'ACTIVE', 'Spain', 'Europe'),
    ('MED-ONC-2024-003', 'Peter MacCallum Cancer Centre', 'SITE-010', 'PHARMA-GAMMA', 'Phase III', 'Oncology', 'Triple Negative Breast Cancer', 40, 35, 4, '2024-04-15', 'ACTIVE', 'Australia', 'Asia Pacific'),
    
    -- Study 4: MED-ONC-2024-004 (Colorectal Cancer Study)
    ('MED-ONC-2024-004', 'Memorial Sloan Kettering Cancer Center', 'SITE-001', 'PHARMA-DELTA', 'Phase III', 'Oncology', 'Metastatic Colorectal Cancer', 55, 45, 5, '2024-05-01', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-004', 'University College London Hospitals', 'SITE-003', 'PHARMA-DELTA', 'Phase III', 'Oncology', 'Metastatic Colorectal Cancer', 50, 38, 20, '2024-05-10', 'ACTIVE', 'United Kingdom', 'Europe'),
    ('MED-ONC-2024-004', 'Samsung Medical Center', 'SITE-011', 'PHARMA-DELTA', 'Phase III', 'Oncology', 'Metastatic Colorectal Cancer', 45, 40, 4, '2024-05-15', 'ACTIVE', 'South Korea', 'Asia Pacific'),
    
    -- Study 5: MED-ONC-2024-005 (Prostate Cancer Study)
    ('MED-ONC-2024-005', 'Johns Hopkins Sidney Kimmel Cancer Center', 'SITE-012', 'PHARMA-EPSILON', 'Phase III', 'Oncology', 'Metastatic Castration-Resistant Prostate Cancer', 65, 55, 6, '2024-06-01', 'ACTIVE', 'United States', 'North America'),
    ('MED-ONC-2024-005', 'The Christie NHS Foundation Trust', 'SITE-013', 'PHARMA-EPSILON', 'Phase III', 'Oncology', 'Metastatic Castration-Resistant Prostate Cancer', 50, 40, 23, '2024-06-05', 'ACTIVE', 'United Kingdom', 'Europe'),
    ('MED-ONC-2024-005', 'Hospital Israelita Albert Einstein', 'SITE-014', 'PHARMA-EPSILON', 'Phase III', 'Oncology', 'Metastatic Castration-Resistant Prostate Cancer', 40, 32, 3, '2024-06-10', 'ACTIVE', 'Brazil', 'Latin America');

/*******************************************************************************
 * TABLE 2: SITE_PERFORMANCE_DASHBOARD
 * 
 * Contains quality and compliance metrics for each clinical site,
 * including protocol deviations, query resolution times, and PI details.
 ******************************************************************************/

CREATE OR REPLACE TABLE SITE_PERFORMANCE_DASHBOARD (
    PERFORMANCE_ID              NUMBER AUTOINCREMENT PRIMARY KEY
        COMMENT 'Unique identifier for each site performance record.',
    SITE_ID                     VARCHAR(20) NOT NULL
        COMMENT 'Unique site identifier code matching TRIAL_ENROLLMENT_METRICS.SITE_ID for joins.',
    SITE_NAME                   VARCHAR(100) NOT NULL
        COMMENT 'Name of the clinical research site.',
    PRINCIPAL_INVESTIGATOR      VARCHAR(100) NOT NULL
        COMMENT 'Name of the Principal Investigator (PI) leading the trial at this site. The PI is the lead physician responsible for trial conduct.',
    PI_SPECIALTY                VARCHAR(50) NOT NULL
        COMMENT 'Medical specialty of the Principal Investigator.',
    RATING_1_TO_5               NUMBER(2,1) NOT NULL
        COMMENT 'Overall site quality rating on a scale of 1 to 5, where 5 is excellent. Based on sponsor assessment of enrollment, compliance, and data quality.',
    MAJOR_DEVIATIONS_COUNT      NUMBER NOT NULL
        COMMENT 'Number of major protocol deviations (violations) at this site. Major deviations may affect patient safety or data integrity.',
    MINOR_DEVIATIONS_COUNT      NUMBER NOT NULL
        COMMENT 'Number of minor protocol deviations at this site. Minor deviations are administrative or procedural issues that do not affect safety or data integrity.',
    TOTAL_QUERIES_ISSUED        NUMBER NOT NULL
        COMMENT 'Total number of data queries issued by the data management team for this site.',
    QUERIES_RESOLVED            NUMBER NOT NULL
        COMMENT 'Number of queries that have been resolved by the site.',
    QUERIES_OUTSTANDING         NUMBER NOT NULL
        COMMENT 'Number of queries still awaiting resolution.',
    AVG_QUERY_RESOLUTION_DAYS   NUMBER(5,1) NOT NULL
        COMMENT 'Average number of days taken to resolve data queries. Lower values indicate better site responsiveness.',
    LAST_MONITORING_DATE        DATE NOT NULL
        COMMENT 'Date of the most recent monitoring visit by the Clinical Research Associate (CRA). Also known as Site Visit Date.',
    MONITORING_FINDINGS         NUMBER NOT NULL
        COMMENT 'Number of findings identified during the last monitoring visit.',
    SITE_STATUS                 VARCHAR(20) NOT NULL
        COMMENT 'Current operational status: ACTIVE, ON_HOLD, CLOSED, or UNDER_REVIEW.',
    COUNTRY                     VARCHAR(50) NOT NULL
        COMMENT 'Country where the site is located.',
    ACTIVATION_DATE             DATE NOT NULL
        COMMENT 'Date when the site was activated for patient enrollment.'
)
COMMENT = 'Site performance dashboard containing quality metrics, protocol compliance data, and monitoring information. Used for site oversight and performance benchmarking. Join with TRIAL_ENROLLMENT_METRICS on SITE_ID.';

-- Insert sample data for site performance (matching sites from enrollment table)
INSERT INTO SITE_PERFORMANCE_DASHBOARD (
    SITE_ID, SITE_NAME, PRINCIPAL_INVESTIGATOR, PI_SPECIALTY, RATING_1_TO_5,
    MAJOR_DEVIATIONS_COUNT, MINOR_DEVIATIONS_COUNT, TOTAL_QUERIES_ISSUED,
    QUERIES_RESOLVED, QUERIES_OUTSTANDING, AVG_QUERY_RESOLUTION_DAYS,
    LAST_MONITORING_DATE, MONITORING_FINDINGS, SITE_STATUS, COUNTRY, ACTIVATION_DATE
) VALUES
    -- US Sites (generally high performing)
    ('SITE-001', 'Memorial Sloan Kettering Cancer Center', 'Dr. Sarah Chen', 'Medical Oncology', 4.8, 1, 3, 145, 140, 5, 2.3, '2024-11-15', 2, 'ACTIVE', 'United States', '2024-01-10'),
    ('SITE-002', 'MD Anderson Cancer Center', 'Dr. Michael Rodriguez', 'Thoracic Oncology', 4.9, 0, 2, 128, 126, 2, 1.8, '2024-11-20', 1, 'ACTIVE', 'United States', '2024-01-15'),
    ('SITE-005', 'Cleveland Clinic', 'Dr. Jennifer Walsh', 'Dermatologic Oncology', 4.5, 2, 5, 175, 168, 7, 3.2, '2024-11-10', 4, 'ACTIVE', 'United States', '2024-02-25'),
    ('SITE-008', 'Dana-Farber Cancer Institute', 'Dr. Robert Kim', 'Breast Oncology', 4.7, 1, 4, 198, 192, 6, 2.5, '2024-11-18', 3, 'ACTIVE', 'United States', '2024-03-28'),
    ('SITE-012', 'Johns Hopkins Sidney Kimmel Cancer Center', 'Dr. Amanda Foster', 'Genitourinary Oncology', 4.6, 1, 3, 156, 150, 6, 2.8, '2024-11-12', 2, 'ACTIVE', 'United States', '2024-05-28'),
    
    -- European Sites (varied performance - some with higher screen failures)
    ('SITE-003', 'University College London Hospitals', 'Dr. James Thompson', 'Medical Oncology', 3.8, 3, 8, 210, 185, 25, 5.5, '2024-10-25', 8, 'UNDER_REVIEW', 'United Kingdom', '2024-01-28'),
    ('SITE-004', 'Charité Berlin', 'Dr. Klaus Mueller', 'Thoracic Surgery', 4.4, 1, 4, 120, 115, 5, 3.0, '2024-11-05', 3, 'ACTIVE', 'Germany', '2024-02-05'),
    ('SITE-006', 'Institut Gustave Roussy', 'Dr. Marie Dubois', 'Surgical Oncology', 3.5, 4, 10, 245, 200, 45, 7.2, '2024-10-20', 12, 'UNDER_REVIEW', 'France', '2024-03-01'),
    ('SITE-009', 'Hospital Universitario 12 de Octubre', 'Dr. Carlos Fernandez', 'Medical Oncology', 3.6, 3, 9, 195, 165, 30, 6.1, '2024-10-28', 9, 'ACTIVE', 'Spain', '2024-04-05'),
    ('SITE-013', 'The Christie NHS Foundation Trust', 'Dr. William Clarke', 'Clinical Oncology', 3.4, 5, 12, 280, 220, 60, 8.5, '2024-10-15', 15, 'UNDER_REVIEW', 'United Kingdom', '2024-06-01'),
    
    -- Asia Pacific Sites (strong performers)
    ('SITE-007', 'National Cancer Center Japan', 'Dr. Takeshi Yamamoto', 'Medical Oncology', 4.9, 0, 1, 135, 134, 1, 1.5, '2024-11-22', 0, 'ACTIVE', 'Japan', '2024-03-05'),
    ('SITE-010', 'Peter MacCallum Cancer Centre', 'Dr. Emily Watson', 'Surgical Oncology', 4.6, 1, 3, 142, 138, 4, 2.4, '2024-11-08', 2, 'ACTIVE', 'Australia', '2024-04-10'),
    ('SITE-011', 'Samsung Medical Center', 'Dr. Jun-Ho Park', 'Gastrointestinal Oncology', 4.8, 0, 2, 118, 117, 1, 1.6, '2024-11-25', 1, 'ACTIVE', 'South Korea', '2024-05-10'),
    
    -- Latin America Site
    ('SITE-014', 'Hospital Israelita Albert Einstein', 'Dr. Paulo Santos', 'Urologic Oncology', 4.3, 2, 5, 165, 155, 10, 3.8, '2024-11-02', 4, 'ACTIVE', 'Brazil', '2024-06-05');

-- Verify data insertion
SELECT 'TRIAL_ENROLLMENT_METRICS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM TRIAL_ENROLLMENT_METRICS
UNION ALL
SELECT 'SITE_PERFORMANCE_DASHBOARD' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM SITE_PERFORMANCE_DASHBOARD;

