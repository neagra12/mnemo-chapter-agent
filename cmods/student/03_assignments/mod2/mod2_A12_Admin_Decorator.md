# Homework 7: The "@admin\_required" Decorator (A13)

  * **Module:** 2
  * **Assignment:** 7 (A13)
  * **Topic:** Refactoring with Python Decorators (DRY)
  * **Points:** 10
  * **Due Date:** 
  * **Type:** "Team Best"

## The "Why": DRY (Don't Repeat Yourself)

Look at your `moj/routes.py` file. You should see this exact line of code repeated in *at least* three different routes (`admin_panel`, `admin_edit_joke`, `admin_edit_user`):

```python
if current_user.role != 'admin':
    abort(403) # Forbidden
```

This is a **"code smell"** and a form of **"technical debt."** We've copied and pasted the same security check. What happens if our "admin" role name changes to "superuser"? We'd have to find and fix it in 3, 10, or 100 different places. This is unmaintainable.

We will "pay off" this debt by refactoring this logic into a **custom Python Decorator**. This will allow us to write code that is much cleaner, more maintainable, and easier to read.

**BEFORE:**

```python
@app.route('/admin_panel')
@login_required
def admin_panel():
    if current_user.role != 'admin':  # <-- Manual check
        abort(403)
    
    actions = AdminAction.query...
    return render_template(...)
```

**AFTER:**

```python
@app.route('/admin_panel')
@login_required
@admin_required  # <-- Clean, declarative, and reusable!
def admin_panel():
    # We can just write our code. The decorator handles the check.
    actions = AdminAction.query...
    return render_template(...)
```

## The "Team Best" Workflow

This is a "Team Best" assignment.

1.  **Branch:** The `Repo Admin` must create a new branch from `main` named `hw7-decorator-refactor`.
2.  **Individual PRs:** Each student must create their *own* "individual PR" (e.g., `[alice]-hw7-attempt`) showing a good-faith effort to complete the *entire* assignment.
3.  **Review:** The team reviews all individual PRs and decides which one is the "best."
4.  **Final PR:** The "Chosen PR" is merged into the `hw7-decorator-refactor` branch.
5.  **Log:** The team completes the `CONTRIBUTIONS.md` log.
6.  **Submit:** The `Repo Admin` opens the final PR from `hw7-decorator-refactor` into `main` and submits a link to that PR on Canvas.

-----

## Core Task 1: Create the Decorator

The cleanest way to do this is in a new, dedicated file.

1.  **Create `moj/decorators.py`:** Create this new file inside your `moj` package.

2.  **Add the Code:** Paste the following boilerplate into `moj/decorators.py`. Your job is to **fill in the `TODO` section.**

    ```python
    from functools import wraps
    from flask import abort
    from flask_login import current_user

    def admin_required(f):
        """
        A decorator to restrict access to admin users.
        """
        @wraps(f)
        def decorated_function(*args, **kwargs):
            # --- TODO: YOUR LOGIC GOES HERE ---
            #
            # 1. Check if the current_user's role is NOT 'admin'
            # 2. If it's not, call abort(403)
            #
            # --- END TODO ---
            
            # If the check passes, run the original route function
            return f(*args, **kwargs)
        return decorated_function
    ```

    *(`@wraps` is a helper that makes our decorator behave correctly. The real logic is just the `if` check you've already written.)*

3.  **Import the Decorator:** For this new file to be "found" by our app, we must import it.

      * Open `moj/__init__.py`.
      * At the bottom of the file, add `decorators` to the import list:

    <!-- end list -->

    ```python
    # ... (bottom of moj/__init__.py)
    from moj import routes, models, commands, decorators
    ```

## Core Task 2: Refactor Your Admin Routes

Now for the easy part. Go through `moj/routes.py` and refactor all your admin-only routes.

1.  **Add the import:** At the top of `moj/routes.py`, add:
    ```python
    from moj.decorators import admin_required
    ```
2.  **Find every admin route:**
      * `admin_panel`
      * `admin_edit_joke`
      * `admin_edit_user`
      * Any EC routes you built (like `admin_delete_user`)
3.  **Refactor them:**
      * **Add** the new `@admin_required` decorator to the stack (it must go *after* `@login_required`).
      * **Delete** the manual `if current_user.role != 'admin': abort(403)` check.

## Core Task 3: Test the Refactor

This is the most important step. How do you know your refactor worked? **You don't break the existing tests.**

1.  You do **not** need to write *new* tests for this.
2.  Run `pytest` from your project root.
3.  All your *existing* tests from `tests/test_admin_joke.py` and `tests/test_admin_user.py` must **still pass**.
      * The "happy path" tests (e.g., `test_admin_can_edit_user_role`) prove your decorator *lets admins in*.
      * The "negative path" tests (e.g., `test_user_cannot_edit_user_role`) prove your decorator *blocks regular users* with a `403`.
4.  If your old tests pass, your refactor was a 100% success.

-----

## ⭐ Extra Credit (+2 Points): The `@author_required` Decorator

You've got another "code smell" in your app: the logic for editing/deleting jokes (from `A10`).

```python
@app.route('/edit_joke/<int:joke_id>', ...)
def edit_joke(joke_id):
    joke = Joke.query.get_or_404(joke_id)
    
    if joke.author != current_user:  # <-- This is also repeated!
        abort(403)
    
    # ...
```

Create a **second decorator** in `moj/decorators.py` called `@author_required`. This one is trickier, as it needs to `get` the `joke_id` from the URL.

**Refactor** your `edit_joke` and `delete_joke` routes to use this new decorator, and prove that your *original* `test_user_joke.py` tests still pass.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 7 (A12): The "@admin_required" Decorator
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link to the *final* PR]
* **Justification:** [Briefly explain *why* this PR was chosen as the "best".]
* **Individual Contributions:**
    * **`@github-userA`**: [Link to *individual* PR]
    * **`@github-userB`**: [Link to *individual* PR]
    * **`@github-userC`**: [Link to *individual* PR]
* **Reflection:** [1-2 sentence reflection. e.g., "Decorators are a clean way to abstract security logic. It made our routes file much easier to read."]
```


<!--
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for A12">
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
                <strong>Decorator Implementation (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>New file <code>moj/decorators.py</code> is created and imported in <code>moj/__init__.py</code>.</li>
                    <li><code>@admin_required</code> decorator is correctly implemented (using <code>@wraps</code>).</li>
                    <li>The decorator's logic correctly checks <code>current_user.role</code> and calls <code>abort(403)</code> if the check fails.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Route Refactoring &amp; Testing (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><strong>(CRITICAL):</strong> All admin routes (<code>admin_panel</code>, <code>admin_edit_joke</code>, <code>admin_edit_user</code>, etc.) are successfully refactored to use the new decorator.</li>
                    <li>All manual <code>if current_user.role != 'admin'</code> checks are removed from the refactored routes.</li>
                    <li>All *existing* admin tests (happy and negative paths) in <code>test_admin_...py</code> files <strong>still pass</strong>.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>EC: <code>@author_required</code> Decorator (+2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>A new, working <code>@author_required</code> decorator is created.</li>
                    <li>The decorator correctly gets the <code>joke_id</code> from the route's <code>kwargs</code> and queries the database.</li>
                    <li>User-facing routes (<code>edit_joke</code>, <code>delete_joke</code>) are refactored to use it, and their tests still pass.</li>
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