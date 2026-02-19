# Chapter 3: Databases and SQLAlchemy

- **Course:** Software Engineering (P465/P565)
- **Audience:** Upper-level undergraduates and Master's students
- **Prerequisites:** Flask routing and request/response cycle (Ch. 1), Python classes
  and instance attributes, basic SQL literacy (SELECT, INSERT, CREATE TABLE), Python
  decorators
- **Estimated Reading Time:** 55 minutes
- **Difficulty:** Intermediate
- **Chapter Type:** Applied

---

## Learning Objectives

By the end of this chapter, you will be able to:

1. **Explain** what an ORM is and articulate why SQLAlchemy is preferred over raw SQL
   strings in a Flask application.
2. **Define** SQLAlchemy models as Python classes and map them to database tables with
   appropriate column types, constraints, and foreign key relationships.
3. **Implement** all four CRUD operations (Create, Read, Update, Delete) against a
   SQLAlchemy-backed database from within Flask routes.
4. **Analyze** the relationship between Flask's application context and the SQLAlchemy
   session lifecycle to diagnose common `RuntimeError: No application context` errors.
5. **Design** a two-table schema for the Ministry of Jokes application that connects a
   `User` model to a `Joke` model via a foreign key.

---

## The Hook

Picture yourself three weeks into a startup. Your Flask app is working — users can
submit jokes, and you store them in a Python list in memory. Then your server restarts.
Every joke, every submission, every piece of state: gone. You add file I/O to persist
the data between restarts. Now you are manually parsing strings, managing encoding edge
cases, and writing brittle search logic that breaks every time a teammate changes the
joke format.

This is the wall every serious web application eventually hits, and it is the problem
relational databases were built to solve. But raw SQL comes with its own friction: you
embed query strings directly into your Python code, a user supplies a value like
`'; DROP TABLE jokes; --`, and your entire database evaporates. SQLAlchemy threads the
needle. It gives you the full power of a relational database while letting you work in
the Python object model you already know — and it handles query parameterization
automatically, so the injection above simply does not work. By the end of this chapter,
the Ministry of Jokes will have a real, persistent, queryable backend.

---

## Section 4: Core Content

### 4a. Concept Introduction — Worked Example

#### What Is an ORM?

An **Object-Relational Mapper (ORM)** translates between two worlds:

| Python World                | Database World               |
|-----------------------------|------------------------------|
| Class definition            | Table schema                 |
| Object instance             | Row                          |
| Instance attribute          | Column value                 |
| `db.session.add(obj)`       | `INSERT INTO …`              |
| `Model.query.filter_by(…)`  | `SELECT … WHERE …`           |
| `db.session.delete(obj)`    | `DELETE FROM … WHERE id = ?` |

Instead of writing `cursor.execute("INSERT INTO jokes (body) VALUES (?)", [body])`,
you create a `Joke` object and let SQLAlchemy generate — and safely parameterize —
the SQL for you.

---

#### Step 1: Install and Configure

```bash
pip install flask flask-sqlalchemy
```

A minimal Flask-SQLAlchemy setup in `app.py`:

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# SQLite for development; swap the URI for PostgreSQL in production
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///moj.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
```

`"sqlite:///moj.db"` means a SQLite file at `instance/moj.db` relative to your project
root (Flask resolves this automatically). Switching to PostgreSQL later only requires
changing this one string — all model and query code stays the same.

`SQLALCHEMY_TRACK_MODIFICATIONS = False` silences a deprecation warning and disables
an event system you will not use, saving a small amount of memory per request.

---

#### Step 2: Define a Model

Create `models.py`:

```python
from app import db
from datetime import datetime


class Joke(db.Model):
    __tablename__ = "jokes"

    id        = db.Column(db.Integer, primary_key=True)
    body      = db.Column(db.String(500), nullable=False)
    submitted = db.Column(db.DateTime, default=datetime.utcnow)
    approved  = db.Column(db.Boolean, default=False)

    def __repr__(self):
        return f"<Joke {self.id}: {self.body[:40]!r}>"
