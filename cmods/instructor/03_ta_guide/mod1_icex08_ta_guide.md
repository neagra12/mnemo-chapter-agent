### TA Follow-up Guide

  * **In-Class Goal (Workshop):** This is a high-risk refactor. Your \#1 priority is blocker removal for **Phase 1 (The Refactor)**. Guide teams through the `git` commands and the inevitable `ImportError`. The goal is to get *all* teams to a stable, refactored state before they leave.
  * **Final DoD (Due 11:59 PM):** The team submits a "green" PR where both `test` and `lint` jobs pass.
  * **Common Pitfalls & Coaching:**
    1.  **[The \#1 Blocker] `ImportError: cannot import name 'db' from 'moj'` (or similar)**
          * **Symptom:** `flask db migrate` fails with an `ImportError`.
          * **The Fix:** This is a circular import. Check two files:
            1.  `moj/models.py`: Must have `from moj import db` (NOT `from app import db`).
            2.  `moj/__init__.py`: The line `from moj import routes, models` *must* come *AFTER* `db = SQLAlchemy(app)` is defined.
    2.  **[The \#2 Blocker] CI Fails: `pytest: command not found` or `ModuleNotFoundError: No module named 'pytest'`**
          * **Symptom:** The `test` job fails on GitHub Actions, even though it works locally.
          * **The Fix:** They missed the **"CRITICAL FIX"** in **Task 2 (Process Lead)**. The `main.yml` file's `test:` job must be updated to `pip install pytest pytest-flask` *in addition* to `pip install -r requirements.txt`.
    3.  **[The \#3 Blocker] CI Fails: `YAML syntax error`**
          * **Symptom:** The GitHub Action fails immediately with a syntax error.
          * **The Fix:** The `Process Lead` incorrectly indented the `lint:` job snippet. It must be at the *same level* as the `test:` job, not "inside" it.
  * **Coaching Questions (for next team meeting):**
      * "Why did we move from a single `app.py` script to the `moj/` package structure? What's the long-term benefit?"
      * "Your `test_hello_world` function checks for `b'Hello World!'`. What's the `b` for? What would happen if you removed it?"
      * "Now that you have a `lint` job, what's one `flake8` rule you might *disagree* with or want to 'ignore' in your config?"
  * **Feed-Forward Prompts (to prep for the next ICE):**
      * "You've now tested a simple route. Your next task is to add a `User` model and a route to *create* a user. How would you write a `pytest` function to test a `POST` request?"

-----

### Rubric (Pandoc Grid Table for PDF)

+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)**                          |  3              |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
+-------------------------------------------------------------+-----------------+
| **Phase 1: Refactor Complete (2 pts)**                      |  2              |
| - `app.py` is properly `git rm`'d.                          |                 |
| - `models.py` is `git mv`'d to `moj/` and imports are fixed.|                 |
+-------------------------------------------------------------+-----------------+
| **Phase 2: `pytest` Test (2 pts)**                          |  2              |
| - `tests/test_routes.py` is created.                        |                 |
| - `test_hello_world` function is implemented correctly.     |                 |
+-------------------------------------------------------------+-----------------+
| **Phase 2: `flake8` Job (2 pts)**                           |  2              |
| - `.flake8` config file is present.                         |                 |
| - `main.yml` is updated with a new, valid `lint:` job.      |                 |
+-------------------------------------------------------------+-----------------+
| **CI Pipeline "Green" (1 pt)**                              |  1              |
| - The final PR shows a "green" checkmark.                   |                 |
| - Both `test` and `lint` jobs pass successfully.            |                 |
+-------------------------------------------------------------+-----------------+
| **Total**                                                   |      **10**     |
+-------------------------------------------------------------+-----------------+
