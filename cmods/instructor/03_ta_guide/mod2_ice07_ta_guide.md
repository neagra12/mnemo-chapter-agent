## 👨‍🏫 TA Guide: ICE 11 "Admin Powers & Inheritance"

### 🎯 Objective

This ICE is the "WE" part of our "I/WE/YOU" structure for RBAC and inheritance. The goal is for students to implement the full "Admin Modify Joke" feature *without* the audit log, which we designed in the lecture. This includes the `.env` refactor, the `Click` command, and the full-stack inheritance pattern.

### ✅ The Happy Path (A Successful Team)

A successful team will execute the following parallel tasks:

1.  **Repo Admin:**

      * Creates the `ice11-admin-powers` branch.
      * Correctly edits `.env`, `.gitignore`, and `moj/config.py` for the `.env` refactor.
      * Correctly creates `moj/commands.py` and edits `moj/__init__.py` to add the `flask init-admin` command.
      * Remembers to `pip install click` (or `Flask`) and `pip freeze > requirements.txt`.
      * Pushes these "setup" changes so the team can sync.

2.  **All Other Roles:**

      * Pull the changes.
      * **Crucially: Create their own local `.env` file.**
      * Run `pip install -r requirements.txt`.
      * Register a user and successfully run `flask init-admin <username>` to become an admin.

3.  **Process Lead:**

      * Correctly creates `AdminJokeForm(JokeForm)` in `moj/forms.py` (with the `justification` field).
      * Correctly modifies `edit_joke.html` to add the `{% block admin_content %}`.
      * Correctly creates `admin_edit_joke.html` that `{% extends "edit_joke.html" %}`.
      * Creates the `admin_panel.html` template.

4.  **Dev Crew (Backend):**

      * Implements the `admin_edit_joke` route, using the new `AdminJokeForm` and the `if current_user.role != 'admin'` check.
      * Correctly leaves the `form.justification.data` "unplugged" (as planned).
      * Implements the `admin_panel` route, adding the RBAC check and querying for users/jokes.

5.  **QA Crew:**

      * Creates `tests/test_admin.py`.
      * Writes the "negative path" test (`test_user_cannot_access_panel`) and the "happy path" test (`test_admin_can_access_panel`).
      * Writes the two tests for the `admin_edit_joke` route (happy and negative).

The team will `git pull` all parallel work, `pytest` will pass, and they will submit the PR.

-----

### ⚠️ Common Pain Points & Bottlenecks

This ICE is *much* simpler than our previous plan, but it still has several places for students to get stuck.

  * **HIGH RISK: The `.env` Sync.**

      * **Problem:** The `Repo Admin` pushes their changes. The rest of the team pulls, `pip installs`, and runs `flask run`. The app *crashes* because `SECRET_KEY` is now `None` (since `config.py` was changed).
      * **Solution:** This is the \#1 pain point. You **must** remind them that `.env` is in `.gitignore` and **every team member** must create their *own* local `.env` file (Phase 2).

  * **MEDIUM RISK: The `Click` Command.**

      * **Problem:** The `Repo Admin` forgets to add `click` to `requirements.txt`. The team pulls, but their `flask` commands don't work (or CI fails).
      * **Solution:** Remind the `Repo Admin` to `pip freeze` after installing a new package.

  * **MEDIUM RISK: Form Inheritance.**

      * **Problem:** The `Process Lead` tries to import `JokeForm` in `moj/forms.py` but `JokeForm` is in a *different* file (e.g., `moj/jokes/forms.py` from `A10`). This creates a circular dependency or import error.
      * **Solution:** The "quick fix" is to move `JokeForm` *into* `moj/forms.py` (if it's not already there) so `AdminJokeForm` can easily inherit from it.

  * **LOW RISK: Template Inheritance.**

      * **Problem:** The `admin_edit_joke.html` template renders a blank page.
      * **Solution:** The student probably forgot to add `{% extends "edit_joke.html" %}`. They are *extending* the base editor, not the `base.html` template.

-----

### COACHING QUESTIONS

  * **For the team (at the start):** "The `Repo Admin` is about to push, but they are adding `.env` to `.gitignore`. What does that mean *you* all need to do on your local machines *after* you pull?"
  * **For the Process Lead:** "You're creating an `AdminJokeForm` that's almost identical to `JokeForm`. What's the 'DRY' way to do this without copying and pasting the whole class?"
  * **For the Dev Crew:** "I see you're using the `AdminJokeForm` in your route. The `justification` field is coming in with the form data. What's our plan for that data in *this* ICE? (Answer: Nothing, we leave it unplugged). Why is this 'decoupled' design useful?"
  * **For the QA Crew:** "You're testing the `admin_panel` route. What two *different* users do you need to log in as to *fully* test this route?" (Answer: An admin user and a regular user).