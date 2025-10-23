Here is our 5-step plan to complete **Module 2 (Week 10)**.

This module completes "Cycle 1" of the project, focusing on adding a database and enhancing our CI pipeline with automated code quality checks (linting).

---

### Step 1: Generate the Canonical Reference Guide

As per our new workflow, we'll start by generating the authoritative reference list for this module's new technologies. This will give us high-quality links to "sprinkle" throughout the lectures and ICEs.

**Topics:**
* **SQLAlchemy:** The Python ORM (Object-Relational Mapper).
* **Alembic:** The database migration tool for SQLAlchemy.
* **`flake8`:** The Python linter for code style.
* **`pytest` (Advanced):** How to write a basic unit test (vs. a placeholder).

---

### Step 2: Day 1 - Databases & Models (L3 / ICE 3)

This day is all about creating the "filing cabinet" for the Ministry.

* **Generate Lecture 3: Databases & Models:** This lecture will introduce the concept of an ORM (SQLAlchemy), explaining how it maps Python `class` definitions to database tables. It will also introduce the *critical* concept of database migrations (Alembic) and why they are essential for preventing team-wide schema conflicts.
* **Generate ICE 3: The Ministry's Filing Cabinet:** This is a high-friction, high-value workshop. Teams will:
    1.  Install `sqlalchemy`, `psycopg2-binary`, and `alembic`.
    2.  Define the `User` and `Joke` models in their app.
    3.  Initialize `alembic` in their repository.
    4.  Run `alembic revision --autogenerate` to create their *first* migration file.
    5.  Add all new packages to `requirements.txt`.

---

### Step 3: Day 2 - Quality & Automation (L4 / ICE 4)

This day enhances the CI pipeline from Week 9, adding a new pillar of automated quality.

* **Generate Lecture 4: Testing, Linting & Data Formats:** This lecture will cover *why* code style (linting) is a critical engineering concern (readability, maintainability, reduced cognitive load). It will also show how to write a simple, *real* unit test using `pytest` (e.g., testing that the "hello world" route returns a `200 OK`).
* **Generate ICE 4: The Ministry's Style Guide:** This ICE directly modifies the `main.yml` file from ICE 2. Teams will:
    1.  Add a *new, parallel job* named `lint`.
    2.  This `lint` job will install `flake8` and run it against their codebase.
    3.  This teaches them how to manage multiple, parallel jobs in a single workflow file.
    4.  They will also write one *real* unit test for their "hello world" route.

---

### Step 4: Generate the "Cycle 1" Project Deliverable

With all the foundational pieces from Weeks 9 and 10 in place, we will now generate the first major project assignment that synthesizes everything.

* **Generate MoJ Project: Cycle 1 Deliverable:** This assignment will require teams to submit a GitHub Release that provides evidence of:
    1.  A working Flask application.
    2.  A 100% "green" CI pipeline with two parallel jobs: `test` and `lint`.
    3.  Defined `User` and `Joke` database models.
    4.  A correct Alembic migration file.
    5.  It will include a clear **TA Grading Rubric** and our mandatory **Ethical Challenge ✍️** prompt (e.g., "Discuss the ethical risks of storing user-submitted joke data").

---

### Step 5: Finalize and Review

We will conclude the module by summarizing our work.

* **Update `decisions_log.md`:** We will log any key pedagogical decisions made during this module's development.
* **Generate Module 2 `README.md`:** I will generate the final summary file with a content overview, pedagogical evaluation, and 1-10 rating, just as we did for Module 1.