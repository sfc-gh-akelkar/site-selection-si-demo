/*******************************************************************************
 * CLINICAL_TRIAL SPONSOR INSIGHTS AGENT - STEP 4: UNSTRUCTURED DATA & CORTEX SEARCH
 * 
 * Purpose: Create infrastructure for protocol document search capabilities.
 *          This enables natural language queries against clinical protocol
 *          documents including exclusion criteria, dosing, and amendments.
 * 
 * Components:
 *   - TRIAL_PROTOCOL_DOCUMENTS_CHUNKS: Chunked protocol text storage
 *   - PROTOCOL_SEARCH_SERVICE: Cortex Search service for semantic search
 * 
 * Role: SF_INTELLIGENCE_DEMO
 ******************************************************************************/

USE ROLE SF_INTELLIGENCE_DEMO;
USE SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

/*******************************************************************************
 * TABLE: TRIAL_PROTOCOL_DOCUMENTS_CHUNKS
 * 
 * Stores chunked protocol document text for semantic search. Each row
 * represents a logical section of a protocol document.
 ******************************************************************************/

CREATE OR REPLACE TABLE TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (
    CHUNK_ID                NUMBER AUTOINCREMENT PRIMARY KEY
        COMMENT 'Unique identifier for each document chunk.',
    RELATIVE_PATH           VARCHAR(500) NOT NULL
        COMMENT 'Source document path or URL where the protocol document originated. Used for citation purposes.',
    CHUNK_TEXT              VARCHAR(16000) NOT NULL
        COMMENT 'The actual text content of this document chunk. Contains protocol language, criteria, dosing instructions, or amendment details.',
    STUDY_ID                VARCHAR(20) NOT NULL
        COMMENT 'Protocol identifier linking this chunk to a specific study. Matches STUDY_ID in TRIAL_ENROLLMENT_METRICS.',
    PROTOCOL_VERSION        VARCHAR(20) NOT NULL
        COMMENT 'Version number of the protocol (e.g., v1.0, v2.1). Protocols are amended during the trial lifecycle.',
    SECTION_TYPE            VARCHAR(50) NOT NULL
        COMMENT 'Type of protocol section: EXCLUSION_CRITERIA, INCLUSION_CRITERIA, DOSING, AMENDMENT, ENDPOINTS, SAFETY, PROCEDURES.',
    CHUNK_SEQUENCE          NUMBER NOT NULL
        COMMENT 'Sequence number for ordering chunks within the same section.',
    LAST_UPDATED            TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
        COMMENT 'Timestamp when this chunk was last updated.',
    METADATA                VARIANT
        COMMENT 'Additional structured metadata in JSON format including author, approval date, and change summary.'
)
COMMENT = 'Chunked protocol document storage for Cortex Search. Contains searchable text from clinical trial protocols including exclusion criteria, dosing instructions, and protocol amendments. Used by the Clinical Trial Insights Agent for procedural and protocol questions.';

/*******************************************************************************
 * INSERT SAMPLE PROTOCOL CHUNKS
 * 
 * Using INSERT...SELECT to support PARSE_JSON for VARIANT column
 ******************************************************************************/

-- Study 1: MED-ONC-2024-001 (NSCLC) - Exclusion Criteria
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-001/v2.1/section_4_exclusion.pdf',
    'EXCLUSION CRITERIA FOR MED-ONC-2024-001 (NSCLC STUDY)

Patients meeting any of the following criteria are NOT eligible for enrollment:

1. PRIOR THERAPY EXCLUSIONS:
   - Prior treatment with any PD-1, PD-L1, or CTLA-4 inhibitor within 12 months of screening
   - More than 2 prior lines of systemic chemotherapy for metastatic disease
   - Prior treatment with investigational agents targeting KRAS G12C mutation
   
2. DISEASE-RELATED EXCLUSIONS:
   - Presence of symptomatic brain metastases (stable, treated brain metastases allowed if off steroids for ≥14 days)
   - Leptomeningeal carcinomatosis
   - Tumor invasion of major blood vessels with high bleeding risk
   - History of grade 3 or higher immune-related adverse events from prior immunotherapy
   
