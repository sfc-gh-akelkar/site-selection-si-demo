# Medpace Sponsor Insights Agent - Demo Guide

## 🎯 Demo Objective

Demonstrate how Snowflake Intelligence enables **natural language analytics** across both structured clinical trial metrics and unstructured protocol documents—all without writing SQL or building a custom application.

---

## 📋 Pre-Demo Setup

### 1. Execute Scripts in Order

```sql
-- Run each script in Snowsight SQL Worksheet
-- Script 01: Database & Schema Setup
-- Script 02: Structured Data Tables  
-- Script 03: Semantic Views
-- Script 04: Unstructured Data & Cortex Search
-- Script 05: Cortex Agent
```

### 2. Verify Deployment

```sql
USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

-- Check all components
SHOW TABLES;
SHOW SEMANTIC VIEWS;
SHOW CORTEX SEARCH SERVICES;
SHOW AGENTS;
```

### 3. Access the Agent

Navigate to **Snowflake Intelligence** in Snowsight and select **"Medpace Sponsor Insights"** agent.

---

## 🌟 Demo Flow & WOW Questions

### Act 1: The Business Challenge (2 min)

**Setup the story:**
> "Clinical operations teams at CROs like Medpace need to answer questions from sponsors every day—about enrollment progress, site quality, and protocol requirements. Today, this requires SQL expertise, switching between multiple systems, and manually searching through protocol documents. What if they could just ask questions in plain English?"

---

### Act 2: Structured Data Analytics (5 min)

#### 🔥 Question 1: Quick Enrollment Overview
```
What is our total enrollment across all Phase III studies?
```

**✅ Verified Response:**
> The total enrollment across all Phase III studies is **668 patients**.
> This enrollment spans across **5 different Phase III studies**, with enrollment activities occurring between January 15, 2024 and June 10, 2024.

**Talking Point:** "Notice how the agent understands 'enrollment' and 'Phase III' without any SQL. The semantic view provides the business context."

---

#### 🔥 Question 2: Identify Problem Sites
```
Which sites have screen failure rates above 30%?
```

**✅ Verified Response:**
> **4 sites** with screen failure rates above 30%:
> 1. The Christie NHS Foundation Trust - **36.5%** (23 failures / 63 screened)
> 2. Hospital Universitario 12 de Octubre - **34.4%** (22 failures / 64 screened)
> 3. Institut Gustave Roussy - **34.2%** (25 failures / 73 screened)
> 4. University College London Hospitals - **34.2%** (38 failures / 111 screened)
> 
> All four sites are in Europe. These elevated rates may warrant investigation.

**Talking Point:** "High screen failure rates often indicate protocol design issues or poor site selection. This insight typically requires a data analyst—now anyone can find it instantly."

---

#### 🔥 Question 3: Regional Performance Comparison
```
Compare enrollment rates by region
```

**✅ Verified Response:**
> | Region | Enrollment Rate | Sites | Patients |
> |--------|-----------------|-------|----------|
> | Asia Pacific | 88.4% | 3 | 115 |
> | North America | 84.1% | 5 | 290 |
> | Europe | 82.5% | 5 | 231 |
> | Latin America | 80.0% | 1 | 32 |
> 
> Asia Pacific leads in efficiency; North America contributes most volume.

**Talking Point:** "Sponsors often ask 'How is Europe performing vs. US?' This answers that in seconds."

---

#### 🔥 Question 4: Site Quality Deep Dive
```
Show me all sites that are under review with their deviation counts and ratings
```

**✅ Verified Response:**
> **3 sites** currently under review:
> 
> 1. **University College London Hospitals** - Rating 3.8, 11 deviations (3 major), 25 outstanding queries
> 2. **Institut Gustave Roussy** - Rating 3.5, 14 deviations (4 major), 45 outstanding queries
> 3. **The Christie NHS Foundation Trust** - Rating 3.4, 17 deviations (5 major), 60 outstanding queries
> 
> Clear correlation between higher deviation counts and lower ratings.

**Talking Point:** "This is exactly what a medical monitor needs before a sponsor call—instant visibility into problem sites."

---

### Act 3: Unstructured Document Search (5 min)

#### 🔥 Question 5: Protocol Eligibility
```
What are the exclusion criteria for patients with brain metastases?
```

**✅ Verified Response:**
> **MED-ONC-2024-001 (NSCLC):**
> - Symptomatic brain metastases are excluded
> - Stable, treated brain metastases allowed if off steroids for ≥14 days
> - Leptomeningeal carcinomatosis is excluded
> 
> **MED-ONC-2024-002 (Melanoma):**
> - Active CNS metastases excluded
> - Previously treated and stable ≥4 weeks permitted

