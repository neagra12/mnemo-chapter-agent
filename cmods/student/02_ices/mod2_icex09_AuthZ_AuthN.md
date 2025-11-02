# ICE 9: The "Front Door" (User Registration & Login)

  - **Objective:** Implement user-facing registration and login forms using `flask-wtf`.
  - **Time Limit:** 35-40 minutes
  - **Context:** In the lecture, we built the "engine" for authentication: the password hashing, the `UserMixin`, and the `@login_required` decorator. However, our `/login` route was just a "hardcoded" placeholder. This ICE builds the *real* user interface—the "dashboard" for our auth engine. We will use the `flask-wtf` library to create secure, server-side forms.
  - _**Caution --** Each team should start with the following conditions:_
    - _Local repo is on main branch and successful git pull._
    - _Activate your virtual environment (venv)_
    - _Run_ `pip install -r requirements.txt` _to ensure all packages are installed and available._
    - _Be sure to set our environment variable `FLASK_APP` to `moj`:_
      ```bash
          export FLASK_APP=moj  # macOS or Linux shell
          $env:FLASK_APP="moj"  # Windows PowerShell
      ```

-----

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Authentication Kit**. Assign these three roles immediately.

  * **`Repo Admin`:** (Git & Environment) Installs new packages, updates `requirements.txt`, handles all Git operations, and is the only one who runs `flask db migrate`.
  * **`Process Lead`:** (Forms) Creates the new `moj/forms.py` file and defines the Python classes for our `LoginForm` and `RegistrationForm`.
  * **`Dev Crew (Backend)`:** (Logic) Modifies `moj/routes.py` to import the forms, handle `POST` requests, and process user logins/registrations.
  * **`Dev Crew (Frontend)`:** (Templates) Modifies `templates/login.html` and `templates/register.html` to render the forms using Jinja2.

## Task Description: Building the Forms

---

### Phase 1: Kit & Installation (Repo Admin)

1.  **Branch:** Pull `main` and create a new branch: `ice9-authn-forms`.
2.  **Download and apply the Kit:** Download `ICE09_auth_kit.zip` from Canvas.
      * **CRITICAL:** This kit contains all the "backend" code from Lecture 5. **Unzip and copy its contents** (the `moj/`, `templates/`, and `tests` directories) into your repo, **overwriting** your existing files. This will update your `__init__.py`, `models.py`, `routes.py`, `config.py` and add new templates.
3.  **Install:** Install the new form library (**with your venv active!**):
    ```bash
    pip install flask-wtf flask_login email_validator
    ```
4.  **Update:** Update your `requirements.txt` file:
    ```bash
    pip freeze > requirements.txt
    ```

5. **Upgrade DB:** You should make sure your local db file is updated. In this case we actually moved the db file from `./moj/app.db` to `./moj.db`. In the previous ICE, we created the database file in the package. Good design has us separate data from code.  
If you do not have a db file, it will create one an migrate it to the current state of the repo.
   ```bash
    flask db upgrade
   ```
   
6. **DB Migrate:** Your code (models.py) is now ahead of your database. You must generate the migration script:
   ```bash
   flask db migrate -m "Add password_hash and role to User"
   ```
7. **DB Upgrade Authn Changes:** Apply the new migration to your local database:
    ```bash
    flask db upgrade
    ```
8.  **Commit:** `git add .` and `git commit -m "feat: add auth backend, flask-wtf, and new DB migration"`.

9.  **Push:** `git push --set-upstream origin ice9-authn-forms`.

10. *Announce to the team that the branch is ready. Tell them they must run `pip install` and `flask db upgrade`.*

---
---

### Phase 2: Define the Forms (Process Lead)

Your job is to create the Python classes that *represent* our forms.

1.  **Pull:** `git pull` to get the latest branch.

2.  **Install New Dependencies:** 
    - `pip install -r requirements.txt` updated requirements from the Process Lead. 
    - `flask db upgrade` to apply db changes to your copy of the `moj.db`

3.  **Create File:** Create a new file: `moj/forms.py`.

4.  **Add Code:** Paste the following code into `moj/forms.py`. This defines the fields and *validators* (rules) for our two forms.

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

4.  **Commit:** `git add moj/forms.py` and `git commit -m "feat: define LoginForm and RegistrationForm"` and push to GitHub.

5.  *Announce to the `Dev Crew` that the forms are ready to be used.*

---
---

### Phase 3: Implement Form Logic (Dev Crew - Parallel Work)

The `Process Lead` has just pushed `moj/forms.py`. The `Dev Crew` now splits into two parallel tasks.

---

#### **Task 3A: `Dev Crew (Backend)` - The Route Logic**

Your job is to update `moj/routes.py` to actually *use* the forms. You can do hti sin parallel with the other crew member working on the front end. **The Dev Crew works in parallel for Phase 3.**

1.  **Pull:** `git pull` to get the new `moj/forms.py` file.

2.  **Install New Dependencies:** 
    - `pip install -r requirements.txt` updated requirements from the Process Lead. 
    - `flask db upgrade` to apply db changes to your copy of the `moj.db`

2.  **Open:** Open `moj/routes.py`.

3.  **Import:** At the top, import the new forms and other tools:

    ```python
    # ... (existing imports)
    from flask import render_template, redirect, url_for, request, flash # <-- Add 'flash'
    from moj.models import User, Joke
    from moj import db # <-- NEW
    from moj.forms import LoginForm, RegistrationForm # <-- NEW
    ```

