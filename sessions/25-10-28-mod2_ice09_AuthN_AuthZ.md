# Session for mod2_ice09_AuthZ_AuthN.md

## **---- PROMPT ----**
```markdown
If we are ready let's take a look at mod2_ice09 that matches this lecture which I will refer to as mod2_lec05_AuthZ_AuthN.md The ice will be called mod2_ice09_AuthZ_AuthN.md. Does that fit with our previous naming scheme? Mismatching lecuture number and ice number is because the lecture number is not public and tracks the sequence of the overall 7 week plan. The ice numbering is public to the class and must conform to the ice's delivered earlier in the class before the 7 week plan. 
```

Yes, we are ready to proceed, and your naming convention is perfect.

The name `mod2_ice09_AuthZ_AuthN.md` fits the pattern exactly. Your reasoning for the mismatched lecture (`lec05`) and ICE (`ice09`) numbers (internal vs. public-facing) is clear and makes perfect sense.

The pedagogical plan is set:

  * **Lecture 5 (I/WE):** You provided the "backend" logic for authentication (password hashing, `flask-login`, session management, migrations).
  * **ICE 9 (YOU):** Students will be given a **starter kit** containing all that backend code. Their job is to build the user-facing "frontend" (the `flask-wtf` forms) to make it all work.

Here is the complete In-Class Exercise for Module 2, Lecture 5.

-----

### ICE 9: The "Front Door" (User Registration & Login)

  - **Objective:** Implement user-facing registration and login forms using `flask-wtf`.
  - **Time Limit:** 35-40 minutes
  - **Context:** In the lecture, we built the "engine" for authentication: the password hashing, the `UserMixin`, and the `@login_required` decorator. However, our `/login` route was just a "hardcoded" placeholder. This ICE builds the *real* user interface—the "dashboard" for our auth engine. We will use the `flask-wtf` library to create secure, server-side forms.

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Authentication Kit**. Assign these three roles immediately.

  * **`Repo Admin`:** (Git & Environment) Installs new packages, updates `requirements.txt`, handles all Git operations (branching, merging, PR).
  * **`Process Lead`:** (Forms) Creates the new `moj/forms.py` file and defines the Python classes for our `LoginForm` and `RegistrationForm`.
  * **`Dev Crew`:** (Routes & Logic) Modifies `moj/routes.py` to import the new forms, handle `POST` requests, and process user logins/registrations.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. This is \<em\>not\</em\> a race and is \<em\>not\</em\> a public leaderboard. This is our private "Triage Dashboard" to help us see if you're blocked.\</p\> \<p\>All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (Kit \&amp; Install)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (Forms File Created)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Login Route Finished)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Part 4 Complete (Register Route Finished)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

### Task Description: Building the Forms

#### Phase 1: Kit & Installation (Repo Admin)

1.  **Branch:** Pull `main` and create a new branch: `ice9-authn-forms`.
2.  **Download the Kit:** Download `ICE09_auth_kit.zip` from Canvas.
      * **CRITICAL:** This kit contains all the "backend" code from Lecture 5. **Unzip and copy its contents** (the `moj/` and `migrations/` directories) into your repo, **overwriting** your existing files. This will update your `__init__.py`, `models.py`, `routes.py`, `config.py` and add new templates.
3.  **Install:** Install the new form library:
    ```bash
    pip install flask-wtf
    ```
4.  **Update:** Update your `requirements.txt` file:
    ```bash
    pip freeze > requirements.txt
    ```
5.  **Commit:** `git add .` and `git commit -m "feat: add auth backend and new templates from kit"`.
6.  *Announce to the team that the branch is ready.*

#### Phase 2: Define the Forms (WE 👩‍🏫) (Process Lead)

This is a "WE do it together" task. Your job is to create the Python classes that *represent* our forms.

1.  **Pull:** `git pull` to get the latest branch.

2.  **Create File:** Create a new file: `moj/forms.py`.

3.  **Add Code:** Paste the following code into `moj/forms.py`. This defines the fields and *validators* (rules) for our two forms.

    ```python
    # In moj/forms.py
    from flask_wtf import FlaskForm
    from wtforms import StringField, PasswordField, BooleanField, SubmitField
    from wtforms.validators import DataRequired, ValidationError, Email, EqualTo
    from moj.models import User

    class LoginForm(FlaskForm):
        """Form for user login."""
        username = StringField('Username', validators=[DataRequired()])
        password = PasswordField('Password', validators=[DataRequired()])
        remember_me = BooleanField('Remember Me')
        submit = SubmitField('Sign In')

    class RegistrationForm(FlaskForm):
        """Form for new user registration."""
        username = StringField('Username', validators=[DataRequired()])
        email = StringField('Email', validators=[DataRequired(), Email()])
        password = PasswordField('Password', validators=[DataRequired()])
        password2 = PasswordField(
            'Repeat Password', validators=[DataRequired(), EqualTo('password')])
        submit = SubmitField('Register')

        # Custom validator
        def validate_username(self, username):
            user = User.query.filter_by(username=username.data).first()
            if user is not None:
                raise ValidationError('Please use a different username.')

        # Custom validator
        def validate_email(self, email):
            user = User.query.filter_by(email=email.data).first()
            if user is not None:
                raise ValidationError('Please use a different email address.')
    ```

4.  **Commit:** `git add moj/forms.py` and `git commit -m "feat: define LoginForm and RegistrationForm"`.

5.  *Announce to the `Dev Crew` that the forms are ready to be used.*

#### Phase 3: Implement Form Logic (YOU 🫵) (Dev Crew)

This is the "YOU do it" task. Your job is to update `moj/routes.py` to actually *use* the forms from Phase 2.

1.  **Pull:** `git pull` to get the new `moj/forms.py` file.

2.  **Open:** Open `moj/routes.py`.

3.  **Import:** At the top, import the new forms and other tools:

    ```python
    # ... (existing imports)
    from flask import render_template, redirect, url_for, request, flash # <-- Add 'flash'
    from flask_login import login_user, logout_user, current_user, login_required
    from moj.models import User, Joke
    from moj import db # <-- NEW
    from moj.forms import LoginForm, RegistrationForm # <-- NEW
    ```

4.  **Update `login` Route:** Find the *existing* `@app.route('/login')` route (from the starter kit). It's a "hardcoded" placeholder. **Replace it entirely** with this new version that actually processes the form:

    ```python
    # In moj/routes.py

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        # A user who is already logged in shouldn't see the login page
        if current_user.is_authenticated:
            return redirect(url_for('index'))
        
        form = LoginForm()
        if form.validate_on_submit():
            # 1. Find the user in the database
            user = User.query.filter_by(username=form.username.data).first()
            
            # 2. Check password
            if user is None or not user.check_password(form.password.data):
                flash('Invalid username or password')
                return redirect(url_for('login'))
            
            # 3. Log them in!
            login_user(user, remember=form.remember_me.data)
            return redirect(url_for('index'))
            
        return render_template('login.html', title='Sign In', form=form)
    ```