3. MEDICAL HISTORY EXCLUSIONS:
   - Active autoimmune disease requiring systemic immunosuppressive therapy
   - History of interstitial lung disease or non-infectious pneumonitis requiring steroids
   - Active infection requiring systemic antibiotics within 7 days of first dose
   - Known HIV infection with CD4 count <350 cells/μL',
    'MED-ONC-2024-001',
    'v2.1',
    'EXCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Sarah Chen", "approval_date": "2024-03-15", "change_summary": "Added KRAS G12C prior therapy exclusion per Amendment 2"}');

-- Study 1: MED-ONC-2024-001 (NSCLC) - Dosing Instructions
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-001/v2.1/section_6_dosing.pdf',
    'DOSING AND ADMINISTRATION FOR MED-ONC-2024-001

STUDY DRUG: MED-1234 (Investigational PD-L1 Inhibitor)

DOSING REGIMEN:
- MED-1234 400 mg administered as IV infusion over 60 minutes every 3 weeks (Q3W)
- Treatment continues until disease progression, unacceptable toxicity, or withdrawal of consent
- Maximum treatment duration: 24 months

DOSE MODIFICATIONS:
- Grade 2 immune-related adverse events: Hold dose until recovery to Grade ≤1, then resume at same dose
- Grade 3 immune-related adverse events: Hold dose until recovery to Grade ≤1, resume at reduced dose (300 mg)
- Grade 4 immune-related adverse events: Permanently discontinue treatment
- Infusion reactions Grade 2: Reduce infusion rate by 50%; Grade 3-4: Discontinue infusion

PRE-MEDICATIONS:
- Acetaminophen 650 mg PO and diphenhydramine 25 mg IV recommended 30 minutes prior to first 2 infusions
- Subsequent pre-medications at investigator discretion based on tolerability

CONCOMITANT MEDICATIONS:
- Systemic corticosteroids >10 mg prednisone equivalent daily are prohibited except for treatment of irAEs
- Avoid live vaccines during treatment and for 6 months after last dose',
    'MED-ONC-2024-001',
    'v2.1',
    'DOSING',
    1,
    PARSE_JSON('{"author": "Dr. Michael Rodriguez", "approval_date": "2024-03-15", "formulation": "IV solution 20 mg/mL"}');

-- Study 2: MED-ONC-2024-002 (Melanoma) - Exclusion Criteria
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-002/v1.3/section_4_exclusion.pdf',
    'EXCLUSION CRITERIA FOR MED-ONC-2024-002 (ADVANCED MELANOMA STUDY)

The following patients are NOT eligible for study participation:

1. PRIOR TREATMENT EXCLUSIONS:
   - Prior therapy with BRAF inhibitors if BRAF V600 wild-type
   - Prior treatment with the same class of investigational agent (TIL therapy)
   - Chemotherapy, targeted therapy, or radiation within 28 days of first dose
   
2. DISEASE CHARACTERISTICS:
   - Uveal (ocular) melanoma
   - Primary mucosal melanoma
   - Active CNS metastases (previously treated and stable ≥4 weeks permitted)
   - Rapidly progressing disease with visceral crisis requiring immediate intervention
   
3. LABORATORY EXCLUSIONS:
   - Absolute neutrophil count (ANC) <1,500/μL
   - Platelet count <100,000/μL
   - Hemoglobin <9.0 g/dL
   - Serum creatinine >1.5× ULN or CrCl <50 mL/min
   - AST/ALT >3× ULN (or >5× ULN if liver metastases present)
   - Total bilirubin >1.5× ULN (except Gilbert syndrome)
   
4. CARDIAC EXCLUSIONS:
   - QTcF interval >470 ms (females) or >450 ms (males)
   - Uncontrolled hypertension (systolic >160 mmHg or diastolic >100 mmHg)
   - Myocardial infarction or unstable angina within 6 months',
    'MED-ONC-2024-002',
    'v1.3',
    'EXCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Jennifer Walsh", "approval_date": "2024-04-20", "regulatory_reference": "FDA IND 123456"}');

-- Study 2: MED-ONC-2024-002 (Melanoma) - Amendment Rationale
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-002/v1.3/amendment_1_rationale.pdf',
    'PROTOCOL AMENDMENT 1 RATIONALE - MED-ONC-2024-002

AMENDMENT DATE: April 10, 2024
AMENDMENT TYPE: Substantial Amendment (requires IRB/EC approval)

SUMMARY OF CHANGES:

