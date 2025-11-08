# Raw development file for mod1_lec03 starting with SQL alchemy and such. 

## **---- PROMPT -----**
```markdown
Files: `ICE_07_Model_migration`, `MongoDB_exploration.md`
We will be developing the mod1_lec03 slide deck on databases and MoJ. Would it be helpful to have the mod1_lec02 slide deck? or the previous ICE before we begin?
```
That context is always helpful for ensuring perfect continuity, but based on the `general_plan_for_final_7_weeks.md` and the `decisions_log.md`, I have enough information to proceed.

I will assume:

1.  **`mod1_lec01`** established a basic "Hello World" Flask app in `app.py`.
2.  **`mod1_lec02`** established a `main.yml` file for Continuous Integration that runs `pytest` and `flake8`.
3.  **This lecture (`mod1_lec03`)** will introduce the "M" (Model) in our "MVC" pattern, adding `flask-sqlalchemy` and `flask-migrate` to the project.
4.  The corresponding **`ICE 3`** (which I see an older version of named `ICE_07_Models_Migrations.md`) will task students with defining the `User` and `Joke` models and creating the first database migration.

Here is the complete slide deck for `mod1_Lec03`.

-----

# Lecture 3: Databases, Models, & Migrations

## Slide 1: Title Slide

  - **Topic:** Databases, Models, & Migrations
  - **Course:** Software Engineering (CSCI-P 465)
  - **Module 1:** Greenfield Development (The Ministry of Jokes)

## Slide 2: Learning Objectives

  - By the end of this lecture, you will be able to:
  - **Contrast** "brownfield" flat-file data (Angband) with a "greenfield" relational database.
  - **Define** a data model using Python classes with `flask-sqlalchemy`.
  - **Explain** the purpose of an Object-Relational Mapper (ORM).
  - **Initialize** a `flask-migrate` workflow to manage database schema changes.
  - **Identify and solve** the "circular import" problem in a Flask application.

## Slide 3: The "Why": From Angband to MoJ

  - **Key Point:** How did Angband store its data? In complex, C-parsed `.txt` files (e.g., `monster.txt`, `vault.txt`).
  - **The "Brownfield" Problem:** This flat-file approach is fast for a single-user C game, but it's brittle, hard to query, and has no concept of "concurrency" (multiple users) or "relations" (e.g., which user *owns* which monster).
  - **The "Greenfield" Solution:** The Ministry of Jokes (MoJ) **must** support many users and complex relationships (a User submits many Jokes). We need a real database.
  - **Speaker Note:** "Start here. Ask the class: 'Where did Angband keep its data? What were the *engineering* problems with that approach?' Guide them to answers like 'concurrency,' 'data integrity,' and 'querying.' This bridges the two halves of the course."

## Slide 4: What is a Database?

  - **Analogy:** A database is a professional, organized "digital filing cabinet" for your application's data.
  - **Key Point:** Instead of just dumping data in a `.txt` file, a database provides:
      - **Structure:** Enforces rules (e.g., "every User *must* have a unique email").
      - **Querying:** Lets you ask complex questions (e.g., "Show me all jokes submitted last Tuesday").
      - **Concurrency:** Manages access from thousands of users at once without corrupting the data.
  - **Our Choice:** We will use **SQLite** for development. It's a simple, file-based database that's perfect for getting started without a complex server.
  - **Instructor Prompt (Evidence):** "Ask: 'What are the two main "filing systems" you've heard of?' (Relational/SQL vs. Non-Relational/NoSQL). This checks their prior knowledge and tees up the concepts from the *MongoDB exploration* assignment."

## Slide 5: The Problem: Python vs. SQL

  - **Key Point:** Our Flask application "thinks" in Python (objects, classes, lists). Our database "thinks" in SQL (tables, rows, queries).
  - **The "Impedance Mismatch":** These two worlds don't speak the same language. Writing raw SQL inside our Python code is tedious, error-prone, and a massive security risk (SQL Injection).
  - **Code Example (The "Bad" Way):**

<!-- end list -->

```python
# We want to AVOID writing this by hand!
def create_user(username, email):
    # This is DANGEROUS and
    # does not protect against SQL injection!
    db.execute(f"INSERT INTO users (username, email) VALUES ('{username}', '{email}')")
```

  - **Speaker Note:** "Emphasize that concatenating strings to build queries is one of the oldest and most dangerous security flaws on the web. We need a 'translator' that handles this for us."

## Slide 6: The Solution: The ORM "Translator"

  - **Key Point:** An **O**bject-**R**elational **M**apper (ORM) is a "translator" that maps our Python classes directly to database tables.
  - **Our ORM:** We will use `flask-sqlalchemy`.
  - **The Benefit:** We get to write pure, clean Python. The ORM writes the safe, efficient SQL for us behind the scenes.
  - **Code Example (The "Good" Way):**

<!-- end list -->

```python
# This is our Python "model"
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)

# This is how we use it (Pure Python!)
new_user = User(username='clio_the_muse')
db.session.add(new_user)
db.session.commit()
```

  - **Speaker Note:** "This is the core concept. Show the Python class and the Python query. Stress that we never wrote a single line of SQL. The ORM handled it all."

## Slide 7: Wiring it Up (Worked Example 1)\*\*

  - **Key Point:** To use our ORM, we must:
    1.  Install it: `pip install flask-sqlalchemy`
    2.  Configure our Flask `app` to tell it where the database file is.
    3.  Initialize the `db` object (our "translator").
  - **Code Example (`app.py`):**

<!-- end list -->

