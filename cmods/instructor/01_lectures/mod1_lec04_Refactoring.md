# Lecture 4: Testing, Linting, & Data Formats
## Slide 1: Title Slide
- **Topic:** Automated Quality: Testing & Linting
- **Course:** Software Engineering (Greenfield Development)
- **Module 1:** Building the "Ministry of Jokes" (MoJ)

## Slide 2: Learning Objectives
- By the end of this lecture, you will be able to:
- **Describe** the "Simple Package" architecture for our MoJ project.
- **Justify** the need for automated testing and linting.
- **Write** a `pytest` "fixture" to create a Flask test client.
- **Implement** a unit test for a Flask route using the test client.
- **Configure** `flake8` to enforce a consistent code style (PEP 8).
- **Add** a "Lint" job to your existing CI pipeline (`main.yml`).

## Slide 3: NEW: Our "Greenfield" Project Architecture
- **Key Point:** Before we add tests, let's establish our official project structure. We will use a "Simple Package Model."
- **This is now our standard "map" for the MoJ repository:**
```
  FA25-SE1-TEAMXX-MoJ/    <-- The <repo-root>
  |
  |-- .github/workflows/
  |   |-- main.yml        <-- CI Pipeline
  |
  |-- moj/                  <-- Our Flask "app package"
  |   |-- __init__.py       <-- Main app file (creates app, db, migrate)
  |   |-- models.py         <-- Database models (User, Joke)
  |   |-- config.py         <-- Configuration class
  |
  |-- tests/                <-- All tests live here
  |   |-- conftest.py       <-- Pytest fixtures (setup code)
  |   |-- test_routes.py    <-- Our first test file
  |
  |-- .flake8               <-- Linter configuration
  |-- migrations/           <-- Flask-Migrate's folder
  |-- requirements.txt
  |-- CONTRIBUTIONS.md
  ```
- **Speaker Note:** "This is a critical slide. This is our 'single source of truth' for file locations. The `moj/` directory is our application package. `__init__.py` replaces the `app.py` we used last week. This structure is professional and, most importantly, it permanently solves the 'circular import' trap."

## Slide 4: The "Evidence-Driven" Mindset
- **Key Point:** All new code is a **liability** until proven otherwise.
- In software engineering, "Done" does not mean "it works on my machine."
- **Done (Definition):** The new code is merged *and* there is an **automated, repeatable, and persistent** body of evidence that proves it (a) works as intended and (b) didn't break anything else.
- **Your tests are this evidence.** They are a core part of the product, not an add-on.

## Slide 5: "Brownfield" Testing: The `Angband` Model
- **Key Point:** How did we "test" `Angband`?
- We **played it**. We ran the program, walked around, tried to cast a spell, and *manually* "spot-checked" if the new feature (or our MFE) worked.
- **This is Manual Testing.**
- **The Problem:** It's slow, tedious, error-prone, and doesn't scale. You can't *play the entire game* every time you change one line of code.

## Slide 6: "Greenfield" Testing: The `MoJ` Model
- **Key Point:** For our greenfield project, we build the tests *with* the code.
- We will write small, automated Python scripts that "pretend" to be a user and check our app's behavior.
- This is **Automated Testing**, and `pytest` is our tool.
- **The Goal:** Every time you `git push`, our GitHub Action will automatically run *every single test* and give you a green checkmark (or a red X).

## Slide 7: How to Test a Flask App?
- **Key Point:** We can't just `import` our app and call functions. We need to test the *web routes*.
- We need to simulate a web browser making an HTTP request (e.g., `GET /`) and then check the HTTP response (e.g., "Did we get a 200 OK? Is 'Hello World' in the response text?").
- **The Solution:** `pytest` has a feature called **fixtures**. A fixture is a "setup" function that prepares a resource for our tests.
- We will create a fixture to provide a **`client`** that can make simulated requests.
- **Speaker Note:** This is the "I" in "I-WE-YOU." The next slide is the *exact code* you will need for your ICE, based on our new architecture.

## Slide 8: WORKED EXAMPLE 1: The `pytest` Fixture
- **Key Point:** This code goes in our new `tests/conftest.py` file.
- `pytest` automatically finds any file named `conftest.py` and uses its fixtures.
- **Code Example:**
```python
  # In tests/conftest.py
  import pytest
  from moj import app as flask_app # Import app from our 'moj' package

  @pytest.fixture
  def app():
      """Create and configure a new app instance for each test."""
      # Set up test-specific configurations
      flask_app.config.update({
          "TESTING": True,
          # We'll add a test DB config in a future lecture
      })
      yield flask_app

  @pytest.fixture
  def client(app):
      """A test client for the app."""
      return app.test_client()
```
- **Speaker Note:** Walk them through this. The `import` line is the key change. We are now importing the `app` object from our `moj/__init__.py` file.