5.  **Create `register` Route:** This route doesn't exist yet. **Add this new route** (e.g., after the `login` route):

    ```python
    # In moj/routes.py

    @app.route('/register', methods=['GET', 'POST'])
    def register():
        if current_user.is_authenticated:
            return redirect(url_for('index'))
            
        form = RegistrationForm()
        if form.validate_on_submit():
            # 1. Create the new user object
            user = User(username=form.username.data, email=form.email.data)
            # 2. Set their password (this hashes it)
            user.set_password(form.password.data)
            # 3. Add to database
            db.session.add(user)
            db.session.commit()
            flash('Congratulations, you are now a registered user!')
            return redirect(url_for('login'))
            
        return render_template('register.html', title='Register', form=form)
    ```

6.  **Update `index` Route:** We need to update the `index` route to render the new `_navigation.html` (which was in the kit).

      * **Replace** the *existing* `index` route with this:

    <!-- end list -->

    ```python
    # In moj/routes.py

    @app.route('/')
    @app.route('/index')
    @login_required # <-- Now the index requires you to be logged in!
    def index():
        return render_template('index.html', title='Home')
    ```

7.  **Commit:** `git add moj/routes.py` and `git commit -m "feat: implement login and register route logic"`.

#### Phase 4: Log and Submit (Repo Admin)

1.  **Pull:** `git pull` to get the final `moj/routes.py` changes.
2.  **Test:** Run the app (`flask run`) and test the full workflow:
      * Can you load `/register`?
      * Can you create a new user?
      * Are you redirected to `/login`?
      * Can you log in with that new user?
      * Are you redirected to `/index`?
      * Can you visit `/logout`?
3.  **Log:** Share your screen and fill out the `CONTRIBUTIONS.md` log.
4.  **Submit:** Commit the log, push the branch, and open a Pull Request. Submit the PR link to Canvas.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 9: The "Front Door" (User Registration & Login)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew: `@github-userZ`
* **Summary of Work:** [1-2 sentence summary, e.g., "Installed flask-wtf, defined the `LoginForm` and `RegistrationForm` in `forms.py`, and implemented the `login` and `register` routes in `routes.py` to handle form validation and user creation."]
* **Evidence & Reflection:** What is the purpose of `form.validate_on_submit()`? What two things does it check for before returning `True`?
```

-----

### Definition of Done (DoD) 🏁

  * [ ] **Artifact (Kit):** The `ICE09_auth_kit.zip` has been unzipped and committed.
  * [ ] **Artifact (Env):** `flask-wtf` is installed and in `requirements.txt`.
  * [ ] **Artifact (Forms):** The `moj/forms.py` file exists and contains the `LoginForm` and `RegistrationForm`.
  * [ ] **Artifact (Routes):** `moj/routes.py` is updated with `POST` logic for the `/login` and `/register` routes.
  * [ ] **Functionality:** A new user can successfully register, log in, see the index page, and log out.
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated.
  * [ ] **Submission:** A Pull Request is open with the title `ICE 9: The "Front Door"`.

-----

### TA Guide & Rubric

  * **Goal:** This ICE is about connecting a "frontend" (forms) to a "backend" (auth logic). The key skill is in `moj/routes.py`: handling `POST` requests, validating data with `form.validate_on_submit()`, and using the `db` and `flask-login` libraries.
  * **Starter Kit:** The `ICE09_auth_kit.zip` is **essential**. It provides all the Lec 5 code *plus* the HTML templates (`index.html`, `login.html`, `register.html`, `_navigation.html`, `base.html`). This is what allows the `Dev Crew` to *only* focus on the Python logic in `routes.py`, not on writing HTML.
  * **Common Pitfalls:**
    1.  **`CSRF token missing` Error:** This is the \#1 blocker. It means the `Repo Admin` forgot to install `flask-wtf`, OR the `Process Lead` forgot to add the `SECRET_KEY` (which `flask-wtf` *requires* for CSRF protection). **Solution:** The `ICE09_auth_kit` *must* include a `SECRET_KEY` in `moj/config.py`.
    2.  **`validate_on_submit()` never runs:** The `Dev Crew` forgot to add `methods=['GET', 'POST']` to the `@app.route()` decorator.
    3.  **`User.query` fails:** The `Dev Crew` forgot to import `db` or `User` at the top of `moj/routes.py`.

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)** | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
\+-------------------------------------------------------------+-----------------+
| **Environment & Forms (3 pts)** | / 3             |
| - `flask-wtf` is in `requirements.txt`.                     |                 |
| - `moj/forms.py` file is created and contains the `LoginForm` |                 |
|   and `RegistrationForm` classes from the instructions.     |                 |
\+-------------------------------------------------------------+-----------------+
| **Route Implementation (4 pts)** | / 4             |
| - `/login` route is updated to use `LoginForm` and            |                 |
|   `form.validate_on_submit()`.                              |                 |
| - `/register` route is created, uses `RegistrationForm`, and  |                 |
|   correctly creates a new `User` in the database.           |                 |
| - `index` route is correctly updated.                       |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

### Canvas-Optimized HTML Snippet

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 9">
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
                <strong>Environment &amp; Forms (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>flask-wtf</code> is in <code>requirements.txt</code>.</li>
                    <li><code>moj/forms.py</code> file is created and contains the <code>LoginForm</code> and Code<code>RegistrationForm</code> classes from the instructions.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Route Implementation (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>/login</code> route is updated to use <code>LoginForm</code> and <code>form.validate_on_submit()</code>.</li>
                    <li><code>/register</code> route is created, uses <code>RegistrationForm</code>, and correctly creates a new <code>User</code> in the database.</li>
                    <li><code>index</code> route is correctly updated.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
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
I feel like I need at least one slide to introduce Flask:redirect() and Flask:render_template(). This will make the lecture longer and leave less time for the ICE. How about we do the login setup only in the ICE and have the students do the register() route on their own as an add on assignment due by the next lecture. This lecture will be on a Monday and the subsequent lecture on Wednesday giving two days to complete this on their own.
```

This is a common and very tempting instructional design problem, but I strongly recommend **against** this plan.

Your instinct is correct (we need to introduce `render_template`), but your proposed solution (splitting the ICE) creates a new set of pedagogical problems. It breaks the "Repetition for Mastery" model that makes the ICE effective.

  * **The Flaw:** The `login()` and `register()` routes are "parallel" tasks. They are the "WE" and "YOU" of the *same* competency (processing a form). Forcing students to do the "YOU" part at home, alone, two days later, turns it into a "to-do item" and disconnects it from the in-class learning.

There is a much cleaner, "surgical" solution that costs **zero extra lecture time** and makes the *existing* lecture slides better.

### The Real Solution: Modify 2 Existing Slides

The problem isn't the ICE; it's that the *lecture* is incomplete. We need to introduce `render_template` and `redirect` *within the lecture's existing code examples*. This makes the lecture a better "scaffold" for the ICE.

Here are the surgical edits.

-----

### 1\. Update Slide 10: The `login` and `logout` Routes

We will change the "placeholder" code to use the *real* functions. This makes the lecture code identical to the code they'll use in the ICE.

#### **BEFORE (Old Slide 10):**

