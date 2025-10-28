# ICE 7: The Ministry's Filing Cabinet
- **Objective:** Define the core database models (`User`, `Joke`) using SQLAlchemy and create the initial **SQLite** database migration.
- **Time Limit:** 25 minutes
- **Context:** The Ministry of Jokes can't just shout "Hello World!" into the void; it needs to *store* the jokes it receives. This exercise builds the "digital filing cabinet" (the database schema) that will form the foundation of our application. We'll use **SQLite** for this first cycle because it's simple, file-based, and lets us focus on the *models* without worrying about a separate database server.

---

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Database Architect Kit**. Assign these three roles immediately.
*Remember the course policy: You cannot hold the same role for more than two consecutive weeks.*

* **`Repo Admin`:** (Environment) Installs new Python packages, updates `requirements.txt`, and handles all Git operations (branching, committing, PR).
* **`Process Lead`:** (Integration) Configures the Flask app (`app.py` or `__init__.py`) to connect to the SQLite database and initializes the `flask-migrate` tool.
* **`Dev Crew`:** (Feature) Defines the data schema by writing and completing the `User` and `Joke` models in a new `models.py` file.

---

## Task Description: Commissioning the Filing System

### Part 1: Branch and Install (Repo Admin)
1.  Pull the latest `main` branch.
2.  Create a new feature branch named `ice7-models-and-migrations`.
3.  In your active virtual environment (`venv`), install the new packages:
    ```bash
    pip install flask-sqlalchemy flask-migrate
    ```
4.  Update your `requirements.txt` file:
    ```bash
    pip freeze > requirements.txt
    ```
5.  `git add requirements.txt` and `git commit -m "feat: add sqlalchemy and migrate packages"`.
6.  *Communicate to the Process Lead and Dev Crew that the branch is ready.*

### Part 2: Configure the Database (Process Lead)
1.  Ensure you are on the `ice7-models-and-migrations` branch (`git checkout ice7-models-and-migrations` & `git pull`).
2.  Open your main application file (e.g., `app.py` or `project/__init__.py`).
3.  Add the following Python code to configure the app. *Place imports at the top and configuration logic near your `app = Flask(...)` line.*

    ```python
    import os
    from flask_sqlalchemy import SQLAlchemy
    from flask_migrate import Migrate

    # Get the absolute path of the directory this file is in
    basedir = os.path.abspath(os.path.dirname(__file__))

    # ... (your existing app = Flask(...) line) ...

    # --- Database Configuration ---
    # Use SQLite. The database file will be named 'moj.db'
    # and stored in the same directory as this file.
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'moj.db')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db = SQLAlchemy(app)
    migrate = Migrate(app, db)
    # --- End Database Configuration ---
    ```
4.  **CRITICAL:** The `moj.db` file is your database. It should *never* be committed to Git. Open your `.gitignore` file and add this line to the bottom:
    ```
    # Local database file
    moj.db
    ```
5.  `git add .gitignore app.py` (or `project/__init__.py`) and `git commit -m "config: initialize sqlalchemy and migrate for sqlite"`.
6.  *Communicate to the Dev Crew that the `db` object is ready to be used.*

### Part 3: Define the Models (Dev Crew)
1.  Ensure you are on the `ice7-models-and-migrations` branch and have pulled the Process Lead's changes (`git pull`).
2.  Create a new file: `project/models.py`.
3.  Add the following code to `project/models.py`. **Your task is to fill in the commented-out stubs** based on the comments and the worked examples.

    ```python
    # We must import the 'db' object from our main app file
    from app import db 
    # Or, if using a factory pattern: from . import db
    import datetime

    class User(db.Model):
        # --- "I" (Worked Example) ---
        # Here is a complete, working example for you to copy.
        id = db.Column(db.Integer, primary_key=True)
        username = db.Column(db.String(80), unique=True, nullable=False)
        password_hash = db.Column(db.String(128))

        # --- "WE" (Guided Practice) ---
        # Complete the definitions below using the worked example as a guide.
        
        # TODO: Define the email column
        # Requirements: String(120), unique, cannot be null
        #email = db.Column(...)

        # TODO: Define the role column
        # Requirements: String(20), cannot be null, default value is 'user'
        # role = db.Column(...)

        # TODO: Uncomment this relationship *after* you define the Joke model
        #jokes = db.relationship('Joke', backref='author', lazy=True)

        def __repr__(self):
            return f'<User {self.username}>'

    class Joke(db.Model):
        # --- "YOU" (Independent Practice) ---
        # Now, define this entire model based on what you learned from User.
        
        # TODO: Define the id column
        # Requirements: Integer, primary key
        #id = db.Column(...)

        # TODO: Define the joke_text column
        # Requirements: Text (use db.Text), cannot be null
        #joke_text = db.Column(...)

        # TODO: Define the created_at column
        # Requirements: DateTime, cannot be null, default to the current time
        # Hint: You'll need `default=datetime.datetime.utcnow`
        #created_at = db.Column(...)

        # TODO: Define the user_id (foreign key)
        # Requirements: Integer, foreign key to 'user.id', cannot be null
        # Hint: Use `db.ForeignKey('user.id')`
        # user_id = db.Column(...)
        
        def __repr__(self):
            return f'<Joke {self.id}>'
    ```
4.  **CRITICAL STEP:** The migration tool needs to "see" these models. Go back to your *main app file* (`app.py` or `project/__init__.py`) and add this import *after* the `migrate = Migrate(app, db)` line:
    ```python
    # Import models so migrations tool can find them
    from project import models 
    ```
5.  `git add project/models.py app.py` (or `project/__init__.py`) and `git commit -m "feat: define User and Joke models"`.
6.  *Push your commits.*