```

Four decisions worth understanding:

- **`primary_key=True`** — SQLAlchemy auto-increments this column; you never set it
  manually when creating new objects.
- **`nullable=False`** — enforced at the *database* level. An attempt to commit a
  `Joke` with no `body` raises an `IntegrityError`, not a Python `ValueError`.
- **`default=datetime.utcnow`** — note the absence of `()`. Passing the *function
  reference* means SQLAlchemy calls it fresh at insert time, giving each row a unique
  timestamp. Writing `default=datetime.utcnow()` would freeze every row to the
  module-load timestamp — a silent, common bug.
- **`__repr__`** — not required, but makes Flask shell debugging much more readable.

---

#### Step 3: Create the Tables

Tables do not exist until you tell SQLAlchemy to create them. In development, do this
once in a shell or at startup:

```python
# In a Flask shell, or in a management script
with app.app_context():
    from models import Joke   # model must be imported before create_all sees it
    db.create_all()
```

`db.create_all()` inspects every class that inherits from `db.Model` and issues
`CREATE TABLE IF NOT EXISTS` for each one. Calling it a second time is safe — it will
not drop or alter existing tables.

The `with app.app_context():` wrapper is mandatory outside of a request handler.
SQLAlchemy's session is bound to Flask's application context; calling database methods
without one raises:

```
RuntimeError: No application context.
```

Inside a route handler, Flask establishes the context automatically. Outside one —
in a management script, a test setup, or a Celery task — you must create it explicitly.

---

#### Step 4: CRUD in Routes

**Create:**

```python
from flask import request, redirect, url_for
from models import Joke

@app.route("/jokes/new", methods=["POST"])
def create_joke():
    body = request.form["body"]
    joke = Joke(body=body)   # id, submitted, and approved use their defaults
    db.session.add(joke)
    db.session.commit()
    return redirect(url_for("list_jokes"))
```

**Read:**

```python
@app.route("/jokes")
def list_jokes():
    # All jokes, newest first
    jokes = Joke.query.order_by(Joke.submitted.desc()).all()
    return "\n".join(j.body for j in jokes)   # templates arrive in Ch. 6
```

**Update:**

```python
@app.route("/jokes/<int:joke_id>/approve", methods=["POST"])
def approve_joke(joke_id):
    joke = Joke.query.get_or_404(joke_id)
    joke.approved = True
    db.session.commit()     # SQLAlchemy detects the mutation automatically
    return redirect(url_for("list_jokes"))
```

You do not call `db.session.add()` again for an update. SQLAlchemy tracks every object
it retrieves. The moment you mutate an attribute, the object is marked *dirty*, and
`commit()` flushes the change.

**Delete:**

```python
@app.route("/jokes/<int:joke_id>/delete", methods=["POST"])
def delete_joke(joke_id):
    joke = Joke.query.get_or_404(joke_id)
    db.session.delete(joke)
    db.session.commit()
    return redirect(url_for("list_jokes"))
```

---

#### Step 5: Foreign Keys and Relationships

The Ministry of Jokes needs to track which user submitted which joke. Add a `User`
model and a `user_id` foreign key to `Joke`:

```python
class User(db.Model):
    __tablename__ = "users"

    id       = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    jokes    = db.relationship("Joke", backref="author", lazy=True)


class Joke(db.Model):
    __tablename__ = "jokes"

    id        = db.Column(db.Integer, primary_key=True)
    body      = db.Column(db.String(500), nullable=False)
    submitted = db.Column(db.DateTime, default=datetime.utcnow)
    approved  = db.Column(db.Boolean, default=False)
    user_id   = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
```

Two things to unpack:

- **`db.ForeignKey("users.id")`** — the string uses the *table* name (`users`), not
  the class name (`User`). This is the single most common error in this chapter.
- **`db.relationship("Joke", backref="author", lazy=True)`** — lives on `User` and
  adds two Python-level conveniences: `user.jokes` returns all jokes for that user, and
  `joke.author` returns the `User` who submitted it. `lazy=True` means the related
  rows are fetched only when you access the attribute, not upfront at query time.

Usage:

```python
alice = User(username="alice")
db.session.add(alice)
db.session.commit()