1. EXPANSION OF ELIGIBILITY (Section 4.2):
   - CHANGE: Reduced washout period for prior checkpoint inhibitors from 6 weeks to 4 weeks
   - RATIONALE: Based on PK modeling and safety data from Phase II showing 4-week washout is sufficient for drug clearance. This change accelerates enrollment without compromising safety.
   - IMPACT: Estimated 15% increase in screening eligible patients.

2. MODIFICATION OF SECONDARY ENDPOINTS (Section 8.2):
   - CHANGE: Added Patient-Reported Outcomes (PRO) using FACT-M questionnaire
   - RATIONALE: Regulatory feedback from FDA Type B meeting emphasized importance of quality of life data for melanoma indication. PRO data will strengthen BLA submission.
   
3. SAFETY MONITORING UPDATE (Section 9.1):
   - CHANGE: Added mandatory cardiac monitoring (ECG and troponin) at Cycle 3 and 6
   - RATIONALE: Signal detection from ongoing Phase II identified 2 cases of subclinical myocarditis. Enhanced monitoring implemented as precautionary measure.
   
4. BIOMARKER SAMPLE COLLECTION (Section 10.3):
   - CHANGE: Added optional tumor biopsy at disease progression
   - RATIONALE: Enable analysis of resistance mechanisms to inform next-generation therapy development.

IMPLEMENTATION: All sites must receive updated protocol and ICF before enrolling new patients under Amendment 1.',
    'MED-ONC-2024-002',
    'v1.3',
    'AMENDMENT',
    1,
    PARSE_JSON('{"author": "Medical Monitor Team", "approval_date": "2024-04-10", "irb_approval_required": true, "sites_affected": "All global sites"}');

-- Study 3: MED-ONC-2024-003 (Breast Cancer) - Dosing
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-003/v2.0/section_6_dosing.pdf',
    'DOSING AND ADMINISTRATION FOR MED-ONC-2024-003 (TNBC STUDY)

INVESTIGATIONAL PRODUCT: MED-5678 (Antibody-Drug Conjugate targeting TROP-2)

TREATMENT REGIMEN:
- MED-5678 10 mg/kg IV on Days 1 and 8 of each 21-day cycle
- Infusion duration: First dose over 90 minutes; subsequent doses may be reduced to 30 minutes if tolerated
- Treatment continues until progression, unacceptable toxicity, or patient withdrawal

DOSE LEVEL MODIFICATIONS:

For Neutropenia:
- Grade 3 ANC (500-1000/μL): Delay dose until ANC ≥1000/μL, resume at same dose
- Grade 4 ANC (<500/μL) or febrile neutropenia: Delay and reduce to 7.5 mg/kg
- Recurrent Grade 4: Further reduce to 5 mg/kg or discontinue

For Diarrhea (without identified infectious etiology):
- Grade 2: Continue dosing with loperamide prophylaxis
- Grade 3: Hold until ≤Grade 1, resume at reduced dose (7.5 mg/kg)
- Grade 4: Permanently discontinue

For Nausea/Vomiting:
- Prophylactic antiemetics required: 5-HT3 antagonist + dexamethasone + NK1 antagonist
- Grade 3: Hold, resume with enhanced antiemetic regimen

MONITORING REQUIREMENTS:
- CBC with differential: Day 1 of each cycle (minimum)
- Comprehensive metabolic panel: Every 2 cycles
- Pregnancy test: Prior to each dose (WCBP only)',
    'MED-ONC-2024-003',
    'v2.0',
    'DOSING',
    1,
    PARSE_JSON('{"author": "Dr. Robert Kim", "approval_date": "2024-05-01", "drug_class": "ADC", "target": "TROP-2"}');

-- Study 3: MED-ONC-2024-003 (Breast Cancer) - Inclusion Criteria
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-003/v2.0/section_3_inclusion.pdf',
    'INCLUSION CRITERIA FOR MED-ONC-2024-003 (TNBC STUDY)

Patients must meet ALL of the following criteria to be eligible:

1. DISEASE REQUIREMENTS:
   - Histologically confirmed triple-negative breast cancer (ER <1%, PR <1%, HER2 negative per ASCO/CAP guidelines)
   - Locally advanced or metastatic disease not amenable to curative surgery or radiation
   - At least one measurable lesion per RECIST v1.1
   - Documented disease progression on or after at least one prior systemic therapy for metastatic disease
   
