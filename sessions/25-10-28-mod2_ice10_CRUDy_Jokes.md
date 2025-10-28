# ICE10 - CRUDy Jokes companion

## **---- PROMPT ----**
```markdown
Let's move on to the ICE now.
```

Yes, we are ready.

Based on our plan, the lecture (`mod2_lec06_CRUDy_Jokes`) taught the "C" (Create) and the *simple* "R" (Read) pattern (showing *all* jokes).

This ICE is the logical "YOU" part, where students will build a more complex, filtered "Read" feature: the **User Profile Page**.

Here is the complete In-Class Exercise for Module 2, Lecture 6.

-----

### ICE 10: The "Profile Page" (A Filtered Read)

  - **Objective:** Implement a dynamic "Profile Page" that shows a specific user's info and *only* their jokes.
  - **Time Limit:** 35 minutes
  - **Context:** In the lecture, we built the "C" (Create) and a simple "R" (Read) for our jokes. That `index` page is a "global feed" showing *all* jokes. This ICE is about building a more complex, filtered "Read" feature. Your task is to build a Profile Page that is "aware" of who it's for, querying the database for a specific user and then finding *only* the jokes that belong to them.

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Profile Kit**. Assign these three roles immediately.

  * **`Repo Admin`:** (Git & Merge) Handles all Git operations (branching, merging, PR).
  * **`Process Lead`:** (Templating) Creates the new `profile.html` template. Modifies `_navigation.html` to add the new links.
  * **`Dev Crew`:** (Logic & Routes) Implements the new, dynamic `/profile/<username>` route in `moj/routes.py`.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. This is \<em\>not\</em\> a race and is \<em\>not\</em\> a public leaderboard. This is our private "Triage Dashboard" to help us see if you're blocked.\</p\> \<p\>All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (Branch Created)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (Profile Route Built)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Profile Template Built)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Part 4 Complete (Navigation Links Added)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

### Task Description: Building the Profile

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in ICE 9.

#### Phase 1: Branch (Repo Admin)

1.  **Pull:** Ensure you have the latest `main` branch.
2.  **Branch:** Create a new feature branch: `ice10-profile-page`.
3.  **Push:** Push the branch to the remote.
4.  *Announce to the team that the branch is ready.*

#### Phase 2: The Logic (WE 👩‍🏫) (Dev Crew)

This is a "WE do it together" task. This is the "brain" of the feature.

1.  **Pull:** `git pull` and `git checkout ice10-profile-page`.

2.  **Open:** Open `moj/routes.py`.

3.  **Add Route:** Add this new route to the *bottom* of the file. This route uses a **dynamic URL** to find a user.

    ```python
    # In moj/routes.py
    # ... (all your other imports and routes) ...

    @app.route('/profile/<username>') # <-- This is a dynamic route!
    @login_required
    def profile(username):
        """
        Shows a user's profile page, complete with their jokes.
        """
        # 1. Query for the user, or return a 404
        #    This is the "R" in CRUD for the User model.
        user = User.query.filter_by(username=username).first_or_404()

        # 2. Query for that user's jokes
        #    This is the "R" in CRUD for the Joke model, filtered!
        jokes = Joke.query.filter_by(author=user).order_by(Joke.timestamp.desc()).all()

        # 3. Pass the user and their jokes to the template
        return render_template('profile.html', user=user, jokes=jokes)

    ```

4.  **Commit:** `git add moj/routes.py` and `git commit -m "feat: add /profile/<username> route"`.

5.  *Announce to the `Process Lead` that the route is built and ready for its template.*

#### Phase 3: The Template (YOU 🫵) (Process Lead)

This is the "YOU do it" task. Your job is to create the template that the `profile` route just referenced.

1.  **Pull:** `git pull` to get the latest changes.

2.  **Create File:** Create a new file: `moj/templates/profile.html`.

3.  **Add Code:** Paste the following code. This is a "Read" (R) template, very similar to the `index.html` from the lecture.

    ```html
    {% extends "base.html" %}

    {% block content %}
        <h1>User Profile: {{ user.username }}</h1>
        <p>Email: {{ user.email }}</p>
        <p>Role: {{ user.role }}</p>
        
        <hr>
        
        <h2>Jokes by {{ user.username }}:</h2>
        
        {% for joke in jokes %}
            <div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
                <p>
                    <strong>{{ joke.author.username }}</strong> 
                    <span style="color: #888;">(on {{ joke.timestamp.strftime('%Y-%m-%d') }})</span>
                </p>
                <p>{{ joke.body }}</p>
            </div>
        {% else %}
            <p>{{ user.username }} has not submitted any jokes yet.</p>
        {% endfor %}

    {% endblock %}
    ```

4.  **Commit:** `git add moj/templates/profile.html` and `git commit -m "feat: create profile.html template"`.

