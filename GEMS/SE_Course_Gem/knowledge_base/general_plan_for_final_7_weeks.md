# The Complete 7-Week Course Plan (v7)

This document outlines the complete learning experience for the final seven weeks. It is divided into two parts:

1.  **Part 1: The Lecture & ICE Sequence** describes the synchronous, in-class learning path.
2.  **Part 2: Integrated Project & Skill Kits** describes the asynchronous, project-based skills delivered and evaluated via project deliverables, quizzes, and extra credit.

-----

## Part 1: The Lecture & ICE Sequence

This is the 14-lecture, 7-week plan that forms the "spine" of the course.

#### **Cycle 1: Foundations & Automated Quality (Weeks 1-2)**

  * **Week 1:**
      * **Lecture 1: The Modern Web & The Engineering Mindset.** (HTTP, Flask)
      * **ICE 1:** Repo setup, branching standards, "Hello World" Flask app.
      * **Lecture 2: Continuous Integration (CI).** (GitHub Actions, YAML)
      * **ICE 2:** Create `main.yml` to run `pytest` on push.
  * **Week 2:**
      * **Lecture 3: Databases & Models.** (SQLAlchemy, Migrations)
      * **ICE 3:** Define `User` and `Joke` models, create initial migration.
      * **Lecture 4: Testing, Linting & Data Formats.** (Pytest, `flake8`, YAML vs. JSON)
      * **ICE 4 (CI Enhancement):** Write unit tests, add "Lint" job to `main.yml`.

-----

#### **Cycle 2: Security, Features & CI Enhancement (Weeks 3-4)**

  * **Week 3:**
      * **Lecture 5: Authentication & User Roles.** (Hashing, Sessions, RBAC)
      * **ICE 5:** Implement user registration and login (on a `feature/user-auth` branch).
      * **Lecture 6: Web Security & Secure CI.** (OWASP Top 10, `bandit`, `pip-audit`)
      * **ICE 6 (CI Enhancement):** Add `bandit` and `pip-audit` jobs to CI workflow.
  * **Week 4:**
      * **Lecture 7: Feature Development & Integration.** (Rating System Logic)
      * **ICE 7:** Implement backend logic for joke rating system.
      * **Lecture 8: Cycle 2 Review & Retrospective.**
      * **ICE 8:** Team "Start, Stop, Continue" retrospective.

-----

#### **Cycle 3: Integration, Operations & Scale (Weeks 5-7)**

  * **Week 5:**
      * **Lecture 9: APIs & Decoupling: The "Contract".** (RESTful API design)
      * **ICE 9:** Build the `GET /api/jokes/count` backend endpoint.
      * **Lecture 10: Introduction to Frontend: "Consuming the Contract".** (React "Why", `fetch`)
      * **ICE 10 (Scaffolded):** Clone canned React template, change `fetch()` URL to connect to their backend.
  * **Week 6:**
      * **Lecture 11: Multi-Service Orchestration with Docker Compose.**
      * **ICE 11 (Upgraded):** Create `docker-compose.yml` to run `backend` + `db` services.
      * **Lecture 12: Continuous Deployment (CD).** (Docker builds, GitHub Container Registry)
      * **ICE 12 (CI/CD Enhancement):** Enhance CI to build and push Docker image to registry.
  * **Week 7:**
      * **Lecture 13: Integrating External Services (GenAI).** (External API calls)
      * **ICE 13:** Add synchronous API call to local GenAI model.
      * **Lecture 14: Course Retrospective & Professional Horizons.**
      * **(No ICE - Final Q\&A and wrap-up)**

-----

## Part 2: Integrated Project & Skill Kits

This section details the essential SE skills that are delivered and evaluated *through* the project deliverables and other asynchronous materials.

