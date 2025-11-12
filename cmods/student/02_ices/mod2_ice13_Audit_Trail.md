# ICE 14: "The Logging Service" (Connecting the Wires)

  * **Objective:** Implement the new `UserAction` model, refactor the admin features to log to it, and build the "Admin Panel" into a true audit log viewer.
  * **Time Limit:** 45 minutes
  * **Context:** In the lecture, we designed a single, flexible `UserAction` model to pay off our two final pieces of technical debt: the 12-Factor "Logs" principle and the "unplugged" `justification` field. Your mission is to implement this logging refactor, using class constants to avoid "magic strings."

-----

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

This is a full-stack refactor. Assign these four roles immediately.

  * **`Repo Admin`:** (Git & DB) Handles all Git operations and is the **only one** who runs `flask db migrate`.
  * **`Dev Crew (Backend)`:** (Logic & Routes) Refactors the `admin_edit_joke` and `admin_panel` routes to use the new `UserAction` model.
  * **`Process Lead`:** (Templating) Refactors the `admin_panel.html` template to display the new log.
  * **`QA Crew`:** (Testing) Refactors the `test_admin.py` file to assert that the new log entries are created.


## Task Description: Refactoring to an Audit Log

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in `A12`.

### Phase 1: The New `UserAction` Model (Repo Admin)

You are responsible for updating the database schema.

1.  **Branch:** Pull `main` and create a new feature branch: `ice14-logging-service`.
2.  **Open:** `moj/models.py`.
3.  **Add `UserAction` Model:** Add this new class (with its constants) to the **bottom** of `moj/models.py`:
    ```python
    class UserAction(db.Model):
        # --- ACTION TYPE CONSTANTS ---
        # This is our "code table" in Python.
        LOGIN = "User Login"
        CREATE_JOKE = "Create Joke"
        ADMIN_EDIT_JOKE = "Admin Edit Joke"
        ADMIN_EDIT_USER = "Admin Edit User"
        # --- End Constants ---
        
        id = db.Column(db.Integer, primary_key=True)
        timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
        
        user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
        user = db.relationship('User')
        
        action_type = db.Column(db.String(50), index=True) 
        
        target_type = db.Column(db.String(50))
        target_id = db.Column(db.Integer)
        details = db.Column(db.String(256))

        def __repr__(self):
            return f'<UserAction {self.user.username} {self.action_type}>'
    ```
4.  **DB Migrate:** Your code is now ahead of your DB. Run:
    ```bash
    (venv) $ flask db migrate -m "Add UserAction log table"
    ```
5.  **Commit:** `git add .` and `git commit -m "feat: add UserAction model"`.
6.  **Push:** `git push --set-upstream origin ice14-logging-service`.
7.  *Announce to the team: "The database model is updated\! Pull now and run `flask db upgrade` to sync your local DB\!"*

-----

### Phase 2: Sync & Implement (All Other Roles)

**Everyone *except* the Repo Admin** must now run these commands:

```bash
# 1. Get all the changes
$ git pull

# 2. Apply the new DB migration to your local moj.db
(venv) $ flask db upgrade
```

Now, you can all work in parallel on your assigned tasks.

-----

### Phase 3: "Connecting the Wires" (Dev Crew - Backend)

Your job is to refactor the admin routes to *use* the new table.

1.  **Open:** `moj/routes.py`.
2.  **Add Imports:** At the top, add `UserAction`.
    ```python
    from moj.models import User, Joke, UserAction
    ```
3.  **Refactor `admin_edit_joke`:**
      * Find the `admin_edit_joke` route.
      * Find the `TODO` comment you left in `ICE 11`.
      * **Add the new logging logic:**
    <!-- end list -->
    ```python
    @app.route('/admin/edit_joke/<int:joke_id>', methods=['GET', 'POST'])
    @login_required
    @admin_required # (from A12)
    def admin_edit_joke(joke_id):
        # ... (get joke, get form)
        if form.validate_on_submit():
            # 1. Perform the action
            joke.body = form.body.data
            
            # 2. "CONNECT THE WIRE"
            new_action = UserAction(
                user=current_user,
                action_type=UserAction.ADMIN_EDIT_JOKE, # <-- Use the constant!
                target_type="Joke",
                target_id=joke.id,
                details=form.justification.data # <-- Save the justification!
            )
            db.session.add(new_action)
            
            # 3. Commit both
            db.session.commit()
            
            flash('Admin edit successful. Action logged.')
            return redirect(url_for('admin_panel'))
        # ... (rest of the route is the same)
    ```