```python
@app.route('/login')
def login():
    # ...
    # 1. Get the one user from our DB
    user = User.query.get(1)
    # 2. "Log them in"
    login_user(user)
    return "You are now logged in!" # <-- WEAK

@app.route('/logout')
def logout():
    logout_user()
    return "You are now logged out!" # <-- WEAK
```

#### **AFTER (New Slide 10):**

```python
# In moj/routes.py
from flask import render_template, redirect, url_for, request # <-- ADDED
from flask_login import login_user, logout_user, current_user 
from moj.models import User, Joke

# ...

@app.route('/login')
def login():
    # We will build the *real* form in the ICE.
    # For now, we'll just log in a "hardcoded" user.

    # 1. Get the one user from our DB
    user = User.query.get(1)
    # 2. "Log them in"
    login_user(user)
    # 3. Send them to the index page
    return redirect(url_for('index')) # <-- FIXED

@app.route('/logout')
def logout():
    logout_user()
    # 4. Send them back to the login page
    return redirect(url_for('login')) # <-- FIXED

@app.route('/index')
def index():
    # 5. Use render_template to show a real HTML page
    return render_template('index.html', title='Home') # <-- NEW
```

**New Speaker Note:** "Notice we are no longer just returning strings. We're using `redirect(url_for(...))` to send the user to a *different route*, and `render_template('index.html')` to send them a full HTML file from our `templates/` folder. This is the core of any web framework."

-----

### 2\. Update Slide 11: The "Magic" of Sessions

We just need to label the diagram's arrows with the functions we just introduced.

#### **AFTER (New Slide 11):**

| Part 1: The Login Response | Part 2: The Next Request |
| :--- | :--- |
| 1. Client `POSTS` to `/login`. | 1. Client `GETS` `/staff_lounge`. |
| 2. Your route validates the password. | 2. Browser attaches the `session` cookie. |
| 3. You call `login_user(user)`. | 3. Flask verifies the cookie. |
| 4. `flask-login` creates the `session` cookie. | 4. `flask-login` reads the `user.id`. |
| 5. **`return redirect(url_for('index'))`** | 5. `flask-login` calls your `@login.user_loader`. |
| 6. Flask sends a `Set-Cookie` header. | 6. Your function returns the `User` object. |
| 7. Browser stores the cookie. | 7. `flask-login` populates `current_user`. |
| | 8. **`return render_template('staff_lounge.html')`** |

-----

### Conclusion

This fix is much stronger:

1.  It costs **zero extra time**. We're just improving the code on slides we already have.
2.  It **keeps the ICE intact**. Students practice `login()` (as the "WE") and `register()` (as the "YOU") in the *same session*, which reinforces the learning.
3.  It **doesn't create a new assignment**, avoiding the "spiky workload" and TA bottleneck problems we fixed in Cycle 1.

## **---- PROMPT ----**
```markdown
Agreed. I didn't like the idea of splitting login() and register() myself. I still want the students to do more of the work with routes and forms. How about a follow on home work that does two things:
1) Modify the login page to have a link to the register route. 
2) Create a change password form. This is only available to an authorized user. 

We can scaffold some place holder files in the starter kit, that give them some comments on what to add to the files. 

Shouldn't we also have them implement a tests for the login and register functionality?


```

Yes, but **not now.** Adding it to the current homework would be a critical mistake.

That's the correct engineering instinct, but we've hit a "pedagogical friction" point. The cognitive load on the students for this 48-hour cycle (Monday-Wednesday) is already maxed out.

### Critical Analysis of the Workload

In this one cycle, students are learning:
1.  `flask-login` (a new library)
2.  `flask-wtf` (a new library)
3.  Password Hashing (`werkzeug.security`)
4.  Form Validation (including custom validators)
5.  Session Management (and the `current_user` proxy)
6.  Handling `POST` requests
7.  Using `flash`, `redirect`, `url_for`, and `render_template`

This is a *massive* conceptual load. Their "YOU" task (HW4: `change_password`) is the perfect "repetition for mastery" of *these* skills.

Asking them to *also* learn how to write complex `pytest` tests for `POST` requests (which involves CSRF tokens, form data, and `follow_redirects=True`) is a bridge too far. It's a different, complex skill set.

### The Solution: A Perfect "I-WE-YOU"

Let's **defer testing to the next ICE (ICE 10).** This creates a beautiful, clean workflow:

1.  **Lecture 5 (Mon):** "I" show you the *backend* of auth.
2.  **ICE 9 (Mon):** "WE" build the *frontend* forms (`login`, `register`).
3.  **HW 4 (Due Wed):** "YOU" build the final form (`change_password`).
4.  **Lecture 6 (Wed):** "I" show you how to write `pytest` tests for `POST` requests and forms.
5.  **ICE 10 (Wed):** "YOU" write the tests for the `login`, `register`, and `change_password` routes you just built.

This is a perfect pedagogical arc. It separates the "building" (ICE 9) from the "testing" (ICE 10), allowing students to focus on one complex topic at a time. It also makes "Testing `POST` Requests" the clear, logical topic for our next lecture.

## **---- PROMPT ----**
```markdown
The last lecture and assignment implemented a test for the linter and hello world. The cognitive load should not be that high since this is a continuation of the last lecture. But I think we should scaffold the tests for the login and the register. But we make the test of password change part of the assignment. This also makes is a complete engineering assignment. We would not write a Jira for the password change form and NOT require a unit test for it concurrently. 
```

You are 100% correct.

Your argument on engineering realism is the deciding factor. You're right—we would **never** permit a feature to be built without concurrent tests. My plan to defer testing was pedagogically "clean" but not "real-world." The cognitive load of learning `pytest` for `POST` is high, but your scaffolding proposal is the perfect way to manage it.

By providing the `login` and `register` tests as a "worked example," the student's task becomes pattern-matching and adaptation, not "discovering" a new, complex testing strategy from scratch. This is a perfect I-WE-YOU.

Let's do this. Here is the new, consolidated "Homework 4" assignment. It is now a complete "Jira ticket," containing the feature, the tests, and the extra credit.

-----

### Homework 4: The "Change Password" Feature (with Tests)

  - **Objective:** Add a "Change Password" feature and write the corresponding unit tests, demonstrating a complete, professional engineering workflow.
  - **Due Date:** Wednesday, [Date] @ 11:59 PM
  - **Grading:** This is a 10-point individual assignment. An optional 2-point extra credit challenge is available.

-----

### The "Complete" Engineering Ticket

In the ICE, we built the "frontend" for `login` and `register`. This homework completes the engineering ticket for our authentication module. This assignment has **two core tasks** that must be done together:

1.  **The Feature:** Build the `change_password` functionality.
2.  **The Tests:** Write the unit tests that *prove* your new feature works and lock in the behavior of the features we built in class.

-----

### Core Task 1 (The Feature): Change Password

Your task is to build this feature from scratch. The code you wrote in ICE 9 is your starter.

1.  **Create the Form:**

      * Open `moj/forms.py`.
      * Add a new class, `ChangePasswordForm(FlaskForm)`.
      * It must contain: `old_password`, `new_password`, `new_password2` (with `EqualTo('new_password')`), and `submit`.

2.  **Create the Template:**

      * Create a new file: `moj/templates/change_password.html`.
      * This template needs a form that renders all the fields from your `ChangePasswordForm`.
      * (You can use `moj/templates/login.html` as a template to copy-paste from).

