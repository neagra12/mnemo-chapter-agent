### ICE 8: Enforcing Quality (The Refactoring Workshop)

  - **Objective:** Refactor the project from a single `app.py` script to a scalable `moj/` package, and then implement the project's first automated quality gates (`pytest` and `flake8`).
  - **Time Limit:** 35 minutes
  - **Context:** (The "Dangerous Refactor" Narrative)
    Our project is growing. A single `app.py` file (from ICE 7) was fine for "Hello World," but it's not a professional, scalable structure. Today, we perform our first major refactor to move to the `moj/` package model you saw in the lecture.

This is a "dangerous" task—files will move, and imports will break. We're going to do it "unsafe" this one time, and the "pain" we feel will be our motivation to build our "Never Again" safety nets: an automated test suite (`pytest`) and an automated linter (`flake8`).

-----

### Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **Refactoring Kit**. Assign these three roles immediately.
*Remember the course policy: You cannot hold the same role for more than two consecutive weeks.*

  * **`Repo Admin`:** (Git & Environment) Manages all `git` file operations (`mv`, `rm`), installs new packages, and updates `requirements.txt`.
  * **`Dev Crew`:** (Code & Test) Edits all Python code (`.py`). Fixes broken imports, writes the new `pytest` test file.
  * **`Process Lead`:** (CI & Config) Edits all configuration files (`.yml`, `.flake8`). Adds the new `lint` job to the CI pipeline.

-----

### Task Description: Building Our Safety Nets

#### Phase 1: The "Dangerous" Refactor (All Roles)

1.  **Download the Kit (`Repo Admin`)**

      * Download `ICE08_refactoring_kit.zip` from Canvas.
      * Unzip its contents (`moj/`, `tests/`, `.flake8`) into the root of your team's repository.
      * *`Repo Admin` shares their screen for this entire phase.*
      * **Note:** Any customizations your team made to `app.py` (like new routes) must be manually copied into `moj/routes.py` or `moj/__init__.py`.

2.  **Install New Dependencies (`Repo Admin`)**

      * Run this command in your `venv`:
        ```bash
        pip install pytest pytest-flask flake8
        ```
      * Update your `requirements.txt`:
        ```bash
        pip freeze > requirements.txt
        ```

3.  **Execute the Refactor (`Repo Admin`)**

      * Your old `app.py` is now obsolete. Remove it from the repository:
        ```bash
        git rm app.py
        ```
      * Your `models.py` file is in the wrong place. Move it into the new `moj/` package:
        ```bash
        git mv models.py moj/models.py
        ```
      * At this point, your app is **broken**.

4.  **Fix the Imports (`Dev Crew`)**

      * Open the newly-moved `moj/models.py`.
      * The old `from app import db` line at the top is now wrong.
      * **Fix it** to import the `db` object from your new package:
        ```python
        # In moj/models.py
        from moj import db 
        ```

5.  **Verify the Refactor (`Process Lead`)**

      * Your project *should* now be working again. Let's prove it by checking if the database can still be found.
      * Run the migration commands (no "real" changes are expected, we just want to see if it runs without errors):
        ```bash
        flask db migrate -m "Refactor to moj package"
        flask db upgrade
        ```
      * If these commands succeed, your refactor was successful\!

#### Phase 2: Building the Quality Gates (Parallel Processing)

*The team can now split up and work on these tasks in parallel.*

1.  **Task 1: Write "Proof of Life" Test (WE 👩‍🏫) (`Dev Crew`)**

      * This is our "WE do it together" task.
      * Create a **new file** at `tests/test_routes.py`.
      * Add the following code. This test is now your permanent, automated "proof of life" that your app's main route is working.

    <!-- end list -->

    ```python
    # In tests/test_routes.py

    def test_hello_world(client):
        """
        GIVEN a configured test client (from conftest.py)
        WHEN the '/' route is requested (GET)
        THEN check that the response is valid
        """
        # 1. Make the request
        response = client.get('/')

        # 2. Check the response status code
        assert response.status_code == 200
        
        # 3. Check the response data
        #    The 'b' means 'bytes', which is how HTTP responses are sent.
        assert b"Hello World!" in response.data
    ```

2.  **Task 2: Add Lint Job to CI (YOU 🫵) (`Process Lead`)**

      * This is your "YOU do it" task.
      * Open your *existing* file: `.github/workflows/main.yml`.
      * **Your goal:** Add a new `lint:` job that runs *in parallel* with your `test:` job.
      * Here is the **code snippet** for the new job. You must figure out where to place this in the YAML file so it is a valid, parallel job.

    <!-- end list -->

    ```yaml
    lint: # This is our NEW job
      name: Lint
      runs-on: ubuntu-latest
      steps:
        - name: Check out repository
          uses: actions/checkout@v4

        - name: Set up Python
          uses: actions/setup-python@v5
          with:
            python-version: '3.11'

        - name: Install dependencies
          run: |
            pip install flake8
            
        - name: Run flake8
          run: |
            # Stop the build if there are Python style errors
            flake8 . --count --show-source --statistics
    ```

      * **CRITICAL FIX:** You must also update your **existing `test:` job** to install the new test packages\!
          * Find the "Install dependencies" step in your `test:` job.
          * Change `pip install -r requirements.txt` to:
            ```yaml
            run: |
              pip install -r requirements.txt
              pip install pytest pytest-flask
            ```

