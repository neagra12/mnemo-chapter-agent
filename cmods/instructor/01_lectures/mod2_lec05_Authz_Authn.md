# Lecture 5: User Authentication & Authorization

  - **Topic:** User Sessions, Authentication, Password Hashing, and Role-Based Authorization
  - **Cycle 2:** Building the "Ministry of Jokes" (MoJ) v2.0
  - **Time:** 35-40 minutes


## **Slide 1: Title Slide**

  - **Topic:** Cycle 2: User Authentication & Authorization
  - **Course:** Software Engineering (Greenfield Development)
  - **Module 1:** Building the "Ministry of Jokes" (MoJ)

## **Slide 2: Learning Objectives**

  - By the end of this lecture, you will be able to:
  - **Differentiate** between Authentication (AuthN) and Authorization (AuthZ).
  - **Implement** password hashing to securely store user credentials.
  - **Use** the `flask-login` extension to manage user sessions.
  - **Protect** specific routes from unauthenticated users.
  - **Modify** the `User` model to add a "role" and run a database migration.
  - **Implement** simple role-based access control (e.g., `admin` vs. `user`).

## **Slide 3: Cycle 1 Recap: The Foundation is Built**

  - **Key Point:** Our Cycle 1 Capstone (`v1.0.0`) is a stable, professional foundation.
  - We have:
      - A scalable `moj/` package architecture.
      - A `User` model in a database, managed by `flask-migrate`.
      - A 100% "green" CI/CD pipeline with `pytest` and `flake8`.
  - **The Problem:** Our `User` model is a "filing cabinet" with no "front door." We have users in the DB, but no way for them to *log in* and prove who they are.

## **Slide 4: The "Front Door": AuthN vs. AuthZ**

  - **Analogy:** Imagine the Ministry of Jokes is a secure building.
  - **Authentication (AuthN): "Who are you?"**
      - This is the **Front Door Bouncer**.
      - They check your ID (username + password) to verify you are who you claim to be.
      - **In Flask:** This is the **Login Page**.
  - **Authorization (AuthZ): "What are you *allowed* to do?"**
      - This is the **VIP List**.
      - Once you're *inside* (authenticated), this determines if you can enter the "Staff Only" area (e.g., delete jokes) or just the "Public" area.
      - **In Flask:** This is checking `current_user.role == 'admin'`.

## **Slide 5: The Password Problem 🔒**

  - **NEVER, EVER, EVER STORE PLAIN-TEXT PASSWORDS.**
  - If our `moj.db` file is *ever* leaked, every user's password would be exposed. This is an unforgivable, company-ending ethical and security failure.
  - **The Solution: Hashing.** We store a one-way "fingerprint" of the password.
      - `password: "secret123"` -\> `hash: "scrypt$..."`
  - **Verification:**
    1.  User types "secret123" at login.
    2.  We *hash* their input: `"secret123"` -\> `"scrypt$..."`
    3.  We *compare* our new hash to the hash in the database.
    4.  If they match, the password was correct. We never stored the password itself.

## **Slide 6: Worked Example 1: Password Hashing**

  - **Key Point:** Flask's companion library, `Werkzeug`, has this built-in.
  - We need to add two *methods* to our `moj/models.py` `User` class.

<!-- end list -->

```python
# In moj/models.py
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)
    password_hash = db.Column(db.String(128)) # We already built this!
    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    # NEW: Method to set the password hash
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    # NEW: Method to check the password
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User {}>'.format(self.username)
```

  - **Speaker Note:** "Notice we're just adding *methods* to the class. The database *schema* (`password_hash` column) is unchanged, so no migration is needed for this step."

**Slide 7: Worked Example 2: Installing `flask-login`**

  - **Key Point:** `flask-login` is the standard tool for managing user sessions (i.e., "remembering" who is logged in).
  - **Step 1: Install it.**
    ```bash
    pip install flask-login
    pip freeze > requirements.txt
    ```

**Slide 8: Worked Example 3: Initializing `flask-login`**

  - **Key Point:** We must initialize the `LoginManager` just like we did for `db` and `migrate`.

<!-- end list -->

```python
# In moj/__init__.py

# ... (other imports)
from flask_login import LoginManager # <-- 1. Import

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app) # <-- 2. Initialize
login.login_view = 'login' # <-- 3. (Critical!) Tell flask-login what
                           # route to redirect to if a user isn't logged in.

from moj import routes, models
```

  - **Speaker Note:** "That `login.login_view = 'login'` line is critical. If a user tries to access a protected page, `flask-login` will automatically redirect them to the `/login` route. 'login' is the *function name* of the route we're about to write."

**Slide 9: Worked Example 4: The `UserMixin`**

  - **Key Point:** `flask-login` needs our `User` model to have 4 specific methods (`is_authenticated`, `is_active`, `is_anonymous`, `get_id()`).
  - We can get all 4 *for free* by inheriting from `UserMixin`.

<!-- end list -->

```python
# In moj/models.py
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin # <-- 1. Import
from moj import login # <-- 2. Import the login manager

# 3. Add UserMixin to the class definition
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    # ... (rest of the class is the same) ...

# 4. (Critical!) Add the user_loader
# This function tells flask-login how to find a specific user
# from the ID that is stored in their session cookie.
@login.user_loader
def load_user(id):
    return User.query.get(int(id))
```

  - **Speaker Note:** "This is the 'magic' that connects `flask-login` to our database. When a user comes back to the site, `flask-login` will read the session cookie, get the user's `id`, and call `load_user(id)` to fetch them from the DB."

