# Use Case: Sponsor Insights Agent - Key Pieces of the Puzzle

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                             │
│                                    ┌─────────────────────────────────┐                                      │
│                                    │   SNOWFLAKE INTELLIGENCE        │                                      │
│                                    │      User Interface             │                     ★ ACTION         │
│                                    └───────────────┬─────────────────┘                                      │
│                                                    │                                                        │
│            ┌───────────────────────────────────────┼───────────────────────────────────┐                    │
│            │                                       │                                   │                    │
│            ▼                                       ▼                                   ▼                    │
│  ┌─────────────────────┐   ┌─────────────────────────────┐   ┌─────────────────────────────┐               │
│  │  ENROLLMENT_VIEW    │   │   SITE_PERFORMANCE_VIEW     │   │    PROTOCOL_SEARCH          │               │
│  │                     │   │                             │   │                             │               │
│  │ (How is patient     │   │ (Which sites have quality   │   │ (What are the eligibility   │  ★ INSIGHT   │
│  │  recruitment        │   │  concerns and compliance    │   │  criteria, dosing, and      │               │
│  │  progressing?)      │   │  issues?)                   │   │  protocol requirements?)    │               │
│  └──────────┬──────────┘   └──────────────┬──────────────┘   └──────────────┬──────────────┘               │
│             │                              │                                 │                              │
│             ▼                              ▼                                 ▼                              │
│  ┌─────────────────────┐   ┌─────────────────────────────┐   ┌─────────────────────────────┐               │
│  │  Enrollment Rate    │   │      Quality Score          │   │   Semantic Search           │               │
│  │  Screen Failure %   │   │      Deviation Risk         │   │   (Cortex Search)           │               │
│  └──────────┬──────────┘   └──────────────┬──────────────┘   └──────────────┬──────────────┘               │
│             │                              │                                 │                              │
│   ┌─────────┴─────────┐          ┌─────────┴─────────┐            ┌─────────┴─────────┐                    │
│   │                   │          │                   │            │                   │                    │
│   ▼                   ▼          ▼                   ▼            ▼                   ▼                    │
│ ┌───────────┐  ┌────────────┐  ┌───────────┐  ┌────────────┐   ┌───────────┐  ┌────────────┐              │
│ │  TRIAL    │  │   SITE     │  │   SITE    │  │  TRIAL     │   │ PROTOCOL  │  │ CORTEX     │   ★ DATA    │
│ │ ENROLLMENT│  │   INFO     │  │ METRICS   │  │ METADATA   │   │ DOCUMENTS │  │ SEARCH     │              │
│ │ METRICS   │  │            │  │           │  │            │   │ (Chunks)  │  │ SERVICE    │              │
│ ├───────────┤  ├────────────┤  ├───────────┤  ├────────────┤   ├───────────┤  ├────────────┤              │
│ │ Study ID  │  │ Site Name  │  │ Rating    │  │ Phase      │   │ Exclusion │  │ Semantic   │              │
│ │ Planned   │  │ Site ID    │  │ Deviations│  │ Indication │   │ Criteria  │  │ Indexing   │              │
│ │ Actual    │  │ Country    │  │ Queries   │  │ Sponsor    │   │ Dosing    │  │ Vector     │              │
│ │ Failures  │  │ Region     │  │ PI Name   │  │ Status     │   │ Amendments│  │ Embeddings │              │
│ │ Start Date│  │ PI         │  │ Findings  │  │ Dates      │   │ Safety    │  │            │              │
│ └───────────┘  └────────────┘  └───────────┘  └────────────┘   └───────────┘  └────────────┘              │
│                                                                                                             │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Visual Slide Content (For PowerPoint/Google Slides)

### Title: **Use Case: Sponsor Insights Agent - Key Pieces of the Puzzle**

### Top Row (User Interface):
```
┌──────────────────────────────────────────┐
│     SNOWFLAKE INTELLIGENCE               │
│        User Interface                    │
└──────────────────────────────────────────┘
```

### Second Row (Semantic Views - Business Questions):

| ENROLLMENT_ANALYTICS | SITE_PERFORMANCE | COMBINED_INSIGHTS | PROTOCOL_SEARCH |
|---------------------|------------------|-------------------|-----------------|
| *"How is patient recruitment progressing across sites and studies?"* | *"Which sites have quality concerns or compliance issues?"* | *"Which sites need intervention based on all metrics?"* | *"What are the eligibility criteria, dosing, and amendments?"* |

### Third Row (Derived Metrics/Scores):

| Enrollment Rate | Screen Failure Rate | Quality Score | Deviation Risk | Content Relevance |
|-----------------|---------------------|---------------|----------------|-------------------|
| ↑ | ↑ | ↑ | ↑ | ↑ |

### Bottom Row (Raw Data Sources):

| TRIAL_ENROLLMENT_METRICS | SITE_PERFORMANCE_DASHBOARD | PROTOCOL_DOCUMENT_CHUNKS |
|--------------------------|---------------------------|--------------------------|
| • Study ID | • Site ID | • Chunk Text |
| • Site Name | • PI Name | • Study ID |
| • Planned Enrollment | • Rating (1-5) | • Section Type |
| • Actual Enrollment | • Major Deviations | • Protocol Version |
| • Screen Failures | • Minor Deviations | • Metadata |
| • Enrollment Status | • Outstanding Queries | |
| • Country/Region | • Avg Resolution Days | |
| • Start Date | • Monitoring Findings | |

