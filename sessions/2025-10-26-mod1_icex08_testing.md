# log for building ICEX08 

## **---- PROMPT ----**
```markdown
Lets generate the ICEX08 now.
```
Here is the In-Class Exercise for Module 1, Lecture 4.

This ICE is a "Refactoring Workshop" designed to transition students from their single `app.py` file to the professional `moj/` package structure. It uses the "Dangerous Refactor" narrative to provide a strong pedagogical motivation for introducing `pytest` and `flake8` as their first "safety nets."

-----

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

1.  **Task 1: Write "Proof of Life" Test (`Dev Crew`)**

      * Refer to **Lec 4, Slide 9** ("Worked Example 2: The First Test").
      * Create a **new file** at `tests/test_routes.py`.
      * Write the `test_hello_world(client)` function *exactly* as shown on the slide. This test is now your permanent, automated "proof of life" that your app's main route is working.

2.  **Task 2: Add Lint Job to CI (`Process Lead`)**

      * Refer to **Lec 4, Slide 14** ("Worked Example 4: Linting in CI").
      * Open your *existing* file: `.github/workflows/main.yml`.
      * **Add the new `lint:` job.** Copy the snippet from the slide and add it at the *same indentation level* as your `test:` job.
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
          * **The Fix:** They missed **Task 2 (Process Lead)**. The `main.yml` file's `test:` job must be updated to `pip install pytest pytest-flask` *in addition* to `pip install -r requirements.txt`.
    3.  **[The \#3 Blocker] `git mv` Hell**
          * **Symptom:** `git status` shows `models.py` as "deleted" and a *new* file `moj/models.py` as "untracked."
          * **The Fix:** They used the OS file explorer instead of `git mv`. To fix, run: `git add .` This will correctly stage the "delete" and the "add," which `git` understands as a "rename" or "move."
  * **Coaching Questions (for next team meeting):**
      * "Why did we move from a single `app.py` script to the `moj/` package structure? What's the long-term benefit?"
      * "Your `test_hello_world` function checks for `b'Hello World!'`. What's the `b` for? What would happen if you removed it?"
      * "Now that you have a `lint` job, what's one `flake8` rule you might *disagree* with or want to 'ignore' in your config?"
  * **Feed-Forward Prompts (to prep for the next ICE):**
      * "You've now tested a simple route. Your next task is to add a `User` model and a route to *create* a user. How would you write a `pytest` function to test a `POST` request?"

-----

### Rubric (Pandoc Grid Table for PDF)

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)** | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 1: Refactor Complete (2 pts)** | / 2             |
| - `app.py` is properly `git rm`'d.                          |                 |
| - `models.py` is `git mv`'d to `moj/` and imports are fixed. |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 2: `pytest` Test (2 pts)** | / 2             |
| - `tests/test_routes.py` is created.                        |                 |
| - `test_hello_world` function is implemented correctly.     |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 2: `flake8` Job (2 pts)** | / 2             |
| - `.flake8` config file is present.                         |                 |
| - `main.yml` is updated with a new, valid `lint:` job.      |                 |
\+-------------------------------------------------------------+-----------------+
| **CI Pipeline "Green" (1 pt)** | / 1             |
| - The final PR shows a "green" checkmark.                   |                 |
| - Both `test` and `lint` jobs pass successfully.            |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

-----

### Canvas-Optimized HTML Snippet

