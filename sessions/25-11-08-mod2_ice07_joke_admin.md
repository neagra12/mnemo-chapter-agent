# The ICE supporting lecture 7 - imlements the admin_joke 

## **---- PROMPT ----**
```markdown
OK let's move on to the ICE. 
```

Here is the In-Class Exercise for Module 2, Lecture 7.

-----

### ICE 11: The "Audit Trail" (Admin RBAC)

  - **Objective:** Implement the `.env` refactor for consistency and build the "Admin-Joke-with-Audit-Trail" feature.
  - **Time Limit:** 45 minutes
  - **Context:** In the lecture, we *designed* a two-part solution. **Part 1** was the `.env` refactor to solve team consistency. **Part 2** was the design for an "Admin" feature with Role-Based Access Control (RBAC) and an `AdminAction` audit trail. Your mission is to *implement* this full design.

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Admin Kit**. Assign these four roles immediately.

  * **`Repo Admin`:** (Git, Env, & DB) Handles all Git, `.env`, `models.py`, and `flask db` migration commands.
  * **`Process Lead`:** (Templating) Modifies `edit_joke.html` (parent) and creates `admin_edit_joke.html` (child) and `admin_panel.html`.
  * **`Dev Crew (Backend)`:** (Logic & Routes) Creates the new `admin_edit_joke` and `admin_panel` routes in `moj/routes.py`.
  * **`QA Crew`:** (Testing) Creates the new `tests/test_admin_joke.py` file and writes the tests for the new admin routes.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (.env Refactor Pushed)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (DB Migration Pushed)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Admin Forms Pushed)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Part 4 Complete (Admin Routes Pushed)\</li\> \<li\>\<strong\>Checkpoint 5:\</strong\> Part 5 Complete (Admin Templates Pushed)\</li\> \<li\>\<strong\>Checkpoint 6:\</strong\> Part 6 Complete (Admin Tests Pushed)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

### Task Description: Building the Admin Feature

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in `A10`.

#### Phase 1: The `.env` Refactor (Repo Admin)

1.  **Branch:** Pull `main` and create a new feature branch: `ice11-admin-audit`.
2.  **Create `.env`:** In the **project root**, create a new file named `.env` with this content:
    ```
    # Developer-specific, non-secret settings
    FLASK_DEBUG=1
    DATABASE_URL=sqlite:///moj.db
    ```
3.  **Update `.gitignore`:** Add the `.env` file to your `.gitignore`:
    ```
    # ... (venv/, __pycache__/, moj.db)

    # Environment config file
    .env
    ```
