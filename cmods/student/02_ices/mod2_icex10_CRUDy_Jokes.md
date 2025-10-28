# ICE 10: The "Profile Page" (A Filtered Read)

  - **Objective:** Implement a dynamic "Profile Page" that shows a specific user's info and *only* their jokes.
  - **Time Limit:** 35 minutes
  - **Context:** In the lecture, we built the "C" (Create) and a simple "R" (Read) for our jokes. That `index` page is a "global feed" showing *all* jokes. This ICE is about building a more complex, filtered "Read" feature. Your task is to build a Profile Page that is "aware" of who it's for, querying the database for a specific user and then finding *only* the jokes that belong to them.

-----

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Profile Kit**. Assign these three roles immediately.

  * **`Repo Admin`:** (Git & Merge) Handles all Git operations (branching, merging, PR).
  * **`Process Lead`:** (Templating) Creates the new `profile.html` template. Modifies `_navigation.html` to add the new links.
  * **`Dev Crew`:** (Logic & Routes) Implements the new, dynamic `/profile/<username>` route in `moj/routes.py`.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. This is \<em\>not\</em\> a race and is \<em\>not\</em\> a public leaderboard. This is our private "Triage Dashboard" to help us see if you're blocked.\</p\> \<p\>All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (Branch Created)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (Profile Route Built)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Profile Template Built)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Part 4 Complete (Navigation Links Added)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

## Task Description: Building the Profile

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in ICE 9.

### Phase 1: Branch (Repo Admin)

1.  **Pull:** Ensure you have the latest `main` branch.
2.  **Branch:** Create a new feature branch: `ice10-profile-page`.
3.  **Push:** Push the branch to the remote.
4.  *Announce to the team that the branch is ready.*

### Phase 2: The Logic (WE 👩‍🏫) (Dev Crew)

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

### Phase 3: The Template (YOU 🫵) (Process Lead)

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

### Phase 4: The Links (YOU 🫵) (Process Lead)

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

### Phase 5: Log and Submit (Repo Admin)

1.  **Pull:** `git pull` to get all final changes.
2.  **Test:** Run the app (`flask run`) and test the full workflow:
      * Log in.
      * Click the new "My Profile" link in the navigation. Does it work?
      * Go to the `index` page. Click on a username. Does it take you to their profile?
3.  **Log:** Share your screen and fill out the `CONTRIBUTIONS.md` log.
4.  **Submit:** Commit the log, push the branch, and open a Pull Request. Submit the PR link to Canvas.

-----

## `CONTRIBUTIONS.md` Log Entry

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

## Definition of Done (DoD) 🏁

  * [ ] **Artifact (Route):** The `moj/routes.py` file has a new, dynamic `/profile/<username>` route.
  * [ ] **Artifact (Template):** The `moj/templates/profile.html` file exists and uses a `{% for %}` loop.
  * [ ] **Artifact (Links):** `_navigation.html` and `index.html` are updated with links to the profile page.
  * [ ] **Functionality:** Clicking the "My Profile" link successfully loads a page showing *only* the logged-in user's jokes.
  * [ ] **Functionality:** Clicking a username on the `index` page loads *that user's* profile.
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated.
  * [ ] **Submission:** A Pull Request is open with the title `ICE 10: The Profile Page`.

-----

<!-- PLACEHOLDER for RAW HTML  Rubric -->

-----

# TA Guide & Rubric

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

---

# Canvas-Optimized HTML Snippet

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