**Talking Point:** "Instead of searching through 200-page PDF protocols, the agent finds and synthesizes the exact language from multiple studies—with citations."

---

#### 🔥 Question 6: Dosing Questions
```
What is the dosing regimen for the TNBC study?
```

**✅ Verified Response:**
> **MED-ONC-2024-003 (TNBC):** MED-5678 (ADC targeting TROP-2)
> - **Dose:** 10 mg/kg IV on Days 1 and 8 of each 21-day cycle
> - **Infusion:** 90 min first dose, 30 min subsequent
> - **Neutropenia Grade 4:** Reduce to 7.5 mg/kg
> - **Diarrhea Grade 3:** Hold, reduce to 7.5 mg/kg
> - **Antiemetics required:** 5-HT3 + dexamethasone + NK1 antagonist

**Talking Point:** "Medical monitors get these questions constantly. Now they have an instant, protocol-accurate answer."

---

#### 🔥 Question 7: Amendment Changes
```
What changes were made in Amendment 2 of the NSCLC study?
```

**✅ Verified Response:**
> **Amendment 2 (MED-ONC-2024-001) - Effective March 1, 2024:**
> 
> 1. **Eligibility (High Impact):** Prior KRAS G12C therapy now EXCLUDED (8% vs 35% ORR)
> 2. **Biomarkers (Medium):** Mandatory PD-L1 testing at screening
> 3. **Dose Mods (Low):** Added hepatitis management guidance
> 4. **Statistics (Medium):** Sample size 400 → 450 patients
> 
> Implementation: Re-consent required, site training March 15, 2024

**Talking Point:** "When sponsors ask 'What changed in the latest amendment?', this gives a complete answer with rationale—no manual document review."

---

### Act 4: Cross-Domain Intelligence (3 min)

#### 🔥 Question 8: Combined Structured + Unstructured
```
For the study with the highest screen failure rate, what are the exclusion criteria?
```

**Expected Response:**
> The agent should:
> 1. First identify which study has highest screen failure rate (~20%)
> 2. Then search protocol documents for that study's exclusion criteria
> 3. Synthesize both answers

**Talking Point:** "This is the magic—the agent orchestrates across BOTH structured metrics AND unstructured documents to answer a complex question."

⚠️ **Note:** If this question doesn't work well, ensure Script 04 has been re-run after the latest updates (see Troubleshooting section).

---

#### 🔥 Question 9: Quality Performance Analysis
```
Which sites have ratings below 4.0 and what is their query resolution performance?
```

**✅ Verified Response:**
> **4 sites** with ratings below 4.0:
> 
> | Site | Rating | Query Resolution | Outstanding |
> |------|--------|------------------|-------------|
> | Christie NHS | 3.4 | 8.5 days | 60 |
> | Institut Gustave Roussy | 3.5 | 7.2 days | 45 |
> | Hospital 12 de Octubre | 3.6 | 6.1 days | 30 |
> | UCL Hospitals | 3.8 | 5.5 days | 25 |
> 
> Strong correlation: Lower ratings correlate with slower query resolution.

**Talking Point:** "This correlation analysis would take an analyst hours. The agent does it in seconds."

---

### Act 5: Operational Scenarios (3 min)

#### 🔥 Question 10: Sponsor Call Prep
```
Give me a summary of enrollment progress and any quality concerns for the NSCLC study MED-ONC-2024-001
```

**✅ Verified Response:**
> **Enrollment:** 143 of 170 patients (84.0%), 30 screen failures (16% rate)
> 
> **Quality:** Average rating 4.5/5, 22 total deviations, 37 outstanding queries
> 
> **Strengths:** Strong enrollment, good ratings, 3.2-day query resolution
> 
> **Attention Areas:** 37 outstanding queries, 22 deviations need pattern analysis
> 
> **Recommendations:** Prioritize query resolution, analyze deviation patterns

**Talking Point:** "This is exactly what a project manager prepares for a sponsor call—generated in seconds."

---

#### 🔥 Question 11: Site Comparison
```
Compare Memorial Sloan Kettering to MD Anderson in terms of enrollment and quality metrics
```

**✅ Verified Response:**
> | Metric | MSK | MD Anderson |
> |--------|-----|-------------|
> | Enrolled | 87 (2 studies) | 38 (1 study) |
> | Enrollment Rate | 82.9% | 84.4% |
> | Screen Failure Rate | 10.3% | 9.5% |
> | Quality Rating | 4.8/5 | 4.9/5 |
> | Deviations | 4 | 2 |
> | Query Resolution | 2.3 days | 1.8 days |
> 
> Both are top-tier performers. MD Anderson slightly better quality; MSK handles higher volume.