4.  **Refactor `admin_panel`:**
      * Find the `admin_panel` route.
      * **Replace the query:** The panel should now show *actions*, not lists of users/jokes.
    <!-- end list -->
    ```python
    @app.route('/admin_panel')
    @login_required
    @admin_required # (from A12)
    def admin_panel():
        # A clean, fast, and maintainable query
        admin_types = [UserAction.ADMIN_EDIT_JOKE, UserAction.ADMIN_EDIT_USER]
        
        actions = UserAction.query.filter(
            UserAction.action_type.in_(admin_types) # <-- Using .in_()
        ).order_by(UserAction.timestamp.desc()).all()
        
        return render_template('admin_panel.html', 
                                title="Admin Panel", actions=actions)
    ```
5.  **Commit & Push:** Commit your changes.

-----

### Phase 4: The New Admin Panel (Process Lead)

Your job is to refactor the admin panel template to be an "Audit Log Viewer."

1.  **Open:** `templates/admin_panel.html`.
2.  **Replace Everything:** **Delete** the old user/joke lists. **Replace** the file's `{% block content %}` with this new table:
    ```html
    {% extends "base.html" %}
    {% block content %}
        <h1>Admin Panel: Audit Log</h1>
        <table border="1" style="width: 100%;">
            <thead>
                <tr style="background-color: #f0f0f0;">
                    <th>Timestamp</th>
                    <th>Admin</th>
                    <th>Action</th>
                    <th>Target</th>
                    <th>Justification / Details</th>
                </tr>
            </thead>
            <tbody>
                {% for action in actions %}
                <tr>
                    <td>{{ action.timestamp.strftime('%Y-%m-%d %H:%M') }}</td>
                    <td>{{ action.user.username }}</td>
                    <td>{{ action.action_type }}</td>
                    <td>
                        {% if action.target_type %}
                            {{ action.target_type }} #{{ action.target_id }}
                        {% else %}
                            N/A
                        {% endif %}
                    </td>
                    <td>{{ action.details }}</td>
                </tr>
                {% else %}
                <tr>
                    <td colspan="5" style="text-align: center;">No admin actions logged yet.</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
    {% endblock %}
    ```
3.  **Commit & Push:** Commit your changes.

-----

### Phase 5: Refactor the Tests (QA Crew)

Your job is to prove the new logging logic works.

1.  **Open:** `tests/test_admin.py`.
2.  **Add Import:** At the top, add `UserAction`.
    ```python
    from moj.models import User, Joke, UserAction
    ```
3.  **Refactor `test_admin_can_edit_joke_route`:**
      * Find this test.
      * At the **end** of the test, add new assertions to check the `UserAction` table.
    <!-- end list -->
    ```python
    def test_admin_can_edit_joke_route(client, app):
        # ... (all the existing setup for this test)
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
        
        # --- (Old assertions) ---
        assert response.status_code == 200
        assert b'Admin Panel: Audit Log' in response.data # (This proves the new template loads)
        assert joke.body == 'Edited by admin'
        
        # --- (NEW ASSERTIONS) ---
        log = UserAction.query.first()
        assert log is not None
        assert log.user == admin
        assert log.action_type == UserAction.ADMIN_EDIT_JOKE # <-- Use the constant!
        assert log.target_id == joke.id
        assert log.details == "Testing admin powers"
    ```
4.  **Test:** Run `pytest tests/test_admin.py`. Your refactored test should pass.
5.  **Commit & Push:** Commit your changes.

-----

### Phase 6: Final Test & Log (Repo Admin)

1.  **Pull:** `git pull` to get all changes from all team members.
2.  **Test:** Run `pytest`. All tests should pass.
3.  **Manual Test:** Run `flask run`.
      * Log in as your admin user.
      * Visit `/admin_panel`. It should be an empty log.
      * Find a joke (create one if needed) and use the admin-edit feature. Fill out the `justification`.
      * When you are redirected back to `/admin_panel`, your new action should be in the log.
4.  **Log:** Fill out the `CONTRIBUTIONS.md` log.
5.  **Submit:** Commit the log, push, and open a Pull Request.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 14: "The Logging Service"
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Dev Crew (Backend): `@github-userY`
    * Process Lead: `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary of Work:** [1-2 sentence summary, e.g., "Paid off our technical debt by creating a new 'UserAction' model with class constants. We refactored the 'admin_edit_joke' route to 'connect the wire' and save the justification to this table. The admin panel is now a full audit log viewer, and our tests confirm the log is created."]
* **Evidence & Reflection:** We just built a `UserAction` table that logs what users do and when. As engineers, what are the **ethical** or **operational** questions we should be asking? For example, who "owns" this data? What happens when this table has a billion rows? Can a user request their history be deleted (e.g., "the right to be forgotten")?
```

