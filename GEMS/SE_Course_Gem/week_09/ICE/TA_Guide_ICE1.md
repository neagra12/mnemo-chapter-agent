# TA Follow-up Guide: ICE 1 (Revised)

## In-Class Goal vs. Final DoD

  * **In-Class Goal (Workshop):** Your \#1 priority is **blocker removal**. The team's goal is *not* to submit the PR, but to get every member to a state where they can `git pull`, `git push`, and `flask run`. The "Team Sync" (`push`/`pull` of `CONTRIBUTIONS.md`) is the test.
  * **Final DoD (Due 11:59 PM):** The team submits a *perfect* PR for you to review.

## Definition of Done (DoD) for ICE 1 (Updated)

This is the team's *final* checklist.

  * [ ] **(In-Class) Team-Wide Local Setup:** Every team member has confirmed they can `git clone`, `git pull`, `git push`, and `flask run` the app locally.
  * [ ] **(Final) Repository:** Repo is private on `github.iu.edu`.
  * [ ] **(Final) Collaborators:** All team members, TA, and Instructor are added.
  * [ ] **(Final) `main` Branch:** `main` is clean (only starter code).
  * [ ] **(Final) Project Board:** Kanban board is created with 5 tasks assigned.
  * [ ] **(Final) `CONTRIBUTIONS.md`:** File exists on the `ice1-setup` branch and is filled out.
  * [ ] **(Final) Pull Request:** PR is open (`ice1-setup` -\> `main`) with TA as "Reviewer".
  * [ ] **(Final) Canvas:** The PR link is submitted to Canvas.

## TA Grading Rubric: ICE 1 (10 points)

*(This rubric is unchanged, as it grades the final, submitted PR artifact)*

| Points | Artifact | Check |
| :--- | :--- | :--- |
| **1 pt** | **Repository Configuration** | [ ] Repo is on `github.iu.edu` and is `private`. |
| **2 pts** | **Collaborators** | [ ] All team members are added. <br> [ ] TA and Instructor are added. |
| **2 pts** | **Project (Kanban) Board** | [ ] Board exists with 3 columns. <br> [ ] 5 starter tasks are created and assigned. |
| **2 pts** | **Branching Workflow** | [ ] `main` branch is clean. <br> [ ] PR is correctly opened from `ice1-setup` -\> `main`. |
| **2 pts** | **`CONTRIBUTIONS.md` File** | [ ] File exists *only* on the `ice1-setup` branch. <br> [ ] ICE 1 entry is complete. |
| **1 pt** | **PR Submission** | [ ] TA is correctly assigned as a "Reviewer". |
| **Total** | | **/ 10** |

## Common Pitfalls & Coaching (Revised)

Your in-class time should be spent 100% on solving these "blockers."

1.  **The \#1 Blocker: SSH Key Hell.**
      * **Symptom:** `git clone` or `git push` fails, or asks for a password.
      * **The Fix:** This is your job. Do the 10-min workshop: `ssh-keygen`, add `.pub` key to `github.iu.edu`, and set remote URL to the `ssh` version. The new `push`/`pull` requirement is *designed* to force this error to happen in class.
2.  **The \#2 Blocker: Python/`venv` Path Hell.**
      * **Symptom:** `python -m venv venv` fails, or `source venv/bin/activate` fails, or `pip install` fails with a "permission denied" error (meaning they aren't in the venv).
      * **The Fix:** Coach them on how `venv` works. Many students will have multiple Python versions. Show them how to check (`which python3`) and be explicit (e.g., `python3.11 -m venv venv`).
3.  **The \#3 Blocker: The `flask` Command.**
      * **Symptom:** `flask --app app run --debug` returns "command not found."
      * **The Fix:** 99% of the time, their `venv` is not active. Make them run `which flask`. If it doesn't point to their `venv/bin/flask`, their environment is not active.