5.  *Announce to the `Dev Crew` that the template is complete.*

#### Phase 4: The Links (YOU 🫵) (Process Lead)

The page exists, but no one can *find* it. Let's add links.

1.  **Open:** Open `moj/templates/_navigation.html`.
2.  **Add "My Profile" Link:** Find the `logout` link. Right *before* it, add a new link to the `current_user`'s profile:
    ```html
    <a href="{{ url_for('staff_lounge') }}">Staff Lounge</a>

    <a href="{{ url_for('profile', username=current_user.username) }}">My Profile</a>

    {% if current_user.role == 'admin' %}
    ```
3.  **Open:** Open `moj/templates/index.html`.
4.  **Make Usernames Clickable:** Find the line that prints `joke.author.username`. We'll turn that text into a link to that author's profile.
      * **Find this:**
        ```html
        <strong>{{ joke.author.username }}</strong>
        ```
      * **Replace it with this:**
        ```html
        <strong>
            <a href="{{ url_for('profile', username=joke.author.username) }}">
                {{ joke.author.username }}
            </a>
        </strong>
        ```
5.  **Commit:** `git add moj/templates/_navigation.html moj/templates/index.html` and `git commit -m "feat: add links to profile pages"`.

#### Phase 5: Log and Submit (Repo Admin)

1.  **Pull:** `git pull` to get all final changes.
2.  **Test:** Run the app (`flask run`) and test the full workflow:
      * Log in.
      * Click the new "My Profile" link in the navigation. Does it work?
      * Go to the `index` page. Click on a username. Does it take you to their profile?
3.  **Log:** Share your screen and fill out the `CONTRIBUTIONS.md` log.
4.  **Submit:** Commit the log, push the branch, and open a Pull Request. Submit the PR link to Canvas.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 10: The "Profile Page" (A Filtered Read)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew: `@github-userZ`
* **Summary of Work:** [1-2 sentence summary, e.g., "Created a new dynamic route `/profile/<username>`, built the `profile.html` template to render a user's jokes, and updated the navigation and index page to link to it."]
* **Evidence & Reflection:** Look at the `profile` route. What does the `.first_or_404()` method do? Why is this a better choice than `.first()`?
```

-----

### Definition of Done (DoD) 🏁

  * [ ] **Artifact (Route):** The `moj/routes.py` file has a new, dynamic `/profile/<username>` route.
  * [ ] **Artifact (Template):** The `moj/templates/profile.html` file exists and uses a `{% for %}` loop.
  * [ ] **Artifact (Links):** `_navigation.html` and `index.html` are updated with links to the profile page.
  * [ ] **Functionality:** Clicking the "My Profile" link successfully loads a page showing *only* the logged-in user's jokes.
  * [ ] **Functionality:** Clicking a username on the `index` page loads *that user's* profile.
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated.
  * [ ] **Submission:** A Pull Request is open with the title `ICE 10: The Profile Page`.

-----

### TA Guide & Rubric

  * **Goal:** This ICE tests two "Read" skills: fetching a *single object* (`User.query.first_or_404()`) and fetching a *filtered list* (`Joke.query.filter_by(author=user)`). It's the core of relational data.
  * **Common Pitfalls:**
    1.  **`AttributeError: 'NoneType' object has no attribute 'username'`:** This will happen if a student uses `.first()` instead of `.first_or_404()` for a user that doesn't exist. The reflection question is designed to make them catch this.
    2.  **`BuildError` (for `url_for`):** The `Process Lead` will get this error if they forget to pass `username=current_user.username` into the `url_for('profile', ...)` in `_navigation.html`. This is a key teaching moment about dynamic routes.
    3.  **`UndefinedError: 'user' is undefined`:** The `Dev Crew` built the route, but the `Process Lead` forgot to pull the changes before starting the template.

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)** | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
\+-------------------------------------------------------------+-----------------+
| **Profile Route Logic (4 pts)** | / 4             |
| - `moj/routes.py` has a new, dynamic `@app.route(...)`     |                 |
| - Route correctly queries for the `User` (using `first_or_404`).|               |
| - Route correctly queries for the filtered `Joke` list.     |                 |
\+-------------------------------------------------------------+-----------------+
| **Templates & Links (3 pts)** | / 3             |
| - `moj/templates/profile.html` exists and renders the user/jokes.|              |
| - `_navigation.html` has a working "My Profile" link.       |                 |
| - `index.html` has working links on author usernames.       |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

### Canvas-Optimized HTML Snippet

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 10">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>CONTRIBUTIONS.md</code> Log (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is completed with all fields (roles, summary).</li>
                    <li>Reflection question is answered thoughtfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Profile Route Logic (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>moj/routes.py</code> has a new, dynamic <code>@app.route(...)</code></li>
                    <li>Route correctly queries for the <code>User</code> (using <code>first_or_404</code>).</li>
                    <li>Route correctly queries for the filtered <code>Joke</code> list.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Templates &amp; Links (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>moj/templates/profile.html</code> exists and renders the user/jokes.</li>
                    <li><code>_navigation.html</code> has a working "My Profile" link.</li>
                    <li><code>index.html</code> has working links on author usernames.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
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
I don't see where the students are reviewing the unit tests we added to the starter kit.
```

