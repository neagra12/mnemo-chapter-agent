# Homework 9: The Full-Stack Logger (A14)

  * **Module:** 2
  * **Assignment:** 9 (A14)
  * **Topic:** Completing the "Logging Service" Refactor
  * **Points:** 10
  * **Due Date:** Friday, November 21 @ 11:59 PM
  * **Type:** "Team Best"

## The "Why"

In Lecture 10 and `ICE 14`, we paid off our technical debt by building the `UserAction` model. We "connected the wire" for *one* admin action (`admin_edit_joke`) and built the "Admin Panel" to view it.

Our app is still not *fully* logged. We are still silently performing other actions.

Your mission is to **complete the logging refactor**. You will "hook" our new `UserAction` logger into all the other important parts of the app. By the end, you will have a complete, site-wide event stream and a new feature page for users to view their *own* activity.

## The "Team Best" Workflow

This is a "Team Best" assignment.

1.  **Branch:** The `Repo Admin` must create a new branch from `main` named `hw9-logging-complete`.
2.  **Individual PRs:** Each student must create their *own* "individual PR" (e.g., `[alice]-hw9-attempt`) showing a good-faith effort to complete the *entire* assignment.
3.  **Review:** The team reviews all individual PRs and decides which one is the "best."
4.  **Final PR:** The "Chosen PR" is merged into the `hw9-logging-complete` branch.
5.  **Log:** The team completes the `CONTRIBUTIONS.md` log.
6.  **Submit:** The `Repo Admin` opens the final PR from `hw9-logging-complete` into `main` and submits a link to that PR on Canvas.

-----

## Core Task 1: Log Admin User Edits

This is a 1-to-1 replication of the pattern from `ICE 14`.

1.  **Open `moj/models.py`:** Add a new class constant to `UserAction` (e.g., `ADMIN_EDIT_USER = "Admin Edit User"`).
2.  **Open `moj/routes.py`:** Find your `admin_edit_user` route (from `A11`).
3.  **"Connect the Wire":** Just like you did in the ICE, add the logic to create and save a `UserAction` when the form is submitted. Use the new constant and be sure to save the `form.justification.data` to the `details` field.
4.  **Update Admin Panel:** The query in your `admin_panel` route *must* be updated to include this new action type.
    ```python
    # In admin_panel route
    admin_types = [UserAction.ADMIN_EDIT_JOKE, UserAction.ADMIN_EDIT_USER]
    actions = UserAction.query.filter(
        UserAction.action_type.in_(admin_types)
    ).order_by(...).all()
    ```
5.  **Update `tests/test_admin_user.py`:** Refactor your `test_admin_can_edit_user_role` test. Add assertions at the end to **prove** that a `UserAction` was created with the correct details.

## Core Task 2: Log User Logins

This shows you can apply the pattern to a non-admin, non-form route.

1.  **Open `moj/routes.py`:** Find the `login` route.
2.  **"Hook" the Logger:** After the `login_user(user)` line, add the logic to create and save a new `UserAction`.
    ```python
    new_action = UserAction(
        user=current_user,
        action_type=UserAction.LOGIN # This constant should already be there
    )
    db.session.add(new_action)
    db.session.commit()
    ```
3.  **Write a New Test:** In `tests/test_auth.py`, create a new test `test_login_creates_log_entry`.
      * **GIVEN:** A valid user in the database.
      * **WHEN:** The client `POST`s to `/login` with correct credentials.
      * **THEN:** A new `UserAction` row is created in the database with the `action_type=UserAction.LOGIN` and linked to that user.

## Core Task 3: Build the "My Activity" Page

This is a new, full-stack, user-facing feature that uses the log data.

1.  **Create the Route (`moj/routes.py`):**
      * Create a new route `@app.route('/my_activity')`.
      * It must be protected by `@login_required`.
      * Inside, query for all actions *for the current user*:
        ```python
        actions = UserAction.query.filter_by(
            user=current_user
        ).order_by(UserAction.timestamp.desc()).all()
        ```
      * Render a new template, passing the `actions` list to it.
2.  **Create the Template (`templates/my_activity.html`):**
      * This new template should `{% extends "base.html" %}`.
      * It should have a title like `<h1>My Activity</h1>`.
      * It needs a table (or list) that loops `{% for action in actions %}` and displays the `action.timestamp` and `action.action_type`.
