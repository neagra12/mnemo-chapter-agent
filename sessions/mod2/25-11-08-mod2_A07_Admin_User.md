# The Assignment to go with lecture 7 - adding admin of Users

## **---- PROMPT ----**
```markdown
Ok it looks like we are ready for the assignment to go with this. With these additions it should be fairly straightforward for the students to extend the user form, modify the routes and templates, account for the user change type in the admin action, and add the test_admin_user and adjust the admin action test, correct?
```

Yes, you are 100% correct. This is a "fairly straightforward" assignment precisely *because* we've designed it that way.

The new Lecture 7 and ICE 11 provide a perfect, one-to-one blueprint for this homework. The students are not learning a *new* skill; they are *mastering* the skill they just practiced by applying it to a different model (`User` instead of `Joke`).

This is the "YOU" phase of "I-WE-YOU" and is a very strong assignment.

Here is the TA Guide and Canvas Rubric for `mod2_A11` (Homework 6).

-----

### TA Guide: Homework 6 (`mod2_A11`) - Admin Modify User

#### 1\. Grading Goal & Core Philosophy

This assignment has one core goal: **assess pattern recognition**. The student's job is to replicate the *exact* "Admin-Edit-with-Audit-Log" pattern from `ICE 11` (which they applied to `Joke`) and apply it to the `User` model.

The critical grading points are:

1.  **RBAC is Correct:** Did they protect the new route (`admin_edit_user`) from non-admins?
2.  **Audit Log is Complete:** Did they *actually log the action* to the `AdminAction` table? A feature that modifies the user but doesn't log the action is a critical failure.
3.  **Tests are Written:** Did they create `tests/test_admin_user.py` and test *both* the "happy path" (admin *can* edit) and the "negative path" (a normal user *cannot*)?

#### 2\. Grading Workflow & Common Pitfalls

1.  Open the final "Team Best" PR.
2.  Open `CONTRIBUTIONS.md` *first*. Read the justification and check the individual PRs for good-faith effort.
3.  Go back to the final PR and review the diff.
4.  Run `pytest` (or check the CI) to see the test results.

-----

**Common Pitfalls to Look For:**

  * **CRITICAL FAILURE (Audit Log):** The `admin_edit_user` route successfully changes the user's role, but the TA **forgets to add the `AdminAction` logic**. They missed the entire "accountability" part of the lecture. This is a -3.
  * **CRITICAL FAILURE (AuthZ):** The route is not protected. A *normal* user can visit `/admin/edit_user/5` and promote themselves to an admin. This is a 0/4 for that criteria.
  * **Poor Form Choice:** The student created a very complex `AdminUserForm` that includes `username` and `email`. This is "correct" but bad design. The *best* implementation is a very simple new form that *only* has a `SelectField` for "role" and the `TextAreaField` for "justification."
  * **Incomplete Tests:** The student wrote `test_admin_can_edit_user` but forgot `test_user_cannot_edit_user`. The "negative path" test is arguably more important.
  * **Admin Panel Not Updated:** This is minor, but the `Admin Panel` test. They'll log the "Edit User" action, but the `admin_panel.html` template might not display it correctly (e.g., if they hardcoded "Joke \#..."). The "Target" column should be generic.

#### 3\. Feed-Forward & Coaching Questions (for Cycle 3)

  * "You've now built two admin features. In your `admin_panel`, you're querying `AdminAction.query.order_by(...).all()`. What happens when this table has 10 million rows? How would you change this query to make it scalable?" (This introduces **pagination**).
  * "Your `AdminUserForm` just has a 'role' field. What other fields would be *dangerous* to put on this form? (e.g., `password_hash`). What fields would be *safe*? (e.g., `email`)?"
  * "You've now used `abort(403)` several times. This is great for an API, but for a user, it's an ugly error page. How could we create a custom `403.html` template to give a friendlier error?"

-----

### Rubric (Pandoc Grid Table for PDF)

\+-------------------------------------------------------------+-----------------+
| Criteria | Points |
\+=============================================================+=================+
| **"Team Best" Process (3 pts)** | / 3 |
| - `CONTRIBUTIONS.md` log is complete. | |
| - Log contains a valid, working "Individual PR" link *for each* | |
| team member, showing a good-faith effort. | |
| - Log contains a justification for the "Chosen PR." | |
\+-------------------------------------------------------------+-----------------+
| **Feature Implementation (4 pts)** | / 4 |
| - `AdminUserForm` is defined in `moj/forms.py` (e.g., with a | |
| `SelectField` for `role` and `TextAreaField` for `justification`). | |
| - `admin_edit_user.html` template is created and renders the form. | |
| - `admin_edit_user` route is created and **protected by RBAC** | |
| (aborts 403 for non-admins). | |
| - Route logic correctly updates the target user's `role` in the DB. | |
\+-------------------------------------------------------------+-----------------+
| **Audit Log & Unit Tests (3 pts)** | / 3 |
| - **(CRITICAL):** The `admin_edit_user` route **must** create an | |
| `AdminAction` log entry with the correct `justification`. | |
| - New `tests/test_admin_user.py` file is created. | |
| - Tests include *both* the "happy path" (admin *can* edit) and the | |
| "negative path" (normal user *cannot* access the route). | |
\+-------------------------------------------------------------+-----------------+
| **EC: Admin "Delete User" Feature (+2 pts)** | / +2 |
| - Admin panel or `admin_edit_user` template includes a "Delete" | |
| button (must be a `POST` form, not a link). | |
| - `admin_delete_user` route is created, is RBAC-protected, and | |
| logs the action to `AdminAction` with a justification. | |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

