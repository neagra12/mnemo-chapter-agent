# ICEX08: The Ministry's Style Guide

  - **Objective:** Add a second, parallel "quality gate" to the CI pipeline by creating a `lint` job. Write one *real* unit test to replace the placeholder.
  - **Time Limit:** 40 minutes
  - **Context:** From Lecture 4, we know our "Silliness Detector" (CI) must check two things: "Does it WORK?" (`pytest`) and "Is it CLEAN?" (`flake8`). Our pipeline is also **broken** from ICE 3\! Our goal is to fix the `test` job and add the new `lint` job, creating a robust, multi-stage pipeline.

-----

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

For this ICE, we will use the **CI/CD Crew Kit**. All three roles will edit different parts of the repository to make the pipeline pass.
*Remember the course policy: You cannot hold the same role for more than two consecutive weeks.*

  * **Repo Admin:** (Domain: Workflow Definition) Creates the branch and is responsible for adding the *new* `lint:` job to the `main.yml` file.
  * **Process Lead:** (Domain: Workflow Repair) Responsible for *fixing* the existing `test:` job in `main.yml` (which broke in ICE 3) to correctly install all dependencies.
  * **Dev Crew:** (Domain: Test Code) Responsible for writing the *new* `tests/test_app.py` unit test and *deleting* the old `tests/test_placeholder.py`.

-----

## Task Description: Installing the "Style Guide"

**Goal:** All three roles will work in parallel. The final goal is to get a "green" build on *both* the `test` job and the new `lint` job.

**Sync Point 0: Get on the Branch**

1.  **([Repo Admin])** Create and push a new feature branch:
    ```bash
    git checkout -b ice4-linting-pipeline
    git push --set-upstream origin ice4-linting-pipeline
    ```
2.  **([All Roles])** *Everyone* must now pull and check out this branch.
    ```bash
    git pull
    git checkout ice4-linting-pipeline
    ```

-----

*Now, all three roles work at the same time.*

### Part 1: Fix the `test` Job

  * **([Process Lead])**
    1.  Open `.github/workflows/main.yml`.
    2.  Find the `test:` job.
    3.  This job is **broken** because it doesn't install our new database packages from ICE 3.
    4.  **Replace** the entire `Install dependencies` step with this one, which uses `requirements.txt`:
        ```yaml
        - name: Install dependencies
          run: |
            python -m venv venv
            source venv/bin/activate
            pip install -r requirements.txt
        ```
    5.  Commit and push this change:
        ```bash
        git add .github/workflows/main.yml
        git commit -m "fix(ci): update test job to install all requirements"
        git push
        ```

### Part 2: Write a Real Unit Test

  * **([Dev Crew])**
    1.  Create a *new* test file: `tests/test_app.py`.
    2.  Paste in the following *real* unit test (from Lecture 4):
        ```python
        # Note: You may need to adjust the import path
        # depending on your project structure.
        # This assumes your Flask 'app' object is in 'app/__init__.py'
        from app import app 

        def test_hello_route():
            """
            GIVEN a Flask application configured for testing
            WHEN the '/' route is requested (GET)
            THEN check that the response is valid
            """
            # Create a test client using the Flask app
            with app.test_client() as client:
                # Simulate a GET request to the "/" route
                response = client.get('/')

                # Check that the status code is "200 OK"
                assert response.status_code == 200
                # Check that the data returned is what we expect
                assert b"Hello, Ministry of Jokes!" in response.data
        ```
    3.  **Delete** the old placeholder test file:
        ```bash
        git rm tests/test_placeholder.py
        ```
    4.  Commit and push these changes:
        ```bash
        git add tests/test_app.py tests/test_placeholder.py
        git commit -m "feat: add unit test for hello route, remove placeholder"
        git push
        ```

### Part 3: Add the `lint` Job

  * **([Repo Admin])**
    1.  Open `.github/workflows/main.yml`.
    2.  Go to the *very end* of the file.
    3.  Add the following code. (Make sure `lint:` is at the *same indentation level* as `test:`).
        ```yaml
        
          # This job runs in parallel with the 'test' job
          lint:
            runs-on: self-hosted

            steps:
              - name: Check out repository
                uses: actions/checkout@v4

              - name: Set up Python 3.10
                uses: actions/setup-python@v5
                with:
                  python-version: '3.10'

              - name: Install linter
                run: |
                  python -m venv venv
                  source venv/bin/activate
                  pip install flake8

              - name: Run flake8
                run: |
                  source venv/bin/activate
                  # Stop the build if there are any style errors
                  # --count shows total number of errors
                  # --max-line-length=120 (a bit more forgiving than 80)
                  flake8 . --count --max-line-length=120 --statistics
        ```
    4.  Commit and push this change:
        ```bash
        git add .github/workflows/main.yml
        git commit -m "feat(ci): add parallel lint job with flake8"
        git push
        ```

-----

### Part 4: Sync & Validate (Team Task)

1.  **([All Roles])** Pull all changes. Your goal is for *everyone* to have the updated `main.yml` and new `tests/` directory.
    ```bash
    git pull
    ```
2.  **([All Roles])** As a team, go to the **"Actions"** tab on GitHub.
3.  Find the run for your latest commit. You should see **two jobs** running in parallel: `test` and `lint`.
4.  **Validate the Result:**
      * **If BOTH are GREEN (✅✅):** Success\! You have a "double-green" build.
      * **If `lint` is RED (❌):** **This is also a success\!** It means `flake8` found a style error. Click into the log, read the error (e.g., "line too long" or "unused import"), fix the style in the code, commit, and push again.
      * **If `test` is RED (❌):** You have a problem in either Part 1 (workflow fix) or Part 2 (test code). Debug the log together.