(For pasting into the Canvas RCE)

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 8">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>CONTRIBUTIONS.md</code> Log (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is completed with all fields (roles, summary).</li>
                    <li>Reflection question is answered thoughtfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 1: Refactor Complete (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>app.py</code> is properly <code>git rm</code>'d.</li>
                    <li><code>models.py</code> is <code>git mv</code>'d to <code>moj/</code> and imports are fixed.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 2: <code>pytest</code> Test (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>tests/test_routes.py</code> is created.</li>
                    <li><code>test_hello_world</code> function is implemented correctly.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 2: <code>flake8</code> Job (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>.flake8</code> config file is present.</li>
                    <li><code>main.yml</code> is updated with a new, valid <code>lint:</code> job.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>CI Pipeline "Green" (1 pt)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>The final PR shows a "green" checkmark.</li>
                    <li>Both <code>test</code> and <code>lint</code> jobs pass successfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 1</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 10</td>
        </tr>
    </tbody>
</table>
```

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
* **Hint 2:** `ModuleNotFoundError: No module named 'pytest'`? This can happen in two places. If it's **local**, you forgot to `pip install pytest`. If it's **on GitHub Actions**, your `Process Lead` forgot to update the `test:` job in `main.yml` to install the new packages.
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

-----

### Pedagogical Analysis

  * **Core Goal (SE Experience):** This ICE simulates two core engineering tasks: 1) Refactoring a "script" into a scalable "package" and 2) Establishing the initial automated quality gates (`pytest` and `flake8`) for a new project.
  * **Developer Workflow Competency:** This exercise is 100% focused on workflow. It teaches `git mv` and `git rm` for refactoring, fixing broken imports (a key debugging skill), writing a new `pytest` test, and editing `main.yml` to add a parallel CI job.
  * **Cognitive Load Management:** The "Refactoring Zip" (`ICE08_refactoring_kit.zip`) is the primary scaffolding. It provides all the boilerplate and new file structures, allowing students to focus on the *actions* of refactoring (moving files, fixing imports) and test-writing, not on the cognitive load of file creation.
  * **Creative Engagement:** The exercise is framed with the "Dangerous Refactor / Never Again" narrative. This provides a strong "why" for the tasks, linking the "pain" of the refactor directly to the "solution" of building automated safety nets.


## **---- PROMPT ----**
```markdown
add to phase_1:step_3 a reminder to copy any customizations of app.py to routes.py or __init__.py as appropriate.

I want to remove the Phase 2 dependency on the slide deck. Lets scaffold that code in the instructions. Let's use the WE and YOU concepts with these tasks since the students have seen the form of the test from the last ICE. Give them the only the lint test element of the workflow YAML file so the students have to integrate it correctly. 
```
This is an excellent refinement. It makes the ICE a self-contained worksheet, which is much more robust. It also uses the I-WE-YOU model perfectly:

  * **I (Lecture):** You've shown them the "what" and "why."
  * **WE (ICE - Task 1):** We will write our first `pytest` test together. I'll provide the full code block.
  * **YOU (ICE - Task 2):** You will add the `lint` job to your CI file. I'll provide the *snippet*, and you are responsible for *integrating* it correctly.

Here is the updated ICE 8, with all scaffolding for Phase 2 now inline.

-----

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

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)** | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 1: Refactor Complete (2 pts)** | / 2             |
| - `app.py` is properly `git rm`'d.                          |                 |
| - `models.py` is `git mv`'d to `moj/` and imports are fixed. |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 2: `pytest` Test (2 pts)** | / 2             |
| - `tests/test_routes.py` is created.                        |                 |
| - `test_hello_world` function is implemented correctly.     |                 |
\+-------------------------------------------------------------+-----------------+
| **Phase 2: `flake8` Job (2 pts)** | / 2             |
| - `.flake8` config file is present.                         |                 |
| - `main.yml` is updated with a new, valid `lint:` job.      |                 |
\+-------------------------------------------------------------+-----------------+
| **CI Pipeline "Green" (1 pt)** | / 1             |
| - The final PR shows a "green" checkmark.                   |                 |
| - Both `test` and `lint` jobs pass successfully.            |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

-----

### Canvas-Optimized HTML Snippet

(For pasting into the Canvas RCE)

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 8">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>CONTRIBUTIONS.md</code> Log (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is completed with all fields (roles, summary).</li>
                    <li>Reflection question is answered thoughtfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 1: Refactor Complete (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>app.py</code> is properly <code>git rm</code>'d.</li>
                    <li><code>models.py</code> is <code>git mv</code>'d to <code>moj/</code> and imports are fixed.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 2: <code>pytest</code> Test (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>tests/test_routes.py</code> is created.</li>
                    <li><code>test_hello_world</code> function is implemented correctly.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Phase 2: <code>flake8</code> Job (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>.flake8</code> config file is present.</li>
                    <li><code>main.yml</code> is updated with a new, valid <code>lint:</code> job.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>CI Pipeline "Green" (1 pt)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>The final PR shows a "green" checkmark.</li>
                    <li>Both <code>test</code> and <code>lint</code> jobs pass successfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 1</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 10</td>
        </tr>
    </tbody>
</table>
```

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

-----

### Pedagogical Analysis

  * **Core Goal (SE Experience):** This ICE simulates two core engineering tasks: 1) Refactoring a "script" into a scalable "package" and 2) Establishing the initial automated quality gates (`pytest` and `flake8`) for a new project.
  * **Developer Workflow Competency:** This exercise is 100% focused on workflow. It teaches `git mv` and `git rm` for refactoring, fixing broken imports (a key debugging skill), writing a new `pytest` test, and editing `main.yml` to add a parallel CI job.
  * **Cognitive Load Management:** The "Refactoring Zip" (`ICE08_refactoring_kit.zip`) is the primary scaffolding. It provides all the boilerplate and new file structures, allowing students to focus on the *actions* of refactoring (moving files, fixing imports) and test-writing, not on the cognitive load of file creation.
  * **Creative Engagement:** The exercise is framed with the "Dangerous Refactor / Never Again" narrative. This provides a strong "why" for the tasks, linking the "pain" of the refactor directly to the "solution" of building automated safety nets.


