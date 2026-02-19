# Chapter Agent: Generation & Testing Process

**Last Updated:** 2026-02-18
**Status:** Active

---

## Overview

This document describes the end-to-end process for generating, reviewing, and managing instructional chapter packages for the P465/P565 Software Engineering course using the **Chapter Agent** persona.

The Chapter Agent is a single-agent system built on Clio's pedagogical principles, redesigned to generate self-contained instructional chapters comparable to the **DARL Instructional Agents** system (Yao et al., EACL 2026, arXiv:2508.19611).

---

## Repository Structure (Relevant Files)

```
clio/
├── knowledge_base/
│   ├── chapter_agent_persona.md       ← The agent's instruction set
│   ├── p465_course_catalog.md         ← P465 chapter sequence & course context
│   ├── clio_persona.md                ← Clio (unchanged, P465 classroom artifacts)
│   ├── decisions_log.md               ← Records why Chapter Agent was created
│   └── README.md                      ← Documents all files in this directory
│
└── regression_testing/
    └── chapter_agent/
        ├── golden_set/                ← Approved baseline artifacts
        │   ├── chapter_01_flask_modern_web.md
        │   ├── chapter_02_continuous_integration.md
        │   └── chapter_03_...md       ← (add as generated)
        └── test_runs/                 ← New outputs for comparison
```

---

## Files Required for Each Session

Every Chapter Agent session requires two files pasted into Claude:

| File | Purpose |
|---|---|
| `knowledge_base/chapter_agent_persona.md` | Defines the agent's behavior, output structure, and ADDIE alignment |
| `knowledge_base/p465_course_catalog.md` | Provides course context, chapter sequence, and prerequisites |

---

## Chapter Sequence (P465/P565)

| # | Topic | Prerequisites |
|---|---|---|
| 1 | Flask and the Modern Web | Python, HTTP basics |
| 2 | Continuous Integration and Automated Testing | Git, basic pytest |
| 3 | Databases and SQLAlchemy | Flask routing, Python classes |
| 4 | Refactoring and Testing | SQLAlchemy models, pytest basics |
| 5 | Authentication and Authorization | Flask, databases, sessions |
| 6 | CRUD Operations and Jinja2 Templating | Auth, Flask-Login, models |
| 7 | Role-Based Access Control | Auth, CRUD, Flask-Login |
| 8 | Many-to-Many Relationships and Advanced RBAC | RBAC, SQLAlchemy associations |
| 9 | The Logging Service | RBAC, models, routes |
| 10 | External Security and the 12-Factor App | Flask, .env files, RBAC |
| 11 | Application Security and DevSecOps | 12-Factor, CI pipeline |
| 12 | Containerization and Docker | Flask app, dependencies |
| 13 | Continuous Delivery and Deployment | Docker, CI pipeline |
| 14 | GenAI Integration | Full MoJ app, REST APIs |

**Current golden set status:**
- ✅ Chapter 1 — `chapter_01_flask_modern_web.md`
- ✅ Chapter 2 — `chapter_02_continuous_integration.md`
- ⬜ Chapters 3–14 — pending

---

## Step-by-Step: Generating a Chapter

### Step 1 — Open a new Claude conversation