## Slide 9: WORKED EXAMPLE 2: The First Test
- **Key Point:** Now we can write a test file (e.g., `tests/test_routes.py`) that *uses* our fixture.
- `pytest` finds any function starting with `test_`.
- **Code Example:**
```python
  # In tests/test_routes.py

  def test_hello_world(client):
      """
      GIVEN a configured test client
      WHEN the '/' route is requested (GET)
      THEN check that the response is valid
      """
      # 1. Make the request
      response = client.get('/')

      # 2. Check the response status code
      assert response.status_code == 200
      
      # 3. Check the response data
      assert b"Hello World!" in response.data
```
- **Speaker Note:** This is the core testing pattern: **Arrange, Act, Assert**. Here, the fixture "Arranges," `client.get()` "Acts," and `assert` "Asserts." The `b` in `b"Hello World!"` is important—it means "bytes," as HTTP responses are byte-streams.

## Slide 10: The *Other* Kind of Quality: Code Style
- **Key Point:** "Working" code is not enough. It must also be **readable** and **maintainable**.
- Code is read far more often than it is written.
- Your code must be understandable by your *teammates* (and by your TAs, and by you... six weeks from now).
- **The Problem:** What if every team member uses a different style? (Different indentation, line lengths, variable names...) The project becomes an unreadable mess.

## Slide 11: "Brownfield" Style: The `Angband` Model
- **Key Point:** The `Angband` C code is 30+ years old.
- The style is dense, complex, and "C-like" (e.g., `monster.c` is over 7,000 lines long).
- It's *functional*, but it has a very high cognitive load. It's hard for a new developer to read and understand.
- This is what happens when style is not managed for decades.

## Slide 12: "Greenfield" Style: The `MoJ` Model
- **Key Point:** We will enforce **one style** from Day 1: **PEP 8**.
- **PEP 8** is the official style guide for all Python code.
- We will use an automated tool called a **Linter** to check our code against PEP 8.
- Our Linter is **`flake8`**.
- A Linter is a "static analysis" tool. It *reads your code* (static) and "complains" about style errors *without running it*.
- **Speaker Note:** This is a core part of professional engineering. You *will* have a linter on your CI pipeline in any serious software company.

## Slide 13: WORKED EXAMPLE 3: Configuring `flake8`
- **Key Point:** We create a new file named `.flake8` in the **root** of our repository.
- This file tells `flake8` what rules to follow.
- **Code Example (A good starting point):**
```ini
  # In .flake8
  [flake8]
  # F401: 'module' imported but unused
  # E722: do not use bare 'except'
  # W292: no newline at end of file
  ignore = F401, E722, W292
  
  # Set max line length to a more modern 100
  max-line-length = 100
  
  # Exclude folders we don't control
  exclude =
      .git,
      __pycache__,
      moj/__pycache__,
      venv,
      migrations
```
- **Speaker Note:** You can run this locally by typing `pip install flake8` and then `flake8 .`. It will instantly show you all your style errors. The `exclude` section is critical for ignoring auto-generated files.

## Slide 14: WORKED EXAMPLE 4: Linting in CI
- **Key Point:** Now we add this check to our `main.yml` file.
- This ensures that no code can be merged if it fails the style check.
- We will add a new **Job** that runs in parallel with our `test` job.
- **Code Example (`.github/workflows/main.yml`):**
```yaml
  name: MoJ CI Pipeline

  on: [push, pull_request]

  jobs:
    test: # This job already exists from ICE 2
      runs-on: ubuntu-latest
      steps:
        # ... (checkout, setup python, install, run pytest)
        - name: Run Pytest
          run: pytest # Pytest will automatically find the tests/ dir

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
- **Speaker Note:** Point out the structure. We now have two *parallel jobs*: `test` and `lint`. The build will only pass if *both* are "green."

## Slide 15: A Quick Detour: Configs vs. Data
- **Key Point:** Notice the file formats we're using.
- Our CI pipeline (`main.yml`) and our linter config (`.flake8`) use a human-readable format.
- This format is **YAML** (or a similar `.ini` format). YAML is optimized for **humans to write** (and machines to read). It's perfect for config files.
- But... when our *application* sends data (e.g., from the React frontend to the Flask backend), it will use a different format.

## Slide 16: WORKED EXAMPLE 5: YAML vs. JSON
- **Key Point:** **YAML** is for configs. **JSON** is for data transfer.
- Let's look at the *same data* (our Joke model) in both formats.

| **YAML** (Human-readable, uses indentation) | **JSON** (Machine-readable, uses brackets/quotes) |
| :--- | :--- |
| ```yaml # Example of data in YAML format joke: id: 101 text: "Why did the...?" rating: 5 user: "@username" ``` | ```json // Same data as an API response { "joke": { "id": 101, "text": "Why did the...?", "rating": 5, "user": "@username" } } ``` |
- **Speaker Note:** You've already mastered YAML's syntax for your CI file. You will master JSON's syntax when you build your API routes.

## Slide 17: Key Takeaways
- **Our Architecture:** We use a `moj/` package for app code and a `tests/` directory for test code.
- **Automated Testing (`pytest`)** is our "evidence of correctness."
- **Fixtures (`conftest.py`)** are the setup helpers for our tests.
- **Automated Linting (`flake8`)** is our "evidence of readability."
- We add linting as a new, parallel **job** in our CI pipeline.
- **YAML** is for human-written config files.
- **JSON** is for machine-written API data.