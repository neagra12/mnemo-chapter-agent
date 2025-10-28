# TA Follow-up Guide: ICE 7

* **In-Class Goal (Workshop):** Your #1 priority is blocker removal for model definition and migration. The goal is for every team to successfully run `flask db migrate` and `flask db upgrade` and commit the resulting `migrations/` directory.
* **Final DoD (Due 11:59 PM):** A clean Pull Request with all new artifacts (`models.py`, `migrations/`, updated `app.py`, updated `requirements.txt`, updated `.gitignore`) and a complete `CONTRIBUTIONS.md` log.

---

## **Grading Rubric (10 pts)**

+--------------------------------------------------------------+--------+
| Criteria                                                     | Points |
+==============================================================+========+
| `requirements.txt` updated & `.gitignore` ignores `moj.db`   | 1      |
+--------------------------------------------------------------+--------+
| `project/models.py` complete & Flask app configured for      | 3      |
| SQLite                                                       |        |
+--------------------------------------------------------------+--------+
| `migrations/` directory present and committed with script    | 3      |
+--------------------------------------------------------------+--------+
| `CONTRIBUTIONS.md` log complete with roles and reflection    | 3      |
+--------------------------------------------------------------+--------+
|                                                    **Total** | **10** |
+--------------------------------------------------------------+--------+

---

## **Common Pitfalls & Coaching**
1.  **Blocker:** Migration tool reports "No changes detected."
    * **Symptom:** `flask db migrate` runs but produces an empty migration file.
    * **The Fix:** They forgot the crucial import. The app file where `migrate = Migrate(app, db)` is defined *must* also import the models (e.g., `from project import models`). The migration tool can't "see" the models if they aren't imported.
2.  **Blocker:** `NameError: name 'db' is not defined` (or `datetime`).
    * **Symptom:** `project/models.py` crashes.
    * **The Fix:** They forgot `from app import db` (or `from . import db`) or `import datetime` at the top of `models.py`.
3.  **Blocker:** `AttributeError` or `ImportError` (Circular Import).
    * **Symptom:** The app crashes on launch, complaining about circular imports.
    * **The Fix:** This happens if `app.py` imports `models.py` *before* `db = SQLAlchemy(app)` is defined. The `from project import models` line *must* come *after* `db` and `migrate` are initialized.
4.  **Blocker:** Migration fails on `ForeignKey`.
    * **Symptom:** Alembic/SQLAlchemy throws an error about `Joke.user_id` or `no table named user`.
    * **The Fix:** They likely misspelled the table name (`'user.id'`). Remember SQLAlchemy conventions: the `User` class becomes the `user` table.

---

## **Coaching Questions (for next team meeting)**
* "I see your `User` model has a `password_hash` field, but we're just storing it as a string for now. What's the obvious, major security risk here, and how do you think we'll fix it in an upcoming lecture?"
* "Why do we bother with a tool like `flask-migrate`? What would happen if two of you tried to add a new column to the `User` model at the same time on different branches? How would you merge that?"
* "You used SQLite for this ICE. What limitations do you think this file-based database will have when we try to deploy our app to the cloud?"

---

## **Feed-Forward Prompts (to prep for the next ICE)**
* "You now have a database *schema*, but it's not being *tested*. Your CI pipeline (from ICE 2) only runs 'Hello World.' Your next task is to write `pytest` unit tests that create a *temporary, in-memory* database, add a new `User`, and confirm it was saved. This is the next step to building a reliable application."
