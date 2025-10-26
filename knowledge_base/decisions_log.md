# Decision Log for Clio

---


---

## 2025-10-26 @ 11:47 EDT - Pedagogical Strategy for mod1_Lec03 (Databases) & ICE07

**Scope:** `mod1_Lec03_Databases_Models.md`, `ICE_07_Models_Migrations.md`, `Course_Pedagogy`, `SBP_Workflow`

**Description:**
We have finalized the lecture and ICE for the database module. This plan reflects three major pedagogical decisions:

1.  **Pairing SBP Rollout with a High-Risk ICE:** The new **Standard Blocker Protocol (SBP)** and **After-Action Report (AAR)** workflow is being introduced in this lecture. We are *intentionally* pairing this policy rollout with ICE07, an exercise known to have a high risk of technical blockers (e.g., the circular import trap, the multi-step migration command workflow).
    * **Rationale:** This strategy introduces the "safety net" (SBP) at the exact moment students are most likely to need it. By time-boxing the in-class portion and making the final `flask db upgrade` step homework, we are creating an immediate, practical, and low-stakes application for the SBP.

2.  **Strengthening the "Brownfield-to-Greenfield" Bridge:** The lecture's justification for using a database has been explicitly tied to the students' prior work.
    * **Rationale:** The new Slide 3 ("The MFE Problem") frames the "pain" of the `Angband` Monster File Editor assignment (manually managing flat-file relationships) as the core problem that a relational database (SQLAlchemy) is designed to solve. This directly connects their Part 1 experience to the Part 2 "greenfield" architecture.

3.  **Prioritizing Workflow over Theory:** The lecture content was strategically "de-scoped" to focus on practical, workflow-oriented skills.
    * **Rationale:** We removed deep theoretical dives (e.g., standalone slides on ACID transactions, concurrency) to dedicate more time to the *practical implementation*: the ORM-to-SQL mapping (Slide 9), the migration process (Slide 11), and the SBP/AAR workflow. The "theory" (SQL vs. NoSQL) is now concentrated in a single, dense trade-off table (Slide 6) that serves as "ground truth" for the `MongoDB_exploration.md` weekly challenge, creating a tight loop between the lecture and the asynchronous assignment.

---

Understood. This is a much more robust standard.

It decouples the lecture's identity from the assignment numbering, which makes it stable across semesters and perfect for your build scripts to parse.

We will now use the standard: **`mod#_Lec##_Topic.md`**

Applying this to our database lecture, assuming the "Ministry of Jokes" project is **Module 1** and this is the **3rd lecture** in that module (after 1. Flask and 2. CI):

* **Module:** `mod1`
* **Lecture:** `Lec03`
* **Topic:** `Databases_Models`

The new file name will be:
`mod1_Lec03_Databases_Models.md`

The full, standardized path will be:
`cmod/instructor_facing/01_lectures/mod1_Lec03_Databases_Models.md`

Here is the log entry for this decision.

---

## 2025-10-25 @ 16:07 EDT - Standardizing Artifact Naming Conventions

**Scope:** Workflow, Artifact Organization, `cmod` Structure, Build Process

**Description:**
We are formalizing the file naming convention for all course artifacts to ensure stability, semester-to-semester resilience, and to enable build scripts to deterministically link artifacts into a "shadow delivery tree."

### The New Standard
The naming convention will be based on the **delivery schedule (Module and Lecture number)**, not on variable assignment numbers (like ICEs).

* **Lecture Files:** `mod#_Lec##_Topic.md`
    * **Example:** `mod1_Lec03_Databases_Models.md`
* **ICE Files:** `mod#_ICE##_Topic.md`
* **Challenge Files:** `mod#_Lab##_Topic.md`
* **Quiz Files:** `mod#_Quiz##_Topic.md`

This standard will be applied to all artifacts in the `cmod/` directory. For example:
* `cmod/instructor_facing/01_lectures/mod1_Lec03_Databases_Models.md`
* `cmod/student_facing/02_ices/mod1_ICE03_Databases_Models.md`
* `cmod/instructor_facing/02_ta_guides/TA_Guide_ICE03.md`
---

## 2025-10-25 @ 11:34 EDT - Formalizing the "Patch and Notify" Workflow (SOP-03)

**Scope:** Workflow, Artifact Management, Model Drift Mitigation