**Talking Point:** "Sponsors frequently ask to compare specific sites. Instant answer."

---

#### 🔥 Question 12: Safety Protocol Question
```
How should grade 3 immune-related adverse events be managed according to the protocol?
```

**✅ Verified Response:**
> **Grade 3 irAE Management (MED-ONC-2024-001):**
> - **Hold treatment** until recovery to Grade ≤1
> - **Resume at reduced dose** (300 mg instead of 400 mg)
> 
> **Complete Scale:**
> - Grade 2: Hold, resume same dose
> - Grade 3: Hold, resume 300 mg (25% reduction)
> - Grade 4: Permanently discontinue
> 
> **Corticosteroids:** Prohibited except for irAE treatment

**Talking Point:** "Critical safety questions answered instantly with protocol-accurate language."

---

## 💡 Key Demo Messages

### For Technical Audience

1. **No YAML files needed** - Semantic Views provide the metadata layer directly in SQL
2. **Multi-tool orchestration** - Agent routes to the right tool (Analyst vs. Search) automatically
3. **Native Snowflake** - Everything runs inside Snowflake, no external infrastructure
4. **Governed data access** - RBAC controls who can access what data through the agent

### For Business Audience

1. **Self-service analytics** - Clinical operations staff get answers without IT tickets
2. **Faster sponsor responses** - Questions that took hours now take seconds
3. **Reduced risk** - Consistent, accurate answers based on source data
4. **Protocol compliance** - Instant access to correct protocol language

---

## 🎤 Closing Statement

> "What you've seen today is the future of clinical operations analytics. Instead of training staff on SQL, building dashboards, and maintaining document search systems, you deploy a single AI agent that understands your business. It knows what 'screen failure rate' means, it can search your protocols, and it can combine insights across both. This is Snowflake Intelligence—and it's available today."

---

## 📊 Sample Data Summary

| Metric | Value |
|--------|-------|
| Studies | 5 Phase III oncology trials |
| Sites | 14 global sites across 10 countries |
| Total Enrollment | 668 patients |
| Regions | North America, Europe, Asia Pacific, Latin America |
| Protocol Docs | 12 document chunks (exclusion, dosing, amendments, safety) |
| Screen Failure Range | 9.5% - 36.5% (varied for demo contrast) |
| Site Ratings | 3.4 - 4.9 (varied for quality analysis) |

---

## ⚠️ Troubleshooting

### Question 8 Not Working (Cross-Domain)?

**Re-run Script 04** to load the updated exclusion criteria documents:

```sql
USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

-- Option 1: Truncate and reload (recommended)
TRUNCATE TABLE TRIAL_PROTOCOL_DOCUMENTS_CHUNKS;
-- Then run entire Script 04

-- Option 2: Just add missing documents
-- Copy only the new INSERT statements for TNBC and Colorectal exclusion criteria
```

After reloading, the Cortex Search service will automatically re-index (within TARGET_LAG of 1 hour, or use `ALTER CORTEX SEARCH SERVICE ... REFRESH`).

### Agent Not Responding
```sql
-- Verify agent exists and is accessible
SHOW AGENTS IN SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;
DESCRIBE AGENT SPONSOR_INSIGHTS_AGENT;
```

### Search Not Working
```sql
-- Verify Cortex Search service
SHOW CORTEX SEARCH SERVICES;

-- Test search directly
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'MEDPACE_DEMO.CLINICAL_OPERATIONS.PROTOCOL_SEARCH_SERVICE',
    '{
        "query": "exclusion criteria brain metastases",
        "columns": ["CHUNK_TEXT", "STUDY_ID", "SECTION_TYPE"],
        "limit": 3
    }'
);
```

### Semantic View Errors
```sql
-- Verify semantic views
SHOW SEMANTIC VIEWS IN SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;
DESCRIBE SEMANTIC VIEW ENROLLMENT_SEMANTIC_VIEW;
```

### Force Refresh Cortex Search Index
```sql
ALTER CORTEX SEARCH SERVICE PROTOCOL_SEARCH_SERVICE REFRESH;
```

---

## 🚀 Next Steps After Demo

1. **Expand Data** - Connect to real Medpace clinical trial data
2. **Add More Documents** - Ingest full protocol PDFs using Snowflake Document AI
3. **Custom Tools** - Add stored procedures for specific calculations (e.g., enrollment projections)
4. **Role-Based Access** - Configure different agent views for different user roles
5. **Production Deployment** - Set up proper warehouse sizing and monitoring
