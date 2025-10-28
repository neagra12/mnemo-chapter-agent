# log of generating Canvas specific components for Week 10

## **---- PROMPT ----**
```markdown
In Canvas I have an overview page for each week.  I need a week introduction. It should lead with a one paragraph introduction to the lecture 3 & 4 for this week. This should be followed by a one paragraph summary of the SBP with a high level summary of the workflow and a sentence explaining the safe harbor of the SBP. A readiness checklist so the team can confirm the repo is ready for week 10 work. Anything I am leaving out?
```
This is a comprehensive and well-thought-out plan. You haven't left anything major out. The three components (Lecture Intro, SBP Summary, and Readiness Checklist) are exactly what students need to orient themselves for the week.

Here is the "Week 10 Overview" text, ready for you to copy into Canvas.

---

## Week 10: Building the Foundation (Databases, Refactoring & Quality)

Welcome to Week 10. This week is the most critical "level-up" of the entire module. We are moving beyond simple scripts and building the professional foundation for our "Ministry of Jokes" application. In Lecture 3, we'll use our past "pain" from the `Angband` flat files to justify why we use a structured database, and you'll build your first models and migrations with SQLAlchemy. In Lecture 4, we'll perform a major "refactor" to evolve our simple `app.py` script into a scalable, professional `moj/` package. We'll then immediately build our first automated "safety nets" (`pytest` and `flake8`) to protect our new architecture.

This week also introduces a critical new course policy: the **Standard Blocker Protocol (SBP)**. This protocol is your "safe harbor" when you get stuck on a technical error during an ICE. If you are individually blocked for more than 15 minutes, you can "invoke the SBP." This means you'll stop coding, create a new branch, and file a detailed **After-Action Report (AAR)** as a pull request. Submitting this AAR on time guarantees you 5/10 points (our "B for good work"), and you'll earn the final 5 points after applying the instructor's fix. This policy is designed to reward professional communication and diagnostic effort, not just a perfect result.

---
### This Week's Mission & Deliverables

* **In-Class:**
    * **ICE 7:** Define the `User` and `Joke` database models and run your first migration.
    * **ICE 8:** Perform a major code refactor (`app.py` -> `moj/`) and write your first `pytest` unit test.
* **Asynchronous:**
    * **Homework: The Linter Audit:** Implement the `flake8` linter and "audit" your project to clean it up.
    * **Weekly Challenge: MongoDB Evaluation:** Use AI to investigate NoSQL as an alternative to our SQL database.

---
### Week 10 Readiness Checklist

This week's workshops (ICE 7 & 8) build directly on the work you completed in Week 9. Before starting, your team's `Repo Admin` should share their screen and verify that your `main` branch is ready:

* [ ] **Repository:** The team repository is accessible to all members.
* [ ] **Application:** The `app.py` file exists and successfully runs a "Hello World" Flask app.
* [ ] **CI Pipeline:** The `.github/workflows/main.yml` file exists from ICE 2.
* [ ] **Process Log:** The `CONTRIBUTIONS.md` file exists and has complete log entries for ICE 1 and ICE 2.
* [ ] **Team Roles:** The team has reviewed the roles from last week and is prepared to rotate (remember, no member can hold the same role for more than two consecutive weeks).

---

Here is a "Recommended Reading" section you can add directly to your Week 10 Overview page in Canvas.

-----

### Recommended Reading & Official Documentation

These resources are not required "cover-to-cover" reading. They are the official documentation for the tools you are implementing this week. Use them as a primary reference to understand *why* the tools work the way they do and to look up configuration options.

  * **Lecture 3 (Databases & Models):**

      * **Flask-SQLAlchemy:** [Quickstart Guide](https://flask-sqlalchemy.palletsprojects.com/en/3.1.x/quickstart/) (The official docs for the extension we use to connect Flask and SQLAlchemy).
      * **Flask-Migrate:** [Official Documentation](https://flask-migrate.readthedocs.io/en/latest/) (The docs for the tool that handles our database "schema version control").
      * **SQL vs. NoSQL:** [MongoDB: SQL vs. NoSQL Explained](https://www.google.com/search?q=https://www.mongodb.com/compare/sql-vs-nosql) (A good high-level overview that supports your `MongoDB` weekly challenge).

  * **Lecture 4 (Refactoring & Quality):**

      * **Flask Application Structure:** [Flask Docs: Larger Applications](https://flask.palletsprojects.com/en/3.0.x/patterns/packages/) (This is the official "I" / "WE" for the `app.py`-to-`moj/` package refactor).
      * **Pytest:** [Get Started with `pytest`](https://www.google.com/search?q=%5Bhttps://docs.pytest.org/en/latest/getting-started.html%5D\(https://docs.pytest.org/en/latest/getting-started.html\)) (The official docs for our testing framework).
      * **Pytest-Flask:** [Official `pytest-flask` Documentation](https://www.google.com/search?q=%5Bhttps://pytest-flask.readthedocs.io/en/latest/%5D\(https://pytest-flask.readthedocs.io/en/latest/\)) (The specific extension that gives us the `client` fixture for testing routes).
      * **Flake8 & PEP 8:** [PEP 8 -- Style Guide for Python Code](https://peps.python.org/pep-0008/) (The *rules* we are enforcing. You should read this at least once in your career).

## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


## **---- PROMPT ----**
```markdown

```