2. PRIOR THERAPY REQUIREMENTS:
   - Must have received prior taxane-based chemotherapy (neoadjuvant, adjuvant, or metastatic setting)
   - Prior platinum therapy is permitted but not required
   - Prior immunotherapy (PD-1/PD-L1 inhibitors) is permitted
   
3. PERFORMANCE STATUS:
   - ECOG Performance Status 0-1
   - Life expectancy ≥12 weeks
   
4. ORGAN FUNCTION:
   - Adequate bone marrow: ANC ≥1,500/μL, platelets ≥100,000/μL, hemoglobin ≥9 g/dL
   - Adequate hepatic: Total bilirubin ≤1.5× ULN, AST/ALT ≤3× ULN
   - Adequate renal: CrCl ≥30 mL/min (Cockcroft-Gault)
   
5. CONSENT AND COMPLIANCE:
   - Signed informed consent
   - Willing to provide tumor tissue (archival or fresh biopsy)
   - Ability to comply with study visits and procedures',
    'MED-ONC-2024-003',
    'v2.0',
    'INCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Robert Kim", "approval_date": "2024-05-01", "target_population": "2L+ mTNBC"}');

-- Study 4: MED-ONC-2024-004 (Colorectal Cancer) - Safety Section
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-004/v1.2/section_9_safety.pdf',
    'SAFETY MONITORING AND ADVERSE EVENT MANAGEMENT - MED-ONC-2024-004

ADVERSE EVENTS OF SPECIAL INTEREST (AESIs):

1. HEPATOTOXICITY:
   - Monitor LFTs at baseline, Day 15 Cycle 1, and Day 1 of each subsequent cycle
   - For ALT/AST >5× ULN: Hold treatment, evaluate for other causes, consult hepatology
   - Rechallenge permitted only if recovery to ≤Grade 1 and no evidence of drug-induced liver injury pattern
   
2. GASTROINTESTINAL PERFORATION:
   - Incidence in Phase II: 1.2% (Grade 3-5)
   - Risk factors: Prior abdominal surgery, active diverticulitis, tumor invasion of bowel wall
   - Management: Immediate surgical consultation; permanent discontinuation required
   
3. HYPERTENSION:
   - Monitor blood pressure at each visit
   - For Grade 2: Initiate or optimize antihypertensive therapy; continue study drug
   - For Grade 3: Hold until controlled (<160/100 mmHg), resume at reduced dose
   - For Grade 4 or hypertensive crisis: Permanent discontinuation
   
4. PROTEINURIA:
   - Urine protein:creatinine ratio at baseline and every 4 weeks
   - For ratio >3.5: Hold until <3.5, reduce dose by one level
   - Nephrotic syndrome: Permanent discontinuation

REPORTING REQUIREMENTS:
- SAEs: Report within 24 hours of awareness
- SUSARs: Report within 7 days (fatal/life-threatening) or 15 days (other)
- Pregnancy: Report within 24 hours; follow until outcome',
    'MED-ONC-2024-004',
    'v1.2',
    'SAFETY',
    1,
    PARSE_JSON('{"author": "Safety Medical Monitor", "approval_date": "2024-06-15", "dsmb_oversight": true}');

-- Study 5: MED-ONC-2024-005 (Prostate Cancer) - Exclusion Criteria
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-005/v1.0/section_4_exclusion.pdf',
    'EXCLUSION CRITERIA FOR MED-ONC-2024-005 (mCRPC STUDY)

Patients with ANY of the following are excluded from participation:

1. PRIOR THERAPY RESTRICTIONS:
   - Prior treatment with PARP inhibitors (olaparib, rucaparib, niraparib, talazoparib)
   - Prior treatment with platinum-based chemotherapy in the castration-resistant setting
   - More than 2 prior lines of life-prolonging therapy for mCRPC
   - Treatment with enzalutamide, apalutamide, or darolutamide within 4 weeks of enrollment
   
2. GENETIC/BIOMARKER EXCLUSIONS:
   - Known deleterious or suspected deleterious germline BRCA1/2 mutation (HRR+ cohort only)
   - For HRR-negative cohort: Must not have known HRR gene alterations
   
3. MEDICAL CONDITIONS:
   - Myelodysplastic syndrome (MDS) or features suggestive of MDS/AML
   - Second primary malignancy within 3 years (except adequately treated non-melanoma skin cancer or carcinoma in situ)
   - Significant cardiovascular disease including CHF (NYHA Class III-IV), unstable arrhythmia, or recent stroke/TIA
   - History of seizure or condition predisposing to seizures
   
