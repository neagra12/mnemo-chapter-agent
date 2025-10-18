
# Lecture 2: Continuous Integration (CI)

## Slide 1: Title Slide

  - **Topic:** Continuous Integration with GitHub Actions
  - **Course:** Software Engineering

## Slide 2: Learning Objectives

  - By the end of this lecture, you will be able to:
  - **Define** Continuous Integration (CI) and its value in a team workflow.
  - **Read and write** a basic GitHub Actions workflow file using YAML syntax.
  - **Implement** a CI pipeline that automatically runs `pytest` on every commit.
  - **Explain** how a CI pipeline functions as a source of *evidence* for code quality.

## Slide 3: Bridging Context: From "Angband" to "MoJ"

  - **Key Point:** In the first half of the course, building and testing `Angband` was a **manual** process.
  - You had to *remember* to run `make`, `make test`, or other scripts on your *local* machine.
  - This is slow, error-prone, and leads to the "it worked on my machine\!" problem.
  - **Key Point:** For our "greenfield" MoJ project, we will **automate** this process from day one. Our engineering goal: **Never merge broken code.**
-     Speaker Note: Ask the class: "Hands up, who *forgot* to run the tests at least once before pushing a change for Angband? What was the result?" This connects their past pain to the new solution. "This automation is our first step in moving from a *hope-based* development model to an *evidence-based* one."


## Slide 4: What is Continuous Integration (CI)?

  - **Key Point:** CI is the *practice* of automatically building and testing your code every time a developer pushes a change to a shared repository.
  - It's a **safety net** and a **feedback loop**. It answers the critical question: "Did my new change break the main project?"
  - 
  - **Historical Hook 📜:** The concept was popularized in the late 90s as part of **Extreme Programming (XP)**. The goal was to solve "integration hell"—the nightmare of merging weeks of work from different developers at the end of a project, only to find nothing worked.
- Speaker Note: Emphasize that CI forces *small, frequent* integrations, which are much safer and easier to debug. The cost is a little setup time. The benefit is a massive reduction in future debugging.
  

## Slide 5: Why Do We Use CI? (The Value)

  - **1. Reduces Risk:** Catches bugs, integration errors, and broken tests *immediately*, not days or weeks later when the code is harder to fix.
  - **2. Improves Quality:** Enforces quality standards (like running tests and linters) on *every single commit*, not just when someone remembers.
  - **3. Increases Velocity:** Automates repetitive tasks (testing, deploying), letting developers focus on building features.
- Speaker Note: "I mentioned 'linters' on that second point. What is a linter? It's a tool that's like a grammar checker for your code. It doesn't run the code, but it *does* check it for stylistic errors, like bad formatting, unused variables, or common mistakes. By running a linter automatically, we enforce a *single, consistent style guide* for the whole team and catch simple bugs before they even get to the testing phase."


## Slide 6: Our Tool: GitHub Actions

  - **Key Point:** GitHub Actions is a CI/CD tool built directly into GitHub.
  - It's **event-driven**. It "listens" for events (like a `push` or `pull_request`) and then "runs" a set of commands (a "workflow").
  - **Key Point:** Workflows are defined in **YAML** files placed in a special directory in your repository: `.github/workflows/`.
- Speaker Note: You may not have heard of YAML, but you've seen it. It stands for "YAML Ain't Markup Language." It's just a human-readable way to write configuration data. We'll learn it by example.


## Slide 7: Anatomy of a Workflow: `name` and `on`

  - **Key Point:** A workflow file always starts with two key things: a `name` for the workflow and the `on` trigger that specifies when it should run.
  - **Code Example:**
    ```yaml
    # This is a comment in YAML

    # 1. A name for this workflow (shows up in GitHub)
    name: Python CI

    # 2. When to run it?
    on: [push] 

    # This configuration runs the workflow on *every push* # to *every branch* in the repository.
    ```

- 
Speaker Note: Emphasize the `on:` trigger. This is the event listener. We can make this much more specific (e.g., only on the `main` branch, or only on `pull_request`). For now, `[push]` is simple and effective.


## Slide 8: Anatomy of a Workflow: `jobs`

  - **Key Point:** A workflow is made of one or more `jobs`. A `job` is a set of steps that run on a specific "runner" (a virtual machine).
  - **Key Point:** Jobs run in parallel by default, but can be configured to run sequentially.
  - **Code Example:**
    ```yaml
    # ... (name: and on: are above) ...

    # 3. What jobs to run?
    jobs:
      # 4. Give the job a unique ID (e.g., "build")
      build:
        # 5. What OS to run on?
        # We will use our own laptops as "self-hosted" runners.
        runs-on: self-hosted
        
        # 6. What are the steps to run?
        steps:
          # (Steps go here... see next slide)
    ```

