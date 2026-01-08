/*******************************************************************************
 * CLINICAL_TRIAL SPONSOR INSIGHTS AGENT - MASTER SETUP SCRIPT
 * 
 * Purpose: Execute all setup scripts in sequence to deploy the complete
 *          Clinical Trial Insights Agent backend.
 * 
 * IMPORTANT: Run each script in order. If running this as a single script,
 *            ensure your Snowflake environment supports multi-statement execution.
 * 
 * Role Required: SF_INTELLIGENCE_DEMO
 * 
 * Execution Order:
 *   1. 01_database_schema_setup.sql     - Creates CLINICAL_TRIAL_DEMO database and schema
 *   2. 02_structured_data_tables.sql    - Creates enrollment and performance tables
 *   3. 03_semantic_views.sql            - Creates semantic views with comments
 *   4. 04_unstructured_data_cortex_search.sql - Protocol docs and search service
 *   5. 05_cortex_agent.sql              - Creates the Cortex Agent
 * 
 * Post-Deployment: Access the agent via Snowflake Intelligence UI
 ******************************************************************************/

-- Verify role access
USE ROLE SF_INTELLIGENCE_DEMO;

-- Display execution plan
SELECT '=== CLINICAL_TRIAL SPONSOR INSIGHTS AGENT DEPLOYMENT ===' AS STATUS;
SELECT 'Please execute the following scripts in order:' AS INSTRUCTIONS;
SELECT '1. 01_database_schema_setup.sql' AS SCRIPT_1;
SELECT '2. 02_structured_data_tables.sql' AS SCRIPT_2;
SELECT '3. 03_semantic_views.sql' AS SCRIPT_3;
SELECT '4. 04_unstructured_data_cortex_search.sql' AS SCRIPT_4;
SELECT '5. 05_cortex_agent.sql' AS SCRIPT_5;

/*
================================================================================
                        QUICK DEPLOYMENT OPTION
================================================================================

If you prefer to run all scripts as a single deployment, copy and paste
the contents of each numbered script below in sequence. Alternatively,
use Snowsight's worksheet feature to run each file individually.

The scripts are designed to be idempotent (CREATE OR REPLACE) so they
can be re-run safely.

================================================================================
                        VERIFICATION QUERIES
================================================================================
*/

-- After running all scripts, use these queries to verify deployment:

-- 1. Verify database and schema
-- SHOW SCHEMAS IN DATABASE CLINICAL_TRIAL_DEMO;

-- 2. Verify tables
-- SHOW TABLES IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

-- 3. Verify views
-- SHOW VIEWS IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

-- 4. Verify Cortex Search Service
-- SHOW CORTEX SEARCH SERVICES IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

-- 5. Verify Agent
-- SHOW AGENTS IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;
-- DESCRIBE AGENT CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.SPONSOR_INSIGHTS_AGENT;

-- 6. Sample data verification
-- SELECT * FROM CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.ENROLLMENT_ANALYTICS_VIEW LIMIT 5;
-- SELECT * FROM CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.SITE_PERFORMANCE_VIEW LIMIT 5;
-- SELECT * FROM CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.TRIAL_PROTOCOL_DOCUMENTS_CHUNKS LIMIT 5;

-- 7. Test Cortex Search (uncomment to run)
-- SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
--     'CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.PROTOCOL_SEARCH_SERVICE',
--     '{
--         "query": "What are the exclusion criteria for patients with brain metastases?",
--         "columns": ["CHUNK_TEXT", "STUDY_ID", "SECTION_TYPE"],
--         "limit": 3
--     }'
-- );

/*
================================================================================
                     ACCESSING THE AGENT
================================================================================

After successful deployment, access the Clinical Trial Insights Agent via:

1. Navigate to Snowflake Intelligence in Snowsight
2. Select the SPONSOR_INSIGHTS_AGENT from available agents
3. Start asking questions like:
   - "What is the overall enrollment rate?"
   - "Which sites have the most protocol deviations?"
   - "What are the exclusion criteria for the NSCLC study?"

================================================================================
*/