### Component 1: GitHub Project Management Kit

  * **Core Objective:** To teach students the value of an integrated toolchain for team productivity, traceability, and documentation.
  * **Delivery Vector:** Phased requirements added to the Cycle 1, 2, and 3 project deliverables.
  * **Evaluation:** Compliance check (i.e., "Did you do it?") via links in the `CONTRIBUTIONS.md` file.

| Cycle | Tool Introduced | The "Problem" It Solves | Deliverable Task & Artifact |
| :--- | :--- | :--- | :--- |
| **Cycle 1** | **GitHub Projects (Kanban)** | "How do we plan our work and see who is doing what?" | **Task:** Create a team project board and add all Cycle 1 tasks. <br> **Artifact:** Link to the project board. |
| **Cycle 2** | **GitHub Issues + PRs** | "How do we track features/bugs and link our code to our plan?" | **Task:** All new work must start as an Issue. PRs must use keywords (e.g., `Closes #12`). <br> **Artifact:** A clean PR history showing links to Issues. |
| **Cycle 3** | **GitHub Wiki** | "How do we document our setup and API *for other developers*?" | **Task:** Move dev setup instructions from `README.md` to a "Developer Setup" Wiki page. Create a new "API Contract" page. <br> **Artifact:** A clean `README.md` and links to the Wiki pages. |

### Component 2: React Deep-Dive Kit (Extra Credit)

  * **Core Objective:** To provide an advanced, optional path for students to learn React implementation *after* they have mastered the core integration task.
  * **Delivery Vector:** Optional Extra Credit module, supported by instructor-provided video guides and documentation links.
  * **Evaluation:** Manual code review of the custom React app and a reflection in the `CONTRIBUTIONS.md`.
  * **Task:**
    1.  Students will replace the "canned" React template from ICE 10.
    2.  They will use `npm create vite@latest` to build a new React app from scratch.
    3.  They must correctly implement `useState` and `useEffect` to fetch and display data from their backend API.
  * **Artifact:** Custom React source code and an "Extra Credit" section in their `CONTRIBUTIONS.md` linking to the commit and explaining *why* `useEffect` was necessary.

### Component 3: Ethical Challenge Prompts

  * **Core Objective:** To ensure students reflect on their responsibilities as engineers and consider the societal impact of their software.
  * **Delivery Vector:** Short-answer reflection questions embedded directly into quizzes and major project cycle deliverables.
  * **Evaluation:** Graded as a short-answer component of the quiz or as part of the "Reflections" section of the deliverable.
  * **Examples:**
      * **Quiz 3:** "Defend or refute: 'If I'm just writing code, I am not responsible for the ethical implications of how it's used.'"
      * **Cycle 2 Deliverable:** "Your rating system now *ranks* user-generated content. What is one potential negative consequence of this ranking, and what is one engineering step (not a policy) you could take to mitigate it?"
      * **Cycle 3 Deliverable:** "You have integrated a GenAI model. What is one risk of your app amplifying biases from this model, and how could you *measure* that?"


## Part 3: "The Ministry of Jokes' Narrative Framework"

You are correct. The narrative framework in Part 3 *must* be regenerated to align with the new ICE sequence in Part 1.

Here is the reworked "Ministry of Jokes" narrative framework, with each scenario now correctly mapped to the new technical goals from Part 1 of your 7-week plan.

---
## Part 3: The "Ministry of Jokes" Narrative Framework (v2)