### Right Side Labels (Star Icons):
- ★ **ACTION** (Top)
- ★ **INSIGHT** (Middle)  
- ★ **DATA** (Bottom)

---

## Snowflake Components Used

| Layer | Component | Purpose |
|-------|-----------|---------|
| **Interface** | Snowflake Intelligence | Natural language chat interface |
| **Agent** | Cortex Agent | Multi-tool orchestration |
| **Structured Analytics** | Semantic Views | Business-contextualized data model |
| **Structured Analytics** | Cortex Analyst | Text-to-SQL generation |
| **Unstructured Search** | Cortex Search | Semantic document retrieval |
| **Data Storage** | Tables | Raw metrics and document chunks |

---

## Data Flow: DATA → INSIGHT → ACTION

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐        │
│  │          │      │          │      │          │      │          │        │
│  │   DATA   │ ───▶ │ SEMANTIC │ ───▶ │  CORTEX  │ ───▶ │  ACTION  │        │
│  │          │      │  VIEWS   │      │  AGENT   │      │          │        │
│  │ • Tables │      │          │      │          │      │ • Faster │        │
│  │ • Docs   │      │ • Facts  │      │ • Route  │      │   sponsor│        │
│  │          │      │ • Dims   │      │ • Query  │      │   calls  │        │
│  │          │      │ • Metrics│      │ • Search │      │ • Better │        │
│  │          │      │          │      │ • Answer │      │   sites  │        │
│  │          │      │          │      │          │      │ • Risk   │        │
│  │          │      │          │      │          │      │   mgmt   │        │
│  └──────────┘      └──────────┘      └──────────┘      └──────────┘        │
│                                                                             │
│       ★ DATA            ★ INSIGHT           ★ INSIGHT         ★ ACTION     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Business Questions Answered

| Semantic View | Business Question | Example Query |
|---------------|-------------------|---------------|
| **ENROLLMENT_ANALYTICS** | How is recruitment progressing? | "What is our total enrollment across Phase III studies?" |
| **SITE_PERFORMANCE** | Which sites need attention? | "Which sites have ratings below 4.0?" |
| **COMBINED_INSIGHTS** | Where should we intervene? | "Show high-enrolling sites with quality concerns" |
| **PROTOCOL_SEARCH** | What does the protocol say? | "What are the exclusion criteria for brain metastases?" |

---

## Slide Design Specifications

### Color Palette (Matching PatientPoint Style):
- **Primary boxes**: Teal/Dark Cyan (#008080)
- **Arrows**: Orange (#FF6600)
- **Stars/Labels**: Gray (#666666)
- **Border**: Orange (#FF6600)
- **Background**: White

### Fonts:
- **Title**: Bold, 36pt
- **Box Headers**: Bold, 14pt
- **Box Content**: Regular, 11pt
- **Labels**: Italic, 12pt

### Logo Placement:
- **Top Right**: Medpace logo + Snowflake logo

---

## Simplified One-Slide Version

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│                     SNOWFLAKE INTELLIGENCE                        ★ ACTION │
│                        User Interface                                       │
│                              │                                              │
│        ┌────────────────────┼────────────────────┐                         │
│        ▼                    ▼                    ▼                         │
│  ┌────────────┐      ┌────────────┐      ┌────────────┐                    │
│  │ ENROLLMENT │      │    SITE    │      │  PROTOCOL  │         ★ INSIGHT │
│  │  ANALYTICS │      │ PERFORMANCE│      │   SEARCH   │                    │
│  │            │      │            │      │            │                    │
│  │ "How is    │      │ "Which     │      │ "What are  │                    │
│  │ recruitment│      │ sites have │      │ the dosing │                    │
│  │ going?"    │      │ issues?"   │      │ rules?"    │                    │
│  └─────┬──────┘      └─────┬──────┘      └─────┬──────┘                    │
│        │                   │                   │                           │
│        ▼                   ▼                   ▼                           │
│  ┌────────────┐      ┌────────────┐      ┌────────────┐                    │
│  │ Enrollment │      │  Quality   │      │  Document  │           ★ DATA  │
│  │   Rate %   │      │   Score    │      │  Chunks    │                    │
│  └─────┬──────┘      └─────┬──────┘      └─────┬──────┘                    │
│        │                   │                   │                           │
│        ▼                   ▼                   ▼                           │
│  ┌────────────┐      ┌────────────┐      ┌────────────┐                    │
│  │ ENROLLMENT │      │   SITE     │      │  PROTOCOL  │                    │
│  │  METRICS   │      │ DASHBOARD  │      │   DOCS     │                    │
│  │ • Study ID │      │ • Rating   │      │ • Exclusion│                    │
│  │ • Actual   │      │ • Deviations│     │ • Dosing   │                    │
│  │ • Planned  │      │ • Queries  │      │ • Amendments│                   │
│  │ • Failures │      │ • PI Name  │      │ • Safety   │                    │
│  └────────────┘      └────────────┘      └────────────┘                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

