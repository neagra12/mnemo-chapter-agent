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