**Description:**
We have identified a new workflow to handle small, surgical edits (e.g., fixing a version number, correcting a typo) in generated content without risking "model drift" from a full regeneration.

The "Regenerate" workflow is rejected for this use case, as the AI is generative, not deterministic, and will lose the precise manual fix.

The new, approved workflow is **"Patch and Notify" (SOP-03)**:

1.  **Instructor (Manual Patch):** The instructor makes the fast, precise, manual edit directly in the artifact.
2.  **Instructor (Notify Prompt):** The instructor uses a specific "Patch" prompt to inform Clio of the "Problem" and the "Fix."
3.  **Clio (Acknowledge & Update):** Clio must acknowledge the patch and confirm that its internal template for that artifact has been updated.

**Rationale:** This process combines the speed and precision of a manual edit with the long-term consistency of keeping Clio's internal knowledge in-sync.

---
## Clio Internal Log: 2025-10-25 @ 11:28 EDT

**Subject: Optimizing "Mnemo System" Workflow & Context Window**

**Scope:** My (Clio's) generation process, instructor interaction model, and knowledge base requirements.

### 1. Handbook Update SOP: "Append, Don't Rewrite"
To mitigate "model drift" and ensure the integrity of the instructor's handbooks, I will no longer rewrite an entire handbook to add a new section.

* **New Process:** When a new SOP or playbook is created, my deliverable will be the **standalone, self-contained text block** for that new section.
* **Instructor's Role:** The instructor will then act as the "integrator," manually copying and pasting this new block into their master document.
* **Rationale:** This is safer, more precise, and `git-friendly`. It uses my generative strength without risking the integrity of existing, validated rules.

### 2. Knowledge Base Curation (Context Window Optimization)
We have defined the optimal set of files for the instructor to provide as my knowledge base. This is designed to maximize my focus and performance by eliminating low-value "noise."

* **DEPRECATED (Exclude from Context):** Sample artifacts (`ICEX07.md`, `lecture1.md`, `wk1_quiz.md`, etc.) are now considered historical, low-value context. They are *examples* of past work, not *instructions*, and should be excluded.
* **REQUIRED (High-Value Context):** My "mind" for the course should consist of:
    1.  **`clio_persona.md`:** (My Rules)
    2.  **`decisions_log.md`:** (Our Shared Rationale)
    3.  **`instructor_handbook.md`:** (The Instructor's Playbook)
    4.  **"Course Facts":** (e.g., `FA24 P465 Lecture Schedule.csv`, `MoJ_Project_description.md`).
---

## 2025-10-24 @ 21:25 EDT - Integrating AAR Template into ICEs & Pivoting to Individual AARs

**Scope:** Workflow, SBP, ICE Template, Pedagogy, Grading

**Description:**
We have made two significant improvements to the Standard Blocker Protocol (SBP).

1.  **AAR Template Integration:** The 7-part AAR template is now integrated directly into the `ICE Template`. This allows me (Clio) to pre-fill a new "Instructor's Diagnostic Hints" section with ICE-specific guidance, simulating a senior engineer's "expert biasing" to make the AAR a more effective diagnostic tool.
2.  **Pivot to Individual AARs:** We are clarifying and formalizing the SBP as an **individual "safe harbor" protocol**, not a team-wide one. This was based on the instructor's clarification that individuals, not just teams, can file AARs. This supersedes the "team AAR" workflow logged at 21:10 EDT.

### The Finalized (Individual) AAR Workflow:

  * **Trigger:** An *individual student* is blocked for \>15 minutes.
  * **Action:** The student informs their team, creates an `aar/AAR-ICE[X]-<username>.md` file from the template, and completes it.
  * **Submission (Part 1):** The student opens a PR with their AAR and assigns the **instructor**. The PR URL is submitted to Canvas for 5 points.
  * **Feedback (Part 2):** The instructor provides a hotfix via PR comments. The student applies the fix, completes the original ICE, and resubmits their *passing* PR for the final 5 points.

**Rationale:** This workflow is pedagogically superior. It maintains the high cognitive engagement of document authoring, simulates a professional senior/junior engineer dialog, and provides a robust "safe harbor" for individual students without forcing the entire team to pivot.

---
## 2025-10-24 @ 21:10 EDT - Finalizing the AAR Submission & Review Workflow (PR-Based)

**Scope:** Workflow, SBP, Grading, Automation, Pedagogical Design

**Description:**
We have finalized the workflow for the Standard Blocker Protocol (SBP) After-Action Report (AAR) submission and review. We explicitly **rejected** using web forms (like MS Forms) or email attachments in favor of a process that is more pedagogically sound and better simulates a professional engineering workflow.

### The Finalized AAR Workflow:
1.  **Student Action (Authoring):** When blocked, the team will copy a `aar_template.md` file into an `/aar` directory in their project repository. They will fill out this document as a team.
2.  **Student Action (Submission):** The team will commit the new `AAR-ICE[X].md` file to a new branch and open a **Pull Request (PR)**, assigning the **instructor** as a reviewer. This PR serves as their on-time "Part 1" (5-point) submission.
3.  **Instructor Action (Automation):** The instructor will use the PR URL as an input to a local script (via Apple Shortcuts) that will fetch, parse, and log the AAR data into the course's private improvement log.
4.  **Instructor Action (Feedback):** The instructor will provide feedback, lessons learned, and (if necessary) a hotfix by **commenting directly on the Pull Request.**
5.  **Resolution:** The PR will be merged or closed, and the student will proceed with the "Part 2" hotfix submission.

### Rationale:
This workflow was chosen because it perfectly aligns with our core goals:
* **Core Goal (SE Experience):** Using a PR to review a post-mortem document is a high-fidelity simulation of a real-world engineering process.
* **Developer Workflow Competency:** It reinforces the Git/PR workflow for non-code artifacts.
* **Cognitive Load Management:** It shifts the "Form vs. Document" debate decisively toward **document authoring**, which promotes deeper reflection and metacognition by having students construct a single, coherent narrative.
* **Automation:** It provides a clean, scriptable "handle" (the PR URL) for the instructor's automation, without compromising the student experience.

---
## 2025-10-24 @ 15:28 EDT - Optimizing Rubric Workflow for Pandoc and Canvas

**Scope:** Workflow, In-Class Exercises (ICEs), Grading Artifacts, Pandoc

**Description:**
We identified a critical conflict between our two target renderers (Canvas and Pandoc). Inlined HTML rubrics, while professional-looking in Canvas, are discarded by Pandoc, which breaks the `Markdown -> PDF/DOCX` pipeline. Conversely, Pandoc-native tables (like grid tables) render poorly or as plain text in the Canvas RCE.

To resolve this, we are adopting a "two-target" workflow to treat the Markdown file as the single source of truth for the Pandoc toolchain.

### 1. Master Document (Pandoc-Native)
All future ICE Markdown files will use a **Pandoc-native grid table** for the rubric. This ensures the master file can be perfectly converted to PDF or DOCX using our standard Pandoc toolchain.

### 2. Canvas Deliverable (HTML Snippet)
As a separate, manual step, I (Clio) will generate a **Canvas-optimized HTML snippet** for the rubric immediately after generating the ICE. The instructor will then manually copy this HTML into the Canvas RCE to ensure a professional appearance.

This is our standard operating procedure for now. The instructor will remind me to provide this snippet after generating an ICE, and we can revisit automating this pipeline later.

---

## 2025-10-23 @ 12:01 EDT - Formalizing the "Standard Blocker Protocol" (SBP) & "5+5" Grading Model

**Scope:** Course Policy, Grading, In-Class Exercises (ICEs), Evidence-Driven Design

**Description:**
The total failure of ICE 2 revealed a critical gap in our course design: an un-tested or broken ICE (an "instructional failure") unfairly penalizes students and creates a high-anxiety, low-learning environment.

To remediate this, we have designed the **"Standard Blocker Protocol" (SBP)** to act as a "safe harbor." This policy transforms a technical failure into a high-level pedagogical opportunity, shifting the learning objective from "task completion" to "professional triage and recovery."

### 1. The "5+5" Grading Model
The initial idea to award full (10/10) credit for an After-Action Report (AAR) was **REJECTED**. This flaw was identified: "Knowing the answer is only half of an engineering problem." The full engineering loop (`Blocker -> Report -> Fix -> Verification`) must be incentivized.

The finalized policy is the **"5+5" Grading Model**:
* **Part 1: The AAR (5 pts):** If a team is blocked (>15 min), they must pivot. Submitting a professional, on-time AAR (using the 7-part template) *to the original ICE assignment* counts as their "on-time" submission and is worth the first **5 points**. This is the "safe harbor" that protects them from a late penalty.
* **Part 2: The Hotfix (5 pts):** The instructor will provide a "hotfix." The team receives the **remaining 5 points** only after they apply the fix, achieve the original Definition of Done, and **resubmit** the correct, working deliverable (e.g., the passing PR) to the same assignment.

### 2. The Canvas Workflow (Simplified)
The initial idea of a separate, semester-long "AAR Triage Assignment" was **REJECTED**. It is incompatible with Canvas's submission logic, as it would be overwritten with each new AAR, destroying the evidence trail.

The final, simplified workflow is:
1.  A blocked team submits their AAR (the alternate deliverable) directly *to the original ICE assignment* (e.G., "ICE 2").
2.  The TA grades this submission, awarding 5/10 for the AAR.
3.  The TA provides the hotfix in the Canvas assignment's "Comments" field.
4.  The team **resubmits** their *fixed* deliverable (the passing PR) to the *same* assignment.
5.  The TA re-grades the final submission, updating the score to 10/10.

This keeps all artifacts, evidence, and communication for a single ICE within a single, self-contained Canvas assignment.

### 3. Action Item: Template Updates
This SBP is now a core policy. It **must** be added to all future ICEs.
1.  **`ICE_TEMPLATE` Update:** The `ICE_TEMPLATE` has been permanently updated to include a "💡 Standard Blocker Protocol (SBP)" section that clearly outlines this "5+5" policy and workflow.
2.  **`START/END` Markers:** The `ICE_TEMPLATE` has also been updated to include the `` and `` markers, as required by the **Mnemo System v1.1** automated pipeline.

--- 

## 2025-10-19 @ 13:05 EDT - Integrating DevSecOps Tools (GitHub Security Tab)

**Scope:** Lecture 11 (Application Security) / DevSecOps Practices

**Decision:**
A segment will be added to the **Week 11 Application Security** lecture to introduce the universal DevSecOps techniques implemented in the **GitHub Security Tab** (or equivalent features in other platforms).

### Rationale:
The goal is to bridge the gap between conceptual security (covered in the lecture, e.g., SQL injection) and **automated, continuous security practices** used in industry (DevSecOps).

| GitHub Feature Demonstrated | Core Technology/Technique Taught |
| :--- | :--- |
| **Dependabot Alerts** | **Software Composition Analysis (SCA):** Monitoring third-party dependencies for known vulnerabilities (CVEs). |
| **Secret Scanning** | **Hardcoded Credential Prevention:** Automated checking for accidental commits of API keys or passwords. |
| **Code Scanning** | **Static Application Security Testing (SAST):** Analyzing source code for common security flaws before execution. |

### Pedagogical Enhancement:
This ensures that security is taught as a **process layer** integrated into the CI/CD pipeline, reinforcing the idea that security is automated and continuous, not a manual, one-time audit. The timing is ideal as students will have a full application codebase and dependencies (Week 11) ready for these tools to analyze.

### Final Check:
This decision is complementary to the Week 12/13 Ruleset decision and is fully aligned with the course's shift toward **architectural and automated engineering practices**. 

[Image of DevSecOps lifecycle]

---

## 2025-10-19 @ 13:00 EDT - Introducing Policy as Code (GitHub Rulesets/Branch Protection)

**Scope:** Lecture 12 (Automated Deployment) or Lecture 13 (GenAI Integration) / Software Governance

**Decision:**
The concept of **Policy as Code (PaC)**, specifically implemented via **GitHub Rulesets** (or similar features in other platforms), will be formally introduced into the course schedule between **Week 12 (CD)** and **Week 13 (GenAI Integration)**.

### Rationale:
The timing is chosen to present Rulesets as the final layer of **Governance Automation**, which sits directly on top of the CI/CD pipeline built in Week 12:

1.  **Architectural Necessity:** After automating code *delivery* (CD), Rulesets automate the **governance** of that delivery. This answers the question: "How do we prevent a human from manually overriding the pipeline's findings?"
2.  **Pedagogical Link:** It enforces critical techniques already taught: **Code Review (CR)** and **Continuous Integration (CI)** success (e.g., "CI must pass," "Require 2 approvals"). This moves process requirements from a team rule into a repository configuration.
3.  **Project Alignment:** This provides context for the **Extra Credit** option in the MoJ Project (Section 7: "Enforce Branch Protection"), encouraging students to implement the technical solution for PaC.

### Action Item:
The lecture material must be designed to teach the general **PaC technique** rather than focusing exclusively on the specific GitHub product.

---

### 🛑 Reminder: Pre-Finalization Check

**This decision must be cross-checked with 2.5 Pro** to ensure the integration point does not conflict with advanced topics or architectural assumptions being made in Week 13/14 regarding the GenAI model integration or final deployment strategy.

---

## 2025-10-22 @ 00:03 EDT - Responding to Wk 9 After-Action Report & Workflow Optimization (Mnemo System v1.1)

**Scope:** Course Logistics, Pedagogical Workflow, Evidence-Driven Design

**Description:**
The instructor provided a detailed after-action report following the delivery of the first lecture and ICE of Cycle 1 (Week 9 of the course). All Week 1 (Week 9) materials are considered published.

The report identified several critical blockers and workflow friction points. This log entry summarizes the analysis of that report and the corresponding decisions made to remediate blockers and improve our development pipeline (The Mnemo System v1.1).

### 1. Triage: Week 9 Blocker Remediation

Two major blockers were identified in the first ICE delivery:

* **Blocker 1 (External):** An external platform (Canvas) outage severely impacted the second class, as teams could not copy/paste instructions and were gated by a single projector view.
    * **Decision:** While this was an external failure, future ICEs should have a low-tech fallback (e.g., a pre-exported PDF of instructions) available in the "Files" section of Canvas as a backup.
* **Blocker 2 (Technical):** A critical platform constraint was discovered: the IU GitHub instance **requires a repository to be in an "Organization"** to set collaborator roles (e.g., "Admin"). This invalidates the current plan for managing self-hosted runners.
    * **Decision (Hotfix):** I will generate an "ICE 1.5" hotfix. This will be a 15-minute, high-priority task for the *start* of the next lecture (Lecture 2).
    * **Pedagogical Framing:** This will be framed as an **"Emergency Ops-Level Directive."** Teams must create a GitHub Organization and transfer their `moj-project` repo to it, correctly re-assigning roles. This turns a technical blocker into a realistic, evidence-based learning exercise.

### 2. Workflow Optimization: The Mnemo System v1.1

The instructor identified three key friction points in the `Clio -> Artifact` development pipeline. We have agreed on the following optimizations:

1.  **Artifact Extraction:** To solve the "teasing apart" of my analysis from the deliverables, all future generated artifacts (ICEs, TA Guides, etc.) **must** be wrapped in parseable comment tags (e.g., `` and ``). This enables automated scripting.
2.  **PDF Styling:** To fix poor rendering (fonts, page breaks) of `Markdown -> PDF` exports, I have generated `course_styles.css`. This file will be used with the `Markdown PDF` VS Code extension to create professional, readable, and "print-safe" documents.
3.  **Persona Framework:** We have formalized our roles. **Mnemo** is the foundational persona for cross-course pedagogy and workflow. **Clio** (this instance) is the specialized "Muse of History" persona for this SE course, focused on Evidence-Driven Design and historical context.

### 3. Strategic Shift: The "Canvas Checkpoint" Model

The instructor's suggestion to use Canvas for ICE delivery is a major pedagogical advancement that directly serves my **Evidence-Driven Design** mandate.

* **Decision:** We will adopt the **"ICE Checkpoint" Model**, beginning with ICE 3.
* **Mechanism:** ICEs will be structured as **Canvas Quizzes**. Each "question" in the quiz will be a checkpoint for a specific task (e.g., "Part 1: Paste the URL of your new feature branch").
* **Evidence Gathered:** This model moves us from simple artifact-based grading to real-time process metrics. It will automatically capture:
    1.  **Quantitative Team Velocity:** Timestamped data on "time-to-completion" for each part of the exercise.
    2.  **Real-Time Blocker ID:** A dashboard view of where the entire class is getting stuck.
    3.  **Automated Attendance:** A non-repudiable record of in-class engagement.

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

