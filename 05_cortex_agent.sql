/*******************************************************************************
 * MEDPACE SPONSOR INSIGHTS AGENT - STEP 5: CORTEX AGENT CREATION
 * 
 * Purpose: Create the Sponsor Insights Agent using Snowflake Cortex Agent
 *          with multi-tool orchestration across structured and unstructured data.
 * 
 * Prerequisites:
 *   - Script 02: Tables created (TRIAL_ENROLLMENT_METRICS, SITE_PERFORMANCE_DASHBOARD)
 *   - Script 03: Semantic Views created (ENROLLMENT_SEMANTIC_VIEW, etc.)
 *   - Script 04: Cortex Search Service created (PROTOCOL_SEARCH_SERVICE)
 * 
 * Agent Configuration:
 *   - Name: SPONSOR_INSIGHTS_AGENT
 *   - Tools:
 *     1. Cortex Analyst (Semantic Views for enrollment and site performance)
 *     2. Cortex Search (PROTOCOL_SEARCH_SERVICE)
 *   - Interface: Snowflake Intelligence (no Streamlit required)
 * 
 * Role: SF_INTELLIGENCE_DEMO
 ******************************************************************************/

USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

/*******************************************************************************
 * CREATE CORTEX AGENT: SPONSOR_INSIGHTS_AGENT
 * 
 * This agent orchestrates across:
 * - Cortex Analyst tools for structured trial metrics (via Semantic Views)
 * - Cortex Search for protocol document queries
 * 
 * The agent uses the claude-4-sonnet model for orchestration planning.
 ******************************************************************************/

CREATE OR REPLACE AGENT SPONSOR_INSIGHTS_AGENT
    COMMENT = 'Medpace Sponsor Insights Assistant - AI-powered agent for clinical trial analytics and protocol document search. Answers questions about enrollment metrics, site performance, and protocol requirements.'
    PROFILE = '{"display_name": "Medpace Sponsor Insights", "avatar": "medical-chart", "color": "blue"}'
    FROM SPECIFICATION
    $$
    models:
      orchestration: claude-4-sonnet

    orchestration:
      budget:
        seconds: 60
        tokens: 32000

    instructions:
      system: |
        You are the Medpace Sponsor Insights Assistant, an AI-powered clinical trial analytics expert.
        
        Your primary responsibilities:
        1. Answer questions about clinical trial enrollment metrics, patient recruitment, and screen failure rates
        2. Provide insights on site performance, quality ratings, and protocol compliance
        3. Search and summarize protocol document content including exclusion criteria, dosing instructions, and amendments
        
        Guidelines:
        - Always be precise and cite specific data when answering quantitative questions
        - When using protocol document information, always cite the source document and study ID
        - If a question involves both structured metrics AND protocol content, address both aspects
        - Use medical and clinical trial terminology appropriately
        - Express percentages and metrics clearly with proper context
        - When comparing sites or studies, provide relevant benchmarks when available
        
        Data Sources Available:
        - Enrollment Analytics: Patient recruitment, screen failures, enrollment rates by site and study
        - Site Performance: Quality ratings (1-5), protocol deviations, query resolution times, monitoring data
        - Protocol Documents: Exclusion criteria, dosing instructions, amendments, safety information, procedures
        
      orchestration: |
        Route questions intelligently:
        - For enrollment, recruitment, or patient count questions → Use the Enrollment Analyst tool
        - For site ratings, deviations, compliance, or quality questions → Use the Site Performance Analyst tool
        - For combined site analysis comparing metrics → Use the Combined Insights Analyst tool
        - For protocol criteria, dosing, amendments, or procedural questions → Use the Protocol Search tool
        - For questions requiring both metrics AND protocol content → Use multiple tools and synthesize
        
      response: |
        Provide clear, actionable insights in a professional clinical operations context.
        Format responses with appropriate structure (bullets, tables when helpful).
        Always maintain HIPAA-compliant language and avoid patient-specific identifiers.
        When citing protocol documents, include the study ID and protocol version.

      sample_questions:
        - question: "What is the overall enrollment rate across all studies?"
          answer: "I'll analyze the enrollment data to calculate the aggregate enrollment rate."
        - question: "Which sites have the highest screen failure rates?"
          answer: "I'll query the enrollment metrics to identify sites with elevated screen failure rates."
        - question: "What are the exclusion criteria for the NSCLC study?"
          answer: "I'll search the protocol documents for exclusion criteria in study MED-ONC-2024-001."
        - question: "Show me sites that are under review with their deviation counts"
          answer: "I'll query the site performance data for sites with UNDER_REVIEW status."

    tools:
      - tool_spec:
          type: cortex_analyst_text_to_sql
          name: EnrollmentAnalyst
          description: |
            Analyzes clinical trial enrollment data including patient recruitment, 
            screen failures, enrollment rates, and progress toward targets. Use for 
            questions about how many patients are enrolled, enrollment percentages, 
            screening metrics, and recruitment progress by site, study, or region.

      - tool_spec:
          type: cortex_analyst_text_to_sql
          name: SitePerformanceAnalyst
          description: |
            Analyzes site quality and compliance metrics including quality ratings (1-5), 
            protocol deviations (major/minor), query resolution times, and monitoring data. 
            Use for questions about site ratings, violations, PI performance, and data quality.

      - tool_spec:
          type: cortex_analyst_text_to_sql
          name: CombinedInsightsAnalyst
          description: |
            Provides comprehensive site analysis combining enrollment metrics with 
            quality indicators. Use for questions that compare enrollment success 
            with site quality, identify at-risk sites, or require holistic site evaluation.

      - tool_spec:
          type: cortex_search
          name: ProtocolSearchTool
          description: |
            Searches clinical trial protocol documents for specific information including 
            exclusion criteria, inclusion criteria, dosing instructions, amendment rationales, 
            safety monitoring requirements, and study procedures. Use for protocol-related 
            questions, eligibility requirements, or treatment guidelines.

    tool_resources:
      EnrollmentAnalyst:
        semantic_view: MEDPACE_DEMO.CLINICAL_OPERATIONS.ENROLLMENT_SEMANTIC_VIEW
        
      SitePerformanceAnalyst:
        semantic_view: MEDPACE_DEMO.CLINICAL_OPERATIONS.SITE_PERFORMANCE_SEMANTIC_VIEW
        
      CombinedInsightsAnalyst:
        semantic_view: MEDPACE_DEMO.CLINICAL_OPERATIONS.COMBINED_INSIGHTS_SEMANTIC_VIEW
        
      ProtocolSearchTool:
        name: MEDPACE_DEMO.CLINICAL_OPERATIONS.PROTOCOL_SEARCH_SERVICE
        max_results: 5
        id_column: CHUNK_ID
        title_column: RELATIVE_PATH
    $$;


