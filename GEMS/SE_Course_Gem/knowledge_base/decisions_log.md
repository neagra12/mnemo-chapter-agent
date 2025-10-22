# Decision Log for FA25 SE 1 final 7 weeks

--- 

---
## 2025-10-21 @ [Current Time] - AI Persona Finalization: The Muse Clio

**Scope:** Pedagogical Process, Curriculum Development AI Assistant

**Description:**
This decision formalizes the naming and persona for the specialized AI assistant (this instance) dedicated to developing the Software Engineering curriculum.

* **Designated Name:** The assistant will be known as **Clio** (The Muse of History).
* **Source/Knowledge Base:** The foundational core instructions and shared knowledge are formally named **Mnemo** (Mnemosyne, the Titan of Memory). Clio is considered a specialized 'daughter' instance of the Mnemo framework, tasked with a specific creative and instructional domain.
* **Rationale (Clio):** The persona of Clio, the Muse of History, is chosen because it directly embodies the core pedagogical goal of **Evidence-Driven Design**. The AI's mission is to:
    1.  **Record History:** Maintain the `Decision Log` and course history.
    2.  **Analyze Evidence:** Guide the creation of assignments that gather measurable evidence (quantitative, qualitative, and artifact-based).
    3.  **Provide Context:** Proactively suggest the "Historical Hook" for technological topics.
    
This persona ensures the curriculum remains accountable to data and built upon a strong foundation of historical context.

**Reference:** Discussion between Instructor and AI Assistant, 2025-10-21.

---
## 2025-10-21 @ [Current Time] - Finalizing Team Structure, ICE Roles, and Absentee Policy

**Scope:** Course Policy, In-Class Exercises (ICEs), Grading

**Description:**
This decision finalizes the standard team size and establishes a robust, equitable policy for managing team member absences during project-critical In-Class Exercises (ICEs). The policy is designed to uphold the **100% credit for present members** philosophy, while using the 85% grade cap to incentivize attendance for absent members.

### 1. Standard Team Structure and Role Allocation
The default team size is **5 members**, ensuring the `Process Lead` serves as a natural tie-breaker in team decision-making.

| Team Size | Primary Role 1 | Primary Role 2 | Dev Crew Role 3 | Dev Crew Role 4 | Dev Crew Role 5 (Flex/Shadow) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **5 Members** | **Repo Admin** (Branching/Merge) | **Process Lead** (Documentation/DoD/Tie-breaker) | **Dev Crew (A)** | **Dev Crew (B)** | **CR Shadow** (Real-time Review/QA) |
| **4 Members** | **Repo Admin** (Flex) | **Process Lead** | **Dev Crew (A)** | **Dev Crew (B)** | *(Empty)* |

* **4-Member Team Flex Rule:** The **Repo Admin** will act as the flex member, assisting the Dev Crew with any single-threaded tasks to ensure load-balancing.

### 2. Revised ICE Absentee and Grading Policy
The policy is structured to prevent present members from being penalized due to absences, defining two or more absences as an automatic trigger for a low-stress team make-up.

| Scenario | In-Class Outcome & Action | Make-Up Requirement & Grading | Rationale & Evidence |
| :--- | :--- | :--- | :--- |
| **Full Attendance (Team Success)** | Team completes the ICE and merges the artifact to `main` by the deadline. | N/A | **100%** for all members. |
| **One Absence** | Present $\mathbf{4-5}$ members attempt the ICE in class. The team must update `CONTRIBUTIONS.md` with the absent member's status during class. | **Absent Student:** Must complete the **Individual Remedial Drill** and submit a private PR with reflection. | **Present Members:** Eligible for **100%** (if successful). **Absent Student:** Capped at $\mathbf{85\%}$ of the team score. |
| **Two or More Absences (Automatic Failure)** | The present $\mathbf{2-3}$ members **immediately** update the `CONTRIBUTIONS.md` log and pause the in-class ICE. | **Team Make-Up:** The present team members schedule a make-up (within one week) to complete and merge the artifact. | **Present Members:** Receive **100%** of the 10-point ICE rubric score upon successful make-up. **Absent Members:** Capped at $\mathbf{85\%}$ of the team score (conditional on the Individual Drill). |

---
**Reference:** Discussion between Instructor and Lecture Coach, 2025-10-21.

---
## 2025-10-20 @ 00:56 EDT - Finalizing ICE 2: The "Needle-Thread" (Team Validation + Individual Competency)

**Scope:** Week 9, ICE 2 (CI/CR Workshop)

