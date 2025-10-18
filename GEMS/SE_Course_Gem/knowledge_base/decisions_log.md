# Decision Log for FA25 SE 1 final 7 weeks


--- 

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