joke = Joke(body="Why do programmers prefer dark mode?", user_id=alice.id)
db.session.add(joke)
db.session.commit()

print(joke.author.username)   # "alice"
print(alice.jokes)            # [<Joke 1: 'Why do programmers prefer dark mode?'>]
```

---

### 4b. Guided Practice — Scaffold Exercise

The Ministry of Jokes needs a route that lets users **search for jokes** by keyword.
The route accepts a `q` query parameter and returns only *approved* jokes whose `body`
contains that string (case-insensitive).

Complete every section marked `[YOUR TASK]`:

```python
@app.route("/jokes/search")
def search_jokes():

    # [YOUR TASK 1]
    # Extract the query parameter "q" from the URL.
    # If it is absent or empty, redirect to url_for("list_jokes").
    keyword = ___________________________

    # [YOUR TASK 2]
    # Query the Joke table for rows where:
    #   - approved is True
    #   - body contains `keyword` (case-insensitive)
    # Assign the result list to `results`.
    results = Joke.query.filter(
        Joke.approved == True,
        ___________________________
    ).all()

    # [YOUR TASK 3]
    # If no results, return "No jokes found."
    # Otherwise return each matching joke body on its own line.
    if not results:
        return ___________________________

    return "\n".join(___________________________ for j in results)