4. CONCOMITANT MEDICATION EXCLUSIONS:
   - Strong CYP3A4 inducers (rifampin, phenytoin, carbamazepine, St. John Wort)
   - Moderate or strong CYP3A4 inhibitors if unable to discontinue
   - Concurrent use of other anticancer therapies including herbal supplements with potential anticancer activity
   
5. BONE MARROW FUNCTION:
   - Platelet count <100,000/μL
   - Hemoglobin <10 g/dL (transfusions to achieve are not permitted)
   - Prior stem cell transplant',
    'MED-ONC-2024-005',
    'v1.0',
    'EXCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Amanda Foster", "approval_date": "2024-06-01", "companion_diagnostic": "Foundation Medicine HRR panel"}');

-- Study 5: MED-ONC-2024-005 (Prostate Cancer) - Procedures
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-005/v1.0/section_7_procedures.pdf',
    'STUDY PROCEDURES AND ASSESSMENTS - MED-ONC-2024-005

SCREENING PERIOD (Day -28 to Day -1):

Visit Procedures:
- Informed consent (must be obtained before any study-specific procedures)
- Medical history and demographics
- Physical examination including vital signs
- ECOG Performance Status assessment
- 12-lead ECG
- Laboratory assessments: CBC, CMP, LFTs, PSA, testosterone, lipid panel
- HRR mutation testing (if not previously performed) - results required before randomization
- CT scan chest/abdomen/pelvis (within 28 days of first dose)
- Bone scan (within 42 days of first dose)
- Tumor tissue collection or confirmation of archival tissue availability

TREATMENT PERIOD:

Cycle 1 Day 1:
- Confirm eligibility
- Randomization (via IxRS)
- Dispense study drug
- AE assessment
- Concomitant medication review

Every 2 Weeks (Q2W):
- PSA collection
- AE and concomitant medication assessment

Every 4 Weeks:
- Physical examination
- Laboratory assessments
- Drug accountability

Every 12 Weeks:
- CT/MRI tumor assessment per PCWG3 criteria
- Bone scan
- Quality of life questionnaires (FACT-P, BPI-SF, EQ-5D-5L)

END OF TREATMENT VISIT (within 30 days of last dose):
- Complete physical examination
- All laboratory assessments
- AE documentation through 30-day safety follow-up',
    'MED-ONC-2024-005',
    'v1.0',
    'PROCEDURES',
    1,
    PARSE_JSON('{"author": "Clinical Operations", "approval_date": "2024-06-01", "assessment_schedule": "PCWG3-aligned"}');

-- Study 3: MED-ONC-2024-003 (TNBC) - Exclusion Criteria (ADDED)
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-003/v2.0/section_4_exclusion.pdf',
    'EXCLUSION CRITERIA FOR MED-ONC-2024-003 (TRIPLE-NEGATIVE BREAST CANCER STUDY)

Patients meeting any of the following criteria are NOT eligible for enrollment:

1. PRIOR THERAPY EXCLUSIONS:
   - Prior treatment with a TROP-2 directed antibody-drug conjugate (e.g., sacituzumab govitecan)
   - Prior treatment with topoisomerase I inhibitors as payload-based ADCs
   - Chemotherapy, immunotherapy, or investigational agents within 21 days of first dose
   - Hormonal therapy within 7 days of first dose (if applicable for ER-low tumors)
   
2. DISEASE-RELATED EXCLUSIONS:
   - Known active CNS metastases or leptomeningeal disease
   - History of inflammatory breast cancer
   - Concurrent second primary malignancy (except adequately treated basal cell carcinoma or CIS)
   - Tumor involvement of major pulmonary vessels with bleeding risk
   
3. LABORATORY EXCLUSIONS:
   - Absolute neutrophil count (ANC) <1,500/μL
   - Platelet count <100,000/μL
   - Hemoglobin <9.0 g/dL (transfusion permitted to achieve)
   - Total bilirubin >1.5× ULN (except Gilbert syndrome)
   - AST/ALT >3× ULN (or >5× ULN with liver metastases)
   - Serum creatinine >1.5× ULN or CrCl <30 mL/min
   - UPC ratio >1 (if dipstick shows ≥2+ protein)
   
