# Week 9 (Cycle 1, Week 1)

## Summary

This week marks the beginning of the "greenfield" development half of the course. We transition from analyzing the "brownfield" `Angband` project to building the **"Ministry of Jokes" (MoJ)** project from scratch.

### Lecture 1: The Modern Web & The Engineering Mindset
The lecture sets the conceptual foundation for our new project.
* **Narrative Bridge:** We explicitly contrast the "archaeology" of `Angband` (reading C code, navigating legacy systems) with the "architecture" of `MoJ` (making design decisions, building from nothing).
* **Core Philosophy:** We introduce "Layers of Abstraction" as our guiding principle.
* **Core Concepts:** We cover the client-server model, the history of the web (Sir Tim Berners-Lee), the difference between HTTP (protocol) and HTML (content), and the basic HTTP verbs (`GET`/`POST`).
* **Framework Intro:** We introduce Flask as an abstraction layer that handles raw HTTP, providing us with powerful tools like **routing** (`@app.route`) and **sessions** (`session` object).
* **Demo:** We conclude with a critical demo of the `flask run --debug` workflow, showing the auto-reloader and the interactive in-browser debugger.

### ICE 1: Repository & Project Setup Workshop
This is a two-phase, 35-minute workshop designed to make every team fully operational.
* **Phase 1 (In-Class Goal):** The *only* goal is to "un-block" every team member. This involves:
    1.  Creating the private `github.iu.edu` repository and adding all collaborators.
    2.  Setting up the Cycle 1 GitHub Project (Kanban) board.
    3.  **Team-wide:** Every member must `git clone` (using SSH), create a `venv`, `pip install` packages, and run the `flask` server.
    4.  **Team Sync Test:** One member `push`es the `CONTRIBUTIONS.md` file, and all other members `pull` it.
* **Phase 2 (EOD Goal):** The team submits a perfect Pull Request (PR) for the `ice1-setup` branch, with the TA assigned as a reviewer, for grading.

---
## Artifact Manifest

This directory contains all artifacts for Week 9.

### `Lecture/`
* `Lecture_1.md`: The `pandoc`-friendly Markdown source for the Lecture 1 slide deck.

### `ICE/`
* `CYCLE_1_SETUP.md`: The student-facing, step-by-step instructions for the 2-phase ICE 1 workshop.
* `TA_Guide_ICE1.md`: The TA-facing guide, including the 10-point grading rubric, Definition of Done, and a guide to common "blockers" (SSH, `venv`).

### `Project_Starter_Kit/` (7 Files)
* `README.md`: The "conceptual" overview template, which directs developers to the Wiki.
* `LICENSE`: The permissive MIT License, which also contains the copyright line.
* `CHANGELOG.md`: The project changelog, pre-seeded with the v0.1.0 entry.
* `DOCUMENTATION_POLICY.md`: The official project documentation policy, to be "activated" in Lecture 2.
* `app.py`: The minimal "Hello World" Flask application, including `session` setup.
* `requirements.txt`: The initial Python dependencies (`Flask`).
* `.gitignore`: The standard Python `.gitignore` file.

### `Quiz/`
* `wk9_quiz.md`: The "Sister Quiz" that covers L1 concepts (`MoJ`, HTTP, Flask) and refreshes SSH knowledge.