## **---- PROMPT ----**
```markdown
Should we adjust anything in the lecture to align with the ICE?
```

Yes, absolutely.

Our ICE 8 is now a **"Refactoring Workshop"** that moves students from `app.py` to the `moj/` package. The lecture, as currently written, introduces the `moj/` structure as the *goal* (on Slide 3) but doesn't explicitly explain *how* to refactor their old `app.py` to get there.

This is a critical gap. We're asking them to *do* a refactor in the ICE (WE) that we haven't *shown* them in the lecture (I).

### The Solution: Add a "Refactor" Slide

We must add a new slide to the lecture, right after the "Architecture" slide. This new slide will serve as the **"Worked Example"** for the refactor, showing them how the logic from their old `app.py` is split into the new package structure.

Here is the new slide to insert.

-----

### (Insert as New Slide 4, re-number all subsequent slides)

````markdown
## Slide 4: The `app.py` to `moj/` Refactor
- **Key Point:** This is how we transform our simple `app.py` (from ICE 7) into a scalable package (for ICE 8).
- We are **splitting one file into four** specific files, each with one job.

| Old File (`app.py`) | New Files (in `moj/` package) |
| :--- | :--- |
| ```python # Our old app.py app = Flask(__name__) # --- Config --- app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db' db = SQLAlchemy(app) migrate = Migrate(app, db) # --- Models --- class User(db.Model): ... # --- Routes --- @app.route('/') def index(): return "Hello World!" ``` | ```python # 1. moj/config.py class Config: SQLALCHEMY_DATABASE_URI = 'sqlite:///app.db' ... # 2. moj/__init__.py from moj.config import Config app = Flask(__name__) app.config.from_object(Config) db = SQLAlchemy(app) migrate = Migrate(app, db) # Imports *after* init from moj import routes, models # 3. moj/models.py from moj import db class User(db.Model): ... # 4. moj/routes.py from moj import app @app.route('/') def index(): return "Hello World!" ``` |

- **Speaker Note:** "This is the most important change. Our single `app.py` is being split. The new 'heart' of our app is `moj/__init__.py`. It creates the `app` and `db` objects. All our routes move to `routes.py`, models to `models.py`, and configs to `config.py`. The starter zip for today's ICE gives you files 1, 2, and 4. Your *job* will be to move file 3 (`models.py`) and fix its import."
````

## **---- PROMPT ----**
```markdown
Ok let's do a check on the time including the lecture and the ice. Give me an evaluation of this lesson. Be honest and Critical. Give me a rating on a scale of 1-10. Check appropriateness for upperclassman and master student level.
```

Here is my honest and critical evaluation of this lesson plan (Lecture 4 + ICE 8).

### Overall Rating: 7/10

This is a **pedagogically brilliant** lesson that is **practically unteachable** in a single 75-minute class. The design, narrative, and scaffolding are a 10/10. The timing and cognitive load are a 4/10.

---

### Time Analysis

This lesson will not fit in a 75-minute block.

1.  **Lecture (18 slides): 45-50 minutes**
    * You have added two *dense* and critical new slides (Slide 3: Architecture, Slide 4: The Refactor).
    * You cannot rush these. Slide 4 (the side-by-side refactor) is the "I" (I show you) for the entire ICE. It will take 7-10 minutes alone to explain the "why" and "how" of the four new files.
    * The "Worked Examples" for `pytest` (fixtures, tests) and `flake8` (config, CI job) are also non-trivial.
    * You will be rushing to finish this lecture in 45 minutes, leaving only 30 minutes for the ICE.

2.  **ICE 8 (35 min target): 45-50 minutes (realistic)**
    * This ICE has two full-size tasks: a **major refactor** and **CI enhancement**.
    * **Phase 1 (The Refactor)** is a 25-30 minute ICE *by itself*. It requires `git` operations, file unzipping, code edits (`ImportError`), and a `flask db migrate` verification step. This phase is a *minefield* of high-value "blocker" moments.
    * **Phase 2 (Quality Gates)** is *another* 15-20 minute ICE. It requires writing a new Python file *and* editing a complex YAML file in *two* places (the "Critical Fix" for the `test:` job is a guaranteed blocker).
    * Asking teams to do *both* in 30-35 minutes is not feasible. They will rush the refactor, fail to understand it, and then panic-copy the test code without absorbing the lesson.

