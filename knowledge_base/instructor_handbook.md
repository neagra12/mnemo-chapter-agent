# P465 Course Design Handbook & SOPs

  - **Version:** 1.0
  - **Purpose:** This document is the instructor's Standard Operating Procedure (SOP) for working with the "Clio/Mnemo" AI assistant to manage the P465 course. Its goal is to ensure consistency, quality, and compliance in all artifact generation.

-----

## 1\. Guiding Philosophy: The Evidenced Experience

Our mission is to deliver an **excellent, modern, and impactful software engineering experience** where success is measurable. All artifacts are designed to be:

1.  **Evidence-Driven:** We must gather quantitative, qualitative, and artifact-based evidence.
2.  **Process-Oriented:** We teach and test the *process* of engineering, not just the technical artifact.
3.  **Cognitively-Managed:** We use scaffolding (`I-WE-YOU`, starter code) to isolate learning objectives.

-----

## 2\. Glossary of Core Principles

  * `Audience-Facing Model:` The `cmod` directory structure. Separates all artifacts into `student_facing/` and `instructor_facing/` for security and automation.
  * `Standard Blocker Protocol (SBP):` The "safe harbor" policy. Allows an *individual* student to pivot from a blocked ICE task to writing a formal `AAR.md` (After-Action Report) by opening a PR for a "5+5" grade.
  * `Scalable Assessment Protocol (SAP):` Our "AI-assisted, human-graded" workflow. Uses AI *only* for **thematic analysis** on an **anonymized** data blob to create a **TA Calibration Guide**. All grading is done by humans.
  * `"I-WE-YOU" Scaffolding:` A cognitive load management technique. We introduce new code by providing a worked example ("I"), a fill-in-the-blank task ("WE"), and an independent task ("YOU").
  * `Two-Target Rubrics:` Our rubric generation workflow. We create **Pandoc Grid Tables** for the master `.md` file (for PDF builds) and separate **HTML Snippets** for Canvas.
  * `The "Historical Hook":` A technique for bridging `Angband` (brownfield) to `MoJ` (greenfield) by using past pain points (e.g., flat files) to justify new technology (e.g., a database).

-----

## 3\. Macro Workflow: The Module Approach

This is the high-level checklist for developing a new course module (typically 1-2 weeks).

  * [ ] **1. Define the Module:**
      * [ ] Define high-level learning objectives (e.g., "Students will learn to secure and test a web API").
      * [ ] Define the capstone "Weekly Challenge" (e.g., the GenAI Tech Evaluation).
  * [ ] **2. Create Weekly Lessons (for each week in the module):**
      * [ ] **Define Lecture(s):**
          * [ ] Prompt Clio to generate the `Lecture_Slide_Deck.md`.
          * [ ] Prompt Clio to generate the `ICE.md` and its `TA_Guide.md`.
          * [ ] Prompt Clio to generate the `Canvas_Rubric_Snippet.html` for the ICE.
      * [ ] **Create Weekly Quiz:**
          * [ ] Prompt Clio to generate a `Quiz.md` with a mix of MC and short-answer questions.
          * [ ] Tag this quiz with `SAP` if it has open-ended questions.
  * [ ] **3. Apply SAP (if needed):**
      * [ ] Prompt Clio to generate the `SAP_Application_Plan.md` for the assignment.
      * [ ] Build and test the workflow (e.g., the anonymizer script).
  * [ ] **4. Review and Commit:**
      * [ ] Review all artifacts for consistency and quality.
      * [ ] Commit to the `cmod` directory.

-----

## 4\. Standard Operating Procedures (SOPs) & Prompt Playbooks

This section contains the *specific, copy-paste-able* prompts and checklists for executing the workflow.

