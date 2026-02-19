# Clio AI Knowledge Base

This directory contains the "single source of truth" documents that define the P465 course and our collaborative workflow. These files are my primary context. When you ask me to generate a new artifact, I synthesize information from these documents to ensure all content is consistent, accurate, and aligned with your pedagogical goals.

---

## Core Course & Planning Documents

These files define the "what, when, and why" of the course content.

* ### `Course_Syllabus_CSCI-P465_Fall_2025.pdf`
    * **Purpose:** This is the primary contract with the students. It provides the high-level **weekly schedule**, grading policies, course description, and learning objectives. I use this to frame the entire semester and ensure all assignments align with the official grading weights and late policies.

* ### `general_plan_for_final_7_weeks.md`
    * **Purpose:** This is the detailed **"spine" for the second half of the course**. It contains the complete 14-lecture and 14-ICE sequence for the "Ministry of Jokes" (MoJ) project. I use this as the master plan to generate all lectures, exercises, and project cycles for weeks 9-15.

* ### `MoJ_Project_description.md`
    * **Purpose:** This is the student-facing description for the final "greenfield" project. It outlines the project's concept, learning objectives, and submission cycles. I use this to ensure all MoJ-related artifacts (like ICEs) directly contribute to the skills needed for the project.

* ### `FA24 P465 Lecture Schedule.xlsx - ... .csv`
    * **Purpose:** These files serve as a **historical reference** from a previous semester. They provide context on topic flow, assignment cadence, and the relationship between lectures and due dates, which helps me understand the "brownfield" (Angband) half of the course.

---

## Workflow & "Meta" Documents

These files define "how" we work together and the principles behind the course design.

* ### `clio_persona.md` (Clio's Core Instructions)
    * **Purpose:** This is Clio's instruction set. It defines the `Lecture Coach` persona, all output templates (for slides, ICEs, etc.), pedagogical goals (like the "Pedagogical Analysis"), and all mandatory protocols (like the `SBP` and `Parallel Processing Strategy`). Use this when generating P465 classroom artifacts.

* ### `chapter_agent_persona.md` (Chapter Agent Instructions)
    * **Purpose:** This is the instruction set for the **Chapter Agent** — a separate, domain-agnostic persona designed to generate self-contained instructional chapters. It follows the ADDIE instructional design framework and supports four operation modes (Autonomous, Catalog-Guided, Feedback-Guided, Full Co-Pilot). It is used for comparison against the DARL Instructional Agents system (Yao et al., EACL 2026) and is **not** tied to P465-specific content, classroom logistics, or GitHub workflows. Use this when generating standalone chapter packages for any course or topic.

* ### `instructor_handbook.md`
    * **Purpose:** This is the **SOP manual** for working with Clio. It defines the shared philosophy (the "Evidenced Experience"), explains key principles (like `SAP`), and outlines the maintenance workflow for our "meta" documents.

* ### `decisions_log.md`
    * **Purpose:** This is the shared "meeting minutes" or changelog. It records the **historical rationale** for key pedagogical and structural decisions. Clio uses this to understand *why* a change was made, ensuring it doesn't revert to old logic.