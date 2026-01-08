/*******************************************************************************
 * CLINICAL_TRIAL SPONSOR INSIGHTS AGENT - STEP 3: SEMANTIC VIEWS
 * 
 * Purpose: Create Semantic Views with proper DDL structure for Cortex Analyst.
 *          These views define the business data model with facts, dimensions,
 *          and metrics that enable natural language queries.
 * 
 * Reference: https://docs.snowflake.com/en/user-guide/views-semantic/example
 * 
 * Role: SF_INTELLIGENCE_DEMO
 ******************************************************************************/

USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

/*******************************************************************************
 * SEMANTIC VIEW 1: ENROLLMENT_SEMANTIC_VIEW
 * 
 * Semantic view for Cortex Analyst to answer enrollment-related questions.
 * Based on TRIAL_ENROLLMENT_METRICS table.
 ******************************************************************************/

CREATE OR REPLACE SEMANTIC VIEW ENROLLMENT_SEMANTIC_VIEW

    TABLES (
        enrollment AS CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.TRIAL_ENROLLMENT_METRICS 
            PRIMARY KEY (ENROLLMENT_ID)
            COMMENT = 'Clinical trial enrollment data with patient recruitment metrics per site and study.'
    )

    FACTS (
        enrollment.enrollment_id 
            AS ENROLLMENT_ID 
            COMMENT = 'Unique identifier for each enrollment record.',
        enrollment.study_id 
            AS STUDY_ID 
            COMMENT = 'Protocol identifier. Synonyms: Protocol Number, Protocol ID, Trial ID.',
        enrollment.site_id 
            AS SITE_ID 
            COMMENT = 'Unique site identifier. Synonyms: Site Number, Site Code, Center ID.',
        enrollment.sponsor_id 
            AS SPONSOR_ID 
            COMMENT = 'Pharmaceutical sponsor identifier. Synonyms: Pharma Company, Drug Company.',
        enrollment.planned_enrollment 
            AS PLANNED_ENROLLMENT 
            COMMENT = 'Target number of patients to enroll. Synonyms: Enrollment Target, Recruitment Goal.',
        enrollment.actual_enrollment 
            AS ACTUAL_ENROLLMENT 
            COMMENT = 'Patients successfully randomized. Synonyms: Enrolled Patients, Randomized Patients.',
        enrollment.screen_failures 
            AS SCREEN_FAILURES 
            COMMENT = 'Patients who failed screening. Synonyms: Screening Failures, Failed Screens, Screen Outs.'
    )

    DIMENSIONS (
        enrollment.site_name 
            AS SITE_NAME 
            COMMENT = 'Clinical research site name. Synonyms: Institution, Hospital, Research Center.',
        enrollment.trial_phase 
            AS TRIAL_PHASE 
            COMMENT = 'Trial phase (Phase I, II, III, IV). Synonyms: Study Phase, Development Phase.',
        enrollment.therapeutic_area 
            AS THERAPEUTIC_AREA 
            COMMENT = 'Medical specialty. Synonyms: Disease Area, Therapy Area. Example: Oncology.',
        enrollment.indication 
            AS INDICATION 
            COMMENT = 'Specific disease treated. Synonyms: Disease, Condition, Diagnosis.',
        enrollment.enrollment_status 
            AS ENROLLMENT_STATUS 
            COMMENT = 'Recruitment status: ACTIVE, COMPLETED, PAUSED, CLOSED.',
        enrollment.enrollment_start_date 
            AS ENROLLMENT_START_DATE 
            COMMENT = 'Date enrollment began. Synonyms: FPFV Date, First Patient First Visit.',
        enrollment.country 
            AS COUNTRY 
            COMMENT = 'Site country location.',
        enrollment.region 
            AS REGION 
            COMMENT = 'Geographic region: North America, Europe, Asia Pacific, Latin America.'
    )

    METRICS (
        enrollment.total_actual_enrollment 
            AS SUM(ACTUAL_ENROLLMENT) 
            COMMENT = 'Total patients enrolled across all records.',
        enrollment.total_planned_enrollment 
            AS SUM(PLANNED_ENROLLMENT) 
            COMMENT = 'Total enrollment target across all records.',
        enrollment.total_screen_failures 
            AS SUM(SCREEN_FAILURES) 
            COMMENT = 'Total screen failures across all records.',
        enrollment.avg_enrollment_rate 
            AS AVG(ACTUAL_ENROLLMENT * 100.0 / NULLIF(PLANNED_ENROLLMENT, 0)) 
            COMMENT = 'Average enrollment rate percentage. Above 80% is strong.',
        enrollment.avg_screen_failure_rate 
            AS AVG(SCREEN_FAILURES * 100.0 / NULLIF(SCREEN_FAILURES + ACTUAL_ENROLLMENT, 0)) 
            COMMENT = 'Average screen failure rate. Benchmark is 15-25%.',
        enrollment.site_count 
            AS COUNT(DISTINCT SITE_ID) 
            COMMENT = 'Number of unique sites.',
        enrollment.study_count 
            AS COUNT(DISTINCT STUDY_ID) 
            COMMENT = 'Number of unique studies.'
    )

    COMMENT = 'Semantic view for clinical trial enrollment analytics. Use for questions about enrollment rates, screen failures, recruitment progress, and site-level enrollment performance.';