You are absolutely right. I missed that explicit step.

We added `tests/test_auth.py` to the `ICE09_auth_kit` as "scaffolding" for the homework, but I never created a formal step for the students to stop and review it. They would hit the homework (`A09`) and we'd be *hoping* they found and understood the scaffolding, which is a poor pedagogical design.

This review **should not** be in **ICE 10**, because ICE 10 is about a *new* topic (CRUD/Profiles).

The **perfect** place for this is at the **very beginning of the `A09` (Homework 4) assignment**. It should be the first step in "Core Task 2 (The Tests)."

This makes the workflow:
1.  **ICE 9 (In-Class):** Students build the `login` and `register` routes. The test file (`tests/test_auth.py`) is in their kit, but they don't touch it.
2.  **A09 (Homework):**
    * **Task 1:** Build the `change_password` feature.
    * **Task 2, Step 1 (NEW):** As a team, **review the provided `tests/test_auth.py`**. Discuss how it works.
    * **Task 2, Step 2:** Write your "YOU" test (`test_change_password`) based on the "WE" patterns you just reviewed.

This creates a perfect I-WE-YOU arc for the testing skill.

Here is the updated "Core Task 2" for the `A09` (Homework 4) assignment.

---

### Core Task 2 (The Tests): AuthN Unit Tests
*(Every team member must complete this task on their own branch.)*

1.  **Review the "WE" Scaffolding (Team Task):**
    * Open `tests/test_auth.py` (which was in your ICE 9 Kit).
    * Before you write any code, **read and discuss** `test_register_new_user` and `test_login_and_logout_user`. This is your "worked example."
    * **Discuss:**
        * Why does `test_register_new_user` need `follow_redirects=True`?
        * What is `assert b'Congratulations' in response.data` testing?
        * Why does `test_login_and_logout_user` need the `app` fixture (Hint: check `conftest.py` and think about the database)?

2.  **Add "YOU" Test (Individual Task):**
    * Now, add your new test to `tests/test_auth.py`. You must write a test for your `change_password` feature, named `def test_change_password(client, app):`.
    * Use the patterns from the scaffolding: you will need to create/log in a user, `POST` to your `/change_password` route, and check that the password was successfully changed in the database.

## **---- PROMPT ----**
```markdown
This ICE has three active roles for a 4-5 member team. Anything we can specifically task to the other crew members. Can the workflow test confirmation be a parallel task for the other crew members. ?
```

Yes, this is an excellent observation. You've spotted the "idle hands" problem in this ICE, and your instinct to use testing as a parallel task is spot on.

Your specific proposal of "workflow test confirmation" is good, but it's hard to do in parallel when the feature isn't built yet.

A much stronger and more realistic parallel task is **writing the unit test for the new feature**. This perfectly models a "test-first" or "test-concurrent" professional workflow.

Here is the surgical update to the ICE 10 plan.

### 1\. Update the Role Kit

We will formally define the 4th/5th members' role in the Role Kit.

  * **`Repo Admin`:** (Git & Merge) Handles all Git operations.
  * **`Dev Crew` (Logic):** Implements the new `/profile/<username>` route in `moj/routes.py`.
  * **`Process Lead` (Templating):** Creates `profile.html` and updates the navigation links.
  * **`QA Crew` (Test):** (This is the 4th/5th member) Writes the new `pytest` for the `/profile` route in parallel.

### 2\. Add a Parallel Task: "Phase 2b"

While the `Dev Crew` is doing "Phase 2" and the `Process Lead` is doing "Phase 3," the `QA Crew` does this:

-----

#### Phase 2b: Write the Test (YOU 🫵) (QA Crew)

This is your "YOU do it" task. Your job is to write the automated test that *proves* the `Dev Crew`'s and `Process Lead`'s work is correct.

1.  **Pull:** `git pull` and `git checkout ice10-profile-page`.

2.  **Open:** Open the existing `tests/test_routes.py` file.

