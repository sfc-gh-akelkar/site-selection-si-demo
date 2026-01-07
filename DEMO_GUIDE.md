# Medpace Sponsor Insights Agent - Demo Guide

## 🎯 Demo Objective

Demonstrate how Snowflake Intelligence enables **natural language analytics** across both structured clinical trial metrics and unstructured protocol documents—all without writing SQL or building a custom application.

**Total Demo Time:** ~20-25 minutes

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

## 🌟 Demo Flow & Questions

### Act 1: The Business Challenge (2 min)

**🎤 Talk Track:**
> "Clinical operations teams at CROs like Medpace need to answer questions from sponsors every day—about enrollment progress, site quality, and protocol requirements. 
>
> Today, this requires SQL expertise, switching between multiple systems, and manually searching through 200-page protocol documents. A simple sponsor question like 'How are our studies doing?' can take hours to answer.
>
> What if they could just ask questions in plain English? That's what we're going to show you today."

---

### Act 2: Structured Data Analytics (8 min)

---

#### 🔥 Question 1: Executive Overview
```
How are my studies doing?
```

**🎤 Talk Track (Before):**
> "Let's start with the kind of question an executive or sponsor would ask. It's intentionally vague—no specific metrics, no SQL. Just a simple question."

**✅ Expected Response:**
> **Study Portfolio Performance Overview**
> - 5 Active Studies across 14 sites
> - 668 patients enrolled out of 795 planned (84.0% enrollment rate)
> - Screen failure rate: 17.6%
> - Average site rating: 4.34/5.0
> - 3 sites under review, 0 on hold
> 
> Individual study rankings, quality metrics, and key insights included.

**🎤 Talk Track (After):**
> "Notice what just happened. The agent understood 'How are my studies doing?' and decided to show enrollment progress, quality metrics, and flag potential concerns. No one had to define what 'doing' means—the semantic view provides that business context."

---

#### 🔥 Question 2: Curiosity Follow-Up
```
What are the 5 studies? And what Phase are they in?
```

**🎤 Talk Track (Before):**
> "Now I'm going to show something powerful—users can be curious. They can ask for explanations of anything they see."

**✅ Expected Response:**
> Lists the 5 studies (MED-ONC-2024-001 through 005) with indications (NSCLC, Melanoma, TNBC, etc.) and explains that Phase III trials are large-scale efficacy studies, the final stage before regulatory approval.

**🎤 Talk Track (After):**
> "This is huge for adoption. Users don't need training on clinical trial terminology. They can ask 'What does this mean?' anytime, and the agent explains it in context."

---

#### 🔥 Question 3: Specific Enrollment Metric
```
What is our total enrollment across all studies?
```

**🎤 Talk Track (Before):**
> "Now let's get specific. This is the kind of metric a sponsor asks for every week."

**✅ Expected Response:**
> The total enrollment across all Phase III studies is **668 patients**.
> This spans **5 different studies**, with enrollment between January 15, 2024 and June 10, 2024.

**🎤 Talk Track (After):**
> "The agent understands 'enrollment' and 'Phase III' without any SQL. The semantic view translates business terms to database columns automatically."

---

#### 🔥 Question 4: Problem Identification
```
Which sites have screen failure rates above 30%?
```

**🎤 Talk Track (Before):**
> "Now let's find problems. High screen failure rates often indicate protocol issues or poor site selection."

**✅ Expected Response:**
> **4 sites** with screen failure rates above 30%:
> 1. The Christie NHS Foundation Trust - **36.5%**
> 2. Hospital Universitario 12 de Octubre - **34.4%**
> 3. Institut Gustave Roussy - **34.2%**
> 4. University College London Hospitals - **34.2%**
> 
> All four sites are in Europe.

**🎤 Talk Track (After):**
> "This insight typically requires a data analyst to write a query, pull the data, and format it. Now anyone on the clinical team can find it in seconds. And notice—the agent flagged that all four sites are in Europe. That's a pattern worth investigating."

---

#### 🔥 Question 5: Regional Comparison
```
Compare enrollment rates by region
```

