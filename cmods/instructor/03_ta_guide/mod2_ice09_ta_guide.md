# TA Guide & Rubric

  * **Goal:** This ICE is about connecting a "frontend" (forms) to a "backend" (auth logic). The key skill is in `moj/routes.py`: handling `POST` requests, validating data with `form.validate_on_submit()`, and using the `db` and `flask-login` libraries.
  * **Starter Kit:** The `ICE09_auth_kit.zip` is **essential**. It provides all the Lec 5 code *plus* the HTML templates (`index.html`, `login.html`, `register.html`, `_navigation.html`, `base.html`). This is what allows the `Dev Crew` to *only* focus on the Python logic in `routes.py`, not on writing HTML.
  * **Common Pitfalls:**
    1.  **`CSRF token missing` Error:** This is the \#1 blocker. It means the `Repo Admin` forgot to install `flask-wtf`, OR the `Process Lead` forgot to add the `SECRET_KEY` (which `flask-wtf` *requires* for CSRF protection). **Solution:** The `ICE09_auth_kit` *must* include a `SECRET_KEY` in `moj/config.py`.
    2.  **`validate_on_submit()` never runs:** The `Dev Crew` forgot to add `methods=['GET', 'POST']` to the `@app.route()` decorator.
    3.  **`User.query` fails:** The `Dev Crew` forgot to import `db` or `User` at the top of `moj/routes.py`.

+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)**                          | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
+-------------------------------------------------------------+-----------------+
| **Environment & Forms (3 pts)**                             | / 3             |
| - `flask-wtf` is in `requirements.txt`.                     |                 |
| - `moj/forms.py` file is created and contains `LoginForm`.  |                 |
|   and `RegistrationForm` classes from the instructions.     |                 |
+-------------------------------------------------------------+-----------------+
| **Route Implementation (4 pts)**                            | / 4             |
| - `/login` route is updated to use `LoginForm` and          |                 |
|   `form.validate_on_submit()`.                              |                 |
| - `/register` route is created, uses `RegistrationForm`,    |                 |
|   correctly creates a new `User` in the database.           |                 |
| - `index` route is correctly updated.                       |                 |
+-------------------------------------------------------------+-----------------+
| **Total**                                                   | \*\* / 10\*\* |
+-------------------------------------------------------------+-----------------+