Go to [claude.ai](https://claude.ai) and click **New Chat**.

> ⚠️ Each chapter must be generated in its own fresh conversation.
> Do not reuse a session from a previous chapter — the prior output will pollute the context.

---

### Step 2 — Open both files in VS Code

1. Open `knowledge_base/chapter_agent_persona.md`
2. Open `knowledge_base/p465_course_catalog.md`

---

### Step 3 — Paste both files as the first message

In the Claude chat:
1. Select all of `chapter_agent_persona.md` (`Ctrl+A`, `Ctrl+C`)
2. Paste into the chat
3. Press `Enter` once to add a blank line
4. Select all of `p465_course_catalog.md` (`Ctrl+A`, `Ctrl+C`)
5. Paste below the persona
6. Hit **Send**

Claude will respond confirming it has absorbed both files and is ready.

---

### Step 4 — Send the chapter request

Use this template. Change only `chapter_number`, `TOPIC`, and `prerequisites`:

```
MODE: Catalog-Guided

CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: [what this chapter builds on — see catalog for each chapter]
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: [N]

TOPIC: [Topic from chapter sequence]

Generate the full chapter package.
```

**Example for Chapter 3:**
```
MODE: Catalog-Guided

CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Python, Flask routing, Python classes, basic SQLAlchemy awareness
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 3

TOPIC: Databases and SQLAlchemy

Generate the full chapter package.
```

Wait for the full response — a complete chapter takes 2–4 minutes to generate.

---

### Step 5 — Check for truncation

Claude has a response length limit. Before saving, verify all 11 sections are present:

| Section | What to look for |
|---|---|
| 1. Chapter Metadata | Title, audience, prerequisites, read time, difficulty |
| 2. Learning Objectives | 3–5 Bloom's Taxonomy objectives |
| 3. The Hook | 1–2 paragraph opening scenario |
| 4. Core Content | I (worked example) + WE (guided practice) + YOU (open challenge) |
| 5. Historical Context | 1 paragraph origin story |
| 6. Ethical Consideration | Ethical Reflection prompt in blockquote |
| 7. Chapter Summary | 5–8 bullet takeaways |
| 8. Self-Assessment Questions | 5 questions (2 recall, 2 application, 1 critical thinking) |
| 9. Connections | Previous/Next/Real-World/Further Reading |
| 10. Instructor Notes | Answer key, misconceptions, talking points, slide outline |
| 11. Pedagogical Review | ADDIE, Bloom's, I-WE-YOU, historical, ethical, assessment, accessibility |

If any section is missing or cut off, ask Claude to continue:
```
The output was truncated. Please continue from Section [N].
```

---

### Step 6 — Review output quality

Before promoting to golden set, check these specifically:

**Structure:**
- [ ] All 11 sections present and in order
- [ ] No P465 classroom logistics (no ICEs, GitHub PRs, Canvas, team roles, rubrics)
- [ ] Instructor Notes clearly separated from student-facing content

**Content quality:**
- [ ] Hook starts with a problem or story, not a definition
- [ ] I-WE-YOU scaffold is visible in Core Content
- [ ] WE section has `[YOUR TASK: ...]` markers
- [ ] YOU section has optional hints clearly marked
- [ ] Historical Context is specific (names, dates, origin story)
- [ ] Ethical Reflection is genuinely open-ended
- [ ] Connections → Next Chapter matches the actual next chapter in the sequence

**Assessment:**
- [ ] Exactly 5 self-assessment questions
- [ ] Mix: 2 recall + 2 application + 1 critical thinking
- [ ] Answers NOT in the student section — they're in Instructor Notes
- [ ] Answer key in Instructor Notes is thorough

---

### Step 7 — Save the output

Copy the entire Claude response and save it as a `.md` file:

```
regression_testing/chapter_agent/golden_set/chapter_0N_topic_name.md
```

**Naming convention:**

| Chapter | Filename |
|---|---|
| 1 | `chapter_01_flask_modern_web.md` |
| 2 | `chapter_02_continuous_integration.md` |
| 3 | `chapter_03_databases_sqlalchemy.md` |
| 4 | `chapter_04_refactoring_testing.md` |
| 5 | `chapter_05_authentication_authorization.md` |
| 6 | `chapter_06_crud_jinja2_templating.md` |
| 7 | `chapter_07_role_based_access_control.md` |
| 8 | `chapter_08_many_to_many_advanced_rbac.md` |
| 9 | `chapter_09_logging_service.md` |
| 10 | `chapter_10_external_security_12factor.md` |
| 11 | `chapter_11_application_security_devsecops.md` |
| 12 | `chapter_12_containerization_docker.md` |
| 13 | `chapter_13_continuous_delivery_deployment.md` |
| 14 | `chapter_14_genai_integration.md` |

---

## Regression Testing Workflow

Use this when you update `chapter_agent_persona.md` and want to verify the agent's output hasn't changed in unexpected ways.

### Step 1 — Generate a new test artifact

Follow the generation process above. Save the output to:
```
regression_testing/chapter_agent/test_runs/chapter_0N_topic_name_v2.md
```

### Step 2 — Compare against golden set

Open both files side by side in VS Code (`Ctrl+Shift+P` → "Diff: Compare Active File With...") or use:

```bash
diff regression_testing/chapter_agent/golden_set/chapter_03_databases_sqlalchemy.md \
     regression_testing/chapter_agent/test_runs/chapter_03_databases_sqlalchemy_v2.md
```

### Step 3 — Evaluate differences

Not all differences are regressions. Use this guide:

| Type of difference | Action |
|---|---|
| Different examples, same structure | ✅ Acceptable — generative variation |
| Missing a section entirely | ❌ Regression — investigate persona change |
| Bloom's verbs missing from objectives | ❌ Regression |
| Instructor Notes merged into student content | ❌ Regression |
| I-WE-YOU scaffold missing | ❌ Regression |
| Next Chapter reference wrong | ⚠️ Fix manually or re-run |
| Shorter than golden set | ⚠️ Check for truncation |

### Step 4 — Promote or reject

- **Pass:** Copy test artifact to `golden_set/` as the new baseline.
- **Fail:** Revert the persona change or fix the issue, then re-run.

---

## Known Issues and Fixes

| Issue | Fix |
|---|---|
| Output truncated mid-section | Ask Claude to continue from the section that was cut off |
| Connections → Next Chapter is wrong | Edit manually using the chapter sequence table |
| Code examples use wrong Flask version | Add `prerequisites: Flask 3.x` to the CATALOG block |
| Section 4 (Core Content) is too short | Add `style: detailed and example-driven` to the CATALOG |
| Chapter number in metadata doesn't match request | Edit the metadata line manually |

---

## Comparison with DARL Instructional Agents

This process produces artifacts for comparison against the DARL system (Yao et al., EACL 2026).

| Dimension | Chapter Agent (this process) | DARL Instructional Agents |
|---|---|---|
| Architecture | Single agent | Multi-agent pipeline |
| Framework | ADDIE | ADDIE |
| Primary output | Chapter packages (.md) | Slides (.pdf) + script (.md) + assessment (.md) |
| Domain | Any (P465 here) | Any (tested on 5 CS courses) |
| Operation modes | 4 explicit modes | 4 explicit modes |
| Classroom logistics | None | None |
| Setup required | None (claude.ai) | Docker + OpenAI API key |
| Cost per chapter | Claude.ai subscription | ~$0.22–$0.36 per course |

**DARL paper:** https://arxiv.org/abs/2508.19611
**DARL code:** https://github.com/DaRL-GenAI/instructional_agents

---

## Quick Reference: Test Prompts

Copy-paste ready prompts for all 14 chapters:

**Chapter 1**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Python (functions, modules, decorators), basic Git, command-line fluency
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 1
TOPIC: Flask and the Modern Web
Generate the full chapter package.
```

**Chapter 2**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Python, basic Git, basic pytest
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 2
TOPIC: Continuous Integration and Automated Testing
Generate the full chapter package.
```

**Chapter 3**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Python, Flask routing, Python classes, basic SQLAlchemy awareness
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 3
TOPIC: Databases and SQLAlchemy
Generate the full chapter package.
```

**Chapter 4**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: SQLAlchemy models, Flask app package structure, pytest basics
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 4
TOPIC: Refactoring and Testing
Generate the full chapter package.
```

**Chapter 5**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Flask, SQLAlchemy, HTTP sessions, password hashing basics
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 5
TOPIC: Authentication and Authorization
Generate the full chapter package.
```

**Chapter 6**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Flask-Login, SQLAlchemy models, Flask routes
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 6
TOPIC: CRUD Operations and Jinja2 Templating
Generate the full chapter package.
```

**Chapter 7**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Authentication, CRUD, Flask-Login, current_user
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 7
TOPIC: Role-Based Access Control
Generate the full chapter package.
```

**Chapter 8**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: RBAC, SQLAlchemy one-to-many relationships, Flask routes
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 8
TOPIC: Many-to-Many Relationships and Advanced RBAC
Generate the full chapter package.
```

**Chapter 9**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: RBAC, SQLAlchemy models, Flask routes and templates
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 9
TOPIC: The Logging Service
Generate the full chapter package.
```

**Chapter 10**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Flask, .env files, RBAC, basic web security awareness
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 10
TOPIC: External Security and the 12-Factor App
Generate the full chapter package.
```

**Chapter 11**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: 12-Factor App, CI pipeline, Flask routes and forms
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 11
TOPIC: Application Security and DevSecOps
Generate the full chapter package.
```

**Chapter 12**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Flask app, requirements.txt, basic command-line fluency
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 12
TOPIC: Containerization and Docker
Generate the full chapter package.
```

**Chapter 13**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Docker, CI pipeline (GitHub Actions), Flask app
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 13
TOPIC: Continuous Delivery and Deployment
Generate the full chapter package.
```

**Chapter 14**
```
MODE: Catalog-Guided
CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: Full Flask MoJ app, REST APIs, basic Python requests or httpx
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: 14
TOPIC: GenAI Integration
Generate the full chapter package.
```