### Canvas-Optimized HTML Snippet

```html
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
```

## **---- PROMPT ----**
```markdown
can you show me the mod2_A11 
```

Here is the full write-up for **Homework 6 (mod2\_A11)**, which follows the pattern from Lecture 7 and ICE 11.

-----

### Homework 6: The Admin Dashboard (A11)

  * **Module:** 2
  * **Assignment:** 6 (A11)
  * **Topic:** Admin RBAC, Audit Logs, & Unit Testing
  * **Points:** 10
  * **Due Date:** Friday, November 14 @ 11:59 PM
  * **Type:** "Team Best"

### The "Why"

In Lecture 7, we designed the "Admin-Audit" pattern. In `ICE 11`, you worked as a team to *implement* this pattern for the **`Joke`** model. You built the `AdminAction` table, created the `AdminJokeForm`, and implemented the `admin_edit_joke` route, all while logging the action to an audit trail.

Now, it's time for you to *master* this pattern.

Your mission is to apply the **exact same pattern** to the **`User`** model. You will build the "Admin Modify User" feature, allowing an admin to change a user's role (e.g., promote another user to 'admin' or demote them) and require a justification for the change.

### The "Team Best" Workflow

This is a "Team Best" assignment.

1.  **Branch:** The `Repo Admin` must create a new branch from `main` named `hw6-admin-user`.
2.  **Individual PRs:** Each student must create their *own* "individual PR" (e.g., `[alice]-hw6-attempt`) showing a good-faith effort to complete the *entire* assignment.
3.  **Review:** The team reviews all individual PRs and decides which one is the "best" to be the team's final submission.
4.  **Final PR:** The "Chosen PR" is merged into the `hw6-admin-user` branch.
5.  **Log:** The team completes the `CONTRIBUTIONS.md` log.
6.  **Submit:** The `Repo Admin` opens the final PR from `hw6-admin-user` into `main` and submits a link to that PR on Canvas.

-----

### Core Task: Build the "Admin Modify User" Feature

You must follow the "Admin-Audit" pattern from `ICE 11`. This will involve touching (or creating) 6 different files.

#### 1\. The Form (`moj/forms.py`)

  * Create a new form class named `AdminUserForm`. This form should **not** extend `JokeForm`.
  * It needs three fields:
      * `role`: Use a `SelectField` to allow the admin to choose between 'user' and 'admin'.
      * `justification`: A `TextAreaField` (just like in the ICE) that is required and has a length validator.
      * `submit`: A `SubmitField`.

#### 2\. The Route (`moj/routes.py`)

  * Create a new route: `@app.route('/admin/edit_user/<int:user_id>', methods=['GET', 'POST'])`.
  * This route must be protected by `@login_required` AND a **manual RBAC check** (e.g., `if current_user.role != 'admin': abort(403)`).
  * **On `GET`:**
      * Query for the `user` being edited.
      * Pre-populate the form with that user's *current* role (`form.role.data = user.role`).
  * **On `POST` (`form.validate_on_submit()`):**
      * **Log the action:** Create a new `AdminAction` object. Fill in all the details (e.g., `action_type="Edit User"`, `model_type="User"`, `model_id=user.id`, etc.).
      * **Update the user:** Change the user's role in the database (`user.role = form.role.data`).
      * **Commit:** `db.session.commit()` (this saves both the user change and the new log entry).
      * `flash(...)` a success message and `redirect(url_for('admin_panel'))`.

#### 3\. The Template (`templates/admin_edit_user.html`)

  * Create a new template file for your new route.
  * This template should `{% extends "base.html" %}`.
  * It must render your `AdminUserForm`.
  * It should clearly state *which user* is being edited (e.g., `<h1>Admin: Edit User {{ user.username }}</h1>`).

#### 4\. The "Entry Point" (Update `templates/profile.html`)

  * How does an admin *get* to this new page?
  * In your `templates/profile.html` (from `ICE 10`), add an "Admin-only" link that is visible *only* if `current_user.role == 'admin'`.
  * This link should point to your new route: `{{ url_for('admin_edit_user', user_id=user.id) }}`.

