# mod1_lec3_Database_and_Models.md

## **---- PROMPT ----**
```markdown
Let's build the mod1_lec3 slide deck. We need to match to the ICE and the MongogDB assignment. 
I want to introduce persistence and reference the angband save file. Also reference the gamedata directory with the text files and the associations of the monster.txt files to the others. It was a mess. This leads us to SQL for data structures and introduce sqlite. We can mention other database architectures like NoSql and key/value and use MongoDB as an example of NoSQL This ties to the first AI query in the MongoDB assignment. With structure is a good time to introduce models and migration. We can mention the import trap with app.py and model.py.
We should then mention concurrency and transactions as benefits of SQL with a brief explanation of both. 
Finally we should interduce the new (starting this week) SBP, and the new AAR workflow and point award mechanism. 
```




## **---- PROMPT ----**
```markdown
Let's drop the concurrency and transactions discussion. 
Drop slide 3, the gamedata discussion will make our point alone. 
Drop slide 8. I will have a speaker note at the closing slide.
Assume the SBP and AAR slides will go faster because the students have been primed with announcements in Canvas this week about the changes. 

Do these changes with the substituted slide below improve our timing?


Replace slide 7 with this slide below. 

## Slide 7: Relational vs. NoSQL (The Core Trade-Off)
- **Key Point:** SQLAlchemy is an "Object-**Relational** Mapper" because it's built for **Relational** (SQL) databases. The most popular alternative is **NoSQL**.
- **The Core Trade-Off:** This is the central conflict you must understand.

| Concept | Relational (SQL / SQLAlchemy) | NoSQL (Document / MongoDB) |
| :--- | :--- | :--- |
| **Data Model** | **Normalized** (Data is split into separate, related tables, e.g., `User` and `Joke`). | **Denormalized** (Data is stored in one "document," e.g., a `User` with a *list* of their jokes embedded inside). |
| **Schema** | **Schema-on-Write** (Rigid. The table *must* conform to the `models.py` definition. Enforced by the DB.) | **Schema-on-Read** (Flexible. Each document can have a different structure. Enforced by your *app code*.) |
| **"The Lock"** | **Transactions (ACID).** Solves the race condition with guaranteed, strict consistency. | **Atomic Operations.** Concurrency is managed differently, often at the *document* level. (Faster, but different.) |
| **The "Join"** | **Yes.** You can easily `JOIN` the `User` and `Joke` tables. | **No.** You *cannot* join collections. This is why data is "denormalized" (pre-joined). |
| **Code** | `SQLAlchemy` (ORM) | `PyMongo` (Driver) |

- Speaker Note: "Pay close attention to this slide. This is the **exact set of trade-offs** you will be investigating in this week's challenge. This is your 'ground truth' for evaluating the AI."
```

Here is the revised 16-slide deck for `mod1_Lec03_Databases_Models`.

This version incorporates all your requested changes:

  * Slides 3 (Intro Persistence), 8 (MongoDB Challenge), 15 (Transactions), and 16 (Concurrency) have been **removed**.
  * The old "NoSQL" slide has been **replaced** with your new, specific trade-off table.
  * The `Learning Objectives` and `Key Takeaways` have been updated to match the new, leaner content.

-----

````markdown
# Lecture 3: Databases, Models, & Migrations
## Slide 1: Title Slide
- **Topic:** Persistence, Databases, Models, and Migrations
- **Course:** Software Engineering (Greenfield Development)
- **Module 1:** Building the "Ministry of Jokes" (MoJ)

## Slide 2: Learning Objectives
- By the end of this lecture, you will be able to:
- **Justify** the need for a relational database (like SQLite) over flat files (like in `Angband`).
- **Explain** the role of an ORM (SQLAlchemy), a Model, and a Schema.
- **Compare** the core trade-offs between Relational (SQL) and NoSQL (Document) databases.
- **Implement** a database migration using `flask-migrate`.
- **Describe** the Standard Blocker Protocol (SBP) and After-Action Report (AAR) workflow.

## Slide 3: "Brownfield" Data: The `gamedata` Mess
- **Key Point:** `Angband`'s `gamedata` directory (e.g., `monster.txt`, `vault.txt`) is a form of persistence. It's a collection of loosely-related flat text files.
- **The Problem:** How do you find "all monsters that drop a 'Ring of Speed'?"
- You'd have to write custom, brittle parsing logic to read `monster.txt`, then `object.txt`, and manually "join" them in C code.
- This is a *data architecture mess*. It's inflexible and hard to query.
- **Speaker Note:** This is the core justification for what's next. We are moving from a "pile of text files" to a structured, queryable system.