### Part 4: Run the First Migration (Process Lead & Repo Admin)
1.  **Repo Admin:** Pull all commits from the Dev Crew (`git pull`).
2.  **Process Lead:** Share your screen.
3.  **Process Lead:** Run the **one-time-only** init command. This creates the `migrations/` directory.
    ```bash
    flask db init
    ```
    * **Verification:** You will see a new `migrations` folder appear in your project.
4.  **Process Lead:** Run the migration generator. This "reads" your models and writes the migration script.
    ```bash
    flask db migrate -m "Initial User and Joke models"
    ```
    * **Verification:** You will see output like `INFO  [alembic.autogenerate.compare] Detected new table 'user'` and `...Detected new table 'joke'`. A new script will appear in `migrations/versions/`.
5.  **Process Lead:** Apply the migration to your database.
    ```bash
    flask db upgrade
    ```
6.  **Process Lead (Verification):**
    * You will see output like: `INFO  [alembic.runtime.migration] Running upgrade ... -> ...`
    * **Crucially:** A new file named `moj.db` should now exist in your project (in the same directory as your `app.py`). This is your new SQLite database file!
7.  **Repo Admin:** You should now see the `migrations/` directory.
    ```bash
    git add migrations/
    git commit -m "chore: add initial migration script"
    ```
8.  **Repo Admin:** Push all new commits to the remote branch (`git push`).

---

## `CONTRIBUTIONS.md` Log Entry

*One team member share their screen.* Open `CONTRIBUTIONS.md` on your feature branch and add the following entry **using this exact format**:

    ```markdown
    #### ICE 7: The Ministry's Filing Cabinet
    * **Date:** 2025-10-27
    * **Team Members Present:** `@github-user1`, `@github-user2`, ...
    * **Roles:**
        * `Repo Admin`: `@github-userX`
        * `Process Lead`: `@github-userY`
        * `Dev Crew`: `@github-userZ`, ...
    * **Summary of Work:** Defined the `User` and `Joke` SQLAlchemy models, configured the Flask app to use **SQLite**, and generated the initial database migration.
    * **Evidence & Reflection:** In the `Angband` project, all "data" was stored in flat `.txt` files (e.g., `monster.txt`). What specific, practical problems will using a relational database (like SQLite) and an ORM (like SQLAlchemy) solve for the Ministry of Jokes project?
    ```

*After logging, commit and push this file. All other members must `git pull` to get the change.*

-----

## Definition of Done (DoD) 🏁

Your team's work is "Done" when you can check all of the following:

  * [ ] **Artifact:** `requirements.txt` is updated with `flask-sqlalchemy` and `flask-migrate`.
  * [ ] **Artifact:** `project/models.py` exists and is *fully completed* (no commented-out stubs).
  * [ ] **Artifact:** The Flask app is configured for SQLite.
  * [ ] **Artifact:** `.gitignore` is updated to ignore `moj.db`.
  * [ ] **Artifact:** A `migrations/` directory exists with a successful, committed migration script.
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated and *all team members* have the pulled file locally.
  * [ ] **Submission:** A Pull Request is open and correctly configured (see below).

-----

## Submission (Due by end of class)

1.  **Open Pull Request:** Open a new PR to merge your feature branch (`ice7-models-and-migrations`) into `main`.
2.  **Title:** `ICE 7: The Ministry's Filing Cabinet`
3.  **Reviewer:** Assign your **Team TA** as a "Reviewer."
4.  **Submit to Canvas:** Submit the URL of the Pull Request to the Canvas assignment.

-----

## 💡 Standard Blocker Protocol (SBP)

**If you are individually blocked for \> 15 minutes** on a technical error you cannot solve, you can invoke the SBP. This is an *individual* protocol to protect your on-time grade.

1.  **Notify Team:** Inform your team that you are invoking the SBP and pivot to helping them with a different task (e.g., documentation, testing, research).
2.  **Create Branch:** Create a new *individual* branch (e.g., `aar-ice7-kseiffert`).
3.  **Create AAR File:** Create a new file in your repo: `aar/AAR-ICE7-<your_github_username>.md`.
4.  **Copy & Complete:** Copy the template below into your new file and fill it out completely.
5.  **Submission (Part 1 - 5 pts):** Open a Pull Request to merge your AAR branch into `main`.
      * **Title:** `AAR ICE 7: <Brief Description of Blocker>`
      * **Reviewer:** Assign your **Instructor** as a "Reviewer."
      * **Submit to Canvas:** Submit the URL of *your AAR Pull Request* to this Canvas assignment. This counts as your on-time submission.
6.  **Submission (Part 2 - 5 pts):** After the instructor provides a hotfix in the PR, you will apply it, achieve the original DoD, and **resubmit your *passing* PR** *to this same assignment* to receive the final 5 points.

-----

## AAR Template (Copy into `aar/AAR-ICE7-....md`)

```markdown
# AAR for ICE 7: [Blocker Title]

* **Student:** `@your-github-username`
* **Timestamp:** `2025-10-27 @ HH:MM`

---

### Instructor's Diagnostic Hints
* **Hint 1:** Migration tool says "No changes detected"? Check your main `app.py`. Did you remember to `import` your `models.py` file *after* you defined the `migrate` object?
* **Hint 2:** `NameError: 'db' is not defined`? Check the top of `models.py`. Did you correctly import the `db` object (e.g., `from app import db`)?
* **Hint 3:** `AttributeError` or `ImportError` on startup? This is often a circular import. Check that your `from project import models` line in `app.py` comes *after* `db = SQLAlchemy(app)` and `migrate = Migrate(app, db)`.

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