# Assignment 09: The "Change Password" Feature (Team Best)

  - **Objective:** Individually implement a "Change Password" feature and its unit tests. As a team, review all solutions and select the "best" one to merge.
  - **Due Date:** Wednesday, [Date] @ 11:59 PM
  - **Grading:** This is a 10-point "Team Best" assignment. Individual effort is required for full credit. An optional 2-point extra credit challenge is available.

-----

## The "Complete" Engineering Ticket

In the ICE, we built the "frontend" for `login` and `register`. This homework completes the engineering ticket for our authentication module. This assignment has **two core tasks** that must be done together:

1.  **The Feature:** Build the `change_password` functionality.
2.  **The Tests:** Write the unit tests that *prove* your new feature works and lock in the behavior of the features we built in class.

-----

## Core Task 1 (The Feature): Change Password

*(Every team member must complete this task on their own branch.)*

1.  **Create the Form:**
      * Open `moj/forms.py`.
      * Add a new class, `ChangePasswordForm(FlaskForm)`.
      * It must contain: `old_password`, `new_password`, `new_password2` (with `EqualTo('new_password')`), and `submit`.
2.  **Create the Template:**
      * Create a new file: `moj/templates/change_password.html`.
      * (You can use `moj/templates/login.html` as a template to copy-paste from).
3.  **Implement the Route:**
      * Open `moj/routes.py`.
      * Add a new route: `@app.route('/change_password', methods=['GET', 'POST'])`.
4.  **Implement the Logic:**
      * This new route **must** be protected by the **`@login_required`** decorator.
      * Handle `form.validate_on_submit()` to check the `old_password`, set the `new_password`, `commit` to the `db`, and `flash` messages.
5.  **Add the Link:**
      * Open `moj/templates/_navigation.html` and add a link to the `change_password` route.

-----

## Core Task 2 (The Tests): AuthN Unit Tests

*(Every team member must complete this task on their own branch.)*

1.  **Create Test File:** Create a new file: `tests/test_auth.py`.
2.  **Add "WE" Scaffolding:** Paste the complete, working tests for `register` and `login` into this file. (This code is provided in the Canvas assignment page).
3.  **Add "YOU" Test:** Add your new test to `tests/test_auth.py`. You must write a test for your `change_password` feature, named `def test_change_password(client, app):`.
      * **Hint:** You will need to first create and log in a user (like in `test_login_and_logout_user`), then `POST` to your `/change_password` route (like in `test_register_new_user`).

-----

## ⭐ Challenge (Optional +2 Extra Credit Points)

*(Individuals can choose to complete this on their branch.)*

Add a **custom password complexity validator** to your `ChangePasswordForm`.

1.  **Create a validator:** `def validate_new_password(self, new_password):`.
2.  **Implement the Logic:** `raise ValidationError` if the password fails these rules:
      * At least 15 characters long.
      * At least one digit (`0-9`).
      * At least one uppercase letter (`A-Z`).
      * At least one lowercase letter (`a-z`).
      * At least one symbol (e.g., `!@#$%^&*`).
3.  **Hint:** The `re` (regular expression) library is a good tool for this.

-----

## "Team Best" Workflow & Submission

Follow this exact workflow. The final submission to Canvas is the **URL of the *final* PR** (from `hw4-auth-features` into `main`).

1.  **`Repo Admin`:**
      * `git pull` `main` and create the main feature branch: `hw4-auth-features`.
      * `git push` this new branch.
2.  **All Team Members (Individual Work):**
      * `git pull` and `git checkout hw4-auth-features`.
      * Create your *own* individual developer branch (e.g., `hw4-alice`, `hw4-bob`).
      * On your branch, complete **Core Task 1** and **Core Task 2**. (You may also complete the Challenge).
      * Commit your work and open a Pull Request to merge *your* branch (e.g., `hw4-alice`) into the *team feature branch* (e.g., `hw4-auth-features`).
3.  **Team Review (as a team):**
      * As a team, look at all the individual PRs submitted to `hw4-auth-features`.
      * Review each other's code. Discuss the pros and cons.
      * **Vote to select the "Best" PR.** (This could be the cleanest, the most correct, or the one that includes the extra credit).
4.  **`Repo Admin` (or `Process Lead`):**
      * **Merge** the *one* "Best" PR into the `hw4-auth-features` branch.
      * **Close** all the other individual PRs.
      * Update the `CONTRIBUTIONS.md` log with the new template below.
      * Open the **final Pull Request** to merge `hw4-auth-features` into `main`.
      * **Title:** `HW 4: Change Password Feature and Tests`
      * Submit the URL for *this final PR* to Canvas.

-----

## `CONTRIBUTIONS.md` Log Entry

*(This log is the **critical evidence** for your individual grades)*

```markdown
#### HW 4: Change Password Feature (Team Best)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...

* **Individual PRs (Required for individual credit):**
    * `@github-userA`: [Link to their PR into the feature branch]
    * `@github-userB`: [Link to their PR into the feature branch]
    * `@github-userC`: [Link to their PR into the feature branch]
    * (etc...)

* **"Team Best" Selection:**
    * **Chosen PR:** [Link to the *one* PR that was merged]
    * **Justification:** [As a team, why did you pick this one? (e.g., "Cleanest code," "Passed all tests," "Successfully implemented the extra credit challenge.")]
```