## Slide 4: "Greenfield" Data: Relational Databases (SQL)
- **Key Point:** A relational database (like one using SQL) solves this by enforcing structure.
- Data is stored in **Tables** (like spreadsheets).
- **Columns** define the data type (string, integer, boolean).
- **Relationships** (e.g., "this `Joke` was submitted by this `User`") are explicitly defined and managed by the database itself.
- This is the foundation of almost all modern web applications.

## Slide 5: Our First DB: SQLite
- **Key Point:** For our greenfield MoJ project, we will start with **SQLite**.
- SQLite is a full-featured SQL database... that lives in a **single file** (e.g., `app.db`).
- **Why?** It's simple, requires zero setup, and is perfect for local development. It lets us focus on our *application logic*, not on database administration.
- This is what you will configure in today's ICE.
- **Speaker Note:** Emphasize that this is a *development* choice. We will swap this out for a more powerful database (PostgreSQL) later in the semester using Docker, and our app logic won't even notice.

## Slide 6: Relational vs. NoSQL (The Core Trade-Off)
- **Key Point:** SQLAlchemy is an "Object-**Relational** Mapper" because it's built for **Relational** (SQL) databases. The most popular alternative is **NoSQL**.
- **The Core Trade-Off:** This is the central conflict you must understand.

| Concept | Relational (SQL / SQLAlchemy) | NoSQL (Document / MongoDB) |
| :--- | :--- | :--- |
| **Data Model** | **Normalized** (Data is split into separate, related tables, e.g., `User` and `Joke`). | **Denormalized** (Data is stored in one "document," e.g., a `User` with a *list* of their jokes embedded inside). |
| **Schema** | **Schema-on-Write** (Rigid. The table *must* conform to the `models.py` definition. Enforced by the DB.) | **Schema-on-Read** (Flexible. Each document can have a different structure. Enforced by your *app code*.) |
| **"The Lock"** | **Transactions (ACID).** Solves the race condition with guaranteed, strict consistency. | **Atomic Operations.** Concurrency is managed differently, often at the *document* level. (Faster, but different.) |
| **The "Join"** | **Yes.** You can easily `JOIN` the `User` and `Joke` tables. | **No.** You *cannot* join collections. This is why data is "denormalized" (pre-joined). |
| **Code** | `SQLAlchemy` (ORM) | `PyMongo` (Driver) |

- **Speaker Note:** "Pay close attention to this slide. This is the **exact set of trade-offs** you will be investigating in this week's challenge. This is your 'ground truth' for evaluating the AI."

## Slide 7: How Do We *Use* the DB in Python?
- **Key Point:** We *could* write raw SQL strings in our Python code... but we shouldn't.
- **Code Example (The "Bad" Way):**
```python
  # Brittle, hard to maintain, and a HUGE security risk (SQL Injection)
  user_input = "Admin' --"
  db.execute("SELECT * FROM users WHERE username = '" + user_input + "'")
```
- **Speaker Note:** This is a critical security and maintenance inflection point. Raw SQL is messy and dangerous.

## Slide 8: The "M" in MVC: Models
- **Key Point:** We use an **Object-Relational Mapper (ORM)**. In Flask, this is **SQLAlchemy**.
- An ORM "maps" a Python **Class** directly to a database **Table**.
- This class is called a **Model**.
- We can now work with familiar Python objects, and the ORM handles writing the safe, efficient SQL for us.
- **The "Schema"** is the complete collection of all our models and their relationships.

## Slide 9: Code Example: A `Joke` Model
- **Key Point:** This is what a model looks like. It's just a Python class that inherits from `db.Model`.
- **Code Example:**
```python
  # This code will live in 'models.py'
  from app import db # We'll come back to this import...

  class Joke(db.Model):
      id = db.Column(db.Integer, primary_key=True)
      text = db.Column(db.String(280), nullable=False)
      rating = db.Column(db.Integer, default=0)
      
      # This defines the relationship!
      user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

      def __repr__(self):
          return f'<Joke {self.id}>'
```
- **Speaker Note:** Point out how the `db.Column` lines define the *schema* (the table structure) and `db.ForeignKey` creates the relationship.