- Speaker Note: "Pay close attention to `runs-on: self-hosted`. Public GitHub projects can use runners provided by GitHub, like `ubuntu-latest`. But our repositories are **private**. For security and cost reasons, GitHub doesn't provide free runners for private repos.
"So, we will use **self-hosted runners**. This means you are configuring your *own machine* (your laptop) to securely listen for jobs from *your* repository. This is very common in companies that have private code. You must follow the **'Self-Hosted Runner Setup Guide'** on Canvas to get this working. It's a one-time setup."
"Also, that `build:` ID on line 4? That just needs to be a unique name for this job *inside this file*. It's how you'd tell other jobs to 'wait for the `build` job to finish' if you had a more complex pipeline."


## Slide 9: Anatomy of a Workflow: `steps` (Part 1)

  - **Key Point:** `steps` are the *actual commands* the job will run, in order.
  - You can use pre-built "actions" (like `actions/checkout`) or run your own shell commands (using `run:`).
  - **Code Example:**
    ```yaml
    # ... (inside the "build:" job) ...
    steps:
      # Step 1: Check out our repository's code
      # This action lets the runner access our project files.
      - uses: actions/checkout@v4

      # Step 2: Set up a specific Python version
      - name: Set up Python 3.10
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"
    ```

- Speaker Note: "Let's look at `uses: actions/checkout@v4`. `actions/checkout` is a script written by GitHub that pulls your code into the runner. The `@v4` is critical. This is **version pinning**. We are telling GitHub to use *exactly* version 4 of this action. Why? Because it's stable and we know it works. If we just said `actions/checkout`, we'd get the *latest* version. If the author released a new, buggy `v5` tomorrow, our pipeline would break for no reason. Version pinning is a core engineering practice for creating stable, repeatable builds."


## Slide 10: Anatomy of a Workflow: `steps` (Part 2)

  - **Key Point:** Once the environment is set up, we use `run:` to execute shell commands, just like in our own terminal.
  - We need to install our project's dependencies before we can run our code.
  - **Code Example:**
    ```yaml
    # ... (previous steps: checkout, setup-python) ...

      # Step 3: Install dependencies
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
    ```

- Speaker Note: Point out the `|` (pipe) character. This lets us write a multi-line shell script for a single `run` command. This is where we install Flask, Pytest, etc., as defined in our `requirements.txt`.


## Slide 11: Anatomy of a Workflow: `steps` (Part 3)

  - **Key Point:** The *most important* step is running our test suite.
  - If any command in a step fails (returns a non-zero exit code), the *entire job fails*.
  - This is how CI "catches" errors and reports a failure.
  - **Code Example:**
    ```yaml
    # ... (previous steps: checkout, setup-python, install) ...

      # Step 4: Run our tests!
      - name: Run Pytest
        run: |
          pytest
    ```

- Speaker Note: This is the moment of truth\! If `pytest` finds a failing test, it will exit with a non-zero code. This `Run Pytest` step will fail, the `build` job will fail, and GitHub will report a big red 'X' next to our commit. This is the feedback loop in action.


## Slide 12: Evidence-Driven Engineering 📈

  - **Key Point:** How do we *prove* our project is stable? We use the CI pipeline as our **source of evidence**.
  - A **"Green Build"** (all checks pass) is the *evidence* that the new code is safe to merge.
  - A **"Red Build"** (checks fail) is a clear, objective signal to *stop* and fix the problem before it gets merged into `main`.
  - 
- **Instructor Note:** "For your project, you will make this evidence *public* by adding a **CI status badge** to your `README.md`. A status badge is a small image, provided by GitHub, that automatically shows 'passing' (green) or 'failing' (red) based on the last CI run on your `main` branch. You can get the Markdown for this badge directly from your repository's 'Actions' tab. Adding this to your README is a point of professional pride. It's a live, quantitative metric of your team's health that is visible to everyone."

## Slide 13: Next: In-Class Exercise (ICE 2)
- **Topic:** The Ministry's First Line of Defense
- **Task:** It's time to build the "Silliness Detector"! You will create the `main.yml` workflow file to automatically test all new "Joke-Objects" (code) before they're approved.
- **Goal:** This workflow will automatically:
  1.  Check out your code.
  2.  Set up Python 3.10.
  3.  Install dependencies from `requirements.txt`.
  4.  Run `pytest`... and watch it pass!
- Speaker Note: "This is where we put it all together. Before we start, this is a good time to check that your team's self-hosted runners are active and listening for jobs, as per the setup guide. This workflow will be 'queued' by GitHub but won't run until your runner picks it up."


## Slide 14: Key Takeaways

  - **CI (Continuous Integration)** is the *practice* of automating builds and tests on every commit to get rapid feedback.
  - **GitHub Actions** is the *tool* we use to implement CI.
  - Workflows are defined in **YAML** files (e.g., `main.yml`) inside the `.github/workflows/` directory.
  - We use **`self-hosted` runners** because our projects are private.
  - CI provides a critical **safety net** and **evidence** of code quality *before* problems are merged into the `main` branch.