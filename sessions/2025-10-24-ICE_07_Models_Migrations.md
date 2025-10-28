Here is the updated slide deck for Lecture 3 (of the 7-week MoJ arc).

This version is now fully consistent with our finalized `ICE_07_Models_Migrations.md`:

1.  It is updated to use **SQLite** (instead of Postgres).
2.  It uses the **Flask-Migrate** (`flask db ...`) commands (instead of raw Alembic).
3.  It introduces the new **Standard Blocker Protocol (SBP)** and the AAR template.

-----

# Lecture 3: Databases & Models

## Slide 1: Title Slide

  - **Topic:** Databases, Models, & Migrations
  - **Course:** Software Engineering

## Slide 2: Learning Objectives

  - By the end of this lecture, you will be able to:
  - **Explain** why a web app needs a database for persistence.
  - **Define** the role of an ORM (Object-Relational Mapper) like SQLAlchemy.
  - **Implement** a Python "Model" class that maps to a database table.
  - **Explain** why database "migrations" (using **Flask-Migrate**) are critical for team-based development.

## Slide 3: Bridging Context: Where Does Our Data Go?

  - **Key Point:** In Lecture 1, our Flask app had a "joke." When the server restarted, the joke was gone. This is called **in-memory storage**.
  - **The Problem:** In-memory storage is **ephemeral** (temporary). For the "Ministry of Jokes" to work, jokes and users must be saved *permanently*.
  - **The Solution:** We need a **database** for **persistence**.
  - Speaker Note: "Think of your Flask app as a temporary office worker. When they go home for the night (the server restarts), their desk is cleared. We need to give them a permanent filing cabinet—that's our database."

## Slide 4: Our First Database: SQLite

  - **Key Point:** For this first project cycle, we will use **SQLite**.
  - **What is SQLite?** It's a simple, fast, self-contained database engine that runs *inside* our application. It stores the entire database in a **single file** (e.g., `moj.db`).
  - **Why not Postgres?** We will use a powerful *database server* (like Postgres) later. SQLite has **zero setup** and lets us focus 100% on the *models* and *migrations* first.
  - Speaker Note: "This is the 'Cognitive Load Management' principle in action. We are isolating one new concept (Models/ORMs) by using the simplest possible tool for the job."

## Slide 5: The Problem: Code vs. Data

  - **Key Point:** Our application "thinks" in Python (objects, classes, methods), but our database "thinks" in SQL (tables, rows, columns).
  - **The "Impedance Mismatch":** How do we translate `my_user.get_email()` into `SELECT email FROM user WHERE id=1`?
  - **Bad Solution:** Writing raw SQL queries by hand (e.g., `db.execute("INSERT INTO ...")`).
      - This is tedious, error-prone, and a major security risk (SQL Injection).
  - **Good Solution:** Use a "translator."

## Slide 6: The Solution: An "ORM"

  - **Key Point:** We use an **Object-Relational Mapper (ORM)**.
  - **What it is:** An ORM is a library that automatically translates our Python objects and methods into SQL queries, and vice-versa.
  - **The Analogy:** The ORM is our "universal translator."
      - **We speak Python:** `user.username = "new_name"`
      - **The ORM translates:** `UPDATE user SET username = 'new_name' WHERE id = 1`
      - **We speak Python:** `db.session.add(new_joke)`
      - **The ORM translates:** `INSERT INTO joke (joke_text, ...) VALUES (...)`

## Slide 7: What is SQLAlchemy?

  - **Key Point:** **SQLAlchemy** is the most popular, powerful, and professional-grade ORM in the Python world.
  - It is *not* a database. It is a *translator* that can talk to many different databases (SQLite, Postgres, MySQL, etc.).
  - We will use the **Flask-SQLAlchemy** extension, which is a simple wrapper that makes it easy to integrate with our Flask app.
  - Speaker Note: "Learning SQLAlchemy is a major, transferable skill. It's used by companies like Reddit, Dropbox, and Yelp."

## Slide 8: From `class` to `table`

  - **Key Point:** With an ORM, our database "schema" (the design) is just a Python class that inherits from `db.Model`.
  - We define the *columns* as class-level *attributes*.
  - **Code Example:** This is the **"I" of our I-WE-YOU** model.

<!-- end list -->

```python
# We define a Python class
class User(db.Model):
    # SQLAlchemy translates this...
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

# ...into this SQL
CREATE TABLE user (
    id INTEGER NOT NULL,
    username VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (username),
    UNIQUE (email)
);
```

  - Speaker Note: "Notice how `nullable=False` becomes `NOT NULL`. The ORM handles the translation, so we can stay in our 'Python brain'."

