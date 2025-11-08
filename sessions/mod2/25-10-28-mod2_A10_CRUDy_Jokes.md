# mod2_A10_CRUDy_Jokes assigment session


## **---- PROMPT ----**
```markdown
OK lets generate the mod2_A10 that accompanies the ice.
```

Here is the asynchronous assignment (`mod2_A10`) that accompanies the lecture and ICE.

This assignment is designed to be the "YOU" part of the CRUD sprint. The lecture/ICE covered "Create" and "Read." This homework assignment is for students to build the "U" (Update) and "D" (Delete) functionality.

It follows the "Team Best" and "Complete Engineering Ticket" (feature + tests) model we established for `A09`.

-----

### Homework 5: The "U" & "D" (Edit & Delete Jokes) (Team Best)

  - **Objective:** Individually implement "Update" and "Delete" functionality for jokes, including authorization checks and unit tests.
  - **Due Date:** Friday, [Date] @ 11:59 PM
  - **Grading:** This is a 10-point "Team Best" assignment. Individual effort is required for full credit. An optional 2-point extra credit challenge is available.

-----

### The "Complete" CRUD Ticket

In the lecture and ICE, we built the "C" (Create) and "R" (Read) for our `Joke` model. This homework completes the engineering ticket. You must now add the "U" (Update) and "D" (Delete) functionality.

