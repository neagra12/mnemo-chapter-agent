Here is the slide deck for Lecture 4, implementing Step 3 of our plan.

It includes the "Cycle 1 Reflection" slide we discussed, covers testing and linting, and bridges directly to ICE 4.

-----

# Lecture 4: Testing, Linting & Automated Quality

## Slide 1: Title Slide

  - **Topic:** Automated Quality: Testing & Linting
  - **Course:** Software Engineering

## Slide 2: Learning Objectives

  - By the end of this lecture, you will be able to:
  - **Write** a `pytest` unit test for a Flask route.
  - **Define** "linting" and its importance for code quality.
  - **Implement** a new `lint` job in your CI pipeline using `flake8`.
  - **Explain** how `pytest` and `flake8` act as automated "quality gates."

## Slide 3: Cycle 1 Reflection: The "Compressed Time"

  - **Key Point:** In this first cycle, we built a CI pipeline (ICE 2) and a database (ICE 3) in *minutes*. In a "real" job, these tasks represent *days* or *weeks* of work.
  - **The 'Angband' Way:** Manual, slow, and full of legacy debt. A simple change took *hours* to verify.
  - **The 'MoJ' Way:** We are adding an **"upfront process tax"** (Alembic, `pytest`, `flake8`) to every new feature.
  - **Why?** We are *using* this compressed time to build the right habits. The time you spend documenting and automating these "quick" tasks is the *real* lesson. It's what ensures this project will be efficient and maintainable in the long run.
  - Speaker Note: "This is the core of the greenfield experience. You're not just building the product; you're building the *factory*. A good factory has quality control (QC) built-in from day one. `pytest` is our QC for *functionality*. `flake8` is our QC for *readability*."

## Slide 4: Two Pillars of Automated Quality

  - **Key Point:** Our CI pipeline (the "Silliness Detector" from ICE 2) is our automated quality gate. It needs to answer two questions for every commit:
  - **1. Does it WORK? (Correctness)**
      - This is the job of **Testing** (e.g., `pytest`).
      - Does the code produce the *expected output*? Does it break anything?
  - **2. Is it CLEAN? (Readability & Maintainability)**
      - This is the job of **Linting** (e.g., `flake8`).
      - Does the code follow the team's *style guide*? Is it easy for another human to read?
  - Speaker Note: "So far, our pipeline only checks for correctness. Today, we add the second pillar: cleanliness. A feature that 'works' but is unreadable is still a 'red' build in a professional environment."

