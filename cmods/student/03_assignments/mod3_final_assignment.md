You're asking for the final capstone assignment, which is a synthesis of the entire course. Since A17 was the final feature integration, this last assignment, **A18**, focuses on **documentation and architectural justification**.

-----

# Homework 13: The Greenfield Development Capstone (A18) 🚀

  * **Module:** Final Synthesis
  * **Assignment:** 13 (A18)
  * **Topic:** Architectural Synthesis, Documentation, and Final Submission
  * **Points:** 20 (Course Capstone)
  * **Due Date:** Final Exam Period
  * **Type:** Team Final Submission

## The "Why": Articulating Value

The core deliverable of an engineer is not just working code, but code that is *understood* and *maintainable*. This assignment requires your team to document the architectural choices, security decisions, and development journey of your application from its "Hello World" beginning to its containerized, API-first end.

## Final Submission Workflow

1.  **Final Merge:** The `Repo Admin` merges the successful `hw12-full-stack` (A17) into a new, clean branch named **`final-submission-A18`**. This is the only branch the TA will grade.
2.  **Documentation:** The team works collaboratively to produce the **Final Report** (`REPORT.md`).
3.  **Submission:** Only the final pushed report and code on the `final-submission-A18` branch are required.

-----

## Core Task 1: The Final Code Submission (5 Points)

Ensure your code is clean and fully functional on the `final-submission-A18` branch.

1.  **Verification:** A TA must be able to run a single command:
    ```bash
    $ docker-compose up --build
    ```
    ...and see all services launch (web, db, ai, frontend) with no errors, including the automatic database upgrade (A15).
2.  **Cleanup:** Remove all redundant test files or temporary configuration variables.
3.  **Dependencies:** Verify `requirements.txt` only contains necessary, stable dependencies.

## Core Task 2: The Final Architectural Report (15 Points)

The **Final Report** (`REPORT.md`) must be a professional document that includes the following sections:

### Section A: Architectural Blueprint (5 Points)

1.  **Diagram:** Include a simple, clean **system diagram** showing the full 5-layer stack developed in Lecture 14 (Postgres, Flask/SQLAlchemy, AI Service, React Frontend). Use visual arrows to show the direction of communication (e.g., React $\rightarrow$ Flask $\rightarrow$ Postgres).
2.  **Component Definition:** Briefly describe the role of each service (`web`, `db`, `ai-service`, `frontend`) and how they communicate (HTTP vs. Database connection).

### Section B: Security and Auditing Narrative (5 Points)

1.  **Authentication:** Justify your choice of Flask-Login and describe the authentication flow (including hashing).
2.  **Authorization (RBAC):** Provide a code snippet of your **Role-Based Access Control (RBAC) decorator** and explain exactly how it protects an Admin-only route.
3.  **Logging:** Explain where your audit logs are stored (standard output/Docker logs) and provide an example log line demonstrating the **who**, **what**, and **when** of a user action (e.g., User 1 creating a joke).

### Section C: Engineering Pragmatism Review (5 Points)

1.  **12-Factor Justification:** Select **three (3)** of the 12-Factor App rules and explain how your application adheres to them (or pragmatically violates them, linking back to your A13 analysis).
      * *Example:* Justify the use of environment variables for `SECRET_KEY` (Config).
2.  **Decoupling:** Explain the engineering benefit of the final **API-First** architecture (Lec 13/A17) compared to a traditional monolithic architecture. What future feature would this design make easier to implement (e.g., a mobile app)?

-----

## Rubric (For TA Use)

| Criteria | Points |
| :--- | :--- |
| **Task 1: Code Submission** | / 5 |
| Code is on the correct branch and runs flawlessly with one command (`docker-compose up --build`). All A11-A17 features are present and working. |
| **Task 2A: Architectural Blueprint** | / 5 |
| System diagram is present and accurate, depicting all 4 services and the 5-layer stack. Component responsibilities are clearly defined. |
| **Task 2B: Security & Auditing Narrative** | / 5 |
| Clear explanation of RBAC decorator, security flow, and a concrete example of a multi-part audit log (who/what/when). |
| **Task 2C: Engineering Pragmatism Review** | / 5 |
| Strong justification for three 12-Factor principles. Articulates the benefits of the decoupled architecture and identifies a new feature it enables. |
| **Total** | **/** 20 |