**🎤 Talk Track (Before):**
> "Sponsors love to ask 'How is Europe doing compared to the US?' Let's see."

**✅ Expected Response:**
> | Region | Enrollment Rate | Sites | Patients |
> |--------|-----------------|-------|----------|
> | Asia Pacific | 88.4% | 3 | 115 |
> | North America | 84.1% | 5 | 290 |
> | Europe | 82.5% | 5 | 231 |
> | Latin America | 80.0% | 1 | 32 |

**🎤 Talk Track (After):**
> "Asia Pacific leads in efficiency, North America contributes the most volume. This comparison would take 15 minutes in Excel. Here it's instant."

---

#### 🔥 Question 6: Problem Site Deep Dive
```
What are the issues with the sites under review?
```

**🎤 Talk Track (Before):**
> "In Question 1, the agent mentioned 3 sites are under review. Let's drill into that."

**✅ Expected Response:**
> **3 sites under review** with performance concerns:
> 
> 1. **SITE-013: The Christie NHS Foundation Trust** 🔴 Highest Risk
>    - Rating: 3.4/5.0, 17 deviations (5 major), 60 outstanding queries
> 
> 2. **SITE-006: Institut Gustave Roussy** 🟡 Moderate Risk
>    - Rating: 3.5/5.0, 14 deviations (4 major), 45 outstanding queries
> 
> 3. **SITE-003: University College London Hospitals** 🟡 Lower Risk
>    - Rating: 3.8/5.0, 11 deviations (3 major), 25 outstanding queries
>
> Common issues: Below-average ratings, elevated deviations, query resolution delays.
> Recommended actions included.

**🎤 Talk Track (After):**
> "Look at what the agent did—it didn't just list the sites. It risk-ranked them, identified The Christie as highest risk, and explained WHY each site is under review. This is medical monitor-level analysis, delivered instantly."

---

#### 🔥 Question 7: Prioritization Logic
```
What is the most important issue to address first with SITE-013?
```

**🎤 Talk Track (Before):**
> "SITE-013 has multiple issues. Before a site intervention call, I need to know: what's the priority?"

**✅ Expected Response:**
> The **most critical issue** is the **5 major protocol deviations**.
> 
> **Why they take priority:**
> - Patient safety impact
> - Regulatory risk
> - Likely root cause driving other problems
> 
> **Action plan:** Urgent review, root cause analysis, corrective measures, enhanced oversight.
> 
> Secondary priorities: 60 outstanding queries, slow resolution time.

**🎤 Talk Track (After):**
> "This is the question a medical director asks before an intervention call. The agent didn't say 'all issues are important'—it prioritized major deviations because of patient safety. That's clinical operations thinking, not just data retrieval."

---

#### 🔥 Question 8: Data Boundaries (Honesty Test)
```
For The Christie NHS Foundation Trust (SITE-013), what were the 5 major deviations?
```

**🎤 Talk Track (Before):**
> "Now I'm going to ask something the agent might NOT be able to answer. Watch what happens."

**✅ Expected Response:**
> The system has **aggregate counts** (5 major deviations) but not the **detailed incident records**.
> 
> What we know: Site, PI name, deviation counts.
> What we don't have: Specific categories, dates, descriptions, root causes.
> 
> Recommended next steps: Access CTMS, contact monitoring team, review visit report.

**🎤 Talk Track (After):**
> "This is critical. The agent did NOT make up deviation details. It told us honestly: 'I have the count, but the detailed records are in your CTMS.' A hallucinating AI would have invented 5 plausible-sounding deviations. This agent respects data boundaries and tells you where to find what it doesn't have."

---

#### 🔥 Question 9: Quality Correlation
```
Which sites have ratings below 4.0 and what is their query resolution performance?
```

**🎤 Talk Track (Before):**
> "Let's look for correlations. Are low-rated sites also slow at resolving queries?"