## Slide 9: The Problem with Models

  - **Key Point:** This is great for Week 1. But what happens in Week 2, when we want to add a `role` column to our `User` model?
  - `class User(db.Model): ... role = db.Column(db.String(20))`
  - **The Conflict:** Our *code* (the Model) now **does not match** our *database* (the Table).
  - **The Problem:** If we just run the app, it will crash. If we drop the whole database, *we lose all our data*. How do we safely *change* a live database?

## Slide 10: The Solution: Migrations

  - **Key Point:** We **never** change a production database by hand. We use a **migration tool**. We will use **Flask-Migrate**.
  - (Flask-Migrate is a simple wrapper for a powerful tool called **Alembic**).
  - **What it is:** A migration is a small, version-controlled *script* that describes *one single change* to the database schema.
  - **The Analogy:** Migrations are like **`git commit` for your database**.
      - `git` records changes to your *code*.
      - `flask-migrate` records changes to your *database schema*.

## Slide 11: The Migration Workflow

  - **Key Point:** This is a critical, three-step "safety dance" that you will do *every time* you change your models.
  - **Step 1: You edit `models.py`**
      - (e.g., You add `role = db.Column(...)` to the `User` model)
  - **Step 2: You run `flask db migrate -m "Added role to User"`**
      - Flask-Migrate "diffs" your models against the database.
      - It auto-generates a new Python script (e.g., `migrations/versions/abc123.py`) that contains the *one* command: `ALTER TABLE user ADD COLUMN role ...`.
      - You should **commit** this new script to Git.
  - **Step 3: You run `flask db upgrade`**
      - The tool runs the new migration script, safely applying the `ALTER TABLE` command.
      - Now your code, your migration scripts, and your database schema all match.

## Slide 12: Historical Hook: The Relational Model

  - **Key Point:** Why is it called an "Object-**Relational** Mapper"?
  - The "Object" part is our Python `class` objects.
  - The "Relational" part comes from the **Relational Model of Data**, a formal theory proposed by **Edgar F. Codd** at IBM in 1970.
  - Codd's paper defined the concept of "relations" (tables), "tuples" (rows), and "attributes" (columns) that are the foundation of SQL and nearly every modern database (SQLite, PostgreSQL, MySQL, etc.).
  - We are mapping our *new* object-oriented world (Python) to Codd's *foundational* relational world (SQL).

## Slide 13: New Policy: The Standard Blocker Protocol (SBP)

  - **Key Point:** In the *Angband* project, getting blocked was frustrating. For the *MoJ* project, we have a "safe harbor" policy.
  - **The SBP:** If you are **individually blocked for \> 15 minutes**, you can invoke the SBP.
  - This is a **Process Pivot**, not a failure.
  - Your new goal: Stop coding and write a professional **After-Action Report (AAR)**. This is a core engineering skill.

## Slide 14: The AAR (After-Action Report) Workflow

  - **Key Point:** Your ICE template now contains a full AAR template.
  - Crucially, it includes **"Instructor's Diagnostic Hints"**—check these first\!
  - **The 5+5 Grading Workflow:**
    1.  **Part 1 (5 pts):** Create an `aar/AAR-ICE[X]-username.md` file, fill it out, and open a **Pull Request** assigning me as reviewer. Submit the PR link. This is your "on-time" submission.
    2.  **Part 2 (5 pts):** I will give you a "hotfix" in the PR. You apply the fix, complete the ICE, and resubmit your *passing* PR for the final 5 points.
  - Speaker Note: "This is how senior and junior engineers interact. The goal is to turn a blocker into an actionable, documented report. The AAR is a *learning opportunity*, not a penalty."

## Slide 15: Next: In-Class Exercise (ICE 7)

  - **Topic:** The Ministry's Filing Cabinet
  - **Task:** It's time to build the "filing cabinet."
  - **Goal:** You will:
    1.  Install `flask-sqlalchemy` and `flask-migrate`.
    2.  Configure the app to use **SQLite** (and create a `moj.db` file).
    3.  Define the `User` and `Joke` models using the **I-WE-YOU** template.
    4.  Initialize Flask-Migrate (`flask db init`).
    5.  Run `flask db migrate` to create your *first migration script*.
    6.  Run `flask db upgrade` to apply the migration and create your database.

## Slide 16: Key Takeaways

  - We need a **Database (SQLite)** for **Persistence** (to save data).
  - We use an **ORM (SQLAlchemy)** to translate our Python code into SQL commands.
  - We use **Migrations (Flask-Migrate)** to safely change our database schema over time.
  - The **SBP** is your "safe harbor" to turn a blocker into a learning (and grading) opportunity.