/*******************************************************************************
 * SEMANTIC VIEW 2: SITE_PERFORMANCE_SEMANTIC_VIEW
 * 
 * Semantic view for Cortex Analyst to answer site quality questions.
 * Based on SITE_PERFORMANCE_DASHBOARD table.
 ******************************************************************************/

CREATE OR REPLACE SEMANTIC VIEW SITE_PERFORMANCE_SEMANTIC_VIEW

    TABLES (
        site_perf AS CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.SITE_PERFORMANCE_DASHBOARD 
            PRIMARY KEY (PERFORMANCE_ID)
            COMMENT = 'Site performance data including quality ratings, deviations, and monitoring metrics.'
    )

    FACTS (
        site_perf.performance_id 
            AS PERFORMANCE_ID 
            COMMENT = 'Unique identifier for site performance record.',
        site_perf.site_id 
            AS SITE_ID 
            COMMENT = 'Site identifier. Synonyms: Site Number, Site Code.',
        site_perf.major_deviations_count 
            AS MAJOR_DEVIATIONS_COUNT 
            COMMENT = 'Major protocol violations affecting safety/data. Synonyms: Major Violations, Critical Deviations.',
        site_perf.minor_deviations_count 
            AS MINOR_DEVIATIONS_COUNT 
            COMMENT = 'Minor administrative deviations. Synonyms: Minor Violations.',
        site_perf.total_queries_issued 
            AS TOTAL_QUERIES_ISSUED 
            COMMENT = 'Data queries issued by data management. Synonyms: DM Queries.',
        site_perf.queries_resolved 
            AS QUERIES_RESOLVED 
            COMMENT = 'Queries successfully resolved. Synonyms: Closed Queries.',
        site_perf.queries_outstanding 
            AS QUERIES_OUTSTANDING 
            COMMENT = 'Open queries pending. Synonyms: Open Queries, Pending Queries.',
        site_perf.avg_query_resolution_days 
            AS AVG_QUERY_RESOLUTION_DAYS 
            COMMENT = 'Average days to resolve queries. Under 5 days is good.',
        site_perf.rating_1_to_5 
            AS RATING_1_TO_5 
            COMMENT = 'Quality rating 1-5 (5=excellent). Synonyms: Site Rating, Quality Score.',
        site_perf.monitoring_findings 
            AS MONITORING_FINDINGS 
            COMMENT = 'Findings from last monitoring visit. Synonyms: Audit Findings.'
    )

    DIMENSIONS (
        site_perf.site_name 
            AS SITE_NAME 
            COMMENT = 'Site name. Synonyms: Institution, Hospital.',
        site_perf.principal_investigator 
            AS PRINCIPAL_INVESTIGATOR 
            COMMENT = 'Lead physician. Synonyms: PI, Lead Investigator, Site PI.',
        site_perf.pi_specialty 
            AS PI_SPECIALTY 
            COMMENT = 'PI medical specialty.',
        site_perf.site_status 
            AS SITE_STATUS 
            COMMENT = 'Status: ACTIVE, ON_HOLD, CLOSED, UNDER_REVIEW.',
        site_perf.last_monitoring_date 
            AS LAST_MONITORING_DATE 
            COMMENT = 'Most recent CRA visit. Synonyms: Last Site Visit.',
        site_perf.activation_date 
            AS ACTIVATION_DATE 
            COMMENT = 'Site activation date. Synonyms: Go-Live Date.',
        site_perf.country 
            AS COUNTRY 
            COMMENT = 'Site country location.'
    )

    METRICS (
        site_perf.avg_rating 
            AS AVG(RATING_1_TO_5) 
            COMMENT = 'Average site quality rating.',
        site_perf.total_major_deviations 
            AS SUM(MAJOR_DEVIATIONS_COUNT) 
            COMMENT = 'Total major deviations across sites.',
        site_perf.total_minor_deviations 
            AS SUM(MINOR_DEVIATIONS_COUNT) 
            COMMENT = 'Total minor deviations across sites.',
        site_perf.total_deviations 
            AS SUM(MAJOR_DEVIATIONS_COUNT + MINOR_DEVIATIONS_COUNT) 
            COMMENT = 'Total all deviations. Synonyms: Total Violations.',
        site_perf.avg_query_resolution 
            AS AVG(AVG_QUERY_RESOLUTION_DAYS) 
            COMMENT = 'Average query resolution time in days.',
        site_perf.total_outstanding_queries 
            AS SUM(QUERIES_OUTSTANDING) 
            COMMENT = 'Total open queries across sites.',
        site_perf.site_count 
            AS COUNT(DISTINCT SITE_ID) 
            COMMENT = 'Number of sites.',
        site_perf.sites_under_review 
            AS COUNT_IF(SITE_STATUS = 'UNDER_REVIEW') 
            COMMENT = 'Count of sites under review.'
    )

    COMMENT = 'Semantic view for site performance and quality metrics. Use for questions about site ratings, protocol deviations (violations), query resolution times, and compliance.';


