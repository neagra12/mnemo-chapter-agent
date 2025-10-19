Here is the slide deck for Lecture 3, implementing Step 2 of our plan.

It follows the template, bridges from the previous lectures, and incorporates the canonical reference links we just generated.

-----

# Lecture 3: Databases & Models

## Slide 1: Title Slide

  - **Topic:** Databases, Models, & Migrations
  - **Course:** Software Engineering

## Slide 2: Learning Objectives

  - By the end of this lecture, you will be able to:
  - **Explain** why a web server needs a database for persistence.
  - **Define** the role of an ORM (Object-Relational Mapper) like SQLAlchemy.
  - **Implement** a Python "Model" class that maps to a database table.
  - **Explain** why database "migrations" (using Alembic) are critical for team-based development.

## Slide 3: Bridging Context: Where Does Our Data Go?

  - **Key Point:** In Lecture 1, our Flask app had a "joke." When the server restarted, the joke was gone. This is called **in-memory storage**.
  - **The Problem:** In-memory storage is **ephemeral** (temporary). For the "Ministry of Jokes" to work, jokes and users must be saved *permanently*.
  - **The Solution:** We need a **database** for **persistence**.
  - Speaker Note: "Think of your Flask app as a temporary office worker. When they go home for the night (the server restarts), their desk is cleared. We need to give them a permanent filing cabinet—that's our database."

## Slide 4: What is a Database?

  - **Key Point:** A database (like PostgreSQL) is a separate, highly-optimized *server program* whose only job is to store, protect, and retrieve data.
  - It is the "filing cabinet" for our Ministry.
  - Our Flask app (the "office worker") will make requests to the Database server (the "filing cabinet") to store or fetch data.
  - 
  - Speaker Note: "It's critical to understand: our Flask app and our Postgres database are two *separate programs* that will talk to each other over a network port."

## Slide 5: The Translation Problem

  - **Key Point:** We have a translation problem.
  - We, the developers, speak **Python** (e.g., `class User:`).
  - The database speaks **SQL** (e.g., `CREATE TABLE user_account (...)`).
  - We don't want to spend our time writing messy, error-prone SQL strings inside our Python code.
  - Speaker Note: "This is a classic problem. How do we, as Python developers, talk to a SQL database without having to become expert SQL writers ourselves?"

## Slide 6: The Solution: An ORM (Object-Relational Mapper)

  - **Key Point:** We use an **ORM (SQLAlchemy)**. An ORM is a "universal translator" for our code.
  - It maps our **Objects** (Python classes) to the database's **Relations** (SQL tables).
  - **We write:** A Python `class`.
  - **The ORM translates:** This class into a `CREATE TABLE` SQL command.
  - **We write:** `user = User(name="admin")`
  - **The ORM translates:** This into an `INSERT INTO ...` SQL command.
  - Speaker Note: "This is our first *major* architectural decision. We are choosing to let SQLAlchemy manage this translation so we can focus on Python."
  - **Reference:** [SQLAlchemy ORM Quick Start](https://docs.sqlalchemy.org/en/20/orm/quickstart.html)

## Slide 7: What is a "Model"?

  - **Key Point:** A "Model" is the specific name for a Python class that the ORM knows how to map to a database table.
  - We will create a `models.py` file in our application.
  - This file will contain all our "data blueprints," like `class User` or `class Joke`.
  - The ORM (SQLAlchemy) will read this file to understand our application's data structure.

## Slide 8: Code Example: A Basic Model

  - **Key Point:** This looks like a Python class, but it's full of instructions for SQLAlchemy.
  - **Code Example:**

<!-- end list -->

```python
# models.py
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

# All our models will inherit from this Base class
class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = "user_account" # The *real* table name in SQL

    # Mapped[] tells the ORM this is a column
    id: Mapped[int] = mapped_column(primary_key=True)
    username: Mapped[str] = mapped_column(unique=True)
    email: Mapped[str]
```

  - Speaker Note: "We define the *shape* of our data in Python. `__tablename__` is the SQL table name. `Mapped` and `mapped_column` tell SQLAlchemy 'this is a column' and what its properties are, like `primary_key=True`."

## Slide 9: The *New* Team Problem: Schema Changes

  - **Key Point:** We just created a *new* problem.
  - **Scenario:**
    1.  You (on `feat/user-auth`) add the `email` column to the `User` model.
    2.  Your teammate (on `feat/joke-form`) adds a `date_posted` column to the `Joke` model.
    3.  You both merge to `main`.
  - **Question:** Whose database is "correct"? How do we keep everyone's local database in sync with the new code?
  - Speaker Note: "This is a *critical* team synchronization problem. If your code expects an `email` column but your database doesn't have it, your app will crash. How do we manage *changes* to the database structure?"

## Slide 10: Solution: Database Migrations

  - **Key Point:** We solve this with **database migrations**. A migration is a *version-controlled script* that safely applies (or undoes) a single change to the database structure.
  - **The Tool:** We will use **Alembic**, a migration tool built for SQLAlchemy.
  - Think of it like **Git for your database schema**.
  - **Reference:** [Alembic Tutorial](https://alembic.sqlalchemy.org/en/latest/tutorial.html)

## Slide 11: The Alembic Workflow

  - **Key Point:** You *never* change the database by hand. You let Alembic do it.
  - **The Workflow (for a new change):**
    1.  You change your `models.py` file (e.g., add `email: Mapped[str]`).
    2.  You run `alembic revision --autogenerate -m "add email to user"`
    3.  Alembic compares your Python models to the database's state and *writes a new migration script*.
    4.  You **commit this new script to Git**.
  - **The Workflow (to get changes):**
    1.  You `git pull` and get your teammate's new migration script.
    2.  You run `alembic upgrade head`
    3.  Alembic runs the script and safely updates your local database to match the code.
  - Speaker Note: "This is the process. Edit models, run autogenerate, commit the script. Pull, run upgrade. This ensures *everyone's* database structure matches the code, solving the team sync problem."

## Slide 12: Historical Hook: The Relational Model

  - **Key Point:** Why is it called an "Object-Relational Mapper"?
  - The "Object" part is our Python `class` objects.
  - The "Relational" part comes from the **Relational Model of Data**, a formal theory proposed by **Edgar F. Codd** at IBM in 1970.
  - Codd's paper defined the concept of "relations" (tables), "tuples" (rows), and "attributes" (columns) that are the foundation of SQL and nearly every modern database (PostgreSQL, MySQL, SQL Server, etc.).
  - We are mapping our *new* object-oriented world (Python) to Codd's *foundational* relational world (SQL).

## Slide 13: Next: In-Class Exercise (ICE 3)

  - **Topic:** The Ministry's Filing Cabinet
  - **Task:** It's time to build the "filing cabinet."
  - **Goal:** You will:
    1.  Install `sqlalchemy`, `psycopg2-binary` (the "driver" that lets Python talk to Postgres), and `alembic`.
    2.  Add the new packages to `requirements.txt`.
    3.  Define the first `User` and `Joke` models.
    4.  Initialize Alembic.
    5.  Run `alembic revision --autogenerate` to create your *first migration script*.

## Slide 14: Key Takeaways

  - We need a **Database** (PostgreSQL) for **Persistence** (to save data).
  - We use an **ORM (SQLAlchemy)** to translate our Python code into SQL commands.
  - A **Model** is a Python class that represents a database table.
  - We use **Alembic** for **Migrations** to manage changes to the database structure safely in a team, like "Git for your database."