### SOP-01: Generating a New Lecture + ICE

  * **Goal:** To create a new, high-quality, and consistent `Lecture_Slide_Deck.md` and its associated `ICE.md`.
  * **Step 1. The Prompt (Template):**
    ```
    Clio, generate the lecture slides and ICE for Week [X], Lecture [Y].

    - **Topic:** [Topic Name]
    - **Bridge from:** [Concept from last lecture, e.g., "We just built the models, now we need to test them."]
    - **Core Learning Objectives:**
        1. [Objective 1]
        2. [Objective 2]
    - **ICE Goal:** [What artifact will students produce? e.g., "A new `pytest` file that tests the `User` model using an in-memory SQLite DB."]
    - **ICE Roles:** [Suggest a kit name, e.g., "The Quality Assurance Kit"]
    - **AAR Hints:** [Suggest 2-3 common blockers for the SBP hints, e.g., "DB connection errors," "forgot to `pip install pytest-flask`"]
    ```
  * **Step 2. My Review (Checklist):**
      * [ ] **Lecture:** Do the slides bridge from the previous topic?
      * [ ] **Lecture:** Is the "Historical Hook" or "Angband" contrast clear?
      * [ ] **ICE:** Is the `CONTRIBUTIONS.md` reflection question high-level and related to an engineering trade-off?
      * [ ] **ICE:** Are the AAR hints specific and genuinely helpful?
      * [ ] **TA Guide:** Is the rubric (Pandoc Grid Table) clear and tied to the objectives?
  * **Step 3. The Follow-up Prompt (Template):**
    ```
    Clio, now generate the Canvas-Optimized HTML snippet for the ICE 
    [X] rubric.
    ```

### SOP-02: Applying the Scalable Assessment Protocol (SAP)

  * **Goal:** To safely and ethically use AI for thematic analysis to create a TA Calibration Guide.
  * **Step 1. The "Plan" Prompt (Template):**
    ```
    Clio, generate the SAP Application Plan for [Assignment Name].

    - **Deliverable(s):** [e.g., "reflection.md"]
    - **Anonymizer Script:** [e.g., "./pipeline/sap_anonymizer.sh"]
    - **TA Team:** [e.g., "TAs 1-6"]
    ```
  * **Step 2. My Workflow (Checklist):**
      * [ ] Execute `SAP_Application_Plan.md` (build/test scripts).
      * [ ] Run the Anonymizer script on the downloaded submissions.
      * [ ] **CRITICAL: FERPA CHECK.** I have manually inspected the `..._blob.txt` file and confirm it is 100% free of PII.
  * **Step 3. The "Analysis" Prompt (Template):**
    ```
    Clio, here is the anonymized text blob for [Assignment Name]. Please perform the SAP Step 3 Analysis and generate the Step 4 TA Grading Guide.
    ```
  * **Step 4. My Review (Checklist):**
      * [ ] Does the TA guide clearly list themes and misconceptions?
      * [ ] Are the "illustrative quotes" helpful for TAs?
      * [ ] Distribute the final guide to the TA team.

### SOP-03: Applying a Manual Patch (to fix a small error)

  * **Goal:** To fix a small error in a generated artifact (e.g., version number, typo) *without* risking "model drift" from a full regeneration.
  * **Step 1. My Manual Edit (Checklist):**
      * [ ] Open the target file (e.g., `ICE_08.md`).
      * [ ] Make the small, precise, manual edit.
      * [ ] Save and commit the file.
  * **Step 2. The "Patch" Prompt (Template):**
    ```
    Clio, I am applying a manual patch to [Artifact Name].

    - **The Problem:** [Describe the original, problematic text]
    - **The Fix:** [Paste the new, corrected text]

    **Your Action:** Please acknowledge this patch and update your internal template for this artifact. All future regenerations of [Artifact Name] must use this new fix.
    ```
  * **Step 3. Clio's Acknowledgment (Checklist):**
      * [ ] Verify that Clio's response confirms the change and states that its internal template is updated.

-----

## 5\. System Maintenance & "Memory"

This section defines the relationship between the three core "meta" documents.

  * **`decisions_log.md` (The "Meeting Minutes"):** This is the historical log. It's where *Clio* records the *rationale* for a new decision. It grows over time and is used for context.
  * **`clio_persona.md` (The "AI's Handbook"):** This is *Clio's* instruction set. It contains *only the final, actionable RULES* (e.g., the text of the SAP protocol, the ICE template).
  * **`instructor_handbook.md` (This Document):** This is *my* instruction set. It's my "Playbook" for *using* Clio.

When a new rule is made (e.g., via our chat), the maintenance workflow is:

1.  Clio adds the *rationale* to the `decisions_log.md`.
2.  I (the instructor) copy the new *actionable rule* (e.g., the SAP template) into Clio's `clio_persona.md`.
3.  I (the instructor) copy the new *SOP/Playbook* (e.g., the "SAP Prompt Template") into *this* handbook.