#### 5\. The Admin Panel (Update `templates/admin_panel.html`)

  * Your `admin_panel.html` should *already* work, as it just loops over the `AdminAction` table.
  * **Refactor:** Make sure your "Target" column is generic, so it correctly displays both "Joke \#X" and "User \#Y". (Hint: You may need to adjust the `Jinja2` logic in your `{% for %}` loop).

#### 6\. The Tests (`tests/test_admin_user.py`)

  * **Create a new test file:** `tests/test_admin_user.py`.
  * **Rename the old test:** As discussed in the lecture, rename `tests/test_admin_joke.py` to `tests/test_admin_joke.py` (if it wasn't already). This keeps our tests separate by role and feature.
  * **Write two new tests:**
    1.  `test_admin_can_edit_user_role`:
          * GIVEN: A regular `user` and a logged-in `admin_user`.
          * WHEN: The `admin_user` `POST`s to `/admin/edit_user/<user_id>` with a new role and justification.
          * THEN: The response is a `302` redirect, the `user.role` in the database *is* changed, and a new `AdminAction` row *is* created.
    2.  `test_user_cannot_edit_user_role`:
          * GIVEN: A regular `user_A` and a logged-in `user_B`.
          * WHEN: `user_B` attempts to `POST` to `/admin/edit_user/<user_A_id>`.
          * THEN: The response is `403 Forbidden`, the `user_A.role` is *not* changed, and no `AdminAction` is created.

-----

### ⭐ Extra Credit (+2 Points): Admin "Delete User"

Implement the "Admin Delete User" feature, following the *exact same "Admin-Audit" pattern*.

  * **The Form/Button:** Add a "Delete User" button to your `admin_edit_user.html` template. This **must** be a small `<form>` that uses `method="POST"` (for security). It should probably require its own justification.
  * **The Route:** Create a new `admin_delete_user` route that is protected by RBAC.
  * **The Logic:**
    1.  Get the `justification` from the delete form.
    2.  **Log the action:** Create an `AdminAction` with `action_type="Delete User"`.
    3.  **Delete the user:** `db.session.delete(user)`.
    4.  `db.session.commit()`.
    5.  `flash(...)` and redirect.
  * **Note:** Deleting a user who has authored jokes will cause a database `IntegrityError` if not handled. For this EC, you may test by deleting a user *without* any jokes, or you can research how to handle "cascading deletes" in SQLAlchemy. The goal is to prove you can build the secure, audited route.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 6 (A11): Admin Modify User
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link to the *final* PR]
* **Justification:** [Briefly explain *why* this PR was chosen as the "best".]
* **Individual Contributions:**
    * **`@github-userA`**: [Link to *individual* PR]
    * **`@github-userB`**: [Link to *individual* PR]
    * **`@github-userC`**: [Link to *individual* PR]
* **Reflection:** [1-2 sentence reflection. e.g., "This was a good exercise in pattern replication. The trickiest part was getting the `SelectField` to pre-populate correctly on the GET request."]
```

-----

### Rubric (For TA Use)

```html
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
```

## **---- PROMPT ----**
```markdown
We didn't address change_password. We could offer it as another challenge or make it a requirement 7, but just summarize the task. "Apply the admin role to the change_password route and ensure it is tested."
```

You're right, that's a key admin feature we overlooked. An admin can't change a user's role but not reset their password. That's inconsistent.

Your summary is on the right track, but the task is more nuanced.

## The Problem

Your proposed summary, "Apply the admin role to the `change_password` route," is a dangerous trap. The *existing* `change_password` route (from `A09`) requires the user's **old password** for verification. An admin *will not have* the user's old password.

## The Solution

We need to create a **new, separate** "Admin Reset Password" feature that follows the exact same "Admin-Audit" pattern we just established.

It's a perfect extra-credit challenge. It's *too much* to make a requirement on top of the "Modify Role" task, but it's a great "challenge" to prove mastery.

Here is how we can add it to the `A11` assignment as a second Extra Credit option.

---

### Updated `A11` Assignment (Adding the EC)

We will add this right next to the "Admin Delete User" EC.

> ### ⭐ Extra Credit (+2 Points): Admin "Reset Password"
>
> An admin can change a user's role, but what if a user forgets their password?
>
> Following the *exact same "Admin-Audit" pattern* as the main assignment, implement an **Admin Reset Password** feature.
>
> 1.  **Form:** Create an `AdminResetPasswordForm` with `password`, `password2`, and `justification` fields. It should *not* have an `old_password` field.
> 2.  **Route:** Create a new `/admin/reset_password/<user_id>` route. It must be protected by RBAC.
> 3.  **Logic:**
>     * The route must log the action to the `AdminAction` table (e.g., `action_type="Reset Password"`).
>     * It must call `user.set_password()` with the new password.
>     * It must `db.session.commit()` both the new password and the audit log.
> 4.  **Template:** Create an `admin_reset_password.html` template that renders your new form.
> 5.  **Entry Point:** Add a link to this new route from the `admin_edit_user.html` template.


## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





