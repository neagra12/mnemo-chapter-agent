# /regression_testing

## Purpose

This directory supports the quality assurance process for both the **Clio** (Lecture Coach) and **Chapter Agent** personas. It contains benchmark artifacts — the "golden set" — generated from a known-good version of each persona's instructions. When instructions are changed, new artifacts are generated and compared against these benchmarks to ensure consistency and accuracy.

---

## Directory Structure

```
regression_testing/
├── clio/
│   ├── golden_set/          # Benchmark artifacts from known-good Clio persona
│   └── test_runs/           # New artifacts generated after persona changes
└── chapter_agent/
    ├── golden_set/          # Benchmark artifacts from known-good Chapter Agent persona
    └── test_runs/           # New artifacts generated after persona changes
```

---

## Clio Regression Tests

### Example Golden Set Files
* `clio/golden_set/ICE_07_Models_Migrations_v1.md`
* `clio/golden_set/mod1_lec03_Database_Models_v1.md`

### Example Test Prompts

**Prompt 1 — ICE Generation:**
```
Clio, generate the ICE for Week 10, Lecture 3.
- Topic: Database Models & Migrations
- Bridge from: "We just set up our Flask app, now we need to persist data."
- Core Learning Objectives:
    1. Define a SQLAlchemy model with at least two fields.
    2. Run a Flask-Migrate migration successfully.
- ICE Goal: A passing `flask db upgrade` with User and Joke models in the DB.
- ICE Roles: The Migration Kit
- AAR Hints: "Circular import trap", "forgot flask db init"
```

**Prompt 2 — Slide Deck Generation:**
```
Clio, generate the lecture slides for mod1_Lec03 (Databases & Models).
Topic: Introducing SQLAlchemy and Flask-Migrate.
Bridge from: The Angband MFE flat-file pain point.
```

---

## Chapter Agent Regression Tests

### Example Golden Set Files
* `chapter_agent/golden_set/chapter_databases_autonomous_v1.md`
* `chapter_agent/golden_set/chapter_indexing_catalog_guided_v1.md`

### Example Test Prompts

**Prompt 1 — Autonomous Mode:**
```
MODE: Autonomous

TOPIC: Introduction to Relational Databases

Generate the full chapter package.
```

**Prompt 2 — Catalog-Guided Mode:**
```
MODE: Catalog-Guided

CATALOG:
  course_name: Introduction to Databases
  audience: second-year CS undergraduates
  prerequisites: basic SQL, Python fundamentals
  style: applied and example-driven
  assessment_type: short answer + SQL coding exercise
  chapter_number: 3

TOPIC: Indexing and Query Optimization

Generate the full chapter package.
```

**Prompt 3 — Feedback-Guided Mode (Blueprint only):**
```
MODE: Feedback-Guided

CATALOG:
  course_name: Software Engineering
  audience: upper-level undergraduates
  prerequisites: OOP, basic Git
  style: practical and project-driven
  assessment_type: code review + short answer
  chapter_number: 5

TOPIC: Continuous Integration and Automated Testing

Generate the Chapter Blueprint for review before full generation.
```

---

## Regression Workflow

1. **Baseline:** When a persona file is updated, generate a new artifact using one of the test prompts above and save it to `test_runs/`.
2. **Compare:** Diff the `test_runs/` artifact against the corresponding `golden_set/` artifact.
3. **Key things to check for Chapter Agent:**
    - All 11 sections present (Metadata through Pedagogical Review)
    - Learning objectives use Bloom's Taxonomy verbs
    - I-WE-YOU structure present in Core Content
    - Historical Hook included
    - Ethical Reflection prompt included
    - Instructor Notes section separated from student-facing content
4. **Key things to check for Clio:**
    - ICE template sections all present (Roles, Tasks, CONTRIBUTIONS.md, DoD, SBP)
    - Rubric uses Pandoc grid table format
    - Pedagogical Analysis appended at end
    - AAR hints pre-filled and ICE-specific
5. **Promote:** If the new artifact passes the check, copy it to `golden_set/` as the new baseline.