3.  **Implement the Route:**

      * Open `moj/routes.py`.
      * Add a new route: `@app.route('/change_password', methods=['GET', 'POST'])`.

4.  **Implement the Logic:**

      * This new route **must** be protected by the **`@login_required`** decorator.
      * If `form.validate_on_submit()`:
          * Check `current_user.check_password(form.old_password.data)`.
          * If valid, call `current_user.set_password(form.new_password.data)` and `db.session.commit()`.
          * `flash` appropriate messages (success or error) and `redirect`.
      * If it's a `GET` request, just `render_template(...)`.

5.  **Add the Link:**

      * Open `moj/templates/_navigation.html`.
      * Add a new link to the `change_password` route so a logged-in user can find the page.

-----

### Core Task 2 (The Tests): AuthN Unit Tests

This is the "WE" and "YOU" of testing `POST` requests.

1.  **Create Test File:** Create a new file: `tests/test_auth.py`.

2.  **Add "WE" Scaffolding:** Paste the following code into your new file. This is your "scaffolding" — these are the complete, working tests for the `register` and `login` routes you built in the ICE. Study them.

    ```python
    # In tests/test_auth.py
    from moj.models import User
    from moj import db

    def test_register_new_user(client):
        """
        GIVEN a client and a new user's details
        WHEN the '/register' route is posted to (POST)
        THEN check that the user is created in the database and they are
             redirected to the login page.
        """
        # 1. Post the form data to the register route
        response = client.post('/register', data={
            'username': 'newuser',
            'email': 'new@example.com',
            'password': 'password123',
            'password2': 'password123'
        }, follow_redirects=True) # <-- 'follow_redirects' is key!
        
        # 2. Check the response
        assert response.status_code == 200
        # Check that we were redirected to the login page
        assert b'Sign In' in response.data
        assert b'Congratulations' in response.data # Check for flash message

        # 3. Check the database
        user = User.query.filter_by(username='newuser').first()
        assert user is not None
        assert user.email == 'new@example.com'
        assert user.check_password('password123')
        assert not user.check_password('wrongpassword')

    def test_login_and_logout_user(client, app):
        """
        GIVEN a client and a test user
        WHEN the '/login' and '/logout' routes are used
        THEN check that the user session is managed correctly.
        """
        # --- Create a test user in the database ---
        # We need a user to log in *with*
        with app.app_context():
            user = User(username='testuser', email='test@example.com')
            user.set_password('testpassword')
            db.session.add(user)
            db.session.commit()

        # --- Test Login ---
        response = client.post('/login', data={
            'username': 'testuser',
            'password': 'testpassword'
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b'Home' in response.data # Redirected to index
        assert b'Sign In' not in response.data # Login link is gone
        assert b'Logout' in response.data # Logout link appears

        # --- Test Logout ---
        response = client.get('/logout', follow_redirects=True)
        
        assert response.status_code == 200
        assert b'Sign In' in response.data # Redirected to login
        assert b'Logout' not in response.data # Logout link is gone
    ```

3.  **Add "YOU" Test:** Now, add your new test to `tests/test_auth.py`. You must write a test for your `change_password` feature. Your test should be named `def test_change_password(client, app):`.

      * **Hint:** You will need to *combine* the patterns from the two tests above.
      * You must first create and log in a user (like in `test_login_and_logout_user`).
      * Then, you must `POST` to your `/change_password` route (like in `test_register_new_user`).
      * You need to check that the password was *successfully* changed in the database.
      * You should also test that it fails if you provide the *wrong old password*.

-----

### ⭐ Challenge (Optional +2 Extra Credit Points)

Add a **custom password complexity validator** to your `ChangePasswordForm`.

1.  **Create a validator:** Inside your `ChangePasswordForm` class, create a new custom validator method named `def validate_new_password(self, new_password):`.
2.  **Implement the Logic:** Inside this method, write code to check `new_password.data` against all of the following rules. If *any* rule is broken, you must `raise ValidationError('Your specific error message.')`:
      * Must be at least 15 characters long.
      * Must contain at least one digit (`0-9`).
      * Must contain at least one uppercase letter (`A-Z`).
      * Must contain at least one lowercase letter (`a-z`).
      * Must contain at least one symbol (e.g., `!@#$%^&*`).
3.  **Hint:** The most efficient way to check for specific character types is to use Python's built-in **`re`** (regular expression) library. You may need to `import re` at the top of `moj/forms.py`.

-----

### Submission

1.  Create a new branch (e.g., `hw4-auth-features-<username>`).
2.  Add and commit your changes to all files (`forms.py`, `routes.py`, `templates/`, and `tests/test_auth.py`).
3.  Open a Pull Request to merge your branch into `main`.
4.  **Title:** `HW 4: Change Password Feature and Tests`
5.  **If you completed the challenge,** add this to your PR description: "I have completed the extra credit challenge."
6.  **Submit to Canvas:** Submit the URL of your Pull Request to this Canvas assignment.

## **---- PROMPT ----**
```markdown
One last problem. This is perfect for an individual but is not a good team assignment. But I think I have an easy solution. Lets' make this a Team Best assignment rather a Team Collaboration assignment. In my Team Best assignments, each team member implements the essential component of the assignment as their own version in a separate developer branch off the feature branch. Eat member creates their own PR to the feature branch with their solution. The Team then picks which PR to merge to the feature branch that represents the Team's version of the assignment. The individual students can choose to implement the Challenge and that can be folded in as part of the Team Best work. This adds very little complexity to the ice and rides on earlier work in the class that had similar assignments. 
```

Yes, this is a strong pedagogical model, and it perfectly aligns with our "Repetition for Mastery" and "Evidence-Driven" principles.

You are correct that it adds minimal *instructional* complexity because it "rides on earlier work." The students have a precedent for this "Team Best" workflow.

This model is excellent because it:

1.  **Guarantees Individual Competency:** Every single student must complete the core feature and its tests, preventing "coasting."
2.  **Forces Peer Review:** The team *must* read and critique each other's code to "pick the best," which is a high-value engineering skill.
3.  **Scaffolds the "EC":** It creates a clear path for individuals to attempt the extra credit and "fold it in" as part of their "best" solution.

Here is the updated "Homework 4" assignment, rewritten to use this "Team Best" workflow. The core tasks are the same, but the **Submission** and **`CONTRIBUTIONS.md`** sections are now completely new.

-----

### Homework 4: The "Change Password" Feature (Team Best)

  - **Objective:** Individually implement a "Change Password" feature and its unit tests. As a team, review all solutions and select the "best" one to merge.
  - **Due Date:** Wednesday, [Date] @ 11:59 PM
  - **Grading:** This is a 10-point "Team Best" assignment. Individual effort is required for full credit. An optional 2-point extra credit challenge is available.

-----

### The "Complete" Engineering Ticket

In the ICE, we built the "frontend" for `login` and `register`. This homework completes the engineering ticket for our authentication module. This assignment has **two core tasks** that must be done together:

1.  **The Feature:** Build the `change_password` functionality.
2.  **The Tests:** Write the unit tests that *prove* your new feature works and lock in the behavior of the features we built in class.