4. MEDICAL HISTORY EXCLUSIONS:
   - Chronic or active hepatitis B or C infection
   - Known HIV infection with CD4 <200 cells/μL or detectable viral load
   - Active serious infection requiring IV antibiotics
   - Interstitial lung disease or history of pneumonitis requiring steroids
   - Uncontrolled diabetes (HbA1c >8%)
   - Significant cardiac disease including CHF (NYHA Class III-IV), recent MI within 6 months
   
5. OCULAR EXCLUSIONS:
   - History of corneal disease or keratitis
   - Current use of contact lenses (must discontinue before enrollment)

Note: Screen failure rate for this study is elevated (19.6%). Most common exclusion reasons: prior TROP-2 ADC therapy, ANC below threshold, and active CNS metastases.',
    'MED-ONC-2024-003',
    'v2.0',
    'EXCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Robert Kim", "approval_date": "2024-05-01", "screen_failure_analysis": "Prior TROP-2 ADC most common exclusion"}');

-- Study 4: MED-ONC-2024-004 (Colorectal) - Exclusion Criteria (ADDED)
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-004/v1.2/section_4_exclusion.pdf',
    'EXCLUSION CRITERIA FOR MED-ONC-2024-004 (METASTATIC COLORECTAL CANCER STUDY)

Patients with ANY of the following are excluded from participation:

1. PRIOR THERAPY RESTRICTIONS:
   - Prior treatment with regorafenib or TAS-102 (trifluridine/tipiracil)
   - Prior anti-angiogenic therapy within 28 days (bevacizumab, ramucirumab, aflibercept)
   - Prior treatment with the same class of investigational agent
   - Major surgery or significant traumatic injury within 28 days
   - Radiation therapy within 14 days (palliative bone RT within 7 days permitted)
   
2. MOLECULAR/BIOMARKER EXCLUSIONS:
   - MSI-High or dMMR tumors that have not received prior checkpoint inhibitor therapy
   - Known BRAF V600E mutation without prior BRAF-targeted therapy
   - HER2 amplification without prior HER2-directed therapy
   
3. GI-SPECIFIC EXCLUSIONS:
   - Active GI bleeding within 3 months
   - History of GI perforation, fistula, or intra-abdominal abscess within 6 months
   - Unresolved bowel obstruction or sub-obstruction
   - Active diverticulitis or history of diverticulitis with micro-perforation
   - Inflammatory bowel disease (Crohns disease or ulcerative colitis)
   - Malabsorption syndrome affecting drug absorption
   
4. CARDIOVASCULAR EXCLUSIONS:
   - Uncontrolled hypertension (systolic >150 mmHg or diastolic >100 mmHg despite medication)
   - History of hypertensive crisis or hypertensive encephalopathy
   - Arterial thromboembolic events within 6 months (MI, CVA, TIA)
   - Venous thromboembolic events within 3 months (DVT, PE) unless on stable anticoagulation
   - Significant vascular disease (aortic aneurysm, peripheral arterial thrombosis)
   - NYHA Class III-IV heart failure
   - QTcF >480 ms
   
5. WOUND HEALING AND BLEEDING:
   - Non-healing wound, ulcer, or bone fracture
   - Significant bleeding diathesis or coagulopathy
   - Therapeutic anticoagulation with warfarin (LMWH or DOACs permitted)
   - Gross hemoptysis (>2.5 mL) within 3 months

6. OTHER EXCLUSIONS:
   - Proteinuria ≥2+ on dipstick or UPCR ≥1.0
   - Known hypersensitivity to study drug components
   - Pregnant or breastfeeding women
   - Psychiatric illness limiting compliance

Note: Screen failure rate for this study is 19.1%. Most common exclusion reasons: uncontrolled hypertension, recent anti-angiogenic therapy, and active GI complications.',
    'MED-ONC-2024-004',
    'v1.2',
    'EXCLUSION_CRITERIA',
    1,
    PARSE_JSON('{"author": "Dr. Lisa Martinez", "approval_date": "2024-06-15", "screen_failure_analysis": "Hypertension and GI complications most common"}');

-- General: Protocol Amendment Example
INSERT INTO TRIAL_PROTOCOL_DOCUMENTS_CHUNKS (RELATIVE_PATH, CHUNK_TEXT, STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE, CHUNK_SEQUENCE, METADATA)
SELECT 
    'protocols/MED-ONC-2024-001/v2.1/amendment_2_summary.pdf',
    'PROTOCOL AMENDMENT 2 SUMMARY - MED-ONC-2024-001 (NSCLC STUDY)

