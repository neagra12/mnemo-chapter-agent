Here is the updated `MoJ_Project_description.md` file with all requested changes. This new version is fully synchronized with our **Complete 7-Week Course Plan (v7)**.

---
Project Description: The Joke App
## 1. Project Overview & Concept

This is the primary project for the final seven weeks of the course. Teams will build a complete, multi-component web application in three two-week cycles, simulating a real-world development process from a minimum viable product (MVP) to a more mature, feature-rich application.

The application's concept is based on the "Need a penny, take a penny. Have a penny, leave a penny" idea, but for jokes. The core business logic is simple: a user must first contribute a joke to the community before they are allowed to view jokes submitted by others. This creates a small, self-sustaining content economy within the application.

## 2. Learning Objectives

Upon successful completion of this project, students will be able to:

* Design, build, and test a database-driven web application using Flask and SQLAlchemy.
* Implement security best practices, including user authentication, Role-Based Access Control (RBAC), and defenses against common OWASP vulnerabilities.
* Decouple a web application into a backend API and a frontend client using React.
* Containerize a multi-service application (application, database) for consistent development and deployment using Docker Compose.
* Create and manage an automated Continuous Integration / Continuous Deployment (CI/CD) pipeline using GitHub Actions to run tests, perform security scans, and publish Docker images.
* Integrate with an external service (a locally-run GenAI model) via an API call.
* Work effectively in an agile team using professional tools and workflows, including Git, GitHub Issues, GitHub Projects (Kanban), and a mandatory Pull Request review process.

## 3. Technical Stack

* **Backend:** Python, Flask, SQLAlchemy
* **Frontend:** JavaScript, React
* **Database:** PostgreSQL (running in a Docker container)
* **Testing:** Pytest, Bandit, `pip-audit`
* **DevOps:** Git, Docker, Docker Compose, GitHub Actions, GitHub Projects

## 4. Project Cycles

The project is divided into three distinct two-week cycles.

### Cycle 1: Foundations (Weeks 1-2)

The goal of this cycle is to build the core MVP of the Joke App.

**Features & Tasks:**

* Develop a Flask application that allows users to register, log in, submit a joke, and view a list of jokes.
* Implement the core business logic: users who have not submitted a joke cannot view the joke list.
* Use SQLAlchemy to model `User` and `Joke` entities and persist them in a database (SQLite is acceptable for this cycle).
* Develop a comprehensive unit test suite for the application logic and routes using Pytest.
* Configure the team's GitHub repository, including setting up the GitHub Projects (Kanban) board for C1 and establishing branching standards.

**Key Deliverables:**

* A functioning Flask application that meets all feature requirements.
* A complete unit test suite with reasonable code coverage.
* A repository with a clean commit history demonstrating team collaboration.
* A `CONTRIBUTIONS.md` file updated with a summary of team contributions and a link to the Cycle 1 GitHub Project board.

### Cycle 2: Security & Features (Weeks 3-4)

The goal of this cycle is to harden the application and add key features that improve user interaction and administration.

**Features & Tasks:**

* Implement a Role-Based Access Control (RBAC) system with at least two roles: `user` and `administrator`. Administrators should have the ability to manage users and jokes.
* Secure all forms against Cross-Site Request Forgery (CSRF).
* Implement a user-driven joke rating system (e.g., 1-5 stars).
* Conduct security testing using `bandit` and `pip-audit` to identify and remediate common vulnerabilities.
* Write integration tests for the new features.
* All new work must be tracked by creating GitHub Issues and linking them to Pull Requests.

**Key Deliverables:**

* A secure application with functional RBAC and rating systems.
* Reports from security scanning tools and a summary of actions taken.
* An expanded test suite including integration tests.
* A `CONTRIBUTIONS.md` file updated with a summary of team contributions and responses to all cycle-specific reflection prompts.

### Cycle 3: Integration & Operations (Weeks 5-7)

The goal of this cycle is to modernize the application architecture and automate its operational lifecycle.

**Features & Tasks:**

* Refactor the Flask backend to primarily serve a JSON API.
* Create a **GitHub Wiki page** to document the API endpoints.
* Build a separate React single-page application (SPA) for the frontend that consumes the Flask API (a scaffolded template will be provided).
* Containerize the application using Docker. Create a `docker-compose.yml` file to orchestrate the Flask app and a PostgreSQL database service.
* Expand the CI/CD pipeline in GitHub Actions to build and push the application's Docker image to the GitHub Container Registry.
* Integrate a local GenAI model (e.g., via LM Studio or Ollama). The Flask app will make a synchronous API call to the local model to generate a "quality score" for each newly submitted joke.
* Refactor the `README.md` to be a high-level project overview and move all developer setup instructions to a new **GitHub Wiki page**.

**Key Deliverables:**

* A multi-container application managed by Docker Compose.
* A decoupled frontend and backend.
* A CI/CD pipeline that successfully builds and pushes a Docker image.
* Successful integration with the local GenAI service.
* A professional `README.md` and a complete GitHub Wiki for developer documentation.
* A `CONTRIBUTIONS.md` file updated with a summary of team contributions and responses to all cycle-specific reflection prompts.

## 5. Team & Process Requirements

* **Project Management:** Teams **must** use GitHub Projects to manage their work in a Kanban-style board for each cycle. All work must be represented as a card (Issue).
* **Version Control:** All work will be done in a shared GitHub repository.
* **Mandatory Pull Request Workflow:**
    1.  All new features or bug fixes **must** be filed as a **GitHub Issue** first.
    2.  All work **must** be done on a feature branch (e.g., `feature/user-auth`) created from that Issue.
    3.  All work **must** be submitted to the `main` branch via a **Pull Request (PR)**. The PR description must use a keyword (e.g., `Closes #12`) to link to the corresponding Issue.
    4.  The PR author **cannot** merge their own pull request.
    5.  A PR **must** be reviewed and approved by **at least two other team members** before it can be merged.
* **Contributions:** To ensure individual accountability, each team member is expected to have a meaningful contribution history for each cycle. Teams will document the division of labor in a `CONTRIBUTIONS.md` file.

## 6. Submission & Grading

* **Submissions:** Each cycle's deliverable will be submitted by creating a GitHub Release in the team's repository.
* **Grading:** The course operates on a "B for good work, A for good work on time" model. Late submissions are accepted but capped at an 85%. Extensions must be requested before the deadline.

## 7. Extra Credit Opportunities

Teams who complete the core requirements and wish to go further may implement one or more of the following for extra credit:

* **Build the React Frontend from Scratch:** Replace the provided "canned" React template (from ICE 10) with your own, self-built frontend application. You must use `npm create vite@latest` to bootstrap the app and correctly implement `useState` and `useEffect` hooks to fetch data.
* **Asynchronous GenAI Call:** Refactor the synchronous GenAI call to be asynchronous using a message queue (e.g., Redis) and a separate worker process.
* **Formal API Documentation:** Create formal API documentation using the OpenAPI/Swagger specification.
* **Enforce Branch Protection:** Enforce all rules from Section 5 (PR reviews, CI checks) using GitHub's branch protection rules.