3.  **Task 3: Commit & Open PR (`Repo Admin`)**

      * Once the `Dev Crew` and `Process Lead` are done, commit all the changes. Your `git status` should show a lot of new and modified files.
        ```bash
        git add .
        git commit -m "feat: refactor to moj package and add testing/linting"
        ```
      * Push the branch and open a Pull Request.

-----

### `CONTRIBUTIONS.md` Log Entry

*One team member share their screen.* Open `CONTRIBUTIONS.md` on your feature branch and add the following entry **using this exact format**:

```markdown
#### ICE 8: Enforcing Quality (The Refactoring Workshop)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Dev Crew: `@github-userY`
    * Process Lead: `@github-userZ`, ...
* **Summary of Work:** [1-2 sentence summary, e.g., "Refactored the app from app.py to the moj/ package, fixed all imports, wrote the first pytest for the '/' route, and added a flake8 linting job to main.yml."]
* **Evidence & Reflection:** Discuss as a team: which new automated check (`pytest` or `flake8`) do you think will provide more *immediate value* to your team's workflow, and why?
```

*After logging, commit and push this file. All other members must `git pull` to get the change.*

-----

### Definition of Done (DoD) 🏁

Your team's work is "Done" when you can check all of the following:

  * [ ] **Artifact (Refactor):** The `moj/` package exists and `app.py` has been `git rm`'d.
  * [ ] **Artifact (Test):** The `tests/test_routes.py` file exists with the `test_hello_world` function.
  * [ ] **Artifact (Lint):** The `.flake8` file exists and `.github/workflows/main.yml` has a new `lint:` job.
  * [ ] **Functionality:** The GitHub Action run for your PR is **"green"** (i.e., *both* the `test` and `lint` jobs are passing).
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated and *all team members* have the pulled file locally.
  * [ ] **Submission:** A Pull Request is open and correctly configured (see below).


-----

### Submission (Due Date)

1.  **Open Pull Request:** Open a new PR to merge your feature branch (`ice8-...`) into `main`.
2.  **Title:** `ICE 8: Enforcing Quality`
3.  **Reviewer:** Assign your **Team TA** as a "Reviewer."
4.  **Submit to Canvas:** Submit the URL of the Pull Request to the Canvas assignment.

-----

### 💡 Standard Blocker Protocol (SBP)

**If you are individually blocked for \> 15 minutes** on a technical error you cannot solve, you can invoke the SBP. This is an *individual* protocol to protect your on-time grade.

1.  **Notify Team:** Inform your team that you are invoking the SBP and pivot to helping them with a different task (e.g., documentation, testing, research).
2.  **Create Branch:** Create a new *individual* branch (e.g., `aar-ice8-<username>`).
3.  **Create AAR File:** Create a new file in your repo: `aar/AAR-ICE8-<your_github_username>.md`.
4.  **Copy & Complete:** Copy the template below into your new file and fill it out completely.
5.  **Submission (Part 1 - 5 pts):** Open a Pull Request to merge your AAR branch into `main`.
      * **Title:** `AAR ICE 8: <Brief Description of Blocker>`
      * **Reviewer:** Assign your **Instructor** as a "Reviewer."
      * **Submit to Canvas:** Submit the URL of *your AAR Pull Request* to this Canvas assignment. This counts as your on-time submission.
6.  **Submission (Part 2 - 5 pts):** After the instructor provides a hotfix in the PR, you will apply it, achieve the original DoD, and **resubmit your *passing* PR** *to this same assignment* to receive the final 5 points.

-----

### AAR Template (Copy into `aar/AAR-ICE8-....md`)

```markdown
# AAR for ICE 8: [Blocker Title]

* **Student:** `@your-github-username`
* **Timestamp:** `2025-XX-XX @ HH:MM`

---

### Instructor's Diagnostic Hints
* **Hint 1:** `ImportError` on `flask db migrate`? This is almost certainly a circular import. Check that `moj/models.py` imports `db` with `from moj import db`. Then, check that `moj/__init__.py` imports `models` *AFTER* the `db = SQLAlchemy(app)` line.
* **Hint 2:** `ModuleNotFoundError: No module named 'pytest'`? This can happen in two places. If it's **local**, you forgot to `pip install pytest`. If it's **on GitHub Actions**, your `Process Lead` forgot to update the `test:` job in `main.yml` (the "CRITICAL FIX" in Task 2).
* **Hint 3:** `git status` shows `models.py` as "deleted" and `moj/models.py` as "untracked"? You used your file explorer, not `git mv`. Just run `git add .` to stage both changes, and `git` will understand it as a move.

---

### 1. The Blocker
*(What is the *symptom*? What is the *exact* error message?)*

> [Paste error message or describe symptom]

### 2. The Investigation
*(What *exactly* did you try? List the commands you ran, files you edited, and Stack Overflow links you read.)*

* I tried...
* Then I edited...
* This Stack Overflow post suggested...

### 3. The Root Cause Hypothesis
*(Based on your investigation, what do you *think* is the real problem? Try to be specific.)*

> I believe the problem is...

### 4. Evidence
*(Paste the *full* terminal output, relevant code snippets, or screenshots that support your hypothesis.)*

    (Paste full logs here)


### 5. The "Aha!" Moment (if any)
*(Did you have a moment of clarity or discover the solution just as you were writing this?)*

> [Describe your realization, or N/A]

### 6. The Learning
*(What new, specific thing did you learn from this? What will you do *differently* next time?)*

> I learned that...

### 7. The Remaining Question
*(What do you *still* not understand? What is the *one key question* you need answered to get unblocked?)*

> My one question is...



```