3.  **Add Test:** Add this new test function to the bottom of the file. This test will:

      * Create a test user and a test joke.
      * Log that user in.
      * Visit that user's new profile page.
      * Check that the response is `200` (OK).
      * Check that the page content contains the user's name and the body of their joke.

    <!-- end list -->

    ```python
    # In tests/test_routes.py
    from moj import db
    from moj.models import User, Joke

    # ... (existing test_hello_world) ...

    def test_profile_page(client, app):
        """
        GIVEN a logged-in user with one joke
        WHEN the user's profile page is requested (GET)
        THEN check that the user's info and their joke are displayed.
        """
        # 1. SETUP: Create a user and a joke
        with app.app_context():
            user = User(username='testuser', email='test@example.com')
            user.set_password('password')
            db.session.add(user)
            db.session.commit() # Must commit user to get their ID
            
            joke = Joke(body="This is a test joke.", author=user)
            db.session.add(joke)
            db.session.commit()

        # 2. LOGIN: Log the user in (use the login route)
        client.post('/login', data={
            'username': 'testuser',
            'password': 'password'
        }, follow_redirects=True)
        
        # 3. ACTION: Request the profile page
        response = client.get('/profile/testuser')
        
        # 4. ASSERT: Check the page content
        assert response.status_code == 200
        assert b"User Profile: testuser" in response.data
        assert b"This is a test joke." in response.data
    ```

4.  **Commit:** `git add tests/test_routes.py` and `git commit -m "test: add test_profile_page"`.

-----

### 3\. Update the Final "Test" Step

Now, in **Phase 5 (Log and Submit)**, the `Repo Admin`'s "Test" step is no longer just "manual clicking."

  * **New Step (Phase 5):**
    1.  **Pull:** `git pull` to get all final changes (the route, the template, *and* the test).
    2.  **Test:** Run the full test suite from the terminal:
        ```bash
        pytest
        ```
    3.  **Verify:** The new `test_profile_page` must **pass**. This is the team's "Definition of Done."
    4.  **Log:** Share screen and fill out `CONTRIBUTIONS.md`.
    5.  **Submit:** Commit the log, push, and open the PR.

This is a **10/10 solution**. It solves the "idle student" problem, introduces a professional TDD-like workflow, and makes the final "Definition of Done" far stronger and more evidence-based.


## **---- PROMPT ----**
```markdown
I also need the AAR report template for the ICE10
```

Here is the AAR (After-Action Report) template for ICE 10, including specific diagnostic hints for the "Profile Page" task.

This should be added to the `mod2_ice10_AuthZ_AuthN.md` file, inside the `Task Description` section, just like in our previous ICEs.

-----

### AAR Template (Standard Blocker Protocol)

**If you are blocked for \> 15 minutes,** invoke the SBP. Create a new file `aar/AAR-ICE10-<your_github_username>.md`, copy this template, and file a PR.

-----

```markdown
# AAR for ICE 10: [Blocker Title]

* **Student:** `@your-github-username`
* **Timestamp:** `2025-10-28 @ HH:MM`

---

### Instructor's Diagnostic Hints
* **Hint 1:** `BuildError: ... "profile" ... no such parameter "username"`?
    * This is a `url_for` error in your *template*.
    * Check `_navigation.html` (for "My Profile") or `index.html` (for the author link).
    * When you call `url_for('profile', ...)`, you **must** provide the dynamic part: `url_for('profile', username=user_object.username)`.

* **Hint 2:** `AttributeError: 'NoneType' object has no attribute 'username'`?
    * This is a common error in your `profile` *route* in `routes.py`.
    * You called `User.query.filter_by(username=username).first()`.
    * The username was invalid, so `user` is `None`. The template then "crashes" when it tries to access `user.username`.
    * **Fix:** Use `User.query.filter_by(username=username).first_or_404()`. This will automatically stop the route and return a 404 error if the user isn't found.

* **Hint 3:** `UndefinedError: 'user' is undefined`?
    * This is an error in your `profile` *route*.
    * Your `return render_template('profile.html', ...)` call is missing the `user=user` part.
    * The template is trying to access `{{ user.username }}`, but the variable was never passed in.

---

### 1. The Blocker
*(What is the *symptom*? What is the *exact* error message?)*

> [Paste error message or describe symptom]

### 2. The Investigation
*(What *exactly* did you try? List the commands you ran, files you edited, and Stack Overflow links you read.)*

* I tried...
* Then I edited...
* This Stack Overflow post suggested...

### 3. The Root Cause Hypothesis
*(Based on your investigation, what do you *think* is the real problem? Try to be specific.)*

> I believe the problem is...

### 4. Evidence
*(Paste the *full* terminal output, relevant code snippets, or screenshots that support your hypothesis.)*

    (Paste full logs here)


### 5. The "Aha!" Moment (if any)
*(Did you have a moment of clarity or discover the solution just as you were writing this?)*

> [Describe your realization, or N/A]

### 6. The Learning
*(What new, specific thing did you learn from this? What will you do *differently* next time?)*

> I learned that...

### 7. The Remaining Question
*(What do you *still* not understand? What is the *one key question* you need answered to get unblocked?)*

> My one question is...
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