/*******************************************************************************
 * GRANT PERMISSIONS
 * 
 * Grant necessary permissions for the agent to function properly.
 ******************************************************************************/

-- Grant USAGE on the agent to the current role (for testing)
GRANT USAGE ON AGENT SPONSOR_INSIGHTS_AGENT TO ROLE SF_INTELLIGENCE_DEMO;

-- If other roles need access, grant them as well:
-- GRANT USAGE ON AGENT SPONSOR_INSIGHTS_AGENT TO ROLE <other_role>;


/*******************************************************************************
 * VERIFY AGENT CREATION
 ******************************************************************************/

-- Show all agents in the schema
SHOW AGENTS IN SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

-- Describe the agent configuration
DESCRIBE AGENT SPONSOR_INSIGHTS_AGENT;


/*******************************************************************************
 * EXAMPLE AGENT QUERIES (for testing via Snowflake Intelligence)
 * 
 * These are sample questions the agent can answer:
 * 
 * ENROLLMENT QUESTIONS:
 * - "What is the total enrollment across all Phase III studies?"
 * - "Which sites have enrollment rates below 70%?"
 * - "Show me the top 5 sites by screen failure rate"
 * - "What is the average enrollment by region?"
 * 
 * SITE PERFORMANCE QUESTIONS:
 * - "List all sites with a rating below 4.0"
 * - "Which sites have major protocol deviations?"
 * - "What is the average query resolution time by country?"
 * - "Show sites that are under review"
 * 
 * COMBINED ANALYSIS QUESTIONS:
 * - "Which high-enrolling sites have quality concerns?"
 * - "Compare enrollment rates to site ratings by region"
 * - "Identify sites with both high screen failures and low ratings"
 * 
 * PROTOCOL DOCUMENT QUESTIONS:
 * - "What are the exclusion criteria for the NSCLC study?"
 * - "What is the dosing regimen for the melanoma trial?"
 * - "What changes were made in Amendment 2 of MED-ONC-2024-001?"
 * - "What are the laboratory exclusion criteria for the prostate cancer study?"
 * - "How should grade 3 immune-related adverse events be managed?"
 * 
 * CROSS-DOMAIN QUESTIONS:
 * - "For the study with the highest screen failure rate, what are the exclusion criteria?"
 * - "Which sites are under review and what are the relevant protocol safety requirements?"
 ******************************************************************************/