**✅ Expected Response:**
> **4 sites** with ratings below 4.0:
> 
> | Site | Rating | Query Resolution | Outstanding |
> |------|--------|------------------|-------------|
> | Christie NHS | 3.4 | 8.5 days | 60 |
> | Institut Gustave Roussy | 3.5 | 7.2 days | 45 |
> | Hospital 12 de Octubre | 3.6 | 6.1 days | 30 |
> | UCL Hospitals | 3.8 | 5.5 days | 25 |
> 
> Strong correlation: Lower ratings = slower query resolution.

**🎤 Talk Track (After):**
> "The agent found the pattern: sites with lower ratings also have slower query resolution. This correlation analysis would take an analyst an hour. Here it's one question."

---

### Act 3: Unstructured Document Search (5 min)

**🎤 Transition Talk Track:**
> "So far we've been querying structured data—enrollment numbers, site metrics. But clinical operations also requires searching through protocol documents. Let's see how the agent handles that."

---

#### 🔥 Question 10: Protocol Eligibility
```
What are the exclusion criteria for patients with brain metastases?
```

**🎤 Talk Track (Before):**
> "This is a question a site coordinator might ask when screening a patient. Normally they'd search through a 200-page PDF."

**✅ Expected Response:**
> **MED-ONC-2024-001 (NSCLC):**
> - Symptomatic brain metastases are excluded
> - Stable, treated brain metastases allowed if off steroids for ≥14 days
> - Leptomeningeal carcinomatosis is excluded
> 
> **MED-ONC-2024-002 (Melanoma):**
> - Active CNS metastases excluded
> - Previously treated and stable ≥4 weeks permitted

**🎤 Talk Track (After):**
> "The agent searched our protocol documents using Cortex Search and found the exact eligibility language from multiple studies. This is semantic search—it understands meaning, not just keywords. And notice the citations so you can verify the source."

---

#### 🔥 Question 11: Dosing Questions
```
What is the dosing regimen for the TNBC study?
```

**🎤 Talk Track (Before):**
> "Medical monitors get dosing questions constantly. Let's see if we can get a quick answer."

**✅ Expected Response:**
> **MED-ONC-2024-003 (TNBC):** MED-5678 (ADC targeting TROP-2)
> - **Dose:** 10 mg/kg IV on Days 1 and 8 of each 21-day cycle
> - **Infusion:** 90 min first dose, 30 min subsequent
> - **Neutropenia Grade 4:** Reduce to 7.5 mg/kg
> - **Diarrhea Grade 3:** Hold, reduce to 7.5 mg/kg
> - **Antiemetics required:** 5-HT3 + dexamethasone + NK1 antagonist

**🎤 Talk Track (After):**
> "Complete dosing information including dose modifications—pulled directly from the protocol. This would take 10 minutes of document searching. Now it's instant."

---

#### 🔥 Question 12: Amendment Changes
```
What changes were made in Amendment 2 of the NSCLC study?
```

**🎤 Talk Track (Before):**
> "Protocol amendments are critical. Sponsors always ask 'What changed in the latest version?'"

**✅ Expected Response:**
> **Amendment 2 (MED-ONC-2024-001) - Effective March 1, 2024:**
> 
> 1. **Eligibility (High Impact):** Prior KRAS G12C therapy now EXCLUDED
> 2. **Biomarkers (Medium):** Mandatory PD-L1 testing at screening
> 3. **Dose Mods (Low):** Added hepatitis management guidance
> 4. **Statistics (Medium):** Sample size 400 → 450 patients
> 
> Implementation: Re-consent required, site training March 15, 2024

**🎤 Talk Track (After):**
> "The agent found the amendment document, extracted the key changes, and even categorized them by impact level. This is the kind of summary that would take someone 30 minutes to prepare manually."

---

### Act 4: Cross-Domain Intelligence (3 min)

**🎤 Transition Talk Track:**
> "Now here's where it gets really interesting. What if we need to combine structured data AND document search in a single question? Watch this."

---

#### 🔥 Question 13: Combined Structured + Unstructured
```
For the study with the highest screen failure rate, what are the exclusion criteria?
```

