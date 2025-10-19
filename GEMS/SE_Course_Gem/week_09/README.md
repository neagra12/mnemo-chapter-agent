# README: Module 1 (Week 9) - Foundations & CI

This module marks the kickoff of the 7-week "Ministry of Jokes" (MoJ) greenfield project. Its primary goal is to transition students from the "brownfield" `Angband` project to a modern, automated engineering workflow. The module is designed to meticulously de-risk all major technical blockers (Git, environments, CI) to ensure a smooth start.

---

## Content Summary

This directory contains the complete set of assets for the first week of the project.

* **`lecture1.md` (Lecture 1: The Modern Web & The Engineering Mindset):** Introduces the "greenfield" project, contrasts it with the "brownfield" `Angband` experience, and covers the basics of the client-server model, HTTP, and Flask.
* **`AI_ICE1.md` (ICE 1: Project Bootstrap, Kanban & Team Sync):** A critical "de-risking" workshop. Its goal is not PR submission, but ensuring every team member's local environment (`venv`, Git/SSH) is 100% functional by forcing a full-team `git pull` cycle with TA support.
* **`Lecture 2.md` (Lecture 2: Continuous Integration):** Covers the "why" of CI (as an evidence-based safety net) and the "how" (GitHub Actions, YAML, `self-hosted` runners). It directly uses the pain of "it worked on my machine" from `Angband` to justify automation.
* **`AI_ICE2_v3.md` (ICE 2 (v3): The Ministry's First Line of Defense):** The capstone workshop for the week. Teams build their `main.yml` pipeline. This version includes the mandatory **"red build simulation" (Part 4)**, which teaches the critical skill of reading a failing build log.
* **`week9_quiz.md` (Week 9 Quiz):** A 10-question quiz (provided in Markdown and Respondus 4.0 format) to capture *individual, quantitative evidence* of comprehension on Flask, HTTP, and CI concepts.
* **`Module_1_Reference_Guide.md` (Canonical Reference Guide):** An authoritative list of external documentation for the module's core technologies (HTTP, Flask, `venv`, `pytest`, CI, YAML) to be "sprinkled" into other assets.
* **`decisions_log.md` (Entries):** Updated log capturing the key pedagogical decisions for this module, including the "red build" requirement for ICE 2 and the new "open-ended question" format for `CONTRIBUTIONS.md`.

---

## Pedagogical Evaluation

**Rating: 9.5 / 10**

This module is exceptionally strong and serves as a model for the rest of the course.

1.  **Excellent De-risking 🛡️:** The module's primary strength is its meticulous de-risking of the project. ICE 1 solves all Git/environment blockers. The (assumed) homework to set up the `self-hosted` runner moves the most complex *individual* task out of precious class time. This allows ICE 2 to be a focused, high-value *team* success.
2.  **High-Fidelity Artifacts 🎟️:** ICE 2 (v3) is a standout. By forcing teams to simulate *and read* a **red build (❌)**, it moves beyond the shallow victory of a "green check" and teaches the *real*, core skill of CI: normalizing failure and using logs to debug. The `README.md` status badge is a brilliant "trophy" that provides a visible, quantitative metric of success.
3.  **Multi-Modal Evidence 📊:** The module design gathers a complete evidential picture:
    * **Artifact-Based:** `main.yml` file and `README.md` badge.
    * **Process-Based (Team):** The `CONTRIBUTIONS.md` reflection on handling a "red build."
    * **Knowledge-Based (Individual):** The Week 9 Quiz.
4.  **Strong Contextual Bridge 🌉:** The module perfectly "bridges" the two halves of the course. It constantly and effectively uses the *pain* and *manual toil* of the `Angband` (brownfield) project to justify the *process* and *automation* of the `MoJ` (greenfield) project.

---

## Improvements & Unresolved Weaknesses

* **Unresolved Weakness (Single Point of Failure):** The module's only significant weakness is structural and unavoidable. The `self-hosted` runner is a single point of failure that is entirely dependent on students.
    * **The Risk:** For the rest of the course, a team's CI pipeline will simply *not run* if they forget to start their runner. Their jobs will remain "Queued," and they will be blocked.
    * **Mitigation:** This is a known constraint. We must be prepared to remind students ("Is your runner on?") at the start of *every* subsequent ICE and train TAs to check for this as the #1 blocker.