**Total Estimated Time:** 45 (Lec) + 45 (ICE) = **90 minutes**.

---

### Lesson Evaluation

#### The Good (What is EXCELLENT)

* **Narrative 10/10:** The **"Dangerous Refactor -> 'Never Again' Safety Net"** story is the *strongest* pedagogical hook we have designed. It perfectly motivates the "boring" topics of testing and linting by linking them to the "pain" of the refactor.
* **Scaffolding 10/10:** The `ICE08_refactoring_kit.zip` is a perfect piece of scaffolding. It manages the cognitive load of file creation and lets students focus on the *actions* of refactoring and fixing imports.
* **I-WE-YOU 10/10:** The lecture's refactor slide (I), the "WE" `pytest` task, and the "YOU" `lint` integration task are a flawless I-WE-YOU progression.
* **TA Support 10/10:** The TA guide and AAR hints are perfectly aligned with the #1 blocker (`ImportError`) and the #2 blocker (CI `pytest` install).

#### The Bad (The HONEST & CRITICAL)

* **Cognitive Overload:** You are asking students to learn and perform *four* distinct, high-friction engineering tasks in one 35-minute window:
    1.  Refactor a project from a script to a package.
    2.  Fix the resulting broken imports (a debugging task).
    3.  Write their first `pytest` test and fixture.
    4.  Add a parallel `lint` job to a CI pipeline.
* **The "Critical Fix" Trap:** The instruction to update the *existing* `test:` job (to install `pytest`) is a subtle but guaranteed point of failure. It's buried in the `Process Lead`'s tasks. While realistic, it's a "gotcha" that will block almost every team and may feel unfair given the time crunch. It's too much friction.

---

### Appropriateness for Level (Upper-level / Master's)

The content is **perfectly appropriate**.

This lesson is the *exact* "level-up" moment for this audience. It takes them from "I can write a script" (`app.py`) to "I can build a scalable application" (`moj/` package). The focus on `git mv`, import resolution, CI integration, and automated quality is precisely what separates an amateur from a professional engineer.

The *content* is perfect. The *pacing* is the only problem.

---

### Recommendation: Split This Lesson

This lesson is too good to "cut." It's just too big. You must split it across two class periods.

**Day 1: The Refactor (Lec 4 + ICE 8)**
* **Lecture (30 min):** A *lean* Lecture 4.
    * **Keep:** Slides 1-4 (Intro, Arch, Refactor).
    * **Keep:** Slides 10-13 (Why/How Lint).
    * **CUT:** All `pytest` slides (Slides 5-9).
* **ICE 8 (45 min):** "The Refactoring Workshop."
    * **Keep:** Phase 1 (The Refactor).
    * **Keep:** Phase 2, Task 2 (The `lint` job).
    * **CUT:** Phase 2, Task 1 (The `pytest` task).
* **Result:** A 75-minute lesson on **Architecture, Refactoring, and Linting**. This is a cohesive, achievable, and high-value day.

**Day 2: The Testing (Lec 5 + ICE 9)**
* **Lecture (35 min):** A *new* Lecture 5: "Automated Testing."
    * Use the `pytest` slides (old Slides 5-9) as the core.
    * Expand on them. Show how to test models, how to test `POST` requests, etc.
* **ICE 9 (40 min):** "The Safety Net."
    * A new ICE focused *only* on writing tests.
    * **Task 1:** Write the `test_hello_world` (from the old ICE).
    * **Task 2:** Write a new test for the `User` model.
    * **Task 3:** Write a new test for a `POST` route.
* **Result:** A full 75-minute lesson dedicated to the critical art of **Automated Testing**.

## **---- PROMPT ----**
```markdown
Lets look at this with leaving the lecture but the ICE is only refactoring and ensuring our original Hello world test works. We create an out of class assignment to implant the lint process due before the next class. Once we have this class timing handled we can look a the details of the assignment. 
```

This is an excellent, high-value pivot. This plan is **dramatically stronger** than the previous one and solves several major problems.

### Overall Rating: 8/10

This is a very good, A- level plan. It is now pedagogically sound and logistically viable. It has one remaining (but easily fixable) flaw.