```python
import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy # New import

app = Flask(__name__)

# --- Database Configuration ---
# Find the absolute path of the project root
basedir = os.path.abspath(os.path.dirname(__file__))
# Set the database URI
app.config['SQLALCHEMY_DATABASE_URI'] = \
    'sqlite:///' + os.path.join(basedir, 'moj.db') # Creates moj.db in root

# Initialize the ORM "translator" object
db = SQLAlchemy(app)

# ... (routes will go here) ...
```

  - **Speaker Note:** "Walk through this line by line. Explain that `sqlite:///moj.db` creates a simple file named `moj.db` in our project's root. This is the 'filing cabinet' itself."

## Slide 8: The *Real* Hard Problem: Change

  - **Key Point:** Your code is easy to change (`git pull`). Your *database's structure* (the **schema**) is not.
  - **The Scenario:**
      - **Week 1:** You launch with a `User` model (username, password).
      - **Week 2:** You have 10,000 users in your database.
      - **Week 3:** You need to add an `email` column to the `User` model.
  - **The Question:** How do you update the *live database* to add this new column **without** deleting the 10,000 users who already exist?
  - **Speaker Note:** "This is a critical, real-world concept. Stress that managing *state* (the DB) is much harder than managing *code*. This is what separates senior devs from junior devs."

## Slide 9: Historical Hook: Database Migrations

  - **Key Point:** This "schema change" problem is solved with **Database Migrations**.
  - **Historical Hook:** For decades, engineers did this manually. They would write `.sql` scripts (e.g., `ALTER TABLE users ADD COLUMN email VARCHAR(120);`) and run them by hand during a "maintenance window" (e.g., 3 AM on a Sunday). This was risky, error-prone, and terrifying.
  - **The Modern Solution:** We use tools that *automate* this. We need "Git for our Database Schema."
  - **Our Tool:** `flask-migrate` (which uses a powerful library called `Alembic`).
  - **Speaker Note:** "Frame this as a massive quality-of-life improvement. We are standing on the shoulders of giants who solved this painful problem."

## Slide 10: The `flask-migrate` Workflow (Worked Example 2)

  - **Analogy:** `flask-migrate` is "Git for your Database Schema."
  - **Key Point:** It compares your Python models (`models.py`) to the *current* state of the database. It then *auto-generates* the safe "migration script" needed to upgrade (or downgrade) the database to match your code.
  - **Code Example (The 3 Commands):**

<!-- end list -->

```bash
# 0. Install it: pip install flask-migrate

# 1. (One time only) Create the 'migrations' folder
#    (Like `git init`)
$ flask db init

# 2. (Every time you change models.py) Auto-generate a new script
#    (Like `git add .` + `git commit -m "..."`)
$ flask db migrate -m "Added User and Joke models"

# 3. (Every time) Apply the script to the database
#    (Like `git push`)
$ flask db upgrade
```

  - **Speaker Note:** "Explain these three commands clearly using the Git analogy. `init` is once. `migrate` *records* the change. `upgrade` *applies* the change. This is the workflow for the ICE."

## Slide 11: The \#1 Blocker: The "Circular Import" Trap

  - **Key Point:** You are *all* going to hit this. It's the most common trap in Flask.
  - **The Paradox:**
    1.  `app.py` needs to import `models.py` (to know about the `User` class for our routes).
    2.  `models.py` needs to import `app.py` (to get the `db = SQLAlchemy(app)` object).
  - **The Result:** A "circular import" paradox. Python will crash with an `ImportError: cannot import name ...`
  - **Speaker Note:** "Draw this loop on the board: `app.py` -\> `models.py` -\> `app.py`. Tell them this error is a rite of passage. Then, immediately show them the solution on the next slide. This is scaffolding: defuse the \#1 blocker *before* the exercise."

## Slide 12: The Solution: The "Late Import" Pattern (Worked Example 3)

  - **Key Point:** The solution is to delay one of the imports. We make sure `app.py` *finishes* defining the `db` object *before* `models.py` (or anything else) tries to import it.
  - **The "Golden" `app.py` Structure:**

<!-- end list -->

```python
# --- app.py ---
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate  # New import

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///moj.db'

# --- INIT ALL THE PLUGINS ---
# These objects MUST be defined globally here
db = SQLAlchemy(app)
migrate = Migrate(app, db) # New line for migration support

# CRITICAL: Import models *after* db is defined
# This avoids the circular import!
from project import models 

# --- ROUTES ---
@app.route('/')
def hello():
    return "Hello from MoJ!"

# ... other routes
```

  - **Speaker Note:** "This is the 'golden template.' The `from project import models` line *must* come *after* `db = SQLAlchemy(app)`. This is the hint for the ICE."

## Slide 13: Key Takeaways

  - **Takeaway 1:** We use a **database** (not flat files) for robust, concurrent data storage. Angband's `.txt` files were not suitable for a web app.
  - **Takeaway 2:** We use an **ORM** (`flask-sqlalchemy`) to "translate" our Python classes into SQL tables, which is safer and easier.
  - **Takeaway 3:** We use **migrations** (`flask-migrate`) to safely and automatically update our database structure *every time* we change our Python models.

## Slide 14: Next Up: ICE 3

  - **Objective:** Your team will now provision the "digital filing cabinet" for the Ministry of Jokes.
  - **Your Task:**
    1.  Install and configure `flask-sqlalchemy` and `flask-migrate`.
    2.  Define the `User` and `Joke` models in `models.py`.
    3.  Generate the first migration script.
    4.  Verify the `moj.db` file is created and your CI pipeline still passes.




## **---- PROMPT -----**
```markdown

```




## **---- PROMPT -----**
```markdown

```