```

**Hints (read only after attempting):**

- `request.args.get("q", "")` retrieves a query parameter safely, defaulting to `""`
  if absent.
- SQLAlchemy's `ilike` method performs a case-insensitive pattern match:
  `Joke.body.ilike(f"%{keyword}%")`.

---

### 4c. Independent Application — Open Challenge

The Ministry of Jokes currently tracks jokes as either approved or not. The editorial
team wants a three-state workflow: `pending`, `approved`, and `rejected`.

**Your task:** Refactor the `Joke` model and relevant routes to support this workflow.

Specifically:

1. Replace the `approved: Boolean` column with a `status: String` column that accepts
   exactly the three values above. Enforce the valid values at the application layer
   (SQLite does not enforce CHECK constraints without extra configuration).
2. Update the `approve_joke` route to set `status = "approved"`.
3. Add a new `reject_joke` route that sets `status = "rejected"`.
4. Update the `list_jokes` route to accept an optional `?status=` query parameter and
   filter accordingly, defaulting to showing only `approved` jokes.

**Optional hints:**

- A module-level constant such as `VALID_STATUSES = {"pending", "approved", "rejected"}`
  lets you validate input before writing to the database.
- When altering an existing SQLite table in development, the standard approach is to
  drop and recreate with `db.drop_all()` followed by `db.create_all()`. In production
  you would use a migration tool — this is covered in a later chapter.

---

## Section 5: Historical Context

Relational databases trace to Edgar F. Codd's 1970 paper "A Relational Model of Data
for Large Shared Data Banks," which proposed organizing data into tables governed by
formal relational algebra. For decades the only way to interact with these systems from
application code was through raw SQL strings — a practice that tangled data logic with
business logic and left every application exposed to injection attacks. Object-Relational
Mappers emerged in the early 2000s to close that gap. SQLAlchemy, created by Michael
Bayer and first released in 2006, became the dominant Python ORM by prioritizing
*explicitness over magic*: unlike some frameworks that hide the database almost
entirely, SQLAlchemy lets you inspect generated SQL, drop to raw queries when necessary,
and control the session lifecycle directly. Flask-SQLAlchemy integrates that session
lifecycle into Flask's application context, making the combination the de facto standard
for Flask-based web applications.

---

## Section 6: Ethical Consideration

> **Ethical Reflection ✍️**
>
> SQLAlchemy makes it trivially easy to store vast amounts of data about users —
> every joke they submit, every action they take, every timestamp. Consider the
> Ministry of Jokes schema you are building: beyond `username` and `jokes`, what other
> data might a real application be tempted to collect "just in case it's useful later"?
> Who owns that data, what are the risks if the database is leaked or subpoenaed, and
> at what point does data collection shift from engineering convenience to a genuine
> privacy harm? If you were required to justify every column you added to a data
> protection officer, how would you design the schema differently?

---

## Section 7: Chapter Summary

- An ORM maps Python classes to database tables, objects to rows, and attributes to
  column values, eliminating the need to write raw SQL strings for common operations.
- Flask-SQLAlchemy ties SQLAlchemy's session lifecycle to Flask's application context;
  database calls made outside a request require an explicit `with app.app_context():`
  block.
- A SQLAlchemy model is a Python class inheriting from `db.Model`; column types,
  constraints (`nullable`, `unique`), and defaults are declared as class-level
  attributes.
- `db.create_all()` issues `CREATE TABLE IF NOT EXISTS` for all registered models and
  is safe to call multiple times, but it cannot alter existing tables.
- The four CRUD operations map to `db.session.add()` + `commit()` (Create),
  `Model.query` methods (Read), attribute mutation + `commit()` (Update), and
  `db.session.delete()` + `commit()` (Delete).
- Foreign keys are declared with `db.ForeignKey("table_name.column")` using the *table*
  name, not the class name; `db.relationship()` adds Python-level convenience accessors
  between related models.
- SQLAlchemy's automatic query parameterization makes SQL injection attacks ineffective
  against any query built through the ORM interface.

---

## Section 8: Self-Assessment Questions

**Factual Recall**

1. What does `nullable=False` enforce, and at which layer — Python or database — is
   that enforcement applied?

2. Explain why `default=datetime.utcnow` and `default=datetime.utcnow()` produce
   different behavior. Which is correct for a "record the insertion timestamp" use
   case, and why?

**Application**

3. A teammate writes the following model and finds that queries raise an error at
   runtime. Identify the mistake and write the corrected version.

   ```python
   class Comment(db.Model):
       __tablename__ = "comments"
       id      = db.Column(db.Integer, primary_key=True)
       text    = db.Column(db.String(300))
       joke_id = db.Column(db.Integer, db.ForeignKey("Joke.id"))
   ```

4. Write a Flask route `/jokes/unapproved` that returns a plain-text list of all joke
   bodies where `approved` is `False`, ordered by `submitted` ascending (oldest first).
   Use SQLAlchemy's query interface — do not write a raw SQL string.

**Critical Thinking**

5. `db.create_all()` is convenient in development but is never used to manage schema
   changes in a production application. Why not? What risks does it introduce, and what
   tool or workflow would you use instead?

---

## Section 9: Connections

- **Previous Chapter (Ch. 2 — Continuous Integration and Automated Testing):** Chapter
  2 established the pytest-based CI pipeline. Now that the application has a database,
  that test suite must manage database state — creating tables before tests run and
  tearing them down after. Chapter 4 addresses this directly with pytest fixtures and
  an in-memory SQLite database.
- **Next Chapter (Ch. 4 — Refactoring and Testing):** Chapter 4 builds on the models
  defined here, introducing test fixtures that provision a clean database for each test
  run and refactoring patterns that move logic out of route handlers and into testable
  model methods.
- **Real-World Link:** Flask-Migrate (built on Alembic) is the standard tool for
  managing incremental schema changes in production SQLAlchemy applications. It
  generates versioned `upgrade` / `downgrade` scripts that can be applied to a live
  database without data loss.
- **Further Reading:**
  - SQLAlchemy ORM Quickstart (official, free):
    https://docs.sqlalchemy.org/en/20/orm/quickstart.html
  - Flask-SQLAlchemy documentation (official, free):
    https://flask-sqlalchemy.palletsprojects.com/en/3.1.x/

---

---

## Section 10: Instructor Notes

*This section is for instructor use only. Exclude from the student-facing artifact.*

---

### Answer Key

**Q1 — `nullable=False`**

`nullable=False` enforces a NOT NULL constraint at the *database* level. When
SQLAlchemy generates the `CREATE TABLE` DDL, it appends `NOT NULL` to that column
definition. Attempting to commit a row without a value for that column raises a
`sqlalchemy.exc.IntegrityError` — not a Python `ValueError`. The constraint is *not*
enforced at Python attribute-assignment time; the error surfaces only at `commit()`.
Students commonly assume SQLAlchemy validates attributes on assignment; it does not.

**Q2 — `default=datetime.utcnow` vs. `default=datetime.utcnow()`**

`default=datetime.utcnow` passes the *function object* to SQLAlchemy. Each time a new
row is inserted, SQLAlchemy invokes the function and uses the returned value — giving
each row its own insertion timestamp. `default=datetime.utcnow()` evaluates the
function *immediately at class-definition time* (i.e., when the module is imported)
and stores the resulting `datetime` object as a static default. Every subsequent row
would receive the same frozen timestamp — the instant the Python process started. The
correct form is `default=datetime.utcnow` (no parentheses).

**Q3 — Foreign Key Bug**

The error is in `db.ForeignKey("Joke.id")`. `ForeignKey` requires the *table* name,
not the Python class name. Because the `Joke` model declares `__tablename__ = "jokes"`,
the correct reference is `"jokes.id"`:

```python
joke_id = db.Column(db.Integer, db.ForeignKey("jokes.id"))
```

SQLAlchemy raises `sqlalchemy.exc.NoReferencedTableError` at `create_all()` or first
query time when the class-name form is used.

**Q4 — `/jokes/unapproved` Route**

```python
@app.route("/jokes/unapproved")
def unapproved_jokes():
    jokes = (Joke.query
                 .filter_by(approved=False)
                 .order_by(Joke.submitted.asc())
                 .all())
    if not jokes:
        return "No unapproved jokes."
    return "\n".join(j.body for j in jokes)
