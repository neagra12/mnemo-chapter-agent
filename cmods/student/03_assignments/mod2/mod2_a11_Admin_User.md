# Homework 6: The Admin Dashboard (A11)

  * **Module:** 2
  * **Assignment:** 6 (A11)
  * **Topic:** Admin RBAC, Audit Logs, & Unit Testing
  * **Points:** 10
  * **Due Date:** 
  * **Type:** "Team Best"

## The "Why"

In the lecture, we outlined a design for managing our application. In `ICE 11`, you worked as a team to *implement* this design for the **`Joke`** model. You created the `AdminJokeForm`, and implemented the `admin_edit_joke` route. For now while we require a justification for the change, we do not yet do anything with it. 

Now, it's time for you to *master* this pattern.

Your mission is to apply the **exact same pattern** to the **`User`** model. You will build the "Admin Modify User" feature, allowing an admin to change a user's role (e.g., promote another user to 'admin' or demote them) and require a justification for the change.

## The "Team Best" Workflow

This is a "Team Best" assignment.

1.  **Branch:** The `Repo Admin` must create a new branch from `main` named `hw6-admin-user`.
2.  **Individual PRs:** Each student must create their *own* "individual PR" (e.g., `[alice]-hw6-attempt`) showing a good-faith effort to complete the *entire* assignment.
3.  **Review:** The team reviews all individual PRs and decides which one is the "best" to be the team's final submission.
4.  **Final PR:** The "Chosen PR" is merged into the `hw6-admin-user` branch.
5.  **Log:** The team completes the `CONTRIBUTIONS.md` log.
6.  **Submit:** The `Repo Admin` opens the final PR from `hw6-admin-user` into `main` and submits a link to that PR on Canvas.

-----

## Core Task: Build the "Admin Modify User" Feature

You must follow the design for Jokes from `ICE 11`. This will involve touching (or creating) 6 different files.

### 1\. The Form (`moj/forms.py`)

  * Create a new form class named `AdminUserForm`. This form should **not** extend `RegistrationForm`.
  * Your subclass should only implement the additional attributes for administration.

### 2\. The Route (`moj/routes.py`)

  * Create a new route: `@app.route('/admin/edit_user/<int:user_id>', methods=['GET', 'POST'])`.
  * This route must be protected by `@login_required` AND a **manual RBAC check** (e.g., `if current_user.role != 'admin': abort(403)`).
  * **On `GET`:**
      * Query for the `user` being edited.
      * Pre-populate the form with that user's *current* role (`form.role.data = user.role`).
  * **On `POST` (`form.validate_on_submit()`):**
      * **Log the action:** Create a new `AdminAction` object. Fill in all the details (e.g., `action_type="Edit User"`, `model_type="User"`, `model_id=user.id`, etc.).
      * **Update the user:** Change the user's role in the database (`user.role = form.role.data`) if required.
      * **Commit:** `db.session.commit()` (this saves both the user change and the new log entry).
      * `flash(...)` a success message and `redirect(url_for('admin_panel'))`.

### 3\. The Template (`templates/admin_edit_user.html`)

  * Create a new template file for your new route.
  * This template should `{% extends "base.html" %}`.
  * It must render your `AdminUserForm`.
  * It should clearly state *which user* is being edited (e.g., `<h1>Admin: Edit User {{ user.username }}</h1>`).

### 4\. The "Entry Point" (Update `templates/profile.html`)

  * How does an admin *get* to this new page?
  * In your `templates/profile.html` (from `ICE 10`), add an "Admin-only" link that is visible *only* if `current_user.role == 'admin'`.
  * This link should point to your new route: `{{ url_for('admin_edit_user', user_id=user.id) }}`.

### 5\. The Admin Panel (Update `templates/admin_panel.html`)

  * Your `admin_panel.html` should *already* work, as it just loops over the `Users` and `Jokes` table.
  * **Verify:** Verify everything still looks good. 

