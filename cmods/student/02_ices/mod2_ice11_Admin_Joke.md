## ICE 11: "Admin Powers & Inheritance"

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