5.  Once you have a "double-green" build, update your `CONTRIBUTIONS.md` file.

-----

## `CONTRIBUTIONS.md` Log Entry

*One team member share their screen.* Open `CONTRIBUTIONS.md` on your feature branch (`ice4-linting-pipeline`) and add the following entry **using this exact format**:

```markdown
#### ICE 4: The Ministry's Style Guide
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew: `@github-userZ`, ...
* **Summary of Work:** We fixed the `test` job in our CI pipeline, wrote a real unit test in `tests/test_app.py`, and added a new, parallel `lint` job to `main.yml` that runs `flake8`.
* **Evidence & Reflection:** As a team, discuss and answer: Your CI pipeline now has two jobs (`test` and `lint`). What is the main *advantage* of running them in parallel (at the same time)? What is one potential *disadvantage*?
```

*After logging, commit and push this file. All other members must `git pull` to get the change.*

-----

## Definition of Done (DoD) 🏁

Your team's work is "Done" when you can check all of the following:

  * [ ] **Artifact 1:** `tests/test_placeholder.py` has been *deleted*.
  * [ ] **Artifact 2:** `tests/test_app.py` *exists* and contains the `test_hello_route` unit test.
  * [ ] **Artifact 3:** `main.yml` contains both a `test:` job and a `lint:` job.
  * [ ] **Functionality:** The latest commit on your branch shows **two green checkmarks (✅✅)** in the GitHub Actions tab (one for `test`, one for `lint`).
  * [ ] **Process:** `CONTRIBUTIONS.md` is updated with roles and the reflection.
  * [ ] **Submission:** A Pull Request is open and correctly configured (see below).

-----

## Submission (Due 11:59 PM Today)

1.  **Open Pull Request:** Open a new PR to merge your feature branch (`ice4-linting-pipeline`) into `main`.
2.  **Title:** `ICE 4: The Ministry's Style Guide`
3.  **Reviewer:** Assign your **Team TA** as a "Reviewer."
4.  **Submit to Canvas:** Submit the URL of the Pull Request to the Canvas assignment.

-----

-----
### TA Follow-up Guide

  * **In-Class Goal (Workshop):** Get every team to a "double-green" build. The *most important* pedagogical moment is when a team's `lint` job fails.
  * **Final DoD (Due 11:59 PM):** A clean PR with two "green" checks on the latest commit, proving both jobs passed.
  * **Common Pitfalls & Coaching:**
    1.  **[The \#1 Blocker] `lint` Job Fails (Red ❌):**
          * **Symptom:** The `test` job passes, but `lint` fails.
          * **The Fix:** **Congratulate them\!** This is the *point* of the exercise. The "Style Guide" is working\! Have them click into the `lint` log, read the `flake8` error (e.Example: `app/models.py:10:1: E302 expected 2 blank lines, found 1`), find that exact line, fix the style, commit, and push.
    2.  **[The \#2 Blocker] `test` Job Fails (Red ❌):**
          * **Symptom:** The `test` job fails, often on "Install dependencies."
          * **The Fix:** The **Process Lead** (Part 1) forgot to update the `test` job's `run:` command to `pip install -r requirements.txt`. It's still using the old command from ICE 2 and is failing when `pytest` tries to `import sqlalchemy`.
    3.  **[The \#3 Blocker] `test_app.py` Fails:**
          * **Symptom:** The `test` job fails on the "Run tests with pytest" step with an `ImportError: cannot import name 'app' from 'app'`.
          * **The Fix:** Their project structure is slightly different from the scaffold. Help them fix the import line. It might be `from app.main import app` or just `from main import app` if they don't have an `app` directory. This is a good time to help them standardize.
  * **Coaching Questions (for next team meeting):**
      * "Your `test` and `lint` jobs both install Python and run `pip install`. Do you see a way we could make this more efficient? (Hint: `needs:` or reusable workflows)."
      * "A `flake8` error is not a 'bug.' Why is it important enough to 'break the build'?"
  * **Feed-Forward Prompts (to prep for the next ICE):**
      * "You now have a fully automated, two-stage CI pipeline. You have database models. You have a web server. All the *pieces* are in place. Your next task is to synthesize all of this into your **first major project deliverable**."

-----

-----

## Pedagogical Analysis

  * **Core Goal (SE Experience):** This is a perfect "Cycle 1" capstone exercise. It forces students to *return to and modify* a core piece of infrastructure (`main.yml`), which is a very common and realistic task. It adds a second, parallel "quality gate," formalizing the idea of automated quality.
  * **Developer Workflow Competency:** This is a strong parallel workflow. More importantly, it teaches students how to *read* and *react* to a `flake8` failure in a CI log, reinforcing that "cleanliness" is a team-level, non-negotiable standard.
  * **Ethical Challenge:** This artifact does not include an ethical challenge. The task is purely technical process setup.
  * **Historical Context:** This was covered in Lecture 4 and is not part of the exercise itself.
  * **Creative Engagement:** The "Style Guide" metaphor connects `flake8` to a real-world concept. The "double-green" checkmark (✅✅) is a satisfying, visible "trophy" for the team to aim for.
  * **Cognitive Load Management:** The load is well-managed. All the necessary YAML and Python code (for the test) is provided. The cognitive load is correctly focused on *implementing* the changes in the right places, *troubleshooting* the (expected) `flake8` failures, and *observing* the parallel jobs in the Actions tab.