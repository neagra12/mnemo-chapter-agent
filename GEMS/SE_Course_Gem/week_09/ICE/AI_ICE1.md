This is the correct approach. It makes the **in-class goal explicit: "un-block" every team member**. The PR submission becomes an asynchronous follow-up. This new push/pull requirement is the perfect "litmus test" to ensure all setups (especially SSH) are working before teams leave the room.

Here are the two updated documents:

1.  The student-facing `CYCLE_1_SETUP.md` file.
2.  The `TA_Followup_Guide.md` (which includes the new DoD).

-----

## `CYCLE_1_SETUP.md` (Cycle 1 Starter Kit - Revised)

**Objective:** This is your first team workshop. It has two goals:

1.  **In-Class Goal (35-Min Workshop):** Get every single team member "operational." This means everyone can clone the repo, run the app, and pull changes from a teammate. **Identify all blockers** so your TA can help you *now*.
2.  **Final Goal (Due 11:59 PM Tonight):** Submit a perfect Pull Request (PR) that includes your project setup and contributions log.

Follow these steps precisely.

-----

## Part 1: Repository & Collaborator Setup (5 min)

1.  **Select a "Repo Admin":** One team member will create the repository.
2.  **Use the IU GitHub:** Go to **[https://github.iu.edu](https://www.google.com/search?q=https://github.iu.edu)** (do **NOT** use `github.com`).
3.  **Create Repository:**
      * Name: `fa25-p465-team-XX`
      * Visibility: `Private`.
4.  **Add Collaborators:** Go to `Settings > Collaborators` and add:
      * Every member of your team.
      * Your assigned Team TA.
      * The Instructor.

-----

## Part 2: Project (Kanban) Board Setup (5 min)

1.  **Enable GitHub Projects:** Go to the `Projects` tab and create a `New project` using the `Team planning` template.
2.  **Configure Columns:** Rename the columns to: `To Do`, `In Progress`, `Done`.
3.  **Create Starter Tasks:** In `To Do`, create notes for the five main tasks of Cycle 1 and assign them:
      * `Task 1: Complete repository and project setup (ICE 1)`
      * `Task 2: Create initial CI pipeline (pytest) (ICE 2)`
      * `Task 3: Define database models (User, Joke) (ICE 3)`
      * `Task 4: Add Linting & Testing to CI (ICE 4)`
      * `Task 5: Finalize & Submit Cycle 1 Deliverable`
4.  **Action:** Drag `Task 1` to `In Progress`.

-----

## Part 3: Local Setup & "Hello World" (10 min)

**Everyone on the team must do this.**

1.  **Clone the Repo:** `git clone [YOUR_SSH_URL_HERE]`
      * **CRITICAL:** Use the **SSH** URL, not HTTPS. If this fails, **STOP**. This is your first "blocker." Call your TA over to help fix your SSH keys.
2.  **Add Starter Code:** The "Repo Admin" will add the three starter files (`app.py`, `requirements.txt`, `.gitignore`) to the repo, commit, and push them *directly to `main`*.
    ```bash
    git add .
    git commit -m "Initial commit: Add Hello World starter code"
    git push origin main
    ```
3.  **Pull Starter Code:** Everyone else run `git pull origin main`.
4.  **Create ICE 1 Branch:** **Everyone** must now create the *same* branch for this ICE:
    ```bash
    git checkout -b ice1-setup
    ```
5.  **Setup Python Environment (All Members):**
      * Create `venv`: `python -m venv venv`
      * Activate `venv`: `source venv/bin/activate` (or `.\venv\Scripts\activate`)
      * Install packages: `pip install -r requirements.txt`
6.  **Run the App:** Run `flask --app app run --debug`. You should see the server running. **This is your second blocker.** If it fails, call your TA.

-----

## Part 4: `CONTRIBUTIONS.md` & Team Sync (15 min)

This part is the most important. It proves your whole team can collaborate.

1.  **One Person Creates the File:** One team member (who is *not* the "Repo Admin") will create the `CONTRIBUTIONS.md` file on the `ice1-setup` branch.

2.  **Add Content:** Copy the template from Canvas into the new file. As a team, fill in the `ICE 1` entry.

3.  **Commit & Push the File:**

    ```bash
    git add CONTRIBUTIONS.md
    git commit -m "feat: Add initial contributions log for ICE 1"
    git push origin ice1-setup 
    ```

      * **This is your third blocker.** If this `git push` fails, call your TA.

4.  **All *Other* Members Pull the File:**

      * Everyone else on the team must now run:
        ```bash
        git pull origin ice1-setup
        ```
      * Confirm that the `CONTRIBUTIONS.md` file now appears in your local project folder.
      * **This is your fourth blocker.** If this `git pull` fails, call your TA.

**If your team completes this, you have met the in-class objective. Your team is officially "un-blocked."**

-----

## Part 5: Submission (Due 11:59 PM Tonight)

After class, one team member must complete the submission.

1.  **Open the PR:** Go to your `github.iu.edu` repo. Open a Pull Request to merge `ice1-setup` into `main`.
2.  **Title:** `ICE 1: Repository & Project Setup`
3.  **Assign Reviewer:** On the right-hand side, assign your **Team TA** as a "Reviewer".
4.  **Submit to Canvas:** Copy the PR URL and submit it to the Canvas assignment for ICE 1.

**DO NOT MERGE THE PR.** Your TA will review, approve, and leave feedback. After they approve, you can merge it.

-----

## `CONTRIBUTIONS.md` Template

```markdown
# Team Contributions Log

This file tracks contributions from team-based in-class exercises (ICEs) and individual work done outside of class.

## Cycle 1

### In-Class Exercises (ICEs)

---
#### ICE 1: Repository & Project Setup
* **Date:** 2025-XX-XX
* **Team Members Present:** `@username1`, `@username2`, `@username3`
* **Summary of Work:** As a team, we successfully created the private `github.iu.edu` repository, added all collaborators, configured the Cycle 1 Kanban board with 5 starter tasks, and created the `ice1-setup` branch. We are submitting this `CONTRIBUTIONS.md` file as part of our first PR.

---
...
```

-----

## TA Follow-up Guide: ICE 1 (Revised)

### In-Class Goal vs. Final DoD

  * **In-Class Goal (Workshop):** Your \#1 priority is **blocker removal**. The team's goal is *not* to submit the PR, but to get every member to a state where they can `git pull`, `git push`, and `flask run`. The "Team Sync" (`push`/`pull` of `CONTRIBUTIONS.md`) is the test.
  * **Final DoD (Due 11:59 PM):** The team submits a *perfect* PR for you to review.

### Definition of Done (DoD) for ICE 1 (Updated)

This is the team's *final* checklist.

  * [ ] **(In-Class) Team-Wide Local Setup:** Every team member has confirmed they can `git clone`, `git pull`, `git push`, and `flask run` the app locally.
  * [ ] **(Final) Repository:** Repo is private on `github.iu.edu`.
  * [ ] **(Final) Collaborators:** All team members, TA, and Instructor are added.
  * [ ] **(Final) `main` Branch:** `main` is clean (only starter code).
  * [ ] **(Final) Project Board:** Kanban board is created with 5 tasks assigned.
  * [ ] **(Final) `CONTRIBUTIONS.md`:** File exists on the `ice1-setup` branch and is filled out.
  * [ ] **(Final) Pull Request:** PR is open (`ice1-setup` -\> `main`) with TA as "Reviewer".
  * [ ] **(Final) Canvas:** The PR link is submitted to Canvas.

### TA Grading Rubric: ICE 1 (10 points)

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

### Common Pitfalls & Coaching (Revised)

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