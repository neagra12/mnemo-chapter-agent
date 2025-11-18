# TA Guide: Assignment 08 (The Linter Audit)

## 1\. Grading Goal & Core Philosophy

This assignment is **100% about process and individual accountability**. The "audit-before-enforce" workflow is a core professional skill. We are assessing three things:

1.  **Did they follow the workflow?** (Did the Repo Admin prep, did individuals clean *locally*, and did the Process Lead "flip the switch" *last*?)
2.  **Is there individual evidence?** (The `reflections/` directory is our artifact for this. Every student *must* have a file.)
3.  **Did it work?** (Is the final PR "green"?)

The "dirty" code in the `refactoring_kit` is the setup. This assignment is the payoff. Do not grade the *quality* of their code fixes, only that they *ran the linter* and *made the code pass*.

## 2\. Common Pitfalls & Grading Strategy

  * **The \#1 Blocker: The "Red" PR.** A team might fail the "audit-before-enforce" workflow. The `Process Lead` might add the `lint:` job to `main.yml` *before* all the other members have pushed their "clean" files. This will cause the CI to run, find the remaining "dirty" files, and **fail the build (Red X)**.

      * **Grading:** This is a minor process failure, not a catastrophe. If they show their work (i.e., they *then* push the fixes and the build turns "green"), they should only lose 1 point from the "Green Build" criteria. If they submit a "Red" PR and never fix it, they get 0/1 for that part.

  * **The \#2 Blocker: Missing Reflections.** One or more students may fail to push their individual `reflections/hw3-@username.md` file.

      * **Grading:** The rubric is clear. The team gets 3 points for a *complete* set of reflections. Deduct 1 point for each missing reflection file. This is a team grade, so it's their job to hold each other accountable.

  * **The \#3 Blocker: Merge Conflicts.** If the `Process Lead` (Phase 3) and an individual (Phase 2) both edit `CONTRIBUTIONS.md` at the same time, they'll have a merge conflict.

      * **Coaching:** This is why the instructions are so specific: only the `Process Lead` edits `CONTRIBUTIONS.md` *after* everyone else is done. The individuals *only* create new files in `reflections/`. If they followed this, conflicts are impossible.

## 3\. Feed-Forward & Coaching Questions

  * "I see `flake8` found a lot of `F401: 'module' imported but unused` errors. Why is this rule so important for a team project?"
  * "Your reflection mentioned you disagreed with the 100-character line limit. What's the *engineering argument* (not personal preference) *for* having a strict line limit?"
  * "You've now run `flake8` *locally* and in the *CI pipeline*. Which of those two do you think is more important for your team's day-to-day speed? Why?"

-----

## Rubric (Pandoc Grid Table for PDF)

+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
+=============================================================+=================+
| **Individual Reflections (3 pts)**                          |   3             |
| - The `reflections/` directory exists.                      |                 |
| - There is one `reflections/hw3-@username.md` file          |                 |
|   *for each* team member.                                   |                 |
| - Each reflection thoughtfully answers all prompts.         |                 |
+-------------------------------------------------------------+-----------------+
| **`CONTRIBUTIONS.md` Log (2 pts)**                          |   2             |
| - The `Process Lead` correctly filled out the  log format.  |                 |
| - The log identifies which member cleaned which file.       |                 |
+-------------------------------------------------------------+-----------------+
| **Configuration (2 pts)**                                   |   2             |
| - The `.flake8` config file is present in the repo root.    |                 |
| - The config contains the correct rules from the lecture.   |                 |
+-------------------------------------------------------------+-----------------+
| **CI Implementation (2 pts)**                               |   2             |
| - `main.yml` is updated with a new, valid `lint:` job.      |                 |
| - The `lint:` job runs in parallel with the `test:` job.    |                 |
+-------------------------------------------------------------+-----------------+
| **"Green" Build (1 pt)**                                    |   1             |
| - The final PR shows a "green" checkmark.                   |                 |
| - The `lint` job passed successfully on its first run.      |                 |
+-------------------------------------------------------------+-----------------+
| **Total**                                                   |  **10**.        |
+-------------------------------------------------------------+-----------------+
