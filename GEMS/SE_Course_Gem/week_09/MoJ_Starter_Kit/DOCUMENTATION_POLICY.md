# Ministry of Jokes (MoJ) Documentation Policy

**Last Modified:** 2025-10-18 (Week 9)
**Version:** 1.0.0

---
## 1. Philosophy: Documentation as an Engineering Tool

This document defines the types of documentation for the MoJ project, their intended audience, and the minimal standards for each.

Our philosophy is that **documentation is not a "tax" but a critical engineering tool for managing complexity.**

In the first half of this course (the `Angband` project), we experienced the pain of a "brownfield" system with sparse, scattered, or hard-to-find documentation. As developers, we were often lost.

For this "greenfield" project, we will be *producers* of high-quality documentation from Day 1. Our guiding principle is: **All documentation is written for a specific audience.**

---
## 2. Core Documentation & Audience

| Artifact | Audience | Purpose (The "Why") |
| :--- | :--- | :--- |
| **`README.md`** | **External:** New Users, Stakeholders, Graders | **The "Conceptual" Model.** A high-level overview. What is this project? What does it do? |
| **`Wiki (Developer Setup)`** | **Internal:** New Team Developers | **The "Implementation" Model.** How do I clone, install, and run this project locally? |
| **`Wiki (API Contract)`** | **Internal & External:** Frontend Devs, API Consumers | **The "Specification" Model.** A technical contract. What are the API endpoints? |
| **`CHANGELOG.md`** | **Internal & External:** Team, Users | Tracks the project's history. What's new? What's fixed? |
| **`CONTRIBUTIONS.md`** | **Internal:** Team, TA, Instructor | Tracks *who* did *what*. Our internal log of work and team process. |
| **`GitHub Issues`** | **Internal:** Team | The "to-do" list. Tracks planned features, bugs, and tasks. |
| **`Inline Code Comments`** | **Internal:** Future Developers (You!) | Explains the "why" of complex, non-obvious code. |
| **`Pull Requests (PRs)`** | **Internal:** Team | Documents the "story" of a change, including the review, discussion, and approval. |

---
## 3. Minimal Standards
1.  **No "Magic" Commits:** All non-trivial commits **must** be tied to a GitHub Issue.
2.  **Human-Readable PRs:** All Pull Requests **must** include a human-readable summary of the change and use a keyword (e.g., `Closes #12`) to link to the Issue.
3.  **Explain the "Why," Not the "What":** Code should be self-documenting. Use inline comments *only* to explain *why* a complex decision was made, not *what* the code does.
4.  **Keep the Wiki Fresh:** Any change to the local setup **must** be documented in the `Wiki (Developer Setup)` page in the *same PR* that makes the change.

---
## 4. Licensing and Copyright Standard
To ensure legal clarity and professional hygiene, this project follows the REUSE standard.

1.  **Repository License:** The full text of our project's MIT license is in the root `LICENSE` file.
2.  **Per-File Copyright:** All source code files (e.g., `.py`) **must** begin with a comment block containing the following two lines.

    ```python
    # SPDX-FileCopyrightText: 2025 The Project Contributors (CSCI-P 465, Indiana University)
    # SPDX-License-Identifier: MIT
    ```
3.  **Enforcement:** This policy will be automatically enforced by a "Compliance" job in our GitHub Actions CI pipeline (which we will build in ICE 2).

---
## 5. Document Change Log
This section tracks changes *to this policy document*.

| Version | Date | Author | Summary of Change |
| :--- | :--- | :--- | :--- |
| 1.0.0 | 2025-10-18 | (Instructor) | Initial creation of the documentation policy. |
| *Template* | *YYYY-MM-DD* | *@username* | *Brief summary of your change* |