3.  **Add a Link:** In `templates/base.html`, add a link to "My Activity" in the navbar that *only* appears if a user is logged in.
4.  **Write a New Test:** In a relevant test file (like `tests/test_routes.py`), create `test_my_activity_page`.
      * **GIVEN:** A logged-in user with two actions and another user with one action.
      * **WHEN:** The logged-in user `GET`s `/my_activity`.
      * **THEN:** The response is `200 OK`, and the page contains the two actions for the logged-in user, but *not* the action for the other user.

-----

## ⭐ EC 1: "Prune History" Challenge (+2 Points)

Implement a feature for admins to "prune" old logs.

1.  **Work (1 pt):**
      * **Form:** Create a `PruneHistoryForm` (`moj/forms.py`) with a `DateField` and a `justification`.
      * **Template:** Create `prune_history.html` to render this form.
      * **Route:** Create a new `/admin/prune_history` route (GET/POST), protected by `@admin_required`.
      * **Logic:** On `POST`, delete logs older than the form's date. **Crucially, log this action itself** (e.g., `action_type=UserAction.ADMIN_PRUNE_LOG`) with the justification and number of records deleted.
2.  **Tests (1 pt):**
      * In `tests/test_admin.py`, create a new test, `test_prune_history`.
      * **GIVEN:** A logged-in admin, 3 logs *before* 2025-01-01, and 2 logs *after*.
      * **WHEN:** The admin `POST`s to `/admin/prune_history` with the date `2025-01-01` and a justification.
      * **THEN:**
        1.  The 3 old logs are deleted.
        2.  The 2 new logs remain.
        3.  A *new* log (the "prune" action) is created.
        4.  The final `UserAction.query.count()` is 3.

## ⭐ EC 2: "CSV Export" Challenge (+2 Points)

Implement the "Export to CSV" feature.

1.  **Work (1 pt):**
      * **Route:** Create a new `/admin/export_logs` route, protected by `@admin_required`.
      * **Add Link:** Add a link to this route in your `admin_panel.html` template.
      * **Logic:** Query all `UserAction` logs. Use Python's `io` and `csv` modules to generate a CSV. Return the data using Flask's `make_response`, setting the `Content-Disposition` and `Content-type` headers correctly.
2.  **Tests (1 pt):**
      * In `tests/test_admin.py`, create a new test, `test_csv_export`.
      * **GIVEN:** A logged-in admin and 2 `UserAction` logs in the database.
      * **WHEN:** The admin `GET`s `/admin/export_logs`.
      * **THEN:**
        1.  The `response.status_code` is 200.
        2.  The `response.headers['Content-type']` is `text/csv`.
        3.  The `response.headers['Content-Disposition']` contains `attachment; filename=moj_logs.csv`.
        4.  The `response.data` (as bytes) contains the CSV header row (e.g., `b"Timestamp,User,Action Type"`) and the data from the 2 logs.

----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 9 (A14): The Full-Stack Logger
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link to the *final* PR]
* **Justification:** [Briefly explain *why* this PR was chosen as the "best".]
* **Individual Contributions:**
    * **`@github-userA`**: [Link to *individual* PR]
    * **`@github-userB`**: [Link to *individual* PR]
    * **`@github-userC`**: [Link to *individual* PR]
* **Reflection:** [1-2 sentence reflection. e.g., "This assignment showed how one flexible model (UserAction) can be 'hooked' into many places to create new features. The hardest part was refactoring the test_admin_user test."]
```

<!--
### Rubric (For TA Use)

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for A14">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>"Team Best" Process (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>CONTRIBUTIONS.md</code> log is complete with justification.</li>
                    <li>Individual PRs show good-faith effort.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 1: Log Admin User Edits (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>Adds new <code>ADMIN_EDIT_USER</code> constant to <code>UserAction</code>.</li>
                    <li><code>admin_edit_user</code> route correctly saves the <code>UserAction</code> with justification.</li>
                    <li><code>test_admin_user.py</code> is refactored to assert the log is created.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 2: Log User Logins (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>login</code> route is refactored to create a <code>UserAction</code>.</li>
                    <li>New test (<code>test_login_creates_log_entry</code>) is written and passes.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 3: "My Activity" Page (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>New <code>/my_activity</code> route is created, protected, and queries correctly.</li>
                    <li>New <code>my_activity.html</code> template is created and renders the user's actions.</li>
                    <li>New test (<code>test_my_activity_page</code>) is written and passes.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>EC: Log Registration &amp; Joke Creation (+2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>register</code> route is refactored to log the new user's registration.</li>
                    <li><code>create_joke</code> route is refactored to log the new joke.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ +2</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 10</td>
        </tr>
    </tbody>
</table>
```


>