| ICE # | Technical Topic (from Plan) | Proposed Monty Pythonesque Scenario (The "Why") |
| :--- | :--- | :--- |
| **ICE 1** | Repo Setup, Branching, "Hello World" Flask | **"Founding the Ministry":** The Ministry of Jokes is officially chartered! Your team must requisition a new repository, establish proper branch protocols (no silly walks!), and hang the official "Hello, World!" shingle on your new Flask office. |
| **ICE 2** | Continuous Integration (CI) with `pytest` | **"The Silliness Detector":** The Ministry's first line of defense is established. You must build the "Silliness Detector" (CI workflow) to automatically test all incoming joke-objects, ensuring they don't break the Ministry's delicate machinery. |
| **ICE 3** | Database Models & Migrations | **"The Official Ledgers":** We need ledgers to track who is telling the jokes and what the jokes are. You must create the official Ministry database schemas for "Users" (Joke-Tellers) and "Jokes", and then perform the initial bureaucratic filing (migration) to create the tables. |
| **ICE 4** | CI Enhancement (Linting & Unit Tests) | **"Upgrading the Detector":** The Silliness Detector isn't silly enough! You must upgrade it to not only run placeholder tests but also to enforce the "Ministry Style Guide" (a linter) and run *actual* unit tests, ensuring all submissions are properly formatted. |
| **ICE 5** | User Registration & Login Endpoints | **"Issuing Joke-Teller Licenses":** The Ministry needs to issue official "Joke-Teller Licenses" (user accounts). Your task is to build the front desk (registration endpoint) where tellers can apply for a license and the security checkpoint (login endpoint) where they present their credentials. |
| **ICE 6** | Security (Password Hashing & JWTs) | **"Forging Unforgeable Licenses":** Un-licensed joke-tellers are trying to sneak in! You must secure the Ministry by replacing paper licenses with unforgeable, encoded "Permits to Jest" (JWTs) and storing all credentials in a "Book of Unintelligible Scribbles" (hashed passwords). |
| **ICE 7** | API Endpoints (POST/GET Jokes) | **"Opening the Chutes":** The Ministry is now open for business. You must build the "Joke Submission" chute (POST endpoint) for tellers to send in new material and the "Joke Viewing" portal (GET endpoint) for authorized members to retrieve them. |
| **ICE 8** | CI Enhancement (API Tests & Coverage) | **"Certifying the Chutes":** The Silliness Detector must inspect the new chutes, not just the code! You must upgrade the CI pipeline to run tests directly against the new API endpoints and file a "Joke Coverage Report" (code coverage) to prove every pipe has been inspected. |
| **ICE 9** | APIs & Decoupling (New Endpoint) | **"The Great Joke-O-Meter":** The Ministry wishes to display its productivity to the public with a giant "Jokes Processed" counter. You must create a new, simple, public-facing endpoint (`/api/jokes/count`) that provides this statistic without requiring any authentication. |
| **ICE 10**| Intro to Frontend (React `fetch`, CORS) | **"Connecting the Display Terminal":** A new "Joke Display Terminal" (the provided React app) has been delivered, but security gates (CORS) are blocking it from talking to your API! Your job is to configure the API to recognize the terminal as a "Trusted Ministry Device." |
| **ICE 11**| `docker-compose.yml` | **"The Ministry-in-a-Box Kit":** The Ministry must be deployable! You must write the `Dockerfile` for the app and the `docker-compose.yml` "Assembly Manual" to bundle the "Portable Joke Booth" (Flask app) and its "Filing Cabinet" (Postgres DB) into a single, shippable kit. |
| **ICE 12**| Continuous Deployment (CD) | **"The Automatic Proclamation System":** The Ministry is tired of manually publishing its new jokes. You must build an "Automatic Proclamation System" (Continuous Deployment) by enhancing your CI pipeline to automatically deploy the "Ministry-in-a-Box" to the cloud. |
| **ICE 13**| GenAI Integration | **"Hiring a Critic-in-a-Box":** The Ministry has hired a "Critic-in-a-Box" (a GenAI model) to automatically rate all new jokes. Your task is to wire up this AI to the joke submission chute, so every new joke receives an official, and likely absurd, "funniness" score. |
| **ICE 14**| (No ICE) Final Q&A | **"The Ministry is on Holiday":** (No ICE) The bureaucracy has triumphed, and all systems are go! The Ministry has declared a holiday for "Final Project Q&A and Tidy-Up," giving all joke-tellers a much-deserved rest. |