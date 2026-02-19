# P465/P565 Software Engineering — Course Catalog

## Course Info

- **Course Name:** Software Engineering (P465/P565)
- **Audience:** Upper-level undergraduates and Master's students
- **Prerequisites:** Python (functions, modules, decorators), basic Git, command-line fluency
- **Style:** Practical and project-driven
- **Assessment Type:** Short answer + coding exercise
- **Project Context:** Ministry of Jokes (MoJ) — a Flask web application built incrementally across the semester

---

## Chapter Sequence

| # | Topic | Builds On | Leads To |
|---|---|---|---|
| 1 | Flask and the Modern Web | Python, HTTP basics | Ch 2 |
| 2 | Continuous Integration and Automated Testing | Git, basic pytest | Ch 3 |
| 3 | Databases and SQLAlchemy | Flask routing, Python classes | Ch 4 |
| 4 | Refactoring and Testing | SQLAlchemy models, pytest basics | Ch 5 |
| 5 | Authentication and Authorization | Flask, databases, sessions | Ch 6 |
| 6 | CRUD Operations and Jinja2 Templating | Auth, Flask-Login, models | Ch 7 |
| 7 | Role-Based Access Control | Auth, CRUD, Flask-Login | Ch 8 |
| 8 | Many-to-Many Relationships and Advanced RBAC | RBAC, SQLAlchemy associations | Ch 9 |
| 9 | The Logging Service | RBAC, models, routes | Ch 10 |
| 10 | External Security and the 12-Factor App | Flask, .env files, RBAC | Ch 11 |
| 11 | Application Security (SQL Injection, DevSecOps) | 12-Factor, CI pipeline | Ch 12 |
| 12 | Containerization and Docker | Flask app, dependencies | Ch 13 |
| 13 | Continuous Delivery and Deployment | Docker, CI pipeline | Ch 14 |
| 14 | GenAI Integration | Full MoJ app, REST APIs | — |

---

## How to Use This Catalog with the Chapter Agent

Paste both this file and `chapter_agent_persona.md` into a new Claude conversation. Then send:

```
MODE: Catalog-Guided

CATALOG:
  course_name: Software Engineering (P465/P565)
  audience: upper-level undergraduates and Master's students
  prerequisites: [see chapter sequence above for what this chapter builds on]
  style: practical and project-driven
  assessment_type: short answer + coding exercise
  chapter_number: [N]

TOPIC: [Topic from chapter sequence above]

Generate the full chapter package.
```

Replace `[N]` and `[Topic]` with the values from the table above.

---

## Notes

- **Chapter 2** golden set artifact already exists at `regression_testing/chapter_agent/golden_set/chapter_02_continuous_integration.md`
- **Chapter 1** golden set artifact already exists at `regression_testing/chapter_agent/golden_set/chapter_01_flask_modern_web.md`
- Chapters 3–14 are pending generation
- The Connections section in each chapter should reference the correct previous/next chapter using this sequence