**Slide 10: Worked Example 5: The `login` and `logout` Routes**

  - **Key Point:** Now we build the "front door" logic in `moj/routes.py`.

<!-- end list -->

```python
# In moj/routes.py
from moj import app
from flask import render_template, redirect, url_for, request # <-- NEW
from flask_login import login_user, logout_user, current_user # <-- NEW
from moj.models import User, Joke

# ... (your existing 'index' route) ...

@app.route('/login')
def login():
    # We will build the *real* form in the ICE.
    # For now, we'll just log in a "hardcoded" user.
    # TODO: Build a real login form!

    # 1. Get the one user from our DB (we'll assume it's user 1)
    user = User.query.get(1)

    # 2. "Log them in" using flask-login
    login_user(user)

    return "You are now logged in!"


@app.route('/logout')
def logout():
    logout_user()
    return "You are now logged out!"
```

**Slide 11: Worked Example 6: Protecting a Route**

  - **Key Point:** We can now protect routes from anonymous users with one line.

<!-- end list -->

```python
# In moj/routes.py
# ... (imports) ...
from flask_login import login_user, logout_user, current_user, login_required # <-- NEW

# ... (login, logout routes) ...

# Let's add a new "Staff Only" page
@app.route('/staff_lounge')
@login_required # <-- 4. THIS IS THE MAGIC
def staff_lounge():
    return "Welcome to the staff lounge, {}!".format(current_user.username)
```

  - **Speaker Note:** "If you are *not* logged in and try to go to `/staff_lounge`, the `login.login_view = 'login'` setting (from Slide 8) and the `@login_required` decorator will work together to automatically send you to the `/login` page."

**Slide 12: Authorization (AuthZ): The "VIP List"**

  - **Key Point:** We have AuthN (login). Now we need AuthZ (roles).
  - This is a **database schema change**.
  - **Step 1: Add the `role` column to our model.**

<!-- end list -->

```python
# In moj/models.py

class User(UserMixin, db.Model):
    # ... (id, username, email, password_hash) ...
    role = db.Column(db.String(10), index=True, default='user') # <-- NEW
    jokes = db.relationship('Joke', backref='author', lazy='dynamic')
    # ... (rest of the class) ...
```

  - **Speaker Note:** "We're setting a `default` of 'user'. This means all existing users will get this role, and any new users will get it automatically."

**Slide 13: Worked Example 7: Run the Migration\!**

  - **Key Point:** We just changed our models, so we *must* run a migration. This is a direct skill from Cycle 1 (ICE 7).

  - **Step 2: Run the `migrate` and `upgrade` commands.**

    ```bash
    # Make sure your venv is active

    # 1. Generate the migration script
    flask db migrate -m "Add role column to User model"

    # 2. (CRITICAL) Inspect the script!
    # Open migrations/versions/....py.
    # Make sure it's adding the 'role' column. This is your "code review" step.

    # 3. Apply the change to the database
    flask db upgrade
    ```

  - **Speaker Note:** "This is the professional workflow. Model, migrate, inspect, upgrade. We've now successfully changed the 'blueprint' of our live database."

**Slide 14: Worked Example 8: Using Roles**

  - **Key Point:** `flask-login` gives us the `current_user` object in every route. We can now use it to check roles.

<!-- end list -->

```python
# In moj/routes.py
from flask import abort # <-- NEW

@app.route('/admin_panel')
@login_required # 1. They must be logged in...
def admin_panel():
    # 2. ...and they MUST be an admin!
    if current_user.role != 'admin':
        abort(403) # "Forbidden" error
    
    return "Welcome to the ADMIN PANEL, {}.".format(current_user.username)
```

  - **Speaker Note:** "This is the core of Authorization. The `@login_required` decorator handles AuthN. The `if` statement handles AuthZ. We'll add a 403 error handler (like our 404) later to make this look nice."

**Slide 15: Key Takeaways**

  - **Authentication (AuthN)** = "Who you are" (Login).
  - **Authorization (AuthZ)** = "What you can do" (Roles).
  - **Never store plain text passwords.** Use `werkzeug.security` to `generate_password_hash` and `check_password_hash`.
  - **`flask-login`** manages sessions for us.
      - Requires `LoginManager` in `__init__.py`.
      - Requires `UserMixin` and `@login.user_loader` in `models.py`.
  - **`@login_required`** protects routes from anonymous users.
  - **`current_user`** is the "global" object we use to check properties like `current_user.username` or `current_user.role`.
  - Adding a new column (like `role`) is a schema change that **requires a new migration**.

**Slide 16: Your Mission (ICE 9)**

  - The lecture code is the "backend" logic, but it's not user-friendly. We "hardcoded" the login for `user 1`.
  - Your task in the ICE is to build the **frontend**:
    1.  A **Registration Form** to create *new* users (and hash their passwords).
    2.  A **Login Form** that *actually* accepts a username and password.
    3.  A **Navigation Bar** that *changes* based on who is logged in (e.g., "Login" vs. "Logout" link).
  - This will require a new tool: `flask-wtf` for forms.
