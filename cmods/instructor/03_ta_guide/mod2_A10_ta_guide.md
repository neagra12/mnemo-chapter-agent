Here is the TA Guide for the `mod2_A10` ("Update & Delete Jokes") homework assignment.

This guide is designed to help TAs grade the "Team Best" workflow, with a primary focus on the implementation of **Authorization (AuthZ)**.

-----

# TA Guide: Homework 5 (`mod2_A10`) - "U" & "D" (Edit & Delete Jokes)

#### 1\. Grading Goal & Core Philosophy

This is the most complex assignment to date and the capstone of our CRUD/AuthZ module. The grading has two priorities:

1.  **AuthZ is Paramount:** The single most important feature is the **authorization check**. Did the student *prove* that `joke.author == current_user` before allowing an edit or delete? A feature that works but allows *any* user to edit *any* joke is a 0/4 for that criteria. It's a critical security failure.
2.  **"Team Best" Process:** The second goal is to grade the *process*. Did every student *actually* attempt the feature? Did the team *actually* review the code? The `CONTRIBUTIONS.md` log is the primary evidence for this. **Do not grade the final PR without first reading the `CONTRIBUTIONS.md` file.**

### 2\. Grading Workflow & Common Pitfalls

This is a "Team Best" assignment. Your workflow must follow this path:

1.  Open the **final PR** submitted to Canvas (the one merging `hw5-edit-joke` into `main`).
2.  Open `CONTRIBUTIONS.md` *first*. Read the "Justification" and then **click every "Individual PR" link** to spot-check them.
      * Is there a link for every student?
      * Does the individual PR show a good-faith effort (i\_s it more than just a `README` change\_)?
3.  Go back to the final PR and review the **"Chosen PR"** code (the final diff). This is what you grade against the rubric.
4.  Run `pytest` (or check the CI) to see the test results.

-----

**Common Pitfalls to Look For:**

  * **CRITICAL FAILURE (AuthZ):** The route has `@login_required` but **no** `if joke.author != current_user: abort(403)`. This is the biggest possible mistake.
  * **"Update" Form is Blank:** The student's `edit_joke` route handles the `POST` but not the `GET` request. When a user *visits* the edit page, the form is blank instead of being pre-populated. They forgot the `elif request.method == 'GET': form.body.data = joke.body` logic.
  * **Insecure "Delete" (EC):** The student used a simple `<a>` link for their "Delete" feature. This is a security flaw (GET requests shouldn't change data). The extra credit *requires* them to use a `<form>` with `method="POST"`.
  * **Incomplete Tests:** The student wrote `test_edit_joke` but forgot `test_cannot_edit_others_joke`. The "AuthZ" test is arguably more important than the "happy path" test.

### 3\. Feed-Forward & Coaching Questions (for Cycle 3)

  * "You correctly used `abort(403)` when a user tried to edit a joke that wasn't theirs. This is great for security, but a `403` page is ugly. In our next module, how could we create a *custom* error page (like `403.html`) to make this a 'friendlier' error?"
  * "Your team correctly identified that `user_a`'s PR was the 'best.' What specific code review comment did you give `user_b` or `user_c` to help them improve for the *next* 'Team Best' assignment?"
  * "You've now built a full, secure CRUD feature. What's the one part of this `moj/routes.py` file that feels the most 'brittle' or 'smelly' to you? (e.g., all routes in one file, repetitive AuthZ checks, etc.)"

-----

## Rubric (Pandoc Grid Table for PDF)

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **"Team Best" Process (3 pts)** | / 3             |
| - `CONTRIBUTIONS.md` log is complete.                       |                 |
| - Log contains a valid, working "Individual PR" link *for each* |               |
|   team member, showing a good-faith effort.                 |                 |
| - Log contains a justification for the "Chosen PR."         |                 |
\+-------------------------------------------------------------+-----------------+
| **"Update" (Edit) Feature (4 pts)** | / 4             |
| - `edit_joke` route exists and uses `<int:joke_id>`.        |                 |
| - **(CRITICAL):** Route has a *correct* authorization check  |                 |
|   (e.g., `if joke.author != current_user: abort(403)`).     |                 |
| - Form is correctly pre-populated on a `GET` request.       |                 |
| - Links are added to templates (conditionally).             |                 |
\+-------------------------------------------------------------+-----------------+
| **Unit Tests (3 pts)** | / 3             |
| - `test_edit_joke` (happy path) is written and passes.      |                 |
| - `test_cannot_edit_others_joke` (AuthZ test) is written    |                 |
|   and passes.                                               |                 |
\+-------------------------------------------------------------+-----------------+
| **EC: "Delete" Feature (+2 pts)** | / +2            |
| - "Delete" route exists and uses `POST` method.             |                 |
| - "Delete" route has a correct authorization (AuthZ) check. |                 |
| - "Delete" tests (happy path + AuthZ) are written and pass. |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

## Canvas-Optimized HTML Snippet

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for A10">
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
                <strong>"Update" (Edit) Feature (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>edit_joke</code> route exists and uses <code>&lt;int:joke_id&gt;</code>.</li>
                    <li><strong>(CRITICAL):</strong> Route has a <em>correct</em> authorization check (e.g., <code>if joke.author != current_user: abort(403)</code>).</li>
                    <li>Form is correctly pre-populated on a <code>GET</code> request.</li>
                    <li>Links are added to templates (conditionally).</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Unit Tests (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>test_edit_joke</code> (happy path) is written and passes.</li>
                    <li><code>test_cannot_edit_others_joke</code> (AuthZ test) is written and passes.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>EC: "Delete" Feature (+2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>"Delete" route exists and uses <code>POST</code> method.</li>
                    <li>"Delete" route has a correct authorization (AuthZ) check.</li>
                    <li>"Delete" tests (happy path + AuthZ) are written and pass.</li>
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