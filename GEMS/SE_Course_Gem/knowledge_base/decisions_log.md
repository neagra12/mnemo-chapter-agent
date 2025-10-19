# Decision Log for FA25 SE 1 final 7 weeks

--- 

---

## 2025-10-19 @ 12:30 EDT - Highlighting Ethical/Profiling Implications of HTTP Headers

**Scope:** Lecture 9 (HTTP Protocol) / General API Design Principles

**Description:**
To connect the foundational discussion of HTTP protocol headers to modern **Software Engineering Ethics** and **API Design**, a new speaker note was added.

The instruction shifts the student's focus from merely "What data is transported?" to "What user profile can be inferred from this data?"

* **Header Used for Illustration:** `Accept-Language` (`es-MX`, `en-GB`, etc.).
* **Engineering Insight:** The discussion now emphasizes that application-specific headers act as an **infrastructure-level side channel** that precedes application logic.
* **Ethical/Design Implication:** This low-level data can be logged, aggregated, and combined with other metrics (`User-Agent`, IP address) to create a specific **client fingerprint**. This fingerprint enables:
    1.  **Price Discrimination** (e.g., serving different pricing tiers based on a user's inferred nation of origin).
    2.  **Content Discrimination/Filtering** (e.g., controlling access to content or creating opaque information bubbles based on presumed nationality).

**Result:** The HTTP lecture now includes a crucial ethical component on the **responsibility of the engineer** regarding data collection, logging, and minimizing profiling vectors, bridging the gap between networking fundamentals and contemporary application design concerns.

**Reference:** [Link to updated lecture slide notes or commit containing new talking points]

---

## 2025-10-19 @ 00:45 EDT - Finalizing Module 2: The "Docker-for-Database" Strategy

**Scope:** `Lecture 3`, `ICE 3`, and the overall viability of Module 2 (Week 10).

**Description:**
Upon a critical review of the planned `ICE 3` (Database & Migrations), I identified a fatal flaw: the ICE "magically assumed" every student would have a native PostgreSQL server installed, configured, and running locally. This unstated prerequisite would have introduced massive cognitive friction, platform-specific bugs, and made the 40-minute time limit impossible.

**Insight (The "Aha!" Moment):**
The user proposed a far superior solution: **use a pre-configured Docker container from DockerHub.**

This insight is pedagogically and technically brilliant for three reasons:
1.  **De-risking:** It completely eliminates the "setup hell" of native installation, which was the module's single greatest weakness.
2.  **Consistency:** It provides a single, OS-agnostic `docker run` command, which allows us to define a **universal `sqlalchemy.url`** (connection string) that is *identical* for every student.
3.  **Scaffolding:** It leverages students' existing familiarity with Docker (from `Angband`) and perfectly "primes" them for the upcoming orchestration module (Week 14), where they will simply codify this *exact same setup* in a `docker-compose.yml` file.

**Decision(s):**
1.  We will **not** create a `step-by-step-postgres-setup-guide.md` homework. It is no longer necessary.
2.  **Lecture 3 (`Lecture 3.md`) will be modified** to include two new slides:
    * **"Slide 9: Activating the 'Filing Cabinet' (with Docker)":** This slide will provide the exact `docker run ... postgres:16` command, setting the standard `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` environment variables.
    * **"Slide 10: The Universal Connection String":** This slide will show the resulting `sqlalchemy.url` and explicitly tell students to copy it into their `alembic.ini` file during ICE 3.
3.  **ICE 3 (`AI_ICE3.md`) is now finalized** with this Docker container as a hard prerequisite. This makes the 40-minute timing realistic, as it correctly focuses the in-class work on the *Alembic workflow*, not on database administration.

**Impact:**
The Module 2 plan is now exceptionally robust, and its primary weakness has been resolved. The pedagogical narrative is stronger, and the risk of in-class failure for ICE 3 has been dramatically reduced. The module rating is upgraded to **9.8/10**.

---

## 2025-10-18 @ 23:30 EDT - Finalizing Week 9 Module & Key Pedagogical Patterns

**Scope:** `Lecture 2`, `ICE 2`, Week 9 Quiz, and future module workflow.

**Description:**
This log entry finalizes the complete Week 9 module and establishes several key pedagogical patterns that will be used for the rest of the course.

1.  **Module 1 (Week 9) is Complete:** The module is now locked and consists of:
    * `lecture1.md` (Flask/HTTP) & `AI_ICE1.md` (Repo/Team Sync)
    * `step-by-step-runner-guide.md` (Homework)
    * `Lecture 2.md` (CI/YAML)
    * `ICE 2 (v3).md` (CI Pipeline Pass/Fail)
    * `week9_quiz.md` (Individual Knowledge Check)

2.  **Decision: ICE 2 Finalized with "Red Build" Simulation:** `ICE 2` has been iterated to `v3` and is now final. The key change is the addition of a **mandatory "red build" simulation**.
    * **Objective:** The learning objective is no longer just "get a green checkmark." The new, more critical objective is for students to see *both* a "pass" and a "fail," and to learn the essential skill of **reading a failing build log** in a safe, scaffolded environment.
    * **Role Update:** The "Mission Control 🚀" role kit is now used, and the `Mission Control` role is responsible for pushing the failing test (`assert False`), making them an active participant.

3.  **Decision: `CONTRIBUTIONS.md` Reflection is Now an Open-Ended Question:** The `Reflection:` prompt in the `ICE Template` is now a mandatory, **open-ended question**.
    * **Goal:** This turns the `CONTRIBUTIONS.md` file into a true evidence-gathering tool.
    * **Content:** The question will be tailored to the ICE to probe either **engineering process** (e.g., "What is your team's process for handling a red build?") or **ethical impact** (e.g., "What is a potential bias of this feature?").

4.  **Decision: Week 9 Quiz Added:** A 10-question quiz has been created to provide *individual, quantitative evidence* of student comprehension. This directly addresses the prior `decisions_log.md` entry ("I am interested in making up those quiz scores...").

5.  **Decision: New Workflow - References First:** We will now generate the **Canonical Reference Guide at the *start* of each new module**. This allows us to "sprinkle" authoritative links (MDN, Python docs, etc.) throughout the module's lectures and ICEs, reducing cognitive friction for students.
---
## 2025-10-18 @ 22:27 EDT - Finalizing the "Greenfield" Bootstrap Strategy (ICE 1)

**Scope:** `ICE 1`, all `MoJ` project teams, and all TAs.

**Description:**
This decision finalizes the structure of `ICE 1` to mitigate the high cognitive load and time risk of a pure "from scratch" exercise. The original plan risked in-class failure due to environment setup issues (SSH, `venv`, Python paths).

The new, de-risked strategy involves three key changes:

1.  **Provide Starter Files:** We will provide a `moj-starter-files.zip` package. This package bootstraps the project with all standard process files (`LICENSE`, `DOCUMENTATION_POLICY.md`, `CONTRIBUTIONS.md`), a correct `requirements.txt` (with `pytest`), and the `tests/test_placeholder.py` file. This shifts the `Dev Crew`'s task from *creating* these files to *using* them.
2.  **Refocus In-Class Goal to "Team Sync":** The primary in-class objective is **no longer PR submission**. The new goal is "Team Sync": ensuring every team member can successfully `git clone`, `git pull`, `git push`, and locally run `flask run` and `pytest`. This forces all environment/SSH blockers to be resolved in class with TA support.
3.  **Move PR to Midnight:** The final deliverable (the "perfect" PR) is now due at midnight, removing the in-class time pressure.
4.  **Add Project Board Task:** The `Repo Admin` role is now also responsible for creating the team's GitHub Project (Kanban) board, integrating project management from Day 1.

This new structure (documented in the `TA_Guide_ICE1.md`) better aligns with the course goal of simulating a real-world engineering experience, where setup is a collaborative task focused on unblocking the team.

**Reference:** `ICE 1: Project Bootstrap, Kanban & Team Sync`, `TA_Guide_ICE1.md`

---
## 2025-10-18 @ 21:56 EDT - Standardized Repository Naming Convention

**Scope:** All student `ministry-of-jokes` project repositories.

**Description:**
To ensure consistency, reduce administrative overhead, and make grading and TA coaching more efficient, all team project repositories must follow a standardized naming convention.

The official format is: **`FA25-P465-TeamXX-moj`**

* `FA25-P465`: Identifies the course and semester.
* `TeamXX`: Identifies the team (e.g., `Team01`, `Team02`).
* `moj`: Identifies the "Ministry of Jokes" project.

This decision is implemented in **`ICE 1: Project Bootstrap & Team Sync`**, where the `Repo Admin` is explicitly tasked with creating the repository using this name.

**Reference:** `ICE 1` documentation.

---
## 2025-10-18 @ 21:11 EDT - Standardized "World-Class" ICE Template

**Scope:** All In-Class Exercises (ICEs) for the "Ministry of Jokes" project.

**Description:**
This decision finalizes a new, standardized template for all future ICEs. The goal is to create a "pedagogical operating system" that maximizes student engagement, manages cognitive load, and simulates a professional Agile micro-sprint in every class.

* **Standardized Structure:** All ICEs will follow a consistent, multi-part structure (Objective, Roles, Tasks, Contributions, DoD, Submission).
* **Mandatory "Closing Ritual":** The final three sections (`CONTRIBUTIONS.md`, `Definition of Done`, `Submission`) are now mandatory and standardized. This provides a predictable "closing ritual" for every workshop, reducing student anxiety and clarifying expectations.
* **"Role Kit" System:** To balance structure with flexibility, we will use a "Role Kit" system. Each ICE will select a "kit" of 3 roles appropriate for the task (e.g., `Build Kit`, `Debug Kit`, `Design Kit`), while always maintaining the 3-role parallel processing model.
* **Forced Role Rotation:** A new policy is established: **"A student cannot hold the same role for more than two weeks."** This rule, enforced via the `CONTRIBUTIONS.md` log, is the core mechanism to prevent role typecasting and ensure all students get hands-on practice with all aspects of the workflow (repo management, project management, and development).

**Reference:** This decision supersedes the simple `In-Class Exercise (ICE) Template` from the initial persona instructions.

---

## 2025-10-18 @ 19:40 EDT - Implemented "Ministry of Jokes" Theme & Fixed Runner Guide

**Scope:** `general_plan_for_final_7_weeks.md`, `step-by-step-runner-guide.md`, all Lecture Slides, all ICEs.

**Description:**
This set of changes integrates a course-wide creative narrative and corrects a critical technical inconsistency in the self-hosted runner setup.

* **Technical Fix (Runner Guide):** Identified a contradiction in `step-by-step-runner-guide.md`. The guide's *instructions* were for a **host runner** (using `./run.sh`), but its *pre-flight checklist* incorrectly required **Docker** to be running. This would lead to student failure, as the Lecture 2 workflow depends on the host's Python 3.10, not Docker.
* **Correction:** The `step-by-step-runner-guide.md` checklist and diagnostics table have been corrected to remove all references to Docker and replace them with a check for a valid **Python 3.10** installation on the host machine, including helper links for installation.
* **Creative Theme Integration:** To improve student engagement, a **"Monty Python - Ministry of Jokes"** narrative framework has been adopted. This theme will be applied to all 14 In-Class Exercises (ICEs).
* **Plan Update:** The 14-point narrative framework has been appended as **Part 3** to the `general_plan_for_final_7_weeks.md` file, making it the single source of truth for the course's creative layer.
* **Starter Kit Update:** Confirmed that the `moj-starter-kit` repository will include a `tests/test_placeholder.py` and `requirements.txt` (with `pytest`) to properly scaffold ICE 2.

**Result:**
All technical guides and course plans are now consistent. All future ICEs and their corresponding lecture slides (the "Next: ICE" slide) will be generated using this new "Ministry of Jokes" theme, starting with the regeneration of ICE 1 ("Founding the Ministry").

---
## 2025-10-18 @ 09:17 EDT - Adopt CI Job for SPDX License Enforcement

**Scope:** `Project_Starter_Kit/` (`DOCUMENTATION_POLICY.md`, `app.py`), Lecture 2 Plan (`main.yml`)

**Description:**
Following the decision to adopt the REUSE/SPDX standard for per-file licensing, we needed an enforcement mechanism. We considered IDE plugins and local pre-commit hooks.

We have decided to enforce this standard by **adding a dedicated "Compliance" job to the CI/CD pipeline** (GitHub Actions).

This method was chosen for three key pedagogical reasons:
1.  **Thematic Alignment:** It integrates perfectly with the Lecture 2 / ICE 2 topic of Continuous Integration.
2.  **Enforceability:** It is the only method the instructional team can reliably enforce, as it blocks non-compliant PRs at the source.
3.  **SE Experience:** It provides a real-world example of using CI automation to enforce team-wide *policy and compliance*, not just to run unit tests.

**Result:**
The `Project_Starter_Kit/app.py` file has been updated with the compliant SPDX header. The `Project_Starter_Kit/DOCUMENTATION_POLICY.md` has also been updated with a new "Licensing and Copyright Standard" section that codifies this rule and its CI-based enforcement. The plan for ICE 2 will now include adding this compliance job to the CI workflow.

---
## 2025-10-18 @ 12:10AM EDT - Restructured Plan (v7) to Integrate Deliverable-Driven Skills

**Scope:** SE\_Course\_Gem (Knowledge Base: `general_plan_for_final_7_weeks.md`)

**Description:**
This change restructures the `general_plan_for_final_7_weeks.md` into a new, unified format (v7). This was done to formally plan for crucial learning objectives that are delivered **asynchronously via project deliverables** rather than in-class lectures.

The plan is now split into two main sections:
* **Part 1: The Lecture & ICE Sequence:** This is the existing 14-lecture sequence (unchanged).
* **Part 2: Integrated Project & Skill Kits:** This new section details the scaffolded, deliverable-driven skills.

This new "Part 2" explicitly defines and plans for three key components:
1.  **GitHub Project Management Kit:** A new, 3-cycle plan to introduce GitHub Projects (Kanban), Issues/PRs, and the Wiki, with specific tasks tied to each project deliverable.
2.  **React Deep-Dive Kit (Extra Credit):** Formalizes the extra credit path (our solution for the L10 "cognitive cliff") for students to build a React app from scratch.
3.  **Ethical Challenge Prompts:** Defines the delivery vector for these questions (quizzes and deliverables).

**Result:** This new structure provides a complete, holistic view of all learning vectors (synchronous and asynchronous) and their specific evaluation methods, creating a single, unified "master plan."

---

## 2025-10-17 @ 20:06 EDT - Finalized SE 7-Week Plan (v5) - Streamlined Prerequisite Content

**Scope:** SE_Course_Gem (Knowledge Base: `7_Week_Plan.md`)

**Description:**
This change finalizes the 7-week plan to optimize the timeline and remove content that is already covered as a prerequisite for the course.

* **Removed Redundant Git Workflow:** Removed the "Git Workflow & Feature Development" lecture (old L7) and the corresponding "managed merge conflict" ICE (old ICE 7). This topic is covered in other courses, and its removal frees up a full lecture for more advanced feature integration.
* **Substituted Redundant Historical Hook:** Replaced the "Historical Hook" for Lecture 11 (Containerization) from "history of VMs" to the "It Works on My Machine" problem, as the former was also prerequisite knowledge.
* **Result:** The plan is now leaner and more focused, with all lecture slots dedicated to new, project-critical content.

**Reference:** [Link to the commit where this plan is saved]

---

## Changes to the team interviews
1. Interviews will be renamed to reviews.
2. Reviews can be online
3. The mid-term and final team interviews have been dropped. A team presentation outside of class will effectively replace the final interview. 
Reviews will be conducted every two weeks and is up to the team and the team TA to schedule the meeting. 

## Reduced number of quizzes first half of course
I failed to deliver two additional quizzes I intended to deliver in the first 8 weeks of the course. I am interested in making up those quiz scores in the latter half of the class.