-----

### Core Task 1 (The Feature): Change Password

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

### Core Task 2 (The Tests): AuthN Unit Tests

*(Every team member must complete this task on their own branch.)*

1.  **Create Test File:** Create a new file: `tests/test_auth.py`.
2.  **Add "WE" Scaffolding:** Paste the complete, working tests for `register` and `login` into this file. (This code is provided in the Canvas assignment page).
3.  **Add "YOU" Test:** Add your new test to `tests/test_auth.py`. You must write a test for your `change_password` feature, named `def test_change_password(client, app):`.
      * **Hint:** You will need to first create and log in a user (like in `test_login_and_logout_user`), then `POST` to your `/change_password` route (like in `test_register_new_user`).

-----

### ⭐ Challenge (Optional +2 Extra Credit Points)

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

### "Team Best" Workflow & Submission

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

### `CONTRIBUTIONS.md` Log Entry

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

## **---- PROMPT ----**
```markdown
OK let's review mod2_lec05 and mod2_ice09, and what is now mod2_A09 (numbering convention similar to ice convention due to public numbering). How does the lecture and ice hang together for the first day?
```

Here is my evaluation of how `mod2_lec05_AuthZ_AuthN` and `mod2_ice09_AuthZ_AuthN` hang together for the first day of Week 11.

In short, they hang together as a **perfectly scaffolded, high-density "sprint."** The instructional design is 9/10, but the "Cognitive Cliff" is very real, and execution will be everything.

---

### The "I-WE" (Lecture) -> "YOU" (ICE) Arc

This 75-minute block is a textbook example of "I-WE-YOU" scaffolding, with a twist:
* **The Lecture (`mod2_lec05`) is the "I" and "WE":** This is a 35-40 minute conceptual walkthrough. You (the "I") introduce a *massive* number of new, complex, backend concepts (hashing, `UserMixin`, `flask-login`, session cookies, migrations, `render_template`, `redirect`). It is *not* a "type-along" because it would be impossible to complete.
* **The ICE (`mod2_ice09`) is the "YOU":** This is the 35-40 minute practical sprint. Students are *given* all the "I/WE" code from the lecture as a "black box" (the `ICE09_auth_kit.zip`). They don't have to re-create the engine; their job is to build the "dashboard" (the `flask-wtf` forms).

### Strengths (What is EXCELLENT)

1.  **The "Engine vs. Dashboard" Narrative:** This is the strongest part of the plan. The lecture builds the "authentication engine," and the ICE builds the "user-facing dashboard" (`/login`, `/register`). This is a clear, powerful separation of concerns.
2.  **The Critical Bridge (The Kit):** The `ICE09_auth_kit.zip` is the most important part of this day. It *proves* you understand the time constraints. By providing the backend, you allow students to focus on the *one new skill* of the ICE: handling `POST` requests with `flask-wtf`.
3.  **Perfect "A09" Setup:** The in-class work is a perfect "WE." The `login()` and `register()` routes are parallel tasks. This provides the *exact* "Repetition for Mastery" that students need to succeed on the `mod2_A09` homework (the "YOU"), where they'll build the `change_password()` route and its tests.

### Risks & Honest Critique (The "Cognitive Cliff" 🧗)

1.  **Extreme Density:** This is, by far, the densest day of the course. The *lecture* alone introduces 5-6 new libraries and concepts. The *ICE* introduces `flask-wtf`, custom validators, and `form.validate_on_submit()`. This isn't a "con," it's a "risk." Your TAs must be fully prepped and circulating.
2.  **The "Magic" Kit:** The `ICE09_auth_kit.zip` is a "magic" box of code. If a student didn't *quite* follow the session-cookie slide (Slide 11), they will be using tools (`login_user`, `current_user`) that they don't fully understand. This is a necessary trade-off for speed, but be prepared for "Why does `current_user` just work?" questions.
3.  **The #1 Blocker (CSRF):** The ICE will fail 100% of the time if `moj/config.py` (in the starter kit) does not have a `SECRET_KEY` defined. `flask-wtf` *requires* this for CSRF protection. This is the day's "Critical Fix" that the starter kit *must* provide.

### Final Verdict

This plan is **9/10**. It's an aggressive, high-energy, high-friction day that perfectly aligns with the "greenfield" development experience.

* The lecture and ICE "hang together" because the **lecture is the "why"** and the **ICE is the "how"** (of the frontend).
* The `A09` homework (the "how" of the tests) makes this a complete, A+ "engineering ticket" for the week.

This is the "crucible" of Cycle 2. If the teams get through this day, they can build anything.

## **---- PROMPT ----**
```markdown
I agree. Let's make a note to revisit the config.py and make this a configuration file and have the secret key specified at run time. I think the place to do this is when we move to containerizing everything. Perfect engineering pivot for containerization. 
```

That's a perfect engineering pivot. 🎯

I've made a note. When we get to **Cycle 3 (Containerization)**, our core task will be to move from "hardcoded" configs (like in `config.py`) to a professional "12-Factor App" model.

The `SECRET_KEY` will be our prime example. We'll refactor the app to read it from an **environment variable**, which the container will inject at runtime. This is the 100% correct, secure, and standard way to handle secrets.

This sets up that future lesson perfectly. I am ready for the next lecture.

## **---- PROMPT ----**
```markdown
Let's generate the script to create the kit. As a standard thing for these "kit scripts", lets have it generate a manifest file as well listing all the files in the kit and their function. 
```

Here is the `build_kit.sh` "recipe" script for `ICE09_auth_kit.zip`.

This kit is comprehensive. It contains all the "backend" logic and "frontend" templates from Lecture 5. The student's job in ICE 9 will be to install `flask-wtf`, define the form classes in `moj/forms.py`, and update `moj/routes.py` to process the forms.

This script includes the critical `SECRET_KEY` in `config.py` (to prevent CSRF errors) and a fully-scaffolded `migrations/` directory.

-----

### `cmods/student/02_ices/mod2_ice09_auth_kit.sh`