4.  **Update `login` Route:** Find the *existing* `@app.route('/login')` route. **Replace it entirely** with this new version that processes the form:

    ```python
    @app.route('/login', methods=['GET', 'POST'])
    def login():
        if current_user.is_authenticated:
            return redirect(url_for('index'))
        
        form = LoginForm() # <-- Instantiate the form
        if form.validate_on_submit():
            user = User.query.filter_by(username=form.username.data).first()
            if user is None or not user.check_password(form.password.data):
                flash('Invalid username or password')
                return redirect(url_for('login'))
            login_user(user, remember=form.remember_me.data)
            return redirect(url_for('index'))
            
        return render_template('login.html', title='Sign In', form=form) # <-- Pass 'form'
    ```

5.  **Create `register` Route:** **Add this new route** (e.g., after the `login` route):

    ```python
    @app.route('/register', methods=['GET', 'POST'])
    def register():
        if current_user.is_authenticated:
            return redirect(url_for('index'))
            
        form = RegistrationForm() # <-- Instantiate the form
        if form.validate_on_submit():
            user = User(username=form.username.data, email=form.email.data)
            user.set_password(form.password.data)
            db.session.add(user)
            db.session.commit()
            flash('Congratulations, you are now a registered user!')
            return redirect(url_for('login'))
            
        return render_template('register.html', title='Register', form=form) # <-- Pass 'form'
    ```

6.  **Update `index` Route:** **Replace** the *existing* `index` route with this (it just adds `@login_required`):

    ```python
    @app.route('/')
    @app.route('/index')
    @login_required # <-- Now the index requires you to be logged in!
    def index():
        return render_template('index.html', title='Home')
    ```

7.  **Commit:** `git add moj/routes.py` and `git commit -m "feat: implement login and register route logic"`.

-----

#### **Task 3B: `Dev Crew (Frontend)` - The Template Rendering**

Your job is to update the HTML templates to *render* the forms.

1.  **Pull:** `git pull` (you don't need to wait for Task 3A, you just need `moj/forms.py` from Phase 2).
2.  **Open:** `templates/login.html`.
3.  **Replace Placeholder:** **Replace the placeholder `<p>...</p>`** text with the real Jinja2 form:
    ```html
    <form action="" method="post" novalidate>
        <!-- form is a variable defined in routes.py:login() and passed when rendering -->
        {{ form.hidden_tag() }} <p>
            {{ form.username.label }}<br>
            {{ form.username(size=32) }}
        </p>
        <p>
            {{ form.password.label }}<br>
            {{ form.password(size=32) }}
        </p>
        <p>{{ form.remember_me() }} {{ form.remember_me.label }}</p>
        <p>{{ form.submit() }}</p>
    </form>
    ```
4.  **Open:** `templates/register.html`.
5.  **Replace Placeholder:** **Replace the placeholder `<p>...</p>`** text with the real Jinja2 form:
    ```html
    <form action="" method="post" novalidate>
        <!-- form is a variable defined in routes.py:register() and passed when rendering -->
        {{ form.hidden_tag() }}
        <p>
            {{ form.username.label }}<br>
            {{ form.username(size=32) }}
        </p>
        <p>
            {{ form.email.label }}<br>
            {{ form.email(size=64) }}
        </p>
        <p>
            {{ form.password.label }}<br>
            {{ form.password(size=32) }}
        </p>
        <p>
            {{ form.password2.label }}<br>
            {{ form.password2(size=32) }}
        </p>
        <p>{{ form.submit() }}</p>
    </form>
    ```
6.  **Commit:** `git add templates/login.html templates/register.html` and `git commit -m "feat: render login and register forms in templates"` and push to GitHub.


### Phase 4: Log and Submit (Repo Admin)

1.  **Pull:** `git pull` to get the final `moj/routes.py` and tempalte changes.
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

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 9: The "Front Door" (User Registration & Login)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew: `@github-userZ`, ...
* **Summary of Work:** [1-2 sentence summary, e.g., "Installed flask-wtf, defined the `LoginForm` and `RegistrationForm` in `forms.py`, and implemented the `login` and `register` routes in `routes.py` to handle form validation and user creation."]
* **Evidence & Reflection:** What is the purpose of `form.validate_on_submit()`? What two things does it check for before returning `True`?
```

-----

## Definition of Done (DoD) 🏁

  * [ ] **Artifact (Kit):** The `ICE09_auth_kit.zip` has been unzipped and committed.
  * [ ] **Artifact (Env):** `flask-wtf` is installed and in `requirements.txt`.
  * [ ] **Artifact (Forms):** The `moj/forms.py` file exists and contains the `LoginForm` and `RegistrationForm`.
  * [ ] **Artifact (Routes):** `moj/routes.py` is updated with `POST` logic for the `/login` and `/register` routes.
  * [ ] **Functionality:** A new user can successfully register, log in, see the index page, and log out.
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated.
  * [ ] **Submission:** A Pull Request is open with the title `ICE 9: The "Front Door"`.

<!-- 
-----

## TA Guide & Rubric

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
\+-------------------------------------------------------------+-----------------+ -->

<!-- ### Canvas-Optimized HTML Snippet

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
``` -->
