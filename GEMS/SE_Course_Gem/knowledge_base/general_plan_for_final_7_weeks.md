***
## The Final 7-Week Plan

#### **Cycle 1: Foundations & Automated Quality (Weeks 1-2)**
* **Week 1:**
    * **Lecture 1: The Modern Web & The Engineering Mindset.**
        * **Historical Hook:** The origin of HTTP at CERN.
        * **Core Concepts:** Client-server model, HTTP basics, role of a web framework (Flask).
        * **ICE 1:** Teams set up their Git repository, establish branching standards, and get the initial "Hello World" Flask app running.
    * **Lecture 2: Continuous Integration (CI).**
        * **Core Concepts:** Principles of CI, GitHub Actions workflow syntax, YAML structure.
        * **ICE 2 (Project-Critical):** Teams create their `main.yml` workflow file for GitHub Actions and configure it to run `pytest` on every push.
* **Week 2:**
    * **Lecture 3: Databases & Models.**
        * **Core Concepts:** ORMs (SQLAlchemy), database migrations, designing data models.
        * **ICE 3:** Teams define their `User` and `Joke` models and create the initial database migration.
    * **Lecture 4: Testing, Linting & Data Formats.**
        * **Core Concepts:** Unit testing with Pytest, code linting with `flake8`, and a comparison of **YAML vs. JSON**.
        * **ICE 4 (CI Enhancement):** Teams write their first unit tests and add a "Lint" job to their GitHub Actions workflow.

---
#### **Cycle 2: Security, Features & CI Enhancement (Weeks 3-4)**
* **Week 3:**
    * **Lecture 5: Authentication & User Roles.**
        * **Historical Hook:** The history of password hashing (MD5 vs. bcrypt).
        * **Core Concepts:** Secure password storage, session management, Role-Based Access Control (RBAC).
        * **ICE 5:** Teams implement user registration and login functionality.
    * **Lecture 6: Web Security & Secure CI.**
        * **Core Concepts:** OWASP Top 10 (CSRF, Injection), security scanning tools (`bandit`, `pip-audit`).
        * **ICE 6 (CI Enhancement):** Teams add `bandit` and `pip-audit` jobs to their GitHub Actions workflow.
* **Week 4:**
    * **Lecture 7: Feature Development & Integration.**
        * **Core Concepts:** Implementing the rating system, integrating the new feature into the existing, secured application.
        * **ICE 7 (Project-Critical):** Teams write the backend logic for the joke rating system.
    * **Lecture 8: Cycle 2 Review & Retrospective.**
        * **ICE 8:** A 30-minute "Start, Stop, Continue" team retrospective to identify process pain points.

---
#### **Cycle 3: Integration, Operations & Scale (Weeks 5-7)**
* **Week 5:**
    * **Lecture 9: APIs & Decoupling: The "Contract".**
        * **Core Concepts:** RESTful API design, API-first development.
        * **ICE 9 (Vertical Slice, Part 1):** Teams define and build the backend "contract": a single, trivial data-only endpoint `GET /api/jokes/count`.
    * **Lecture 10: Introduction to Frontend Frameworks: "Consuming the Contract".**
        * **Core Concepts:** The "why" of React, component-based architecture, the `fetch` API.
        * **ICE 10 (Vertical Slice, Part 2):** Teams create a single React component that fetches data from their `/api/jokes/count` endpoint and displays: "Total Jokes: [Number]".
* **Week 6:**
    * **Lecture 11: Containerization with Docker.**
        * **Substituted Hook:** **The "It Works on My Machine" Problem.** (This replaces the redundant history hook).
        * **Core Concepts:** Dockerfiles, Docker Compose, solving dependency and environment drift.
        * **ICE 11:** Teams create a `Dockerfile` for their Flask application.
    * **Lecture 12: Continuous Deployment (CD).**
        * **Core Concepts:** Principles of CD, automating Docker builds, GitHub Container Registry.
        * **ICE 12 (CI/CD Enhancement):** Teams enhance their GitHub Actions workflow to build the Docker image and push it to the GitHub Container Registry.
* **Week 7:**
    * **Lecture 13: Integrating External Services (GenAI).**
        * **Core Concepts:** Making API calls to the GenAI service, synchronous vs. asynchronous operations.
        * **ICE 13:** Teams add the synchronous API call to the local GenAI model.
    * **Lecture 14: Course Retrospective & Professional Horizons.**
        * **Core Concepts:** A final, course-wide retrospective; discussion of advanced topics (e.g., async, microservices); "where to go from here."
        * **(No ICE - Final Q&A and wrap-up)**