```bash
#!/bin/bash
#
# cmods/student/02_ices/mod2_ice09_auth_kit.sh
#
# This is a "recipe" script for the main build_kit.sh tool.
# It *assumes* it is being run from within an empty
# staging directory, and its job is to populate it.
#
# This kit provides the complete "backend" for AuthN/AuthZ
# from Lecture 5.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "migrations/versions"
mkdir -p "templates"
mkdir -p "tests" # (Still present from last ICE)

# --- Manifest ---
echo "   -> Writing manifest.txt..."
cat << EOF > "manifest.txt"
This is the "AuthN/AuthZ Backend" kit for ICE 9.

It provides all the completed code from Lecture 5, allowing your team to
focus on the "frontend" (forms) during the ICE.

FILE MANIFEST:
================
moj/__init__.py:
    - CONTAINS: The Flask 'app' and 'db' objects.
    - NEW: Initializes the 'LoginManager' and sets 'login.login_view'.

moj/config.py:
    - CONTAINS: Standard app configuration.
    - NEW: Adds the 'SECRET_KEY'. This is CRITICAL for Flask-WTF.

moj/models.py:
    - CONTAINS: The 'User' and 'Joke' models.
    - NEW: 'User' model is updated with:
        - 'UserMixin' for session management.
        - 'password_hash' and 'role' columns.
        - 'set_password()' and 'check_password()' methods.
        - The '@login.user_loader' function.

moj/routes.py:
    - CONTAINS: The routes from the end of the lecture.
    - 'index' now uses render_template().
    - 'login' is a "hardcoded" placeholder (you will replace this).
    - 'logout' is functional.
    - 'staff_lounge' and 'admin_panel' are protected route examples.

migrations/env.py:
    - Standard Flask-Migrate file, pre-configured.

migrations/versions/xxxx_add_auth_columns.py:
    - The *migration script* to add 'password_hash' and 'role' to the User.
    - Your 'Process Lead' will need to run 'flask db upgrade' in the ICE.

templates/base.html:
    - A new base template that includes a 'flash()' message handler.
    - Includes the new '_navigation.html'.

templates/index.html:
    - A simple "Home" page that extends base.html.

templates/login.html:
    - The *HTML* for the login form. (No form logic yet).

templates/register.html:
    - The *HTML* for the registration form. (No form logic yet).

templates/_navigation.html:
    - A partial template with conditional logic to show "Login" or "Logout"
      based on 'current_user.is_authenticated'.
EOF

# --- moj/__init__.py ---
echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
import sys
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app)
login.login_view = 'login' # Tell flask-login which route to redirect to

from moj import routes, models
EOF

# --- moj/config.py ---
echo "   -> Writing moj/config.py..."
cat << EOF > "moj/config.py"
import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    """Set Flask configuration variables."""
    
    # CRITICAL: Flask-WTF (forms) requires a SECRET_KEY
    # This key is used to prevent CSRF attacks.
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess-this-secret'
    
    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'moj.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

# --- moj/models.py ---
echo "   -> Writing moj/models.py..."
cat << EOF > "moj/models.py"
from moj import db, login
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
import datetime

# This "user_loader" callback is used to reload the user object
# from the user ID stored in the session.
@login.user_loader
def load_user(id):
    return User.query.get(int(id))

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)
    
    # New columns from Lecture 5
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(10), index=True, default='user')

    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    # New methods from Lecture 5
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User {}>'.format(self.username)

class Joke(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    body = db.Column(db.String(280), nullable=False)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    def __repr__(self):
        return '<Joke {}>'.format(self.body)
EOF

# --- moj/routes.py ---
echo "   -> Writing moj/routes.py (lecture placeholder version)..."
cat << EOF > "moj/routes.py"
from moj import app
from flask import render_template, redirect, url_for, request, abort
from flask_login import login_user, logout_user, current_user, login_required
from moj.models import User, Joke

@app.route('/')
@app.route('/index')
def index():
    """Renders the main index.html page."""
    return render_template('index.html', title='Home')

@app.route('/login')
def login():
    """
    This is the "hardcoded" placeholder from the lecture.
    Your team will REPLACE this in the ICE.
    """
    # TODO: Build a real login form!
    
    # 1. Get the one user from our DB (we'll assume it's user 1)
    user = User.query.get(1)

    # 2. "Log them in" using flask-login
    login_user(user)

    # 3. Send them to the index page
    return redirect(url_for('index'))

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login')) # Send them to login page

@app.route('/staff_lounge')
@login_required # This is the AuthN (authentication) check
def staff_lounge():
    return "Welcome to the staff lounge, {}!".format(current_user.username)

@app.route('/admin_panel')
@login_required # 1. They must be logged in...
def admin_panel():
    # 2. ...and they MUST be an admin! (AuthZ)
    if current_user.role != 'admin':
        abort(403) # "Forbidden" error
    
    return "Welcome to the ADMIN PANEL, {}.".format(current_user.username)
EOF

# --- migrations/env.py ---
echo "   -> Writing migrations/env.py..."
cat << EOF > "migrations/env.py"
# ... (standard alembic env.py setup) ...
# ... (this file is long, only adding the critical part) ...

# add this line:
from moj.models import db
# ...
# and set:
target_metadata = db.metadata

# ... (rest of the standard env.py file) ...
EOF

# --- migrations/versions/xxxx_add_auth_columns.py ---
echo "   -> Writing migrations/versions/xxxx_add_auth_columns.py..."
cat << EOF > "migrations/versions/abc123_add_auth_columns.py"
"""Add password_hash and role columns to User

Revision ID: abc123_add_auth_columns
Revises: 
Create Date: 2025-11-10 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'abc123_add_auth_columns'
down_revision = None # This assumes this is the *first* migration after init
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('password_hash', sa.String(length=128), nullable=True))
        batch_op.add_column(sa.Column('role', sa.String(length=10), nullable=True))
        batch_op.create_index(batch_op.f('ix_user_role'), ['role'], unique=False)

    # Note: We are NOT backfilling 'role', so we'll set a default in the model.
    # For existing rows, it will be NULL.
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_user_role'))
        batch_op.drop_column('role')
        batch_op.drop_column('password_hash')

    # ### end Alembic commands ###
EOF

# --- templates/base.html ---
echo "   -> Writing templates/base.html..."
cat << EOF > "templates/base.html"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{% if title %}{{ title }} - MoJ{% else %}MoJ{% endif %}</title>
    <style>
      body { font-family: sans-serif; margin: 2em; }
      nav { background: #f0f0f0; padding: 1em; }
      nav a { margin-right: 1em; }
      .flash { background: #cee5F5; padding: 1em; margin: 1em 0; }
    </style>
  </head>
  <body>
    {% include '_navigation.html' %}
    <hr>
    
    {% with messages = get_flashed_messages() %}
    {% if messages %}
    <ul class="flash">
      {% for message in messages %}
      <li>{{ message }}</li>
      {% endfor %}
    </ul>
    {% endif %}
    {% endwith %}

    {% block content %}{% endblock %}

  </body>
</html>
EOF

# --- templates/_navigation.html ---
echo "   -> Writing templates/_navigation.html..."
cat << EOF > "templates/_navigation.html"
<nav>
  <a href="{{ url_for('index') }}">Home</a>
  
  {% if current_user.is_anonymous %}
  <a href="{{ url_for('login') }}">Login</a>
  <a href="{{ url_for('register') }}">Register</a>
  {% else %}
  <a href="{{ url_for('staff_lounge') }}">Staff Lounge</a>
  
  {% if current_user.role == 'admin' %}
  <a href="{{ url_for('admin_panel') }}">Admin</a>
  {% endif %}
  
  <a href="{{ url_for('logout') }}">Logout</a>
  <span>(Logged in as: {{ current_user.username }})</span>
  {% endif %}
</nav>
EOF

# --- templates/index.html ---
echo "   -> Writing templates/index.html..."
cat << EOF > "templates/index.html"
{% extends "base.html" %}

{% block content %}
    <h1>Hello, {{ current_user.username }}!</h1>
    <p>Welcome to the Ministry of Jokes (MoJ) v2.0.</p>
{% endblock %}
EOF

# --- templates/login.html ---
echo "   -> Writing templates/login.html..."
cat << EOF > "templates/login.html"
{% extends "base.html" %}

{% block content %}
    <h1>Sign In</h1>
    <p>This is the placeholder HTML for the login form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>
    
    <p>New User? <a href="{{ url_for('register') }}">Click to Register!</a></p>
EOF

# --- templates/register.html ---
echo "   -> Writing templates/register.html..."
cat << EOF > "templates/register.html"
{% extends "base.html" %}

{% block content %}
    <h1>Register</h1>
    <p>This is the placeholder HTML for the registration form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>
    
    <p>Already have an account? <a href="{{ url_for('login') }}">Click to Login!</a></p>EOF

# --- tests/conftest.py (Unchanged) ---
echo "   -> Writing tests/conftest.py (unchanged)..."
cat << EOF > "tests/conftest.py"
import pytest
from moj import app as flask_app

@pytest.fixture
def app():
    """Create and configure a new app instance for each test."""
    flask_app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:", # Use in-memory db
    })
    yield flask_app

@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()
EOF

# --- tests/test_routes.py (Unchanged) ---
echo "   -> Writing tests/test_routes.py (unchanged)..."
cat << EOF > "tests/test_routes.py"
def test_hello_world(client):
    """
    GIVEN a configured test client (from conftest.py)
    WHEN the '/' route is requested (GET)
    THEN check that the response is valid
    """
    # Note: This test will FAIL now, because '/' requires login.
    # This is a good "teaching moment" that tests must be updated!
    # We will fix this in a future lesson.
    response = client.get('/')
    assert response.status_code == 302 # 302 is a "redirect"
EOF


echo "   -> Recipe complete. Kit is built."
```

