Here is the project description for the "Master of Jokes" app, incorporating all the changes and qualifications we have discussed. This document is structured to be a comprehensive and clear resource for your Gem's knowledge base.

***

## Project Description: The Joke App

### ## 1. Project Overview & Concept

This is the primary project for the final seven weeks of the course. Teams will build a complete, multi-component web application in three two-week cycles, simulating a real-world development process from a minimum viable product (MVP) to a more mature, feature-rich application.

The application's concept is based on the "Need a penny, take a penny. Have a penny, leave a penny" idea, but for jokes. The core business logic is simple: **a user must first contribute a joke to the community before they are allowed to view jokes submitted by others.** This creates a small, self-sustaining content economy within the application.

### ## 2. Learning Objectives

Upon successful completion of this project, students will be able to:

* Design, build, and test a database-driven web application using **Flask** and **SQLAlchemy**.
* Implement security best practices, including user authentication, **Role-Based Access Control (RBAC)**, and defenses against common **OWASP** vulnerabilities.
* Decouple a web application into a backend API and a frontend client using **React**.
* Containerize a multi-service application (application, database) for consistent development and deployment using **Docker Compose**.
* Create and manage an automated **Continuous Integration (CI)** pipeline using **GitHub Actions** to run tests.
* Integrate with an external service (a locally-run GenAI model) via an API call.
* Work effectively in an agile team using professional tools and workflows, including **Git**, pull requests, and project boards.

### ## 3. Technical Stack

* **Backend:** Python, Flask, SQLAlchemy
* **Frontend:** JavaScript, React
* **Database:** PostgreSQL (running in a Docker container)
* **Testing:** Pytest, Bandit
* **DevOps:** Git, Docker, Docker Compose, GitHub Actions

### ## 4. Project Cycles

The project is divided into three distinct two-week cycles.

#### **Cycle 1: Foundations (Weeks 1-2)**
The goal of this cycle is to build the core MVP of the Joke App.

* **Features & Tasks:**
    * Develop a Flask application that allows users to register, log in, submit a joke, and view a list of jokes.
    * Implement the core business logic: users who have not submitted a joke cannot view the joke list.
    * Use SQLAlchemy to model `User` and `Joke` entities and persist them in a database (SQLite is acceptable for this cycle).
    * Develop a comprehensive **unit test** suite for the application logic and routes using Pytest.
* **Key Deliverables:**
    * A functioning Flask application that meets all feature requirements.
    * A complete unit test suite with reasonable code coverage.
    * A repository with a clean commit history demonstrating team collaboration.

#### **Cycle 2: Security & Features (Weeks 3-4)**
The goal of this cycle is to harden the application and add key features that improve user interaction and administration.

* **Features & Tasks:**
    * Implement a **Role-Based Access Control (RBAC)** system with at least two roles: `user` and `administrator`. Administrators should have the ability to manage users and jokes.
    * Secure all forms against **Cross-Site Request Forgery (CSRF)**.
    * Implement a user-driven **joke rating system** (e.g., 1-5 stars).
    * Conduct security testing using tools like **`bandit`** and **`pip-audit`** to identify and remediate common vulnerabilities.
    * Write **integration tests** for the new features.
* **Key Deliverables:**
    * A secure application with functional RBAC and rating systems.
    * Reports from security scanning tools and a summary of actions taken.
    * An expanded test suite including integration tests.

#### **Cycle 3: Integration & Operations (Weeks 5-7)**
The goal of this cycle is to modernize the application architecture and automate its operational lifecycle.

* **Features & Tasks:**
    * Refactor the Flask backend to primarily serve a **JSON API**. Create a simple `API.md` file to document the endpoints.
    * Build a separate **React** single-page application (SPA) for the frontend that consumes the Flask API.
    * Containerize the application using **Docker**. Create a **`docker-compose.yml`** file to orchestrate the Flask app and a **PostgreSQL** database service.
    * Implement a basic **CI pipeline** using GitHub Actions that automatically runs the test suite on every push.
    * Integrate a **local GenAI model** (e.g., via LM Studio or Ollama). The Flask app will make a **synchronous** API call to the local model to generate a "quality score" for each newly submitted joke. *The resulting slow user experience is an expected outcome and will be used as a teaching point.*
    * Implement a basic logging strategy where all services log to `stdout` to be viewed with `docker-compose logs`.
* **Key Deliverables:**
    * A multi-container application managed by Docker Compose.
    * A decoupled frontend and backend.
    * A functioning CI pipeline in GitHub Actions.
    * Successful integration with the local GenAI service.

### ## 5. Team & Process Requirements

* **Project Management:** Teams must use **GitHub Projects** to manage their work in a Kanban-style board for each cycle.
* **Version Control:** All work will be done in a shared GitHub repository. A pull request workflow is strongly encouraged but not mandatory.
* **Contributions:** To ensure individual accountability, each team member is expected to have a meaningful contribution history for each cycle. Teams will document the division of labor in a `CONTRIBUTIONS.md` file.

### ## 6. Submission & Grading

* **Submissions:** Each cycle's deliverable will be submitted by creating a **GitHub Release** in the team's repository.
* **Grading:** The course operates on a "B for good work, A for good work on time" model. Late submissions are accepted but capped at an 85%. Extensions must be requested before the deadline.

### ## 7. Extra Credit Opportunities

Teams who complete the core requirements and wish to go further may implement one or more of the following for extra credit:
* Refactor the synchronous GenAI call to be **asynchronous** using a message queue (e.g., Redis) and a worker process.
* Create formal API documentation using the **OpenAPI/Swagger** specification.
* Enforce **mandatory code reviews** for all pull requests using GitHub's branch protection rules.
* Expand the CI/CD pipeline to build and push Docker images to a container registry.