### 6\. The Tests (`tests/test_admin_user.py`)

  * **Create a new test file:** `tests/test_admin_user.py`.
  * **Write two new tests:**
    1.  `test_admin_can_edit_user_role`:
          * GIVEN: A regular `user` and a logged-in `admin_user`.
          * WHEN: The `admin_user` `POST`s to `/admin/edit_user/<user_id>` with a new role and justification.
          * THEN: The response is a `302` redirect, the `user.role` in the database *is* changed.
    2.  `test_user_cannot_edit_user_role`:
          * GIVEN: A regular `user_A` and a logged-in `user_B`.
          * WHEN: `user_B` attempts to `POST` to `/admin/edit_user/<user_A_id>`.
          * THEN: The response is `403 Forbidden`, the `user_A.role` is *not* changed.

-----

## ⭐ Extra Credit (+2 Points): Admin "Delete User"

Implement the "Admin Delete User" feature, following the *exact same "Admin-Audit" pattern*.

  * **The Form/Button:** Add a "Delete User" button to your `admin_edit_user.html` template. This **must** be a small `<form>` that uses `method="POST"` (for security). It should probably require its own justification.
  * **The Route:** Create a new `admin_delete_user` route that is protected by RBAC.
  * **The Logic:**
    1.  Get the `justification` from the delete form.
    2.  **Delete the user:** `db.session.delete(user)`.
    3.  `db.session.commit()`.
    4.  `flash(...)` and redirect.
  * **Note:** Deleting a user who has authored jokes will cause a database `IntegrityError` if not handled. For this EC, you may test by deleting a user *without* any jokes, or you can research how to handle "cascading deletes" in SQLAlchemy. The goal is to prove you can build the secure, audited route.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
### Assignment 11 (A11): Admin Modify User
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link to the *final* PR]
* **Justification:** [Briefly explain *why* this PR was chosen as the "best".]
* **Individual Contributions:**
    * **`@github-userA`**: [Link to *individual* PR]
    * **`@github-userB`**: [Link to *individual* PR]
    * **`@github-userC`**: [Link to *individual* PR]
* **Reflection:** [1-2 sentence reflection. e.g., "This was a good exercise in pattern replication. The trickiest part was getting the `SelectField` to pre-populate correctly on the GET request."]
```

<!-- 
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for A11">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>"Team Best" Process (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>CONTRIBUTIONS.md</code> log is complete.</li>
                    <li>Log contains a valid, working "Individual PR" link <em>for each</em> team member, showing a good-faith effort.</li>
                    <li>Log contains a justification for the "Chosen PR."</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Feature Implementation (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>AdminUserForm</code> is defined in <code>moj/forms.py</code> (e.g., with a <code>SelectField</code> for <code>role</code> and <code>TextAreaField</code> for <code>justification</code>).</li>
                    <li><code>admin_edit_user.html</code> template is created and renders the form.</li>
                    <li><code>admin_edit_user</code> route is created and <strong>protected by RBAC</strong> (aborts 403 for non-admins).</li>
                    <li>Route logic correctly updates the target user's <code>role</code> in the DB.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Audit Log &amp; Unit Tests (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><strong>(CRITICAL):</strong> The <code>admin_edit_user</code> route <strong>must</strong> create an <code>AdminAction</code> log entry with the correct <code>justification</code>.</li>
                    <li>New <code>tests/test_admin_user.py</code> file is created.</li>
                    <li>Tests include <em>both</em> the "happy path" (admin <em>can</em> edit) and the "negative path" (normal user <em>cannot</em> access the route).</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>EC: Admin "Delete User" Feature (+2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>Admin panel or <code>admin_edit_user</code> template includes a "Delete" button (must be a <code>POST</code> form, not a link).</li>
                    <li><code>admin_delete_user</code> route is created, is RBAC-protected, and logs the action to <code>AdminAction</code> with a justification.</li>
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
-->