4.  **Refactor `moj/config.py`:** Change `SQLALCHEMY_DATABASE_URI` to read from the `.env` file.
      * **Find this:**
        ```python
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
            'sqlite:///' + os.path.join(basedir, 'moj.db')
        ```
      * **Replace it with this** (it's a small but important change):
        ```python
        # Read from .env, but use the old path as a fallback
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
            'sqlite:///' + os.path.join(basedir, 'moj.db')
        ```
5.  **Commit:** `git add .` and `git commit -m "refactor: add .env for dev consistency"`.
6.  **Push:** `git push --set-upstream origin ice11-admin-audit`.
7.  *Announce to the team that the refactor is pushed.*

#### Phase 2: The Audit Log Model (Repo Admin)

You are now adding the new database table.

1.  **Pull:** (You are already on the branch).
2.  **Open:** `moj/models.py`.
3.  **Add `AdminAction`:** Add this new class to the **bottom** of `moj/models.py`:
    ```python
    # ... (at the end of the file, after the Joke class)
    import datetime # (This should already be at the top)

    class AdminAction(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
        
        # Who did the action?
        admin_id = db.Column(db.Integer, db.ForeignKey('user.id'))
        admin = db.relationship('User') # Link to the User table
        
        # What did they do?
        action_type = db.Column(db.String(50)) # e.g., "Edit Joke"
        model_type = db.Column(db.String(50)) # e.g., "Joke"
        model_id = db.Column(db.Integer) # e.g., Joke ID 42
        
        # Why did they do it?
        justification = db.Column(db.String(256))

        def __repr__(self):
            return f'<AdminAction {self.admin.username} {self.action_type}>'
    ```
4.  **DB Migrate:** Your code is now ahead of your DB. Run:
    ```bash
    (venv) $ flask db migrate -m "Add AdminAction audit log table"
    ```
5.  **Commit:** `git add .` and `git commit -m "feat: add AdminAction model"`.
6.  **Push:** `git push`.
7.  *Announce to the team: "The database model is updated\! Pull now and run `flask db upgrade` to sync your local DB\!"*

-----

#### Phase 3: Sync & Implement (All Other Roles)

**Everyone *except* the Repo Admin** must now run these commands:

```bash
# 1. Get all the changes
$ git pull

# 2. Apply the new DB migration to your local moj.db
(venv) $ flask db upgrade
```

Now, you can all work in parallel on your assigned tasks.

-----

#### Phase 4: The Admin Form (Process Lead)

1.  **Open:** `moj/forms.py`.
2.  **Add Imports:** At the top, add `TextAreaField` and `Length`, and import `JokeForm`.
    ```python
    from wtforms import StringField, PasswordField, BooleanField, SubmitField, TextAreaField
    from wtforms.validators import DataRequired, ValidationError, Email, EqualTo, Length
    from moj.models import User
    from moj.forms import JokeForm # <-- ADD THIS (or move it)
    ```
3.  **Add `AdminJokeForm`:** Add this new class to the **bottom** of `moj/forms.py`.
    ```python
    # ... (after your other form classes)

    class AdminJokeForm(JokeForm):
        """
        Extends the base JokeForm with a mandatory
        justification field for admin actions.
        """
        # We inherit 'body' and 'submit' from JokeForm
        
        # We just add the new field:
        justification = TextAreaField('Admin Justification (Required)', 
                                    validators=[DataRequired(), Length(min=5, max=256)])
    ```
4.  **Commit & Push:** Commit your changes.

-----

#### Phase 5: The Admin Routes (Dev Crew - Backend)

1.  **Open:** `moj/routes.py`.
2.  **Add Imports:**
    ```python
    from moj.forms import AdminJokeForm # <-- ADD
    from moj.models import AdminAction # <-- ADD
    ```
3.  **Create `admin_edit_joke`:** Add this new route:
    ```python
    @app.route('/admin/edit_joke/<int:joke_id>', methods=['GET', 'POST'])
    @login_required
    def admin_edit_joke(joke_id):
        # 1. RBAC Check
        if current_user.role != 'admin':
            abort(403)
            
        joke = Joke.query.get_or_404(joke_id)
        form = AdminJokeForm() # <-- Use the new admin form
        
        if form.validate_on_submit():
            # 2. Log the action
            log_entry = AdminAction(
                admin=current_user,
                action_type="Edit Joke",
                model_type="Joke",
                model_id=joke.id,
                justification=form.justification.data
            )
            db.session.add(log_entry)
            
            # 3. Perform the action
            joke.body = form.body.data
            db.session.commit()
            
            flash('Admin edit successful. Action logged.')
            return redirect(url_for('admin_panel'))
            
        elif request.method == 'GET':
            form.body.data = joke.body
            
        return render_template('admin_edit_joke.html', 
                                title='Admin Edit Joke', form=form, joke=joke)
    ```
4.  **Update `admin_panel`:** **Replace** the old, stubbed `admin_panel` route with this real one:
    ```python
    @app.route('/admin_panel')
    @login_required
    def admin_panel():
        if current_user.role != 'admin':
            abort(403)
        
        # 1. Query the log, newest first
        actions = AdminAction.query.order_by(AdminAction.timestamp.desc()).all()
        
        # 2. Pass the list to the template
        return render_template('admin_panel.html', 
                                title="Admin Panel", actions=actions)
    ```
5.  **Commit & Push:** Commit your changes.

-----

#### Phase 6: The Admin Templates (Process Lead)

You have three template tasks:

1.  **Modify `templates/edit_joke.html` (The Parent):**
      * Find the `<p>{{ form.submit() }}</p>` line.
      * **Right before it,** add this new empty block:
    <!-- end list -->
    ```html
    {% block admin_content %}{% endblock %}

    <p>{{ form.submit() }}</p>
    ```
2.  **Create `templates/admin_edit_joke.html` (The Child):**
      * This new file is very small and clean.
    <!-- end list -->
    ```html
    {% extends "edit_joke.html" %} {% block admin_content %}
        <hr>
        <p style="background: #fff0f0; padding: 1em;">
            <b>{{ form.justification.label }}</b><br>
            {{ form.justification(rows=2, cols=50) }}
            {% for error in form.justification.errors %}
            <span style="color: red;">[{{ error }}]</span>
            {% endfor %}
        </p>
    {% endblock %}
    ```
3.  **Create `templates/admin_panel.html` (The Log Viewer):**
    ```html
    {% extends "base.html" %}
    {% block content %}
        <h1>Admin Panel: Audit Log</h1>
        <table border="1" style="width: 100%;">
            <tr>
                <th>Timestamp</th>
                <th>Admin</th>
                <th>Action</th>
                <th>Target</th>
                <th>Justification</th>
            </tr>
            {% for action in actions %}
            <tr>
                <td>{{ action.timestamp.strftime('%Y-%m-%d %H:%M') }}</td>
                <td>{{ action.admin.username }}</td>
                <td>{{ action.action_type }}</td>
                <td>{{ action.model_type }} #{{ action.model_id }}</td>
                <td>{{ action.justification }}</td>
            </tr>
            {% else %}
            <tr><td colspan="5">No admin actions logged yet.</td></tr>
            {% endfor %}
        </table>
    {% endblock %}
    ```
4.  **Commit & Push:** Commit your changes.

-----

#### Phase 7: The Admin Tests (QA Crew)

1.  **Rename old file:** Rename `tests/test_joke.py` (or similar) to `tests/test_user_joke.py`.
2.  **Create new file:** Create `tests/test_admin_joke.py`.
3.  **Add Tests:** Add these two tests:
    ```python
    from moj import db
    from moj.models import User, Joke, AdminAction

    # Helper function to create users
    def make_users():
        user_a = User(username='user_a', email='a@a.com')
        user_a.set_password('a')
        admin = User(username='admin', email='admin@a.com', role='admin')
        admin.set_password('a')
        return user_a, admin

    def test_admin_can_edit_others_joke(client, app):
        """
        GIVEN a joke by user_A and a logged-in Admin
        WHEN the Admin POSTs to the /admin/edit_joke route
        THEN the joke is updated AND an AdminAction is logged.
        """
        with app.app_context():
            user_a, admin = make_users()
            joke = Joke(body="Original joke", author=user_a)
            db.session.add_all([user_a, admin, joke])
            db.session.commit()
        
        # 1. Log in as Admin
        client.post('/login', data={'username': 'admin', 'password': 'a'})
        
        # 2. Post to the admin edit route
        response = client.post(f'/admin/edit_joke/{joke.id}', data={
            'body': 'Edited by admin',
            'justification': 'Testing admin powers'
        }, follow_redirects=True)
        
        # 3. Check response
        assert response.status_code == 200
        assert b'Admin Panel: Audit Log' in response.data
        assert b'Admin edit successful' in response.data
        
        # 4. Check joke was changed in DB
        assert joke.body == 'Edited by admin'
        
        # 5. Check audit log was created
        log = AdminAction.query.first()
        assert log is not None
        assert log.admin == admin
        assert log.justification == 'Testing admin powers'

    def test_user_cannot_use_admin_route(client, app):
        """
        GIVEN a joke by user_A and a logged-in user_B
        WHEN user_B tries to POST to the /admin/edit_joke route
        THEN they get a 403 Forbidden error.
        """
        with app.app_context():
            user_a, user_b = make_users() # user_b is a 'user'
            joke = Joke(body="Original joke", author=user_a)
            db.session.add_all([user_a, user_b, joke])
            db.session.commit()
        
        # 1. Log in as user_B
        client.post('/login', data={'username': 'user_a', 'password': 'a'}) # Oops, log in as user_a
        
        # 2. Try to post to admin route
        response = client.post(f'/admin/edit_joke/{joke.id}', data={
            'body': 'Edited by hacker',
            'justification': 'Hacking'
        })
        
        # 3. Check for 403
        assert response.status_code == 403
        
        # 4. Check joke was NOT changed
        assert joke.body == 'Original joke'
    ```
4.  **Commit & Push:** Commit your changes.

-----

#### Phase 8: Final Test & Log (Repo Admin)

1.  **Pull:** `git pull` to get all changes from all team members.
2.  **Test:** Run `pytest`. All tests should pass.
3.  **Manual Test:** Run `flask run`.
      * Log in as a normal user. Can you see any admin links?
      * Use `flask shell` to make yourself an `admin`.
      * Find a joke by *another user*.
      * Edit it using the `(Admin)` link.
      * Check the `/admin_panel`. Is your action logged?
4.  **Log:** Fill out the `CONTRIBUTIONS.md` log.
5.  **Submit:** Commit the log, push, and open a Pull Request.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 11: The "Audit Trail" (Admin RBAC)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew (Backend): `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary of Work:** [1-2 sentence summary, e.g., "Implemented a .env refactor for dev consistency. Built a full RBAC feature allowing admins to edit any joke, with all actions logged to a new AdminAction table and displayed on a new Admin Panel."]
* **Evidence & Reflection:** Look at the `AdminJokeForm` and the `admin_edit_joke.html` template. How did using OOP (inheritance) and template inheritance make this feature cleaner and easier to build?
```



## **---- PROMPT ----**
```markdown
I have a minor issue with making sure that the entire team creates their own .env and not just the repo admin. I will perform a manual edit for that change including a checklist of things to do on a pull:
1) Review changes for local updates to .env
2) `pip install -r requirements.txt` to install any new packages
3) `flask db upgrade` to make sure db structure is up to date with any changes. 
```

That's a sharp catch, and you are 100% right.

My plan in `ICE 11` was flawed. I had the `Repo Admin` create the `.env` file and add it to `.gitignore`, but I **failed to add a step for the rest of the team to create their own.** They would `git pull` and get *no* `.env` file, and the app would fail (or use the wrong config).

Your solution is exactly the correct, professional workflow. That 3-step checklist is the "sync" every developer should do after pulling a new feature branch.

Here is the updated `ICE 11` plan with your fix integrated.

-----

### Phase 3: Sync & Implement (All Other Roles)

**This is the most important step\!** The `Repo Admin` has changed the environment, the database, and the configuration. You must all sync your local setup.

**Run these commands *before* you write any code:**

1.  **Pull Changes:**

    ```bash
    $ git pull
    ```

2.  **Create Your *Own* `.env` File:**

      * The `.env` file is in `.gitignore`, so you did *not* receive it from the `Repo Admin`. You must create your own local copy.
      * In your project root, create a new file named `.env` and paste this content into it:

    <!-- end list -->

    ```
    # Developer-specific, non-secret settings
    FLASK_DEBUG=1
    DATABASE_URL=sqlite:///moj.db
    ```

      * ✅ **Check:** Your app will now correctly read its configuration from this file.

3.  **Install New Packages:**

      * Check `requirements.txt` for any new packages.

    <!-- end list -->

    ```bash
    (venv) $ pip install -r requirements.txt
    ```

4.  **Upgrade Your Database:**

      * Apply the new migration script (for `AdminAction`) to your local `moj.db`.

    <!-- end list -->

    ```bash
    (venv) $ flask db upgrade
    ```

Now your local environment is 100% in sync. You can proceed to your parallel tasks (Phase 4, 5, etc.).


## **---- PROMPT ----**
```markdown
instead of `flask shell`, why not use the Flask Tutorial solution of importing Click package and then use a click.command to to initialize the admin_dev user. It creates a cleaner `flask init-admin` process over the error prone `flask shell` solution. 
```

That is an excellent, more professional solution. You're 100% right.

It's a classic engineering trade-off, and your suggestion is the better one for this course.

  * **`flask shell` (My Plan):** Teaches the *underlying mechanism* (query user, change property, `db.session.commit()`). It's a good "first-time" learning experience but is manual, slow, and error-prone.
  * **`flask init-admin` (Your Plan):** Teaches *application-level scripting* and *automation*. It's a cleaner, faster, and more "professional" workflow for the team. It perfectly aligns with the "dev consistency" theme of the lecture.

Your solution is better. We should **replace** the `flask shell` demo in the lecture with a "Worked Example" on building this `Click` command. This makes the lecture slightly more advanced but makes the ICE *much* cleaner for the entire team.

Here are the new, replacement slides and the updated ICE task.

-----

### \#\# Replacement for Lecture 7 (Slide 8)

We will replace the "Becoming an Admin (flask shell)" slide with this new one:

**Slide 8: Worked Example 2: Creating an Admin (The *Right* Way)**

  * **Key Point:** Manually editing the database with `flask shell` is slow and error-prone. We should *automate* this.
  * **The Tool:** Flask has a built-in command-line tool called **Click**. We can add our own custom commands to the `flask` executable.
  * **Step 1: Create `moj/commands.py`** (A new file)
    ```python
    import click
    from moj import app, db
    from moj.models import User

    @app.cli.command("init-admin")
    @click.argument("username")
    def init_admin(username):
        """
        Grants admin privileges to a user.
        Usage: flask init-admin <username>
        """
        user = User.query.filter_by(username=username).first()
        if not user:
            print(f"Error: User '{username}' not found.")
            return

        user.role = 'admin'
        db.session.commit()
        print(f"Success! User '{username}' is now an admin.")
    ```
  * **Step 2: Import the commands.** In `moj/__init__.py`, add this to the bottom:
    ```python
    # ... (bottom of moj/__init__.py)
    from moj import routes, models, commands # <-- Add 'commands'
    ```
  * **Speaker Note:** "Now, instead of a 6-step manual process, we have a clean, one-step command. This is how you build a maintainable app."

-----

### \#\# Updated `ICE 11` Task

This new, cleaner command replaces the `Dev Crew`'s manual `flask shell` task.

**New `ICE 11` Plan:**

  * **Phase 1: The `.env` Refactor** (Repo Admin)

  * **Phase 2: The Audit Log Model** (Repo Admin)

  * **Phase 3: Create Admin Command** (Repo Admin)

      * *This is a new, one-time task for the Repo Admin to set up the tool for the team.*
      * Create `moj/commands.py` (from lecture slide).
      * Update `moj/__init__.py` to import `commands`.
      * `git commit -m "feat: add flask init-admin command"` and `git push`.

  * **Phase 4: Sync & 👑 Become an Admin** (All Other Roles)

      * **Sync:** Run your 3-step sync: `git pull`, create `.env`, `pip install -r requirements.txt`, `flask db upgrade`.
      * **Register:** Run `flask run` and register a normal user account for yourself (e.g., "alice").
      * **Promote:** Use the new command to make yourself an admin.
        ```bash
        (venv) $ flask init-admin alice
        Success! User 'alice' is now an admin.
        ```
      * *Now the entire team (including the `QA Crew`) can easily get admin privileges without error.*

  * **Phase 5: The Admin Form** (Process Lead)

  * **Phase 6: The Admin Routes** (Dev Crew - Backend)

  * ...and so on.

This is a much more robust and professional workflow. Great call.



## **---- PROMPT ----**
```markdown
OK lets see the latest version of the ice.
<!-- This represents the ice after reworking the lecture 7 to exclude AdminActions -->
```

Here is the latest version of the In-Class Exercise for Lecture 7.

This plan is streamlined to be challenging but achievable in 45 minutes. It removes the database migration (the "Audit Log") but **keeps** the high-value lessons: the `.env` refactor, the `Click` command, and the full-stack **Form & Template Inheritance** for the Admin Edit feature.

-----

### ICE 11: "Admin Powers & Inheritance"

  * **Objective:** Implement the `.env` refactor, add the `flask init-admin` command, and build the "Admin-Modify-Joke" feature using OOP and template inheritance.
  * **Time Limit:** 45 minutes
  * **Context:** In the lecture, we designed a professional, multi-part solution for our "Admin" feature.
    1.  **Dev Consistency:** Using `.env` files.
    2.  **Automation:** Using a `Click` command (`flask init-admin`).
    3.  **Inheritance:** Using OOP (`AdminJokeForm`) and template blocks (`{% block %}`) to build a "decoupled" feature, including a `justification` field we'll use in a later lecture.
  * **Your Mission:** Implement this full design.

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

This is a full-stack feature. Assign these four roles immediately.

  * **`Repo Admin`:** (Git, Env, & Commands) Handles all Git, the `.env` refactor, and creating the new `moj/commands.py` file.
  * **`Process Lead`:** (Forms & Templates) Creates the `AdminJokeForm` and all new/modified HTML templates.
  * **`Dev Crew (Backend)`:** (Logic & Routes) Creates the `admin_edit_joke` route and the `admin_panel` route.
  * **`QA Crew`:** (Testing) Creates a new `tests/test_admin.py` file and tests all new RBAC protections.

## *(Insert TopHat `<div>` here...)*

### Task Description: Building the Admin Feature

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in `A10`.

#### Phase 1: The "Admin Setup" (Repo Admin)

You are responsible for the entire environment and command setup. Work carefully.

1.  **Branch:** Pull `main` and create a new feature branch: `ice11-admin-powers`.
2.  **Task 1: The `.env` Refactor**
      * **Create `.env`:** In the **project root**, create a new file named `.env` with this content:
        ```
        # Developer-specific, non-secret settings
        FLASK_DEBUG=1
        DATABASE_URL=sqlite:///moj.db
        ```
      * **Update `.gitignore`:** Add the `.env` file to your `.gitignore`:
        ```
        # ... (venv/, __pycache__/, moj.db)

        # Environment config file
        .env
        ```
      * **Refactor `moj/config.py`:** Change `SQLALCHEMY_DATABASE_URI` to read from the `.env` file:
        ```python
        # Read from .env, but use the old path as a fallback
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
            'sqlite:///' + os.path.join(basedir, 'moj.db')
        ```
3.  **Task 2: The `Click` Command**
      * **Create `moj/commands.py`:** Create this new file:
        ```python
        import click
        from moj import app, db
        from moj.models import User

        @app.cli.command("init-admin")
        @click.argument("username")
        def init_admin(username):
            """Grants admin privileges to a user."""
            user = User.query.filter_by(username=username).first()
            if not user:
                print(f"Error: User '{username}' not found.")
                return

            user.role = 'admin'
            db.session.commit()
            print(f"Success! User '{username}' is now an admin.")
        ```
      * **Update `moj/__init__.py`:** At the **bottom** of the file, add `commands` to the import:
        ```python
        # ... (at the very bottom)
        from moj import routes, models, commands
        ```
4.  **Commit:** `git add .` and `git commit -m "feat: add .env refactor and init-admin command"`.
5.  **Push:** `git push --set-upstream origin ice11-admin-powers`.
6.  *Announce to the team: "The setup is pushed\! You can now pull, sync, and get to work."*

-----

#### Phase 2: Sync & Become Admin (All Other Roles)

**This is a critical sync step.** You must do all of the following:

1.  **Pull Changes:**
    ```bash
    $ git pull
    ```
2.  **Create Your *Own* `.env` File:**
      * The `.env` file is in `.gitignore`, so you did *not* receive it. You must create your own local copy.
      * In your project root, create a new file named `.env` and paste this content into it:
    <!-- end list -->
    ```
    # Developer-specific, non-secret settings
    FLASK_DEBUG=1
    DATABASE_URL=sqlite:///moj.db
    ```
3.  **Install Packages:** (This makes sure `click` is installed, though it's a Flask dependency).
    ```bash
    (venv) $ pip install -r requirements.txt
    ```
4.  **Register a User:** Run `flask run` and register a normal user account for yourself (e.g., "my\_user").
5.  **Become an Admin:** Use the new command to promote your user.
    ```bash
    (venv) $ flask init-admin my_user
    Success! User 'my_user' is now an admin.
    ```

*Now you are all synced and have admin accounts to test with. Proceed to your parallel tasks.*

-----

#### Phase 3: The Admin Form (Process Lead)

Your job is to create the new `AdminJokeForm` by inheriting from `JokeForm`.

1.  **Open:** `moj/forms.py`.
2.  **Add Imports:** At the top, add `TextAreaField` and `Length`.
    ```python
    from wtforms import ..., TextAreaField
    from wtforms.validators import ..., Length
    ```
3.  **Import `JokeForm`:** Find the line `from moj.models import User` and add `JokeForm` to your imports (you'll need to import it from `moj.forms` itself, or from the `A10` `edit_joke` form). A simple way is to just **import `JokeForm` from `A10`'s file**:
    ```python
    # ...
    from moj.models import User
    from .forms import JokeForm # Or wherever your JokeForm is
    ```
    *(If your `JokeForm` is already in `moj/forms.py`, just make sure you can import it)*
4.  **Add `AdminJokeForm`:** Add this new class to the **bottom** of `moj/forms.py`.
    ```python
    class AdminJokeForm(JokeForm):
        """
        Extends the base JokeForm with a mandatory
        justification field for admin actions.
        """
        # We inherit 'body' and 'submit' from JokeForm
        
        # We just add the new field:
        justification = TextAreaField('Admin Justification', 
                                    validators=[DataRequired(), Length(min=5, max=256)])
    ```
5.  **Commit & Push:** Commit your changes.

-----

#### Phase 4: The Admin Routes (Dev Crew - Backend)

Your job is to build the new admin-only routes.

1.  **Open:** `moj/routes.py`.
2.  **Add Imports:**
    ```python
    from moj.forms import AdminJokeForm # <-- ADD
    ```
3.  **Create `admin_edit_joke`:** Add this new route:
    ```python
    @app.route('/admin/edit_joke/<int:joke_id>', methods=['GET', 'POST'])
    @login_required
    def admin_edit_joke(joke_id):
        # 1. RBAC Check
        if current_user.role != 'admin':
            abort(403)
            
        joke = Joke.query.get_or_404(joke_id)
        form = AdminJokeForm() # <-- Use the new admin form
        
        if form.validate_on_submit():
            # 2. Perform the action
            joke.body = form.body.data
            db.session.commit()
            
            # 3. TODO (Lec 10): Log the action
            # We have the justification: form.justification.data
            # We will save this to an audit log in a future lecture.
            
            flash('Admin edit successful.')
            return redirect(url_for('admin_panel'))
            
        elif request.method == 'GET':
            form.body.data = joke.body
            
        return render_template('admin_edit_joke.html', 
                                title='Admin Edit Joke', form=form, joke=joke)
    ```
4.  **Update `admin_panel`:** **Replace** the old, stubbed `admin_panel` route with this real one:
    ```python
    @app.route('/admin_panel')
    @login_required
    def admin_panel():
        if current_user.role != 'admin':
            abort(403)
        
        # Get data for the dashboard
        users = User.query.order_by(User.username).all()
        jokes = Joke.query.order_by(Joke.timestamp.desc()).all()
        
        return render_template('admin_panel.html', 
                                title="Admin Panel", 
                                users=users, 
                                jokes=jokes)
    ```
5.  **Commit & Push:** Commit your changes.

-----

#### Phase 5: The Admin Templates (Process Lead)

Your job is to implement the template inheritance.

1.  **Modify `templates/edit_joke.html` (The Parent):**
      * Find the `<p>{{ form.submit() }}</p>` line.
      * **Right before it,** add this new empty block:
    <!-- end list -->
    ```html
    {% block admin_content %}{% endblock %}

    <p>{{ form.submit() }}</p>
    ```
2.  **Create `templates/admin_edit_joke.html` (The Child):**
      * This new file is very small and clean.
    <!-- end list -->
    ```html
    {% extends "edit_joke.html" %} {% block admin_content %}
        <hr>
        <p style="background: #fff0f0; padding: 1em;">
            <b>{{ form.justification.label }}</b><br>
            {{ form.justification(rows=2, cols=50) }}
            {% for error in form.justification.errors %}
            <span style="color: red;">[{{ error }}]</span>
            {% endfor %}
        </p>
    {% endblock %}
    ```
3.  **Create `templates/admin_panel.html` (The Dashboard):**
    ```html
    {% extends "base.html" %}
    {% block content %}
        <h1>Admin Panel</h1>
        <p>Welcome, {{ current_user.username }}. You have admin privileges.</p>
        <hr>
        <h2>All Users ({{ users|length }})</h2>
        <ul>
            {% for user in users %}
                <li>{{ user.username }} (Role: {{ user.role }})</li>
            {% endfor %}
        </ul>
        <h2>All Jokes ({{ jokes|length }})</h2>
        <ul>
            {% for joke in jokes %}
                <li>"{{ joke.body }}" - <i>by {{ joke.author.username }}</i></li>
            {% endfor %}
        </ul>
    {% endblock %}
    ```
4.  **Commit & Push:** Commit your changes.

-----

#### Phase 6: The Admin Tests (QA Crew)

Your job is to prove the new RBAC security works.

1.  **Create `tests/test_admin.py`:**
2.  **Add Tests:**
    ```python
    from moj import db
    from moj.models import User, Joke

    # Helper function to create users in the DB
    def make_users():
        user = User(username='testuser', email='user@a.com', role='user')
        user.set_password('a')
        admin = User(username='admin', email='admin@a.com', role='admin')
        admin.set_password('a')
        return user, admin

    def test_admin_can_access_panel(client, app):
        """GIVEN a logged-in Admin, WHEN they GET /admin_panel, THEN they see the panel."""
        with app.app_context():
            user, admin = make_users()
            db.session.add_all([user, admin])
            db.session.commit()
        client.post('/login', data={'username': 'admin', 'password': 'a'})
        response = client.get('/admin_panel')
        assert response.status_code == 200
        assert b'Admin Panel' in response.data

    def test_user_cannot_access_panel(client, app):
        """GIVEN a logged-in User, WHEN they GET /admin_panel, THEN they get a 403."""
        with app.app_context():
            user, admin = make_users()
            db.session.add_all([user, admin])
            db.session.commit()
        client.post('/login', data={'username': 'testuser', 'password': 'a'})
        response = client.get('/admin_panel')
        assert response.status_code == 403

    def test_admin_can_edit_joke_route(client, app):
        """GIVEN a logged-in Admin, WHEN they POST to /admin/edit_joke, THEN the joke is changed."""
        with app.app_context():
            user, admin = make_users()
            joke = Joke(body="Original joke", author=user)
            db.session.add_all([user, admin, joke])
            db.session.commit()
            
        client.post('/login', data={'username': 'admin', 'password': 'a'})
        response = client.post(f'/admin/edit_joke/{joke.id}', data={
            'body': 'Edited by admin',
            'justification': 'Testing admin powers'
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b'Admin Panel' in response.data
        assert joke.body == 'Edited by admin'

    def test_user_cannot_use_admin_edit_route(client, app):
        """GIVEN a logged-in User, WHEN they POST to /admin/edit_joke, THEN they get a 403."""
        with app.app_context():
            user, admin = make_users()
            joke = Joke(body="Original joke", author=user)
            db.session.add_all([user, admin, joke])
            db.session.commit()

        client.post('/login', data={'username': 'testuser', 'password': 'a'})
        response = client.post(f'/admin/edit_joke/{joke.id}', data={
            'body': 'Edited by user',
            'justification': 'Hacking'
        })
        assert response.status_code == 403
        assert joke.body == 'Original joke'
    ```
3.  **Commit & Push:** Commit your changes.

-----

#### Phase 7: Final Test & Log (Repo Admin)

1.  **Pull:** `git pull` to get all changes from all team members.
2.  **Test:** Run `pytest`. All tests (including the new `test_admin.py` tests) should pass.
3.  **Manual Test:** Run `flask run`.
      * Log in as the admin user you created.
      * Visit `/admin_panel`. You should see the dashboard.
      * Find a joke (create one if needed) and edit it using the new admin route.
      * Log out. Log in as a *normal* user.
      * Manually type `/admin_panel` in the URL. You should get a "Forbidden" error.
4.  **Log:** Fill out the `CONTRIBUTIONS.md` log.
5.  **Submit:** Commit the log, push, and open a Pull Request.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 11: "Admin Powers & Inheritance"
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Dev Crew (Backend): `@github-userY`
    * Process Lead: `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary of Work:** [1-2 sentence summary, e.g., "Refactored the app to use .env files, added a 'flask init-admin' command, and built an admin-only 'Edit Joke' feature using form and template inheritance."]
* **Evidence & Reflection:** This was our first time using inheritance. How did extending `JokeForm` and `edit_joke.html` make this feature faster to build? What lesson does the "decoupled" `justification` field teach us?
```



## **---- PROMPT ----**
```markdown
I don't believe we generated a ta guide for the ICE that goes with lecture 7. Can I see that now including the Canvas specific version of the rubric?
```

Yes, here is the TA guide for **ICE 11: "Admin Powers & Inheritance"** (which accompanies Lecture 7), along with the Canvas-ready rubric.

-----

## 👨‍🏫 TA Guide: ICE 11 "Admin Powers & Inheritance"

### 🎯 Objective

This ICE is the "WE" part of our "I/WE/YOU" structure for RBAC and inheritance. The goal is for students to implement the full "Admin Modify Joke" feature *without* the audit log, which we designed in the lecture. This includes the `.env` refactor, the `Click` command, and the full-stack inheritance pattern.

### ✅ The Happy Path (A Successful Team)

A successful team will execute the following parallel tasks:

1.  **Repo Admin:**

      * Creates the `ice11-admin-powers` branch.
      * Correctly edits `.env`, `.gitignore`, and `moj/config.py` for the `.env` refactor.
      * Correctly creates `moj/commands.py` and edits `moj/__init__.py` to add the `flask init-admin` command.
      * Remembers to `pip install click` (or `Flask`) and `pip freeze > requirements.txt`.
      * Pushes these "setup" changes so the team can sync.

2.  **All Other Roles:**

      * Pull the changes.
      * **Crucially: Create their own local `.env` file.**
      * Run `pip install -r requirements.txt`.
      * Register a user and successfully run `flask init-admin <username>` to become an admin.

3.  **Process Lead:**

      * Correctly creates `AdminJokeForm(JokeForm)` in `moj/forms.py` (with the `justification` field).
      * Correctly modifies `edit_joke.html` to add the `{% block admin_content %}`.
      * Correctly creates `admin_edit_joke.html` that `{% extends "edit_joke.html" %}`.
      * Creates the `admin_panel.html` template.

4.  **Dev Crew (Backend):**

      * Implements the `admin_edit_joke` route, using the new `AdminJokeForm` and the `if current_user.role != 'admin'` check.
      * Correctly leaves the `form.justification.data` "unplugged" (as planned).
      * Implements the `admin_panel` route, adding the RBAC check and querying for users/jokes.

5.  **QA Crew:**

      * Creates `tests/test_admin.py`.
      * Writes the "negative path" test (`test_user_cannot_access_panel`) and the "happy path" test (`test_admin_can_access_panel`).
      * Writes the two tests for the `admin_edit_joke` route (happy and negative).

The team will `git pull` all parallel work, `pytest` will pass, and they will submit the PR.

-----

### ⚠️ Common Pain Points & Bottlenecks

This ICE is *much* simpler than our previous plan, but it still has several places for students to get stuck.

  * **HIGH RISK: The `.env` Sync.**

      * **Problem:** The `Repo Admin` pushes their changes. The rest of the team pulls, `pip installs`, and runs `flask run`. The app *crashes* because `SECRET_KEY` is now `None` (since `config.py` was changed).
      * **Solution:** This is the \#1 pain point. You **must** remind them that `.env` is in `.gitignore` and **every team member** must create their *own* local `.env` file (Phase 2).

  * **MEDIUM RISK: The `Click` Command.**

      * **Problem:** The `Repo Admin` forgets to add `click` to `requirements.txt`. The team pulls, but their `flask` commands don't work (or CI fails).
      * **Solution:** Remind the `Repo Admin` to `pip freeze` after installing a new package.

  * **MEDIUM RISK: Form Inheritance.**

      * **Problem:** The `Process Lead` tries to import `JokeForm` in `moj/forms.py` but `JokeForm` is in a *different* file (e.g., `moj/jokes/forms.py` from `A10`). This creates a circular dependency or import error.
      * **Solution:** The "quick fix" is to move `JokeForm` *into* `moj/forms.py` (if it's not already there) so `AdminJokeForm` can easily inherit from it.

  * **LOW RISK: Template Inheritance.**

      * **Problem:** The `admin_edit_joke.html` template renders a blank page.
      * **Solution:** The student probably forgot to add `{% extends "edit_joke.html" %}`. They are *extending* the base editor, not the `base.html` template.

-----

### COACHING QUESTIONS

  * **For the team (at the start):** "The `Repo Admin` is about to push, but they are adding `.env` to `.gitignore`. What does that mean *you* all need to do on your local machines *after* you pull?"
  * **For the Process Lead:** "You're creating an `AdminJokeForm` that's almost identical to `JokeForm`. What's the 'DRY' way to do this without copying and pasting the whole class?"
  * **For the Dev Crew:** "I see you're using the `AdminJokeForm` in your route. The `justification` field is coming in with the form data. What's our plan for that data in *this* ICE? (Answer: Nothing, we leave it unplugged). Why is this 'decoupled' design useful?"
  * **For the QA Crew:** "You're testing the `admin_panel` route. What two *different* users do you need to log in as to *fully* test this route?" (Answer: An admin user and a regular user).

-----

### 📋 Canvas HTML Rubric

Here is the HTML rubric for **ICE 11: "Admin Powers & Inheritance"**, formatted for Canvas.

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 11">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Teamwork &amp; Process (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>Team roles were assigned and followed.</li>
                    <li><code>CONTRIBUTIONS.md</code> log is complete with a summary.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Setup: .env &amp; Click Command (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>.env</code> refactor is complete in <code>config.py</code>.</li>
                    <li><code>moj/commands.py</code> is created and <code>flask init-admin</code> works.</li>
                    <li>Team successfully synced (created local <code>.env</code>, promoted user).</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Feature: RBAC &amp; Inheritance (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>AdminJokeForm</code> correctly inherits from <code>JokeForm</code>.</li>
                    <li><code>admin_edit_joke.html</code> correctly extends <code>edit_joke.html</code>.</li>
                    <li><code>admin_edit_joke</code> route uses the new form and is protected by an RBAC check (<code>if current_user.role...</code>).</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Testing (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>New <code>tests/test_admin.py</code> file is created.</li>
                    <li>Includes a "negative path" test proving a normal user gets a 403.</li>
                    <li>Includes a "happy path" test proving an admin can access/use the new features.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
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

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