```

Accept `filter(Joke.approved == False)` as equivalent to `filter_by(approved=False)`.
Both are correct; award full credit for either.

**Q5 — `db.create_all()` in Production**

`db.create_all()` only creates tables that do not yet exist; it cannot add a column to
an existing table, change a column type, or remove a column. Running it against a live
database with the wrong model state is a no-op at best and misleading at worst — the
developer may believe the schema was updated when it was not. There is also no version
record, so rollbacks are impossible. The standard solution is **Flask-Migrate** (built
on Alembic), which generates versioned migration scripts. Each script contains
`upgrade()` and `downgrade()` functions that can be applied (`flask db upgrade`) or
reversed (`flask db downgrade`) against a live database; the current migration version
is stored in an `alembic_version` table in the database itself.

---

### Common Misconceptions

1. **"I need to call `db.session.add()` again when updating an object."**
   Students frequently re-add an already-tracked object before committing an update.
   This is harmless but signals a misunderstanding: SQLAlchemy's identity map tracks
   every object it retrieves from the database. Mutating an attribute marks the object
   *dirty* automatically; `add()` is needed only for brand-new, never-persisted objects.

2. **"`db.ForeignKey()` takes the class name, not the table name."**
   This is the most common syntax error in this chapter. The string passed to
   `db.ForeignKey()` must match the `__tablename__` of the referenced model, not the
   Python class name. If the model uses `__tablename__ = "users"`, the correct foreign
   key is `db.ForeignKey("users.id")`, not `db.ForeignKey("User.id")`.

3. **"Database calls work anywhere in the code."**
   Students who call `db.create_all()` or execute queries at module level (outside any
   route or explicit context) are surprised by `RuntimeError: No application context`.
   The fix — `with app.app_context():` — is simple, but the underlying concept (the
   session is scoped to the context) is important to reinforce because it reappears in
   test fixtures (Ch. 4) and background workers later in the course.

---

### Suggested Lecture Talking Points

- **Open with the persistence problem.** Ask students what happens to their Flask app's
  data when the process restarts. Let them arrive at "we need a real database" on their
  own before introducing SQLAlchemy. The motivation is more durable when students derive
  it from a concrete failure mode rather than receiving it as a premise.

- **Draw the ORM translation table on the board.** The class ↔ table, object ↔ row,
  attribute ↔ column mapping is abstract until visualized. Draw it before showing any
  code, then walk through the `Joke` model line by line as a translation exercise —
  "what SQL does this line represent?"

- **Live-demo the `utcnow` vs. `utcnow()` bug.** Open a Python shell and show both
  forms. Create two objects a few seconds apart. The frozen timestamp from `utcnow()` is
  immediately visible and memorable in a way that reading about it is not. This demo
  also reinforces a broader Python lesson: be careful about what you evaluate at
  definition time versus at call time.

---

### Slide Outline

1. **The Persistence Problem** — data lost on restart; why file I/O does not scale;
   why raw SQL strings are dangerous (injection preview).
2. **What Is an ORM?** — the class/table, object/row, attribute/column translation
   table; SQLAlchemy's design philosophy versus Django ORM.
3. **Flask-SQLAlchemy Setup** — `SQLALCHEMY_DATABASE_URI`; the `db` object; connection
   string portability (SQLite in dev, PostgreSQL in production — same model code).
4. **Defining a Model** — live walkthrough of the `Joke` class; `primary_key`,
   `nullable`, and the `default` gotcha (`utcnow` vs. `utcnow()`).
5. **Application Context** — why `with app.app_context():` is required outside a
   request; `db.create_all()`; the `RuntimeError` and how to fix it.
6. **CRUD in Routes** — side-by-side: raw SQL string vs. SQLAlchemy ORM for each
   operation; emphasize that updates do not require a second `add()` call.
7. **Foreign Keys and Relationships** — `db.ForeignKey("table.column")` (table name,
   not class name); `db.relationship` and `backref`; lazy loading explained.
8. **What `create_all()` Cannot Do** — segue to Flask-Migrate for production schema
   evolution; preview of Ch. 4.

---

---

## Section 11: Pedagogical Review

- **ADDIE Alignment:** Analysis is addressed in the Prerequisites and Hook, which
  surface the learning gap (the persistence and injection problems that motivate a
  database layer). Design is materialized in the Learning Objectives and chapter
  structure. Development spans the full Core Content section — worked example, guided
  practice, and open challenge. Implementation is reflected in the Markdown formatting
  and Instructor Notes ready for direct course use. Evaluation is embedded in the
  Self-Assessment questions and this review.

- **Bloom's Taxonomy Coverage:** All six cognitive levels appear: Remember/Understand
  (LO 1 — explain ORM concepts; factual recall questions), Apply (LOs 2–3 — define
  models, implement CRUD; application questions), Analyze (LO 4 — diagnose context
  errors; Q3 bug-hunt), and Evaluate/Create (LO 5 — design a two-table schema;
  independent challenge; Q5 critical thinking).

- **Cognitive Load Management:** The I-WE-YOU scaffold is applied explicitly. Section
  4a introduces all concepts through a complete, step-by-step worked example (I).
  Section 4b provides a partially completed route with clearly marked gaps; hints are
  present but visually separated to discourage premature reading (WE). Section 4c
  removes all scaffolding and presents an open-ended design challenge with only
  optional, labeled hints (YOU).

- **Historical Grounding:** Section 5 traces the concept from Codd's 1970 paper through
  the emergence of ORMs in the early 2000s to SQLAlchemy's specific design philosophy,
  giving students a reason the tool was built the way it was — not just how to use it.

- **Ethical Dimension:** The Ethical Reflection in Section 6 asks students to examine
  data minimization as a design decision rather than an afterthought, connecting the
  mechanics of schema design to real-world privacy harms and the concept of data
  minimization under frameworks like GDPR.

- **Assessment Variety:** The five self-assessment questions include two factual recall
  items (Qs 1–2), two applied coding and bug-finding tasks (Qs 3–4), and one
  open-ended critical thinking question (Q5) with no single correct answer, graded on
  reasoning quality.

- **Accessibility:** All technical terms (ORM, foreign key, application context, lazy
  loading, dirty tracking) are defined on first use with concrete analogies or
  contrasting examples. Code comments explain *why* each line exists. The chapter
  assumes no prior SQLAlchemy exposure beyond the prerequisites stated in the metadata.