**🎤 Talk Track (Before):**
> "This question requires the agent to first query structured data to find which study has the highest screen failure rate, then search the protocol documents for that study's exclusion criteria."

**✅ Expected Response:**
> The agent should:
> 1. First identify which study has highest screen failure rate
> 2. Then search protocol documents for that study's exclusion criteria
> 3. Synthesize both answers

**🎤 Talk Track (After):**
> "This is the magic of the Cortex Agent. It orchestrated across BOTH structured metrics AND unstructured documents to answer a complex, multi-step question. No human had to tell it which tool to use—it figured out the workflow automatically."

⚠️ **Note:** If this question doesn't work well, ensure Script 04 has been re-run (see Troubleshooting).

---

### Act 5: Operational Scenarios (5 min)

**🎤 Transition Talk Track:**
> "Let's finish with some real-world operational scenarios. These are the questions clinical ops teams answer every day."

---

#### 🔥 Question 14: Sponsor Call Prep
```
Give me a summary of enrollment progress and any quality concerns for the NSCLC study MED-ONC-2024-001
```

**🎤 Talk Track (Before):**
> "You have a sponsor call in 10 minutes. You need a quick briefing on one study."

**✅ Expected Response:**
> **Enrollment:** 143 of 170 patients (84.0%), 30 screen failures (16% rate)
> 
> **Quality:** Average rating 4.5/5, 22 total deviations, 37 outstanding queries
> 
> **Strengths:** Strong enrollment, good ratings, 3.2-day query resolution
> 
> **Attention Areas:** 37 outstanding queries, 22 deviations need pattern analysis
> 
> **Recommendations:** Prioritize query resolution, analyze deviation patterns

**🎤 Talk Track (After):**
> "That's sponsor call prep in 10 seconds. Enrollment status, quality metrics, strengths, concerns, and recommendations. A project manager would normally spend 30 minutes pulling this together."

---

#### 🔥 Question 15: Site Comparison
```
Compare Memorial Sloan Kettering to MD Anderson in terms of enrollment and quality metrics
```

**🎤 Talk Track (Before):**
> "Sponsors frequently ask to compare specific sites. Let's compare two of our best."

**✅ Expected Response:**
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

**🎤 Talk Track (After):**
> "Side-by-side site comparison with commentary. Both sites are excellent, but the agent noted the trade-off: MD Anderson has slightly better quality, MSK handles more volume."

---

#### 🔥 Question 16: Safety Protocol
```
How should grade 3 immune-related adverse events be managed according to the protocol?
```

**🎤 Talk Track (Before):**
> "Safety questions need accurate, protocol-specific answers. This is critical."

**✅ Expected Response:**
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

**🎤 Talk Track (After):**
> "Protocol-accurate safety guidance. This is the kind of information that needs to be exactly right, and the agent pulled it directly from the source document."

---

#### 🔥 Question 17: Future Risk Identification (No Hallucination Proof)
```
Once we address the issues with the 3 sites under review, what are some other potential risk spots within our current trials?
```

**🎤 Talk Track (Before):**
> "This is a forward-looking question. I want to see if the agent will invent problems or stick to what the data actually shows."

**✅ Expected Response:**
> **Primary Risk Site: SITE-009** (Hospital Universitario 12 de Octubre)
> - Rating: 3.6/5.0, 12 deviations, 30 outstanding queries
> - Shows early warning signs similar to sites now under review
> 
> **Positive Finding:** All 5 studies performing well (no study-level risks)
> 
> **Preventive Recommendations:**
> - Enhanced monitoring for SITE-009
> - Early warning dashboard for sites approaching thresholds
> - Regional quality training (Europe concentration)
> 
> "Your portfolio is generally healthy with strong enrollment performance."

**🎤 Talk Track (After):**
> "This is the most important moment in the demo. The agent found ONE real site with early warning signs—SITE-009. But it also said 'All 5 studies are performing well' and 'Your portfolio is generally healthy.' 
>
> A hallucinating AI would have invented problems to seem helpful. This agent told us the truth: there's one site to watch, but overall we're in good shape. That's the kind of trustworthy AI you can build decisions on."