/*******************************************************************************
 * SEMANTIC VIEW 3: COMBINED_INSIGHTS_SEMANTIC_VIEW
 * 
 * Semantic view joining enrollment and site performance for holistic analysis.
 * Uses RELATIONSHIPS to join the two tables.
 ******************************************************************************/

CREATE OR REPLACE SEMANTIC VIEW COMBINED_INSIGHTS_SEMANTIC_VIEW

    TABLES (
        enrollment AS CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.TRIAL_ENROLLMENT_METRICS 
            PRIMARY KEY (ENROLLMENT_ID)
            COMMENT = 'Enrollment metrics per site and study.',
        site_perf AS CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.SITE_PERFORMANCE_DASHBOARD 
            PRIMARY KEY (PERFORMANCE_ID)
            UNIQUE (SITE_ID)
            COMMENT = 'Site quality and performance data.'
    )

    RELATIONSHIPS (
        enrollment (SITE_ID) REFERENCES site_perf (SITE_ID)
    )

    FACTS (
        enrollment.study_id AS STUDY_ID COMMENT = 'Protocol identifier.',
        enrollment.site_id AS SITE_ID COMMENT = 'Site identifier.',
        enrollment.planned_enrollment AS PLANNED_ENROLLMENT COMMENT = 'Enrollment target.',
        enrollment.actual_enrollment AS ACTUAL_ENROLLMENT COMMENT = 'Patients enrolled.',
        enrollment.screen_failures AS SCREEN_FAILURES COMMENT = 'Screen failures.',
        site_perf.rating_1_to_5 AS RATING_1_TO_5 COMMENT = 'Site quality rating 1-5.',
        site_perf.major_deviations_count AS MAJOR_DEVIATIONS_COUNT COMMENT = 'Major violations.',
        site_perf.minor_deviations_count AS MINOR_DEVIATIONS_COUNT COMMENT = 'Minor violations.',
        site_perf.avg_query_resolution_days AS AVG_QUERY_RESOLUTION_DAYS COMMENT = 'Query resolution time.',
        site_perf.queries_outstanding AS QUERIES_OUTSTANDING COMMENT = 'Open queries.'
    )

    DIMENSIONS (
        enrollment.site_name AS SITE_NAME COMMENT = 'Site name.',
        enrollment.sponsor_id AS SPONSOR_ID COMMENT = 'Sponsor identifier.',
        enrollment.trial_phase AS TRIAL_PHASE COMMENT = 'Trial phase.',
        enrollment.therapeutic_area AS THERAPEUTIC_AREA COMMENT = 'Therapeutic area.',
        enrollment.indication AS INDICATION COMMENT = 'Disease indication.',
        enrollment.enrollment_status AS ENROLLMENT_STATUS COMMENT = 'Enrollment status.',
        enrollment.country AS COUNTRY COMMENT = 'Country.',
        enrollment.region AS REGION COMMENT = 'Geographic region.',
        site_perf.principal_investigator AS PRINCIPAL_INVESTIGATOR COMMENT = 'PI name.',
        site_perf.site_status AS SITE_STATUS COMMENT = 'Site operational status.'
    )

    METRICS (
        enrollment.total_enrolled AS SUM(ACTUAL_ENROLLMENT) COMMENT = 'Total patients enrolled.',
        enrollment.total_planned AS SUM(PLANNED_ENROLLMENT) COMMENT = 'Total planned enrollment.',
        enrollment.total_failures AS SUM(SCREEN_FAILURES) COMMENT = 'Total screen failures.',
        enrollment.enrollment_rate AS AVG(ACTUAL_ENROLLMENT * 100.0 / NULLIF(PLANNED_ENROLLMENT, 0)) COMMENT = 'Enrollment rate %.',
        enrollment.screen_failure_rate AS AVG(SCREEN_FAILURES * 100.0 / NULLIF(SCREEN_FAILURES + ACTUAL_ENROLLMENT, 0)) COMMENT = 'Screen failure rate %.',
        site_perf.avg_site_rating AS AVG(RATING_1_TO_5) COMMENT = 'Average site rating.',
        site_perf.total_deviations AS SUM(MAJOR_DEVIATIONS_COUNT + MINOR_DEVIATIONS_COUNT) COMMENT = 'Total deviations.',
        site_perf.avg_query_time AS AVG(AVG_QUERY_RESOLUTION_DAYS) COMMENT = 'Average query resolution days.'
    )

    COMMENT = 'Comprehensive semantic view joining enrollment and site performance. Use for holistic site analysis, comparing enrollment success with quality metrics, and identifying at-risk sites.';


/*******************************************************************************
 * VERIFY SEMANTIC VIEWS
 ******************************************************************************/

-- Show semantic views
SHOW SEMANTIC VIEWS IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

-- Describe each semantic view
DESCRIBE SEMANTIC VIEW ENROLLMENT_SEMANTIC_VIEW;
DESCRIBE SEMANTIC VIEW SITE_PERFORMANCE_SEMANTIC_VIEW;
DESCRIBE SEMANTIC VIEW COMBINED_INSIGHTS_SEMANTIC_VIEW;