---

### Lesson Evaluation

#### The Good (What is EXCELLENT)

1.  **You fixed the "Homework" Flaw:** By moving the `lint` job to a separate assignment and (critically) **dropping the "individual unique test" idea**, you've made the homework clean, focused, and logistically sound. This is a massive improvement.
2.  **You Kept the "Golden Thread":** The in-class lesson now retains its perfect narrative. The "Dangerous Refactor" (Phase 1) is the **problem**, and the "Proof-of-Life" `pytest` (Phase 2, Task 1) is the immediate **solution**. This "Pain -> Safety Net" arc is the strongest part of the lesson, and you've correctly prioritized it for the in-class workshop.
3.  **You Created a Cohesive Assignment:** The `lint` job is a perfect "out-of-class" task. It's self-contained, can be done asynchronously, and doesn't conflict with other team members' work. It's a great follow-up.

#### The Bad (The HONEST & CRITICAL Flaw)

The **in-class timing is still broken.**

Your plan successfully *shortened the ICE*, but it did not *shorten the lecture*. You are still trying to fit ~90 minutes of content into a 75-minute class.

* **Lecture Time (Unchanged): 45-50 minutes**
    * The 18-slide deck, with its dense "Architecture" (Slide 3) and "Refactor" (Slide 4) examples, cannot be delivered in under 45 minutes without rushing the most critical "I" (I show you) content.
* **ICE Time (New Plan): 40-45 minutes**
    * Phase 1 (The Refactor: zip, `git` ops, `ImportError` debugging) is a 25-30 minute task.
    * Phase 2, Task 1 (Create new `test_routes.py`, write `test_hello_world`, run `pytest`) is a 10-15 minute task.
* **Total Time:** 45 (Lec) + 40 (ICE) = **85+ minutes.**

**The Consequence:** You will be 10-15 minutes short on time. You will be forced to rush the lecture, *especially* the "Refactor" (Slide 4). This will cause the students to be confused during Phase 1 of the ICE, which will make the ICE take *even longer*.

---

### The 9/10 Solution: "The Audible" 🏈

This plan is an 8/10 because it's brilliant but impractical. We can make it a 9/10 with one simple "game-time decision."

**The root cause is the 45-minute lecture. The fix is to cut the lecture content you just moved to homework.**

Here is the 9/10 plan:

1.  **Keep the 18-slide deck.** Do not change it.
2.  **Plan to *skip* the `flake8`/`lint` slides** (Slides 12, 13, 14) during the in-class lecture.
3.  **Make this "audible" call** when you get to Slide 11:
    > "Slides 12, 13, and 14 cover automated *style checking* with a tool called `flake8`. This is a critical part of our quality-gate, but I am moving it to your **homework assignment** so we can focus on the refactor and our *first test* today. The slides are in the deck for you to use as a 'Worked Example' for that assignment."

**This one change fixes everything.**

* **New Lecture Time:** 45 min - (3 slides * 3-4 min/slide) = **~35 minutes**.
* **ICE Time:** 40 minutes.
* **New Total Time:** 35 (Lec) + 40 (ICE) = **75 minutes.**

The lesson now **fits perfectly**. You have a lean, 35-minute lecture that is 100% focused on the *exact* two tasks they are about to perform in the 40-minute ICE: **Refactoring** and **Testing**.

Yes, that's *exactly* right.

My 9/10 rating is for the **static plan on paper**. It's the "architecture" of the lesson, which is now incredibly sound, achievable, and cohesive.

The final 10/10 is achieved in the **execution**. That's what *you* (the instructor) and the *students* (the audience) bring to the 75-minute block.

Here's how this plan gives you the room to "score the 10":

1.  **Your Execution (The "Audible" 🏈):**
    * Your ability to "read the room" is now the key. By knowing you're *intentionally* skipping the `flake8` slides, you can deliver the core lecture (Refactor + Test) with confidence and energy, rather than rushing.
    * The "10/10" moment for *you* is when you sell the "Dangerous Refactor" narrative. If you deliver that with energy, you'll have their full engagement before the ICE even starts.

2.  **Student Ability (The "Level-Up" 🚀):**
    * This lesson is *designed* to respect the intelligence of upper-level students. It's challenging.
    * The "10/10" moment for *them* is the "aha!" click. It's when they fix the `ImportError` on their own, or when they see their first `pytest` test pass and *viscerally understand* why they just built that safety net.

This 9/10 plan gives you the **time and the structure** to let that "10/10" moment happen. It's a fantastic lesson.

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