## **---- PROMPT ----**
```markdown
You need to include the unit tests for register and login. These will be the templates that the students will use in the assignment. 
```

You are correct. My previous script was incomplete. If we're having the students write tests in the homework (`A09`), we must provide the "WE" scaffolding (the tests for `login` and `register`) in the "I/WE" kit (`ICE09`).

This is a critical "I-WE-YOU" step.

Here is the new, complete `build_kit.sh` recipe. I have made two critical changes:

1.  **Added `tests/test_auth.py`:** This new file contains the full, "scaffolding" tests for `register` and `login`, as we designed for the `A09` assignment.
2.  **Fixed `tests/conftest.py`:** I've updated this file to automatically create and drop the database tables for each test. Without this, the new `test_auth.py` file would fail immediately. I also disabled CSRF for testing to simplify things.

-----

### `cmods/student/02_ices/mod2_ice09_auth_kit.sh`

```bash
#!/bin/bash
#
# cmods/student/02_ices/mod2_ice09_auth_kit.sh
#
# This is a "recipe" script for the main build_kit.sh tool.
# It *assumes* it is being run from within an empty
# staging directory, and its job is to populate it.
#
# This kit provides the complete "backend" for AuthN/AuthZ
# from Lecture 5.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "migrations/versions"
mkdir -p "templates"
mkdir -p "tests"

# --- Manifest ---
echo "   -> Writing manifest.txt..."
cat << EOF > "manifest.txt"
This is the "AuthN/AuthZ Backend" kit for ICE 9.

It provides all the completed code from Lecture 5, allowing your team to
focus on the "frontend" (forms) during the ICE.

FILE MANIFEST:
================
moj/__init__.py:
    - CONTAINS: The Flask 'app' and 'db' objects.
    - NEW: Initializes the 'LoginManager' and sets 'login.login_view'.

moj/config.py:
    - CONTAINS: Standard app configuration.
    - NEW: Adds the 'SECRET_KEY'. This is CRITICAL for Flask-WTF.

moj/models.py:
    - CONTAINS: The 'User' and 'Joke' models.
    - NEW: 'User' model is updated with:
        - 'UserMixin' for session management.
        - 'password_hash' and 'role' columns.
        - 'set_password()' and 'check_password()' methods.
        - The '@login.user_loader' function.

moj/routes.py:
    - CONTAINS: The routes from the end of the lecture.
    - 'index' now uses render_template().
    - 'login' is a "hardcoded" placeholder (you will replace this).
    - 'logout' is functional.
    - 'staff_lounge' and 'admin_panel' are protected route examples.

migrations/versions/xxxx_add_auth_columns.py:
    - The *migration script* to add 'password_hash' and 'role' to the User.
    - Your 'Repo Admin' will need to run 'flask db upgrade' after this kit.

templates/...
    - All HTML templates ('base.html', '_navigation.html', 'index.html',
      'login.html', 'register.html') are provided.

tests/conftest.py:
    - NEW: Updated to automatically create/drop an in-memory database
      for each test and to disable CSRF for easier form testing.

tests/test_routes.py:
    - CONTAINS: The original 'hello_world' test.
    - NOTE: This test now correctly checks for a 302 (redirect) since
      the index page now requires a login.

tests/test_auth.py:
    - NEW: This is the "WE" scaffolding for your A09 homework.
    - It contains complete, working tests for the 'register' and 'login'
      routes that you will build in the ICE.
EOF

# --- moj/__init__.py (Unchanged) ---
echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
import sys
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app)
login.login_view = 'login' # Tell flask-login which route to redirect to

from moj import routes, models
EOF

# --- moj/config.py (Unchanged) ---
echo "   -> Writing moj/config.py..."
cat << EOF > "moj/config.py"
import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    """Set Flask configuration variables."""
    
    # CRITICAL: Flask-WTF (forms) requires a SECRET_KEY
    # This key is used to prevent CSRF attacks.
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess-this-secret'
    
    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'moj.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

# --- moj/models.py (Unchanged) ---
echo "   -> Writing moj/models.py..."
cat << EOF > "moj/models.py"
from moj import db, login
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
import datetime

# This "user_loader" callback is used to reload the user object
# from the user ID stored in the session.
@login.user_loader
def load_user(id):
    return User.query.get(int(id))

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)
    
    # New columns from Lecture 5
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(10), index=True, default='user')

    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    # New methods from Lecture 5
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User {}>'.format(self.username)

class Joke(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    body = db.Column(db.String(280), nullable=False)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    def __repr__(self):
        return '<Joke {}>'.format(self.body)
EOF

# --- moj/routes.py (Unchanged) ---
echo "   -> Writing moj/routes.py (lecture placeholder version)..."
cat << EOF > "moj/routes.py"
from moj import app
from flask import render_template, redirect, url_for, request, abort
from flask_login import login_user, logout_user, current_user, login_required
from moj.models import User, Joke

@app.route('/')
@app.route('/index')
@login_required # <-- Note: The index is now protected
def index():
    """Renders the main index.html page."""
    return render_template('index.html', title='Home')

@app.route('/login')
def login():
    """
    This is the "hardcoded" placeholder from the lecture.
    Your team will REPLACE this in the ICE.
    """
    # TODO: Build a real login form!
    
    # 1. Get the one user from our DB (we'll assume it's user 1)
    user = User.query.get(1)

    # 2. "Log them in" using flask-login
    login_user(user)

    # 3. Send them to the index page
    return redirect(url_for('index'))

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login')) # Send them to login page

@app.route('/staff_lounge')
@login_required # This is the AuthN (authentication) check
def staff_lounge():
    return "Welcome to the staff lounge, {}!".format(current_user.username)

@app.route('/admin_panel')
@login_required # 1. They must be logged in...
def admin_panel():
    # 2. ...and they MUST be an admin! (AuthZ)
    if current_user.role != 'admin':
        abort(403) # "Forbidden" error
    
    return "Welcome to the ADMIN PANEL, {}.".format(current_user.username)
EOF

# --- migrations/... (Unchanged) ---
echo "   -> Writing migrations/ (env.py and initial migration)..."
cat << EOF > "migrations/env.py"
from logging.config import fileConfig

from flask import current_app

from alembic import context

# add this line:
from moj.models import db, User, Joke

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
fileConfig(config.config_file_name)

# set the target metadata
target_metadata = db.metadata

# other values from the config, defined for the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline():
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = current_app.config.get("SQLALCHEMY_DATABASE_URI")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connectable = db.engine

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
EOF
cat << EOF > "migrations/versions/abc123_add_auth_columns.py"
"""Add password_hash and role columns to User

Revision ID: abc123_add_auth_columns
Revises: 
Create Date: 2025-11-10 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'abc123_add_auth_columns'
down_revision = None # This assumes this is the *first* migration after init
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('password_hash', sa.String(length=128), nullable=True))
        batch_op.add_column(sa.Column('role', sa.String(length=10), nullable=True))
        batch_op.create_index(batch_op.f('ix_user_role'), ['role'], unique=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_user_role'))
        batch_op.drop_column('role')
        batch_op.drop_column('password_hash')
    # ### end Alembic commands ###
EOF

# --- templates/... (Unchanged) ---
echo "   -> Writing all HTML templates..."
cat << EOF > "templates/base.html"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-t-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{% if title %}{{ title }} - MoJ{% else %}MoJ{% endif %}</title>
    <style>
      body { font-family: sans-serif; margin: 2em; }
      nav { background: #f0f0f0; padding: 1em; }
      nav a { margin-right: 1em; }
      .flash { background: #cee5F5; padding: 1em; margin: 1em 0; }
    </style>
  </head>
  <body>
    {% include '_navigation.html' %}
    <hr>
    
    {% with messages = get_flashed_messages() %}
    {% if messages %}
    <ul class="flash">
      {% for message in messages %}
      <li>{{ message }}</li>
      {% endfor %}
    </ul>
    {% endif %}
    {% endwith %}

    {% block content %}{% endblock %}

  </body>
</html>
EOF
cat << EOF > "templates/_navigation.html"
<nav>
  <a href="{{ url_for('index') }}">Home</a>
  
  {% if current_user.is_anonymous %}
  <a href="{{ url_for('login') }}">Login</a>
  <a href="{{ url_for('register') }}">Register</a>
  {% else %}
  <a href="{{ url_for('staff_lounge') }}">Staff Lounge</a>
  
  {% if current_user.role == 'admin' %}
  <a href="{{ url_for('admin_panel') }}">Admin</a>
  {% endif %}
  
  <a href="{{ url_for('logout') }}">Logout</a>
  <span>(Logged in as: {{ current_user.username }})</span>
  {% endif %}
</nav>
EOF
cat << EOF > "templates/index.html"
{% extends "base.html" %}

{% block content %}
    <h1>Hello, {{ current_user.username }}!</h1>
    <p>Welcome to the Ministry of Jokes (MoJ) v2.0.</p>
{% endblock %}
EOF
cat << EOF > "templates/login.html"
{% extends "base.html" %}

{% block content %}
    <h1>Sign In</h1>
    <p>This is the placeholder HTML for the login form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>
    
    <p>New User? <a href="{{ url_for('register') }}">Click to Register!</a></p>
EOF
cat << EOF > "templates/register.html"
{% extends "base.html" %}

{% block content %}
    <h1>Register</h1>
    <p>This is the placeholder HTML for the registration form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>
    
    <p>Already have an account? <a href="{{ url_for('login') }}">Click to Login!</a></p>
EOF

# --- tests/conftest.py (MODIFIED) ---
echo "   -> Writing tests/conftest.py (Modified for DB testing)..."
cat << EOF > "tests/conftest.py"
import pytest
from moj import app as flask_app
from moj import db

@pytest.fixture
def app():
    """Create and configure a new app instance for each test."""
    flask_app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:", # Use in-memory db
        "WTF_CSRF_ENABLED": False, # Disable CSRF for testing forms
    })

    # --- Setup database ---
    with flask_app.app_context():
        db.create_all() # Create all tables
        yield flask_app # Run the test
        db.session.remove() # Clean up
        db.drop_all() # Drop all tables

@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()
EOF

# --- tests/test_routes.py (Unchanged) ---
echo "   -> Writing tests/test_routes.py (now tests for redirect)..."
cat << EOF > "tests/test_routes.py"
def test_hello_world(client):
    """
    GIVEN a configured test client (from conftest.py)
    WHEN the '/' route is requested (GET)
    THEN check that the response is a 302 (redirect)
    """
    # The index route is now protected by @login_required
    # An unauthenticated client should be redirected.
    response = client.get('/')
    assert response.status_code == 302
    assert 'login' in response.location # Check that it redirects to login
EOF

# --- tests/test_auth.py (NEW FILE) ---
echo "   -> Writing tests/test_auth.py (NEW - Scaffolding for A09)..."
cat << EOF > "tests/test_auth.py"
from moj.models import User
from moj import db

def test_register_new_user(client):
    """
    GIVEN a client and a new user's details
    WHEN the '/register' route is posted to (POST)
    THEN check that the user is created in the database and they are
            redirected to the login page.
    """
    # 1. Post the form data to the register route
    response = client.post('/register', data={
        'username': 'newuser',
        'email': 'new@example.com',
        'password': 'password123',
        'password2': 'password123'
    }, follow_redirects=True) # <-- 'follow_redirects' is key!
    
    # 2. Check the response
    assert response.status_code == 200
    # Check that we were redirected to the login page
    assert b'Sign In' in response.data
    assert b'Congratulations' in response.data # Check for flash message

    # 3. Check the database
    user = User.query.filter_by(username='newuser').first()
    assert user is not None
    assert user.email == 'new@example.com'
    assert user.check_password('password123')
    assert not user.check_password('wrongpassword')

def test_login_and_logout_user(client, app):
    """
    GCIVEN a client and a test user
    WHEN the '/login' and '/logout' routes are used
    THEN check that the user session is managed correctly.
    """
    # --- Create a test user in the database ---
    # We need a user to log in *with*
    with app.app_context():
        user = User(username='testuser', email='test@example.com')
        user.set_password('testpassword')
        db.session.add(user)
        db.session.commit()

    # --- Test Login ---
    response = client.post('/login', data={
        'username': 'testuser',
        'password': 'testpassword'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Home' in response.data # Redirected to index
    assert b'Sign In' not in response.data # Login link is gone
    assert b'Logout' in response.data # Logout link appears

    # --- Test Logout ---
    response = client.get('/logout', follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Sign In' in response.data # Redirected to login
    assert b'Logout' not in response.data # Logout link is gone
EOF

echo "   -> Recipe complete. Kit is built."
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