A user must be able to **edit** their own jokes (to fix a typo) and **delete** their own jokes (if they're not funny). Critically, a user must **never** be able to edit or delete a joke that *is not theirs*.

This assignment has **three core tasks**:

1.  **The "Update" Feature:** Build the `edit_joke` functionality.
2.  **The Links:** Add "Edit" links to the templates.
3.  **The Tests:** Write unit tests to prove your new feature works and is secure.

-----

### Core Task 1 (The "Update" Feature)

*(Every team member must complete this task on their own branch.)*

1.  **Create the Route:**
      * Open `moj/routes.py`.
      * Add a new route: `@app.route('/edit_joke/<int:joke_id>', methods=['GET', 'POST'])`.
      * **Note:** We are using `<int:joke_id>` to find the specific joke.
2.  **Add the Logic:** This is the most complex part of the sprint.
      * Add the `@login_required` decorator.
      * **Find the joke:** `joke = Joke.query.get_or_404(joke_id)`.
      * **Add Authorization:** Check if the user is the author: `if joke.author != current_user: abort(403)`.
      * **Reuse the Form:** We can reuse the `JokeForm`. Create an instance: `form = JokeForm()`.
      * **Handle `POST` (Update):**
          * If `form.validate_on_submit()`:
          * Update the joke's body: `joke.body = form.body.data`.
          * `db.session.commit()`.
          * `flash('Your joke has been updated!')`
          * `redirect(url_for('profile', username=current_user.username))`.
      * **Handle `GET` (Pre-populate):**
          * If it's a `GET` request, you must *pre-populate* the form with the joke's existing text.
          * `elif request.method == 'GET': form.body.data = joke.body`.
      * **Render:** `return render_template('edit_joke.html', title='Edit Joke', form=form)`.
3.  **Create the Template:**
      * Create a new file: `moj/templates/edit_joke.html`.
      * This template should be almost identical to `submit_joke.html`.
      * It needs to `{% extends "base.html" %}` and render the `form` provided by the route.

-----

### Core Task 2 (The Links)

*(Every team member must complete this task on their own branch.)*

Our pages (like `index.html` and `profile.html`) now need to link to our new "Edit" feature.

1.  **Open `moj/templates/profile.html`** (or `index.html`, or both).
2.  **Find** your `{% for joke in jokes %}` loop.
3.  **Inside the loop,** add a conditional link that *only* appears if the `current_user` is the `joke.author`:
    ```html
    <p>{{ joke.body }}</p>

    {% if joke.author == current_user %}
        <p><a href="{{ url_for('edit_joke', joke_id=joke.id) }}">Edit Joke</a></p>
    {% endif %}
    </div> {% endfor %}
    ```

-----

### Core Task 3 (The Test)

*(Every team member must complete this task on their own branch.)*

This is the "complete engineering ticket" step.

1.  **Open `tests/test_routes.py`**.
2.  **Add "YOU" Test:** Add a new test function, `def test_edit_joke(client, app):`.
      * **Setup:** Create a user, log them in, and create a joke.
      * **Action:** `POST` new data to the `/edit_joke/<joke_id>` route.
      * **Assert:** Check that the joke's `body` has been *changed* in the database.
3.  **Add AuthZ Test:** Add a new test, `def test_cannot_edit_others_joke(client, app):`.
      * **Setup:** Create *two users* (user\_a, user\_b). Create a joke authored by `user_a`. Log in as `user_b`.
      * **Action:** Try to `POST` to the `edit_joke` route for `user_a`'s joke.
      * **Assert:** Check that the response status code is `403` (Forbidden) and that the joke's body *was not* changed.

-----

### ⭐ Challenge (Optional +2 Extra Credit Points)

Implement the **"D" (Delete)** feature.

1.  **Create the Route:** Add `@app.route('/delete_joke/<int:joke_id>', methods=['POST'])`.
      * **Note:** This route should *only* accept `POST`. This is a security best-practice to prevent accidental deletion.
2.  **Add AuthZ:** Add `@login_required` and check `if joke.author != current_user: abort(403)`.
3.  **Add Logic:** Find the joke, `db.session.delete(joke)`, `db.session.commit()`, `flash('Joke deleted.')`, and `redirect` to the profile page.
4.  **Add the Link:** Add a "Delete" link/button in `edit_joke.html` or `profile.html`. This link *must* be inside a small `<form>` that uses `method="POST"`.
    ```html
    <form action="{{ url_for('delete_joke', joke_id=joke.id) }}" method="POST">
        <input type="submit" value="Delete This Joke" onclick="return confirm('Are you sure?');">
    </form>
    ```
5.  **Add the Test:** Add `test_delete_joke` and `test_cannot_delete_others_joke` to `tests/test_routes.py`.

-----

### "Team Best" Workflow & Submission

Follow the **"Team Best"** workflow. The final submission to Canvas is the **URL of the *final* PR** (from `hw5-edit-joke` into `main`).

1.  **`Repo Admin`:** Create the main feature branch: `hw5-edit-joke`.
2.  **All Team Members (Individual Work):**
      * Create your individual developer branch (e.g., `hw5-alice`) off the feature branch.
      * On your branch, complete **Core Tasks 1, 2, and 3**.
      * Open a Pull Request to merge *your* branch into the *team feature branch* (`hw5-edit-joke`).
3.  **Team Review (as a team):**
      * Look at all the individual PRs. Review each other's code.
      * **Vote to select the "Best" PR** (cleanest code, best tests, includes the EC).
4.  **`Repo Admin` (or `Process Lead`):**
      * **Merge** the *one* "Best" PR into the `hw5-edit-joke` branch.
      * **Close** all the other individual PRs.
      * Update the `CONTRIBUTIONS.md` log with the new template below.
      * Open the **final Pull Request** to merge `hw5-edit-joke` into `main`.
      * **Title:** `HW 5: Edit and Delete Joke Features`
      * Submit the URL for *this final PR* to Canvas.

-----

### `CONTRIBUTIONS.md` Log Entry

*(This log is the **critical evidence** for your individual grades)*

```markdown
#### HW 5: Edit and Delete Jokes (Team Best)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...

* **Individual PRs (Required for individual credit):**
    * `@github-userA`: [Link to their PR into the feature branch]
    * `@github-userB`: [Link to their PR into the feature branch]
    * `@github-userC`: [Link to their PR into the feature branch]
    * (etc...)

* **"Team Best" Selection:**
    * **Chosen PR:** [Link to the *one* PR that was merged]
    * **Justification:** [As a team, why did you pick this one? (e.g., "Cleanest implementation of AuthZ," "Tests were comprehensive," "Successfully implemented the Delete challenge.")]
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



## **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