---

## 🎤 Closing Statement

> "What you've seen today is the future of clinical operations analytics. 
>
> We asked 17 questions—from high-level executive summaries to specific protocol details. The agent:
> - Handled vague questions and specific queries equally well
> - Maintained context across a multi-question conversation
> - Combined structured data and document search automatically
> - Admitted when it didn't have detailed data
> - Refused to hallucinate or invent problems
>
> Instead of training staff on SQL, building dashboards, and maintaining document search systems, you deploy a single AI agent that understands your business. It knows what 'screen failure rate' means, it can search your protocols, and it can combine insights across both.
>
> This is Snowflake Intelligence—and it's available today."

---

## 💡 Key Demo Messages

### For Technical Audience

1. **No YAML files needed** - Semantic Views provide the metadata layer directly in SQL
2. **Multi-tool orchestration** - Agent routes to the right tool (Analyst vs. Search) automatically
3. **Native Snowflake** - Everything runs inside Snowflake, no external infrastructure
4. **Governed data access** - RBAC controls who can access what data through the agent
5. **No hallucination** - Agent respects data boundaries and admits limitations

### For Business Audience

1. **Self-service analytics** - Clinical operations staff get answers without IT tickets
2. **Faster sponsor responses** - Questions that took hours now take seconds
3. **Reduced risk** - Consistent, accurate answers based on source data
4. **Protocol compliance** - Instant access to correct protocol language
5. **Trustworthy AI** - Agent tells you when it doesn't know something

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

## 📝 Quick Reference: All 17 Questions

### Act 2: Structured Data (9 questions)
1. How are my studies doing?
2. What are the 5 studies? What does "Phase III" mean?
3. What is our total enrollment across all Phase III studies?
4. Which sites have screen failure rates above 30%?
5. Compare enrollment rates by region
6. What are the issues with the sites under review?
7. What is the most important issue to address first with SITE-013?
8. What were the 5 major deviations at SITE-013?
9. Which sites have ratings below 4.0 and query resolution performance?

### Act 3: Document Search (3 questions)
10. What are the exclusion criteria for brain metastases?
11. What is the dosing regimen for the TNBC study?
12. What changes were made in Amendment 2 of the NSCLC study?

### Act 4: Cross-Domain (1 question)
13. For the study with highest screen failure rate, what are the exclusion criteria?

### Act 5: Operational (4 questions)
14. Give me enrollment summary and quality concerns for MED-ONC-2024-001
15. Compare Memorial Sloan Kettering to MD Anderson
16. How should grade 3 irAEs be managed?
17. What other potential risk spots exist beyond the 3 sites under review?

---

## ⚠️ Troubleshooting

### Question 13 Not Working (Cross-Domain)?

**Re-run Script 04** to load the updated exclusion criteria documents:

```sql
USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

-- Option 1: Truncate and reload (recommended)
TRUNCATE TABLE TRIAL_PROTOCOL_DOCUMENTS_CHUNKS;
-- Then run entire Script 04
```

After reloading, refresh the search index:
```sql
ALTER CORTEX SEARCH SERVICE PROTOCOL_SEARCH_SERVICE REFRESH;
```

### Agent Not Responding
```sql
SHOW AGENTS IN SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;
DESCRIBE AGENT SPONSOR_INSIGHTS_AGENT;
```

### Search Not Working
```sql
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
SHOW SEMANTIC VIEWS IN SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;
DESCRIBE SEMANTIC VIEW ENROLLMENT_SEMANTIC_VIEW;
```

---

## 🚀 Next Steps After Demo

1. **Expand Data** - Connect to real Medpace clinical trial data
2. **Add More Documents** - Ingest full protocol PDFs using Snowflake Document AI
3. **Custom Tools** - Add stored procedures for specific calculations (e.g., enrollment projections)
4. **Role-Based Access** - Configure different agent views for different user roles
5. **Production Deployment** - Set up proper warehouse sizing and monitoring