## Slide 10: The Problem: Schema Drift
- **Key Point:** What happens when we change the code for our model?
- **Scenario:** We add `created_at = db.Column(db.DateTime, default=datetime.utcnow)` to our `Joke` model.
- **Problem:** Our Python code is now **out of sync** with the database table. The `app.db` file doesn't have a `created_at` column.
- This "schema drift" will crash our application.

## Slide 11: The Solution: Migrations
- **Key Point:** We **never** change the database by hand. We use a **migration tool**.
- Our tool is **`flask-migrate`** (which uses a tool called `Alembic` inside).
- **Workflow:**
    1.  You change your `models.py` file.
    2.  You run `flask db migrate -m "Added created_at to Joke"`
    3.  The tool *compares* your models to the DB and *auto-generates* a small Python script (a "migration").
    4.  You run `flask db upgrade` to apply that script.
- **Speaker Note:** This is today's ICE. Migrations are like "Git for your database schema." It provides a clear, reversible history of every change.

## Slide 12: The Dreaded "Import Trap"
- **Key Point:** You will hit a **Circular Import** error today. This is a rite of passage.
- **The Problem:**
    1.  `app.py` needs to import `models.py` (to know the models).
    2.  `models.py` needs to import `app.py` (to get the `db` object).
- **Code Example (The Fix):**
```python
  # In app.py
  app = Flask(__name__)
  # ... config ...
  
  # 1. Initialize extensions BEFORE importing models
  db = SQLAlchemy(app)
  migrate = Migrate(app, db)
  
  # 2. NOW it's safe to import models
  from project import models
  
  # In models.py
  # 3. This import now works!
  from app import db 
```
- **Speaker Note:** This is the #1 blocker for this ICE. I'm telling you the answer right now. It's also in the AAR hints.

## Slide 13: New Policy: Standard Blocker Protocol (SBP)
- **Key Point:** We are introducing a new policy for when you get *individually* stuck on an ICE: The **Standard Blocker Protocol (SBP)**.
- **This is a "safe harbor," not a punishment.** It protects your on-time grade.
- If you are stuck on a technical error for **> 15 minutes** and your team can't solve it, you can **invoke the SBP**.
- **Speaker Note:** This is a core *engineering process*. Recognizing you are blocked and pivoting to a diagnostic report is a senior-level skill. You've seen the announcements on this; here is where it becomes real.

## Slide 14: SBP Workflow: The AAR
- **Key Point:** When you invoke SBP, you pivot from *coding* to *reporting*.
- You will create a new branch and fill out an **After-Action Report (AAR)** template.
- An AAR is a professional diagnostic report. It must include:
    1.  **The Blocker:** The *exact* error message.
    2.  **The Investigation:** What you *tried* (commands, Stack Overflow links).
    3.  **The Hypothesis:** What you *think* the root cause is.
    4.  **Evidence:** Full logs and code snippets.
- **Speaker Note:** Emphasize that "I don't know" is not a valid AAR. You must document your *investigation*. This is how we provide targeted help.

## Slide 15: SBP Grading: The "5+5" Model
- **Key Point:** The SBP uses a "5+5" grading model for the 10-point ICE.
- **Part 1 (5 points):** Submit a high-quality, on-time AAR as a Pull Request before the deadline. This gets you 5/10 (on-time "B" grade).
- **Part 2 (5 points):** After the instructor/TA provides a fix in your PR, you must *apply the fix*, get your code working, and resubmit your *passing* PR to get the final 5 points.
- **The Goal:** Everyone ends up with working code *and* a perfect record of how they got unblocked.
- **Speaker Note:** This is an explicit mechanism to gather evidence of learning from failure.

## Slide 16: Key Takeaways
- **Flat Files (`Angband`)** are brittle, hard to query, and don't support concurrent access.
- **Relational Databases (SQL)** provide structure and enforce relationships.
- **SQL vs. NoSQL** is a core trade-off between **structure** (SQL) and **flexibility** (NoSQL).
- **Models (via an ORM)** are the Python classes we use to talk to the DB.
- **Migrations** are "Git for our database" — they keep models and the DB in sync.
- **SBP/AAR** is your new professional workflow for getting unblocked.
- **Speaker Note:** (For you, as requested) "As a reminder, you have a Weekly Challenge assignment to explore these trade-offs by evaluating MongoDB. Use Slide 6 as your starting point for that investigation."
````

## **---- PROMPT ----**
```markdown

```