EFFECTIVE DATE: March 1, 2024
VERSION: v2.1 (supersedes v2.0)

KEY MODIFICATIONS:

1. ELIGIBILITY EXPANSION (Impact: High)
   Change: Patients with prior KRAS G12C inhibitor therapy are now EXCLUDED
   Rationale: Preliminary data from MED-1234-001 Phase I expansion cohort showed reduced efficacy (ORR 8% vs 35%) in patients with prior KRAS G12C exposure due to overlapping resistance mechanisms.
   
2. BIOMARKER REQUIREMENTS (Impact: Medium)
   Change: Mandatory tumor PD-L1 testing at screening (previously optional)
   Rationale: Stratification by PD-L1 status (TPS ≥50%, 1-49%, <1%) required for planned subgroup analyses per FDA guidance.
   
3. DOSE MODIFICATION CLARIFICATION (Impact: Low)
   Change: Added specific guidance for immune-related hepatitis management
   Rationale: Increased clarity requested by sites based on monitoring feedback.
   
4. STATISTICAL CONSIDERATIONS (Impact: Medium)
   Change: Increased sample size from 400 to 450 patients
   Rationale: To maintain >90% power following updated control arm assumptions based on recently published competitor data.

IMPLEMENTATION NOTES:
- All currently enrolled patients may continue under v2.0 provisions
- New enrollments must meet v2.1 criteria
- ICF update required - patients should re-consent at next visit
- Mandatory site training call scheduled for March 15, 2024',
    'MED-ONC-2024-001',
    'v2.1',
    'AMENDMENT',
    1,
    PARSE_JSON('{"author": "Global Medical Lead", "approval_date": "2024-03-01", "amendment_number": 2, "requires_reconsent": true}');


-- Verify data insertion
SELECT COUNT(*) AS TOTAL_CHUNKS, 
       COUNT(DISTINCT STUDY_ID) AS UNIQUE_STUDIES,
       COUNT(DISTINCT SECTION_TYPE) AS UNIQUE_SECTION_TYPES
FROM TRIAL_PROTOCOL_DOCUMENTS_CHUNKS;

-- Show distribution by section type
SELECT SECTION_TYPE, COUNT(*) AS CHUNK_COUNT 
FROM TRIAL_PROTOCOL_DOCUMENTS_CHUNKS 
GROUP BY SECTION_TYPE 
ORDER BY CHUNK_COUNT DESC;


/*******************************************************************************
 * CORTEX SEARCH SERVICE: PROTOCOL_SEARCH_SERVICE
 * 
 * Creates a semantic search service on protocol document chunks.
 * Enables natural language queries against protocol content with
 * filtering by study and section type.
 ******************************************************************************/

-- NOTE: Update the warehouse name to match your environment
CREATE OR REPLACE CORTEX SEARCH SERVICE PROTOCOL_SEARCH_SERVICE
    ON CHUNK_TEXT
    ATTRIBUTES STUDY_ID, PROTOCOL_VERSION, SECTION_TYPE
    WAREHOUSE = COMPUTE_WH
    TARGET_LAG = '1 hour'
    COMMENT = 'Cortex Search service for clinical trial protocol documents. Enables natural language search across exclusion criteria, dosing instructions, amendments, safety information, and procedures. Filter by STUDY_ID, PROTOCOL_VERSION, or SECTION_TYPE.'
    AS (
        SELECT 
            CHUNK_ID,
            RELATIVE_PATH,
            CHUNK_TEXT,
            STUDY_ID,
            PROTOCOL_VERSION,
            SECTION_TYPE,
            CHUNK_SEQUENCE,
            LAST_UPDATED
        FROM TRIAL_PROTOCOL_DOCUMENTS_CHUNKS
    );

-- Verify Cortex Search Service creation
SHOW CORTEX SEARCH SERVICES IN SCHEMA CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS;

-- Example query to test the search service (using modern SEARCH_PREVIEW syntax)
-- SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
--     'CLINICAL_TRIAL_DEMO.CLINICAL_OPERATIONS.PROTOCOL_SEARCH_SERVICE',
--     '{
--         "query": "What are the exclusion criteria for brain metastases?",
--         "columns": ["CHUNK_TEXT", "STUDY_ID", "SECTION_TYPE"],
--         "limit": 3
--     }'
-- );
