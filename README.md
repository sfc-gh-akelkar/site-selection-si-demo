# CRO Sponsor Insights Agent

A Snowflake Intelligence demo showcasing **natural language analytics** for clinical trial operations using Cortex Agents, Semantic Views, and Cortex Search.

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=flat&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)
![AI](https://img.shields.io/badge/Cortex%20AI-FF6F00?style=flat&logo=ai&logoColor=white)

## Overview

This demo enables clinical operations teams to ask questions in plain English across both **structured clinical trial metrics** and **unstructured protocol documents**—without writing SQL or building custom applications.

### Key Capabilities

| Capability | Description |
|------------|-------------|
| 🔍 **Natural Language Queries** | Ask questions like "What is our total enrollment across Phase III studies?" |
| 📊 **Structured Analytics** | Query enrollment, site performance, and quality metrics via Semantic Views |
| 📄 **Document Search** | Search protocol documents for eligibility criteria, dosing, and amendments |
| 🔗 **Cross-Domain Intelligence** | Combine structured and unstructured data in a single query |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   SNOWFLAKE INTELLIGENCE                        │
│                      User Interface                             │
└───────────────────────────┬─────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  ENROLLMENT   │   │     SITE      │   │   PROTOCOL    │
│   ANALYTICS   │   │  PERFORMANCE  │   │    SEARCH     │
│ (Semantic View)│   │ (Semantic View)│   │(Cortex Search)│
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  Enrollment   │   │     Site      │   │   Protocol    │
│   Metrics     │   │   Dashboard   │   │   Documents   │
│   (Table)     │   │   (Table)     │   │   (Chunks)    │
└───────────────┘   └───────────────┘   └───────────────┘
```

## Quick Start

### Prerequisites

- Snowflake account with Cortex features enabled
- Role with appropriate privileges (see [Role Setup](#role-setup) below)

### Role Setup

The demo uses a role called `SF_INTELLIGENCE_DEMO`. Create and configure this role with the required privileges:

```sql
-- Run as ACCOUNTADMIN
USE ROLE ACCOUNTADMIN;

-- Create the demo role
CREATE ROLE IF NOT EXISTS SF_INTELLIGENCE_DEMO;

-- Grant Cortex database roles (required for AI features)
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE SF_INTELLIGENCE_DEMO;

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE <your_warehouse> TO ROLE SF_INTELLIGENCE_DEMO;

-- Grant database creation (or USAGE on existing database)
GRANT CREATE DATABASE ON ACCOUNT TO ROLE SF_INTELLIGENCE_DEMO;

-- Assign role to user
GRANT ROLE SF_INTELLIGENCE_DEMO TO USER <your_username>;
```

#### Required Privileges by Feature

| Feature | Privilege | Object | Notes |
|---------|-----------|--------|-------|
| **Cortex Agent** | `CREATE AGENT` | Schema | Create the agent |
| **Cortex Agent** | `USAGE` | Agent | Query the agent |
| **Semantic View** | `CREATE SEMANTIC VIEW` | Schema | Create semantic views |
| **Semantic View** | `SELECT` | Tables/Views | Access underlying data |
| **Semantic View** | `REFERENCES, SELECT` | Semantic View | Use in Cortex Analyst |
| **Cortex Search** | `CREATE CORTEX SEARCH SERVICE` | Schema | Create search service |
| **Cortex Search** | `SELECT` | Tables/Views | Index source data |
| **Cortex Search** | `USAGE` | Warehouse | Refresh the index |
| **General** | `SNOWFLAKE.CORTEX_USER` | Database Role | Access Cortex AI features |

#### Granting Access to End Users

To allow other users to query the agent (without creation privileges):

```sql
-- Grant usage on database and schema
GRANT USAGE ON DATABASE CRO_DEMO TO ROLE <user_role>;
GRANT USAGE ON SCHEMA CRO_DEMO.CLINICAL_OPERATIONS TO ROLE <user_role>;

-- Grant usage on the agent
GRANT USAGE ON AGENT CRO_DEMO.CLINICAL_OPERATIONS.SPONSOR_INSIGHTS_AGENT TO ROLE <user_role>;

-- Grant Cortex access
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE <user_role>;
```

### Installation

Run the SQL scripts in order using Snowsight:

```sql
-- 1. Database & Schema Setup
-- Execute: 01_database_schema_setup.sql

-- 2. Structured Data Tables  
-- Execute: 02_structured_data_tables.sql

-- 3. Semantic Views
-- Execute: 03_semantic_views.sql

-- 4. Unstructured Data & Cortex Search
-- Execute: 04_unstructured_data_cortex_search.sql

-- 5. Cortex Agent
-- Execute: 05_cortex_agent.sql
```

### Verify Deployment

```sql
USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA CRO_DEMO.CLINICAL_OPERATIONS;

SHOW TABLES;
SHOW SEMANTIC VIEWS;
SHOW CORTEX SEARCH SERVICES;
SHOW AGENTS;
```

### Access the Agent

Navigate to **Snowflake Intelligence** in Snowsight and select **"Sponsor Insights Agent"**.

## Sample Questions

### Structured Data Analytics

```
What is our total enrollment across all Phase III studies?
```
```
Which sites have screen failure rates above 30%?
```
```
Compare enrollment rates by region
```

### Unstructured Document Search

```
What are the exclusion criteria for patients with brain metastases?
```
```
What is the dosing regimen for the TNBC study?
```
```
What changes were made in Amendment 2 of the NSCLC study?
```

### Cross-Domain Queries

```
For the study with the highest screen failure rate, what are the exclusion criteria?
```
```
Give me a summary of enrollment progress and any quality concerns for MED-ONC-2024-001
```

## Sample Data

| Metric | Value |
|--------|-------|
| Studies | 5 Phase III oncology trials |
| Sites | 14 global sites across 10 countries |
| Total Enrollment | 668 patients |
| Regions | North America, Europe, Asia Pacific, Latin America |
| Protocol Docs | 12 document chunks (exclusion, dosing, amendments, safety) |

## Project Structure

```
├── 00_run_all_setup.sql              # Master setup script
├── 01_database_schema_setup.sql      # Database & schema creation
├── 02_structured_data_tables.sql     # Enrollment & performance tables
├── 03_semantic_views.sql             # Semantic views with business context
├── 04_unstructured_data_cortex_search.sql  # Protocol docs & search service
├── 05_cortex_agent.sql               # Cortex Agent definition
└── SAMPLE_QUESTIONS.md               # Example questions for the agent
```

## Snowflake Components Used

| Component | Purpose |
|-----------|---------|
| **Snowflake Intelligence** | Natural language chat interface |
| **Cortex Agent** | Multi-tool orchestration |
| **Semantic Views** | Business-contextualized data model |
| **Cortex Analyst** | Text-to-SQL generation |
| **Cortex Search** | Semantic document retrieval |

## Documentation

- [Sample Questions](SAMPLE_QUESTIONS.md) - Example questions to ask the agent

## Troubleshooting

### Agent Not Responding
```sql
SHOW AGENTS IN SCHEMA CRO_DEMO.CLINICAL_OPERATIONS;
DESCRIBE AGENT SPONSOR_INSIGHTS_AGENT;
```

### Search Not Working
```sql
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CRO_DEMO.CLINICAL_OPERATIONS.PROTOCOL_SEARCH_SERVICE',
    '{
        "query": "exclusion criteria brain metastases",
        "columns": ["CHUNK_TEXT", "STUDY_ID", "SECTION_TYPE"],
        "limit": 3
    }'
);
```

### Force Refresh Cortex Search Index
```sql
ALTER CORTEX SEARCH SERVICE PROTOCOL_SEARCH_SERVICE REFRESH;
```

## License

This solution accelerator is provided as a reference implementation for Snowflake Intelligence capabilities.

---

Built with ❄️ Snowflake Cortex

