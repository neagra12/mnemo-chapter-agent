# Session to develop ice09 - Refactor secret_key and external security tests

## **---- PROMPT ----**
```markdown
Let's see the ice for this lecture 9
```

Here is the In-Class Exercise for Module 2, Lecture 9.

-----

### ICE 13: "Paying Our Debt" (Security Refactor & Testing)

  * **Objective:** Secure the app by refactoring the `SECRET_KEY` into the `.env` file and write a new security test to prove the app is safe from XSS attacks.
  * **Time Limit:** 30-35 minutes
  * **Context:** In the lecture, we identified our "technical debt" (the hardcoded `SECRET_KEY`) and learned about external threats (XSS, CSRF). This ICE is about *fixing* the debt and *proving* our app is secure.

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

This is a focused refactor and testing task. Assign these three roles.

  * **`Repo Admin`:** (Git & Merge) Handles all Git operations and merges the final code.
  * **`Process Lead`:** (Refactor) Implements the `SECRET_KEY` refactor by editing `.env` and `moj/config.py`.
  * **`QA Crew`:** (Testing) Creates the new `tests/test_security.py` file and writes the XSS test.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (Branch Created)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (Refactor Pushed)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Security Test Pushed)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

### Task Description: Paying Our "Technical Debt"

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in `A12`.

#### Phase 1: Branch (Repo Admin)

1.  **Branch:** Pull `main` and create a new feature branch: `ice13-security-fix`.
2.  **Announce:** *Announce to the team that the branch is ready. The Process Lead and QA Crew can now work in parallel.*

-----

#### Phase 2: The `SECRET_KEY` Refactor (Process Lead)

Your job is to "pay off" the technical debt.

1.  **Pull:** `git pull` to get the new branch.

2.  **Open `.env`:** Add the `SECRET_KEY` to your local environment file.

    ```
    # ... (FLASK_DEBUG and DATABASE_URL are already here)

    # NEW: Private secrets for our application
    SECRET_KEY='a-new-super-long-and-random-string-that-is-not-in-git'
    ```

    > **Note:** Every team member *must* add this line to their *own* `.env` file. The file is not tracked by Git, so this change won't be "pushed."

3.  **Refactor `moj/config.py`:** This is the change that *will* be pushed.

      * **Find this:**
        ```python
        # TODO: In Week 12, we will fix this...
        SECRET_KEY = os.environ.get('SECRET_KEY') or 'a-temporary-and-insecure-fallback-key'
        ```
      * **Replace it with this:**
        ```python
        # Load the secret key from the .env file.
        # The app will crash if this is not set, which is good.
        SECRET_KEY = os.environ.get('SECRET_KEY')
        ```

4.  **Test:** Run `flask run`. Does the app still run? If it crashes, it means you forgot to add the `SECRET_KEY` to your `.env` file\!

5.  **Commit & Push:** Commit your change to `moj/config.py`.

-----

#### Phase 3: The XSS Security Test (QA Crew)

Your job is to *prove* our app is safe from XSS.

1.  **Pull:** `git pull` to get the new branch.
2.  **Create `tests/test_security.py`:** Create this new test file.
3.  **Add Test:** Add the following test. (This test assumes you have a "Create Joke" route from `A10`. If your route is named differently, update `'/create_joke'`.)
    ```python
    from moj import db
    from moj.models import User, Joke
    import pytest

    # Helper fixture to log in a user
    @pytest.fixture
    def logged_in_user(client, app):
        with app.app_context():
            user = User(username='test', email='test@test.com')
            user.set_password('a')
            db.session.add(user)
            db.session.commit()
            
        client.post('/login', data={'username': 'test', 'password': 'a'})
        return user

    def test_xss_attack_is_escaped(client, app, logged_in_user):
        """
        GIVEN a logged-in user
        WHEN they post a joke with a <script> tag
        THEN the tag is 'escaped' as text and not rendered as HTML
        """
        # WHEN: They post a joke with a <script> tag
        # (Update '/create_joke' if your route is named differently)
        client.post('/create_joke', data={
            'body': 'A joke with <script>alert(1)</script> tag'
        }, follow_redirects=True)
        
        # AND they view the index page
        response = client.get('/index')
        
        # THEN: The <script> tag is *escaped*, not rendered
        assert response.status_code == 200
        
        # The literal < > characters are GONE
        assert b'<script>alert(1)</script>' not in response.data
        
        # They have been REPLACED with HTML-safe codes
        assert b'&lt;script&gt;alert(1)&lt;/script&gt;' in response.data
        print("XSS test passed: <script> was successfully escaped.")
    ```
4.  **Test:** Run `pytest tests/test_security.py`. The test should pass, proving Jinja2 is protecting you.
5.  **Commit & Push:** Commit your new test file.

-----

#### Phase 4: Final Test & Log (Repo Admin)

1.  **Pull:** `git pull` to get all changes from both team members.
2.  **Test:** Run `pytest`. All tests (including the new `test_security.py` test) should pass.
3.  **Manual Test:**
      * **Check the refactor:** Run `flask run`. If the app *loads*, your `.env` refactor was successful.
      * **Check the XSS:** Log in. Create a new joke with the body: `<script>test</script>`.
      * View the joke on the index/profile page. You should see the literal *text* `"<script>test</script>"` and **NOT** an empty spot (which would mean the browser tried to run it).
4.  **Log:** Fill out the `CONTRIBUTIONS.md` log.
5.  **Submit:** Commit the log, push, and open a Pull Request.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 13: "Paying Our Debt" (Security Refactor & Testing)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * QA Crew: `@github-userZ`
* **Summary of Work:** [1-2 sentence summary, e.g., "Refactored the app to securely load the SECRET_KEY from the .env file, paying off our technical debt. Added a new security test (test_xss_attack_is_escaped) to prove our app is safe from XSS."]
* **Evidence & Reflection:** We just proved our app is "secure by default" against XSS. Why is it still important to write this test? What does the test protect us from in the future?
```


## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