## Slide 5: Pillar 1: Writing a *Real* Unit Test

  - **Key Point:** In ICE 2, our `test_placeholder.py` just ran `assert True`. This is a "smoke test" (it proves the *test runner* works) but it doesn't test our *application*.
  - A **Unit Test** checks one "unit" of code (like a single function or route) in isolation.
  - To test our Flask app, we need a "test client."
  - **Reference:** [How to write and run tests (`pytest`)](https://www.google.com/search?q=%5Bhttps://docs.pytest.org/en/latest/how-to/run_pytest_doc.html%5D\(https://docs.pytest.org/en/latest/how-to/run_pytest_doc.html\))

## Slide 6: Code Example: Testing a Flask Route

  - **Key Point:** We can write a test that *simulates* a web browser making a `GET` request to our route and checks the response.
  - **Code Example:**

<!-- end list -->

```python
# tests/test_app.py
from app import app # Import our main Flask 'app' object

def test_hello_route():
    """
    GIVEN a Flask application
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

  - Speaker Note: "This is a *real* unit test. We use `app.test_client()` to get a simulator. We call `client.get('/')` to hit our route. Then, we make two assertions: `response.status_code == 200` (it didn't crash) and that our "Hello" message is in the `response.data`."

## Slide 7: Pillar 2: What is "Linting"?

  - **Key Point:** Linting is the automated process of checking code for stylistic and programmatic errors.
  - It's a "style guide" for your code. It checks for things like:
      - `import os` but `os` is never used (programmatic error)
      - Too many blank lines (stylistic)
      - A line that is 120 characters long (stylistic)
      - Missing spaces around an operator, like `x=y+1` (stylistic)
  - **The Tool:** We will use **`flake8`**, the most common Python linter.
  - **Reference:** [flake8 on PyPI](https://pypi.org/project/flake8/)

## Slide 8: Why is "Clean" Code an Engineering Goal?

  - **Key Point:** Code is written once, but it is **read hundreds of times**.
  - You (and your teammates) will spend more time *reading* old code to understand it than *writing* new code.
  - **Inconsistent style increases Cognitive Load.** It's like trying to read a book where every page uses a different font and text size.
  - A linter (like `flake8`) **externalizes the debate**. The team doesn't argue about style; you just agree to follow the linter. It's an objective, automated referee.
  - Speaker Note: "This is the 'process tax' I mentioned. Following `flake8` might feel annoying at first, but it pays for itself *immediately* by making your code readable and consistent for your teammates."

## Slide 9: Historical Hook: The Origin of "Lint"

  - **Key Point:** Where did this weird name come from?
  - The term "lint" comes from **Stephen C. Johnson**, a computer scientist at **Bell Labs** in 1978.
  - He wrote a tool to check for "fluff and fuzz" (stylistic errors and hidden bugs) in C code, just like a "lint trap" catches the fluff from a clothes dryer.
  - The name stuck. A "linter" is a tool that catches the "fluff" in your code before it causes a problem.
  - 
## Slide 10: Enhancing Our CI Pipeline

  - **Key Point:** Right now, our `main.yml` has *one* job: `test`. We are going to add a *second, parallel* job called `lint`.
  - This is a key GitHub Actions concept: your workflow can be a *graph* of jobs.
  - The `test` job and the `lint` job will **both start at the same time**.
  - The `push` or `pull_request` will *not* be "green" unless **BOTH** jobs pass.
  - This creates two "quality gates" that all code must pass.

## Slide 11: Code Example: A Multi-Job Workflow

  - **Key Point:** We just add a new top-level key (alongside `test:`) called `lint:`.
  - **Code Example:**

<!-- end list -->

```yaml
# .github/workflows/main.yml
name: Ministry CI

on: [push, pull_request] # ... (omitted for brevity)

jobs:
  test:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - name: Install dependencies
        run: |
          # ... (install from requirements.txt)
      - name: Run tests
        run: |
          # ... (run pytest)

  lint: # <-- NEW JOB!
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - name: Install linter
        run: |
          pip install flake8
      - name: Run flake8
        run: |
          # Stop the build if there are any linting errors
          flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
```

  - Speaker Note: "Notice `lint:` is at the same indentation level as `test:`. This makes it a new, parallel job. It checks out the code, installs `flake8`, and then runs it. This is how we build a more robust, multi-stage pipeline."

## Slide 12: Next: In-Class Exercise (ICE 4)

  - **Topic:** The Ministry's Style Guide
  - **Task:** It's time to add the second quality gate.
  - **Goal:** You will:
    1.  Write one *real* unit test for your "hello world" route (`test_app.py`).
    2.  Add the new `lint` job (from the slide) to your `main.yml` file.
    3.  Run `flake8` locally, fix any style errors, and push.
    4.  Confirm that your CI run shows **two green checkmarks**: one for `test` and one for `lint`.

## Slide 13: Key Takeaways

  - **Testing (`pytest`)** checks for **correctness** (Does it work?).
  - **Linting (`flake8`)** checks for **cleanliness** (Is it readable?).
  - Both are critical "quality gates" for a professional engineering team.
  - Code is **read** far more than it is written. Clean, readable code is a core engineering goal.
  - We can add multiple, **parallel jobs** to our `main.yml` file to create a more robust CI pipeline.