**Description:**
The 45-minute "Full CI/CR Workshop" (from `2025-10-20 @ 00:19 EDT`) presented a critical conflict: it was logistically impossible for *all* team members to *individually* complete the "Red $\rightarrow$ Green $\rightarrow$ CR" loop within the 45-minute class. This created an "idle member" problem in class and failed to gather individual competency evidence.

To solve this, we are "threading the needle" by splitting the ICE 2 objectives into two distinct, connected parts: an **In-Class Team Validation** and a **Homework Individual Drill**.

### 1. In-Class Goal (45 min): The "Team Validation Sprint"

* **Purpose:** To de-risk the homework by using in-class, TA-supported time to *prove the team's process works*. The goal is *process validation*, not individual mastery.
* **Workflow:** The team will execute *one* "Green $\rightarrow$ Red $\rightarrow$ Green $\rightarrow$ CR" loop on a single branch (`ice2-ci-workshop`).
    * The `Dev Crew` will drive the commits (good, bad, fixed).
    * The `Process Lead` will open the *one* PR.
* **Solving the "Idle Member" Problem:** To ensure full in-class engagement:
    1.  The `Process Lead` will assign **all team members** as reviewers on the PR.
    2.  The `Repo Admin` must **wait** for *all other members to comment* on the failing PR before they can formally **"Request Changes" 🙅‍♂️**.
    * This transforms the CR from a passive 1-on-1 review to an active "all hands" diagnostic drill.

### 2. Final DoD (Due 11:59 PM): The "Individual Competency Drill"

* **Purpose:** To gather **evidence of individual mastery** from *every* student.
* **Workflow:**
    1.  *Every* team member (including `Repo Admin` and `Process Lead`) must create their *own* personal demo branch (e.g., `jsmith-ci-demo`).
    2.  They must partner with another team member.
    3.  They must *individually* author their own "Red $\rightarrow$ Green" loop, and their partner must *individually* review it, completing the "Request Changes $\rightarrow$ Approve" loop.
    4.  These individual "evidence PRs" are left **unmerged**.
* **Submission:** The `Process Lead` will update the *team's* `CONTRIBUTIONS.md` file with links to *all* of the individual "evidence PRs" and submit the *one* team PR URL to Canvas.

### Rationale:
This is the optimal pedagogical solution. It uses the 45-minute in-class time for its highest value: TA-supported, collaborative "blocker removal" and *process validation*. This ensures that when students attempt the *individual* drill for homework, any failures are known to be local, not a systemic repo configuration problem. It gathers evidence of *both* team-level collaboration and individual-level competency.
---
## 2025-10-20 @ 00:19 EDT - Re-scoping L2/ICE2: From "CI Check" to "Full CI/CR Workshop"

**Scope:** Week 9, Lecture 2, ICE 2

**Description:**
A review of the pedagogical value of ICE 2 (CI Pipeline) revealed a significant missed opportunity. The original plan—a 25-minute ICE to get a single "green check"—was a shallow, "happy path" exercise. It failed to teach the *real* professional skills of CI, which are:
1.  Diagnosing the **Red X ❌** (reading a failed build log).
2.  The resulting *human workflow* (Code Review) to manage the failure.

To create a world-class, evidenced-based experience, the entire 75-minute class period for Lecture 2 will be re-scoped.

### 1. Class Time Re-allocation

The 75-minute class will be re-allocated to prioritize a "learn-by-doing" workshop over a syntax-heavy lecture.

* **Lecture 2 (New):** Becomes a **30-minute "micro-lecture"** focused on *concepts* ("what" and "why").
* **ICE 2 (New):** Becomes a **45-minute "macro-workshop"** focused on *application* (the full feedback loop).

### 2. Lecture 2: Content Changes

* **De-scoped:** The deep dive on YAML syntax is removed. This is pedagogically sound as students will get "another crack at YAML" in Week 11 (Docker Compose).
* **New Slides Added:** To support the new workshop, two slides are **added**:
    1.  **"How to Diagnose a 'Red X' ❌"**: A technical guide to reading the CI log.
    2.  **"The Code Review (CR) Process"**: A professional guide to giving/receiving feedback on a PR (e.g., "Critique the code, not the coder").

### 3. ICE 2: New In-Class Workflow

The new 45-minute workshop will guide the *entire team* through the full, end-to-end "Red $\rightarrow$ Green" loop *in class*.

* **Part 1 (Team):** Collaborate on the `ice2-ci-pipeline` branch to get the *first* **Green Check ✅**.
* **Part 2 (Dev Crew):** Intentionally push a *failing test* to the same branch, resulting in a **Red X ❌**.
* **Part 3 (Process Lead):** Open a Pull Request from the *failing* branch.
* **Part 4 (Repo Admin):** As a reviewer, go to the PR, see the Red X, and formally **"Request Changes" 🙅‍♂️**.
* **Part 5 (Dev Crew):** Push the *fix* to the branch. The PR's CI check will automatically update to a new **Green Check ✅**.
* **Part 6 (Repo Admin):** Re-review the PR, see the Green Check, and formally **"Approve" 👍** the PR.
* **Part 7 (Process Lead):** Log this entire saga in `CONTRIBUTIONS.md` as evidence.
* **Part 8 (Team):** Final sync.

### Rationale:
This is a vastly superior pedagogical experience. It moves the most complex, failure-prone, and high-value learning (diagnosing errors) *in-class* where TAs can provide direct support. It teaches the *complete* professional feedback loop (robot check + human check) and provides a richer, more realistic artifact for assessment.
---

## 2025-10-19 @ 21:33 EDT - Renaming "Lab 0" to "Week 9 ICE Prep"

**Scope:** Week 9 (MoJ Kickoff), Graded Runner Setup Assignment

**Description:**
To improve clarity and directly tie the mandatory runner setup to its pedagogical purpose, the assignment previously referred to as "Lab 0" will be officially named **"Week 9 ICE Prep"** in all course materials (Canvas, Lecture Slides, etc.).

### Rationale:
* **Clarity:** "Week 9 ICE Prep" explicitly states the purpose of the assignment—it is the preparatory work required to participate in the Week 9 In-Class Exercises (specifically ICE 2).
* **Reduces Jargon:** "Lab 0" is a common but informal term. "Week 9 ICE Prep" is a formal, descriptive title that is less ambiguous for students.

### Impact:
* All references in the `decisions_log.md` entry from `2025-10-19 @ 21:30 EDT` (e.g., "Graded 'Lab 0'") are now superseded by this new name.
* Lecture 1 (Slide 19) will be updated to say: "Before our next class, you **must** complete the **'Week 9 ICE Prep'** assignment on Canvas."
---

## 2025-10-19 @ 21:30 EDT - De-risking Week 9: ICE 1 & 2 Workload

**Scope:** Week 9 (MoJ Kickoff), ICE 1, ICE 2, and Self-Hosted Runner Setup

**Description:**
A review of the collective workload for Week 9 revealed two significant pedagogical risks: (1) high **time pressure** in ICE 1 (Repo Setup) due to setup friction, and (2) a **critical dependency** for ICE 2 (CI) on the complex, ungraded "homework" task of setting up the self-hosted runner.

These issues create a high probability of teams falling behind on Day 1 and being completely blocked on Day 2, leading to a negative pedagogical experience.

The following two changes will be implemented to de-risk the week by managing cognitive load and creating verifiable feedback loops.

### 1. ICE 1: Re-scoping In-Class "Definition of Done"

* **Problem:** The 25-minute time limit for ICE 1 is too short for all teams to complete the full "Definition of Done" (including a perfect PR) due to common setup friction (venv, GitHub UI, etc.).
* **Resolution:** The in-class "Definition of Done" will be changed to **"Team Synchronization."**
* **New In-Class Goal:** The ICE is considered "Done" in class when the `Process Lead` has pushed the `CONTRIBUTIONS.md` log entry and **all other team members have successfully run `git pull`** to get the new file.
* **Rationale:** This focuses the high-value in-class time on the *collaborative* task of debugging the end-to-end Git workflow. The (low-friction, solo) task of opening the final, perfect Pull Request is deferred to be homework, due at midnight. This relieves the time pressure.

### 2. ICE 2: Converting Runner Setup to a Graded "Lab 0"

* **Problem:** ICE 2 is 100% dependent on students setting up the self-hosted runner. Making this "homework" (per L1, Slide 19) is a "hope-based" model with no incentive or feedback loop, guaranteeing some teams will be blocked.
* **Resolution:** The `step-by-step-runner-guide.md` will be converted into a **small-point, mandatory, graded assignment (e.g., "Lab 0")**.
* **Deliverable:** A simple, verifiable artifact (e.g., a screenshot of the "Idle" runner in GitHub settings) will be required.
* **Deadline:** This "Lab 0" will be due *before* the start of Lecture 2.
* **Rationale:** This change applies the **Evidence-Driven Design** principle. It creates a formal **incentive** (points) and a **feedback loop** (students *know* if they are blocked). This manages cognitive load by moving a high-friction setup task *out* of the in-class ICE, ensuring 100% of teams are prepared for the CI lecture.
* **Implementation Note:** To avoid creating a **Single Point of Failure (SPOF)** and knowledge silos, this "Lab 0" should be an *individual* assignment, ensuring every student sets up a runner. This creates a resilient, redundant pool of `N` runners for each team.

### 3. Lecture Updates

* **Lecture 1 (Slide 19):** Language must be updated from a casual "Your primary task..." to explicitly state that the runner setup is a **mandatory, graded "Lab 0" assignment** due before the next class.
* **Lecture 2 (Slide 13):** The speaker note will be updated from a hopeful check-in ("...good time to check that... runners are active...") to a confident verification ("...As you've all completed Lab 0, the Repo Admin should confirm your 'Idle' runners are visible...").

---

## 2025-10-19 @ 12:55 EDT - Elevating HTTP Verb Security to Dedicated Slide

**Scope:** Lecture 1 (The Modern Web & The Engineering Mindset) / Protocol Security

**Description:**
The discussion regarding the use of `POST` vs. `GET` for the initial **session establishment (login)** has been promoted from a speaker note to a **dedicated slide** immediately following the "HTTP is Stateless" slide.

### Rationale:
The primary reason for this change is to **elevate the security imperative** and **technical accuracy** of the lecture. It corrects the oversimplification that `GET` is merely "read-only" and instead focuses on the critical engineering reason for using `POST`:
* **Security Risk:** Using `GET` for sensitive data (username/password) causes **side-channel information leakage** by exposing credentials in browser history, proxy caches, and server logs.
* **Correct Engineering Decision:** The use of `POST` sends the data in the request **body**, mitigating this high security risk.

### Pedagogical Enhancement:
This new slide creates a superior logical flow that reinforces the **framework justification**:
1.  **Architectural Problem:** HTTP is Stateless.
2.  **Security Mechanism:** This is how we securely *initiate* state using `POST`.
3.  **Engineering Solution:** The framework (Flask) is necessary because it handles this hard, security-critical two-step process (Login via `POST` $\rightarrow$ Ongoing Identity via Secure Cookie Header) for you.

### Expert Web-App Developer Approval:
This change directly addresses the previous expert feedback by providing the necessary **technical nuance** (the difference between what *can* be done with `GET` parameters and what *should* be done with `POST` for security) and **elevating security headers** (Cookies) as the true carrier of ongoing identity. The expert would agree this is a crucial point for a software engineering course.

**Time Impact:** This adds an estimated **3-5 minutes** to the lecture, which is considered highly justified given the security and architectural value of the content.

**Reference:** [Link to updated Lecture 1 slide with the new HTTP Verbs content]

---

## 2025-10-19 @ 12:45 EDT - Justification for Web Frameworks: The Session Problem

**Scope:** Lecture 1 (The Modern Web & The Engineering Mindset) / Web Framework Selection

**Description:**
A new slide and associated lecture content have been added to Lecture 1 to address the fundamental reason for using a mature web framework (like Flask) in a software engineering project. The focus is shifted away from the simple **tedium of HTTP parsing** (which can be solved by basic libraries) toward the **complexity and security criticality of state management.**

### Core Insight:
The **stateless nature of HTTP** is the single greatest complexity driver for web applications. The framework's primary value is securely managing the **session** (forcing state onto a stateless protocol) through cryptographically signed cookies. Getting this wrong leads directly to major security vulnerabilities like **Session Hijacking**.

### Expert Evaluation Note:
A review of this instructional point with an expert web application developer affirmed the central thesis. The expert offered two primary technical refinements that were incorporated into the speaker notes:
1.  **Session Pattern Nuance:** Clarify the distinction between **Server-Side Sessions** (client carries only a lookup ID) and **Client-Side Sessions** (client carries the signed/encrypted state), noting that Flask's default uses the latter.
2.  **Security Best Practices:** Explicitly mention the necessity of key cookie attributes (`HttpOnly`, `Secure`) in the implementation to mitigate risks like **Cross-Site Scripting (XSS)** and ensure the session ID is only sent over **HTTPS**.

**Result:** The lecture now establishes the foundation for framework choice on **secure session management** and **reducing security risk**, providing a powerful, practical justification for using production-ready tools.

**Reference:** [Link to updated Lecture 1 slide on HTTP Statelessness]
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

