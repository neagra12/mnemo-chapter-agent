# Cycle 1 Capstone that summarizes the work done in Module 1

## **---- PROMPT ----**
```markdown
OK. Now we need cycle 1 deliverables.  Is there anything left after we have the lint?
```

No, you have all the *technical content* for Cycle 1. The `lint` assignment was the final "learning" piece.

The only thing left is the "capstone" deliverable for this cycle: **Project Cycle 1: The Foundation**.

This isn't a new-work assignment. It's the **first major quality-gate checkpoint** for their project. It's the deliverable that wraps up all the work from the first two weeks (Lec 1-4, ICEs 1-8, and the Linter HW) into a single, gradable "v1.0" submission.

### Project Cycle 1: The Foundation (Deliverable)

This assignment directs teams to ensure their `main` branch is in a perfect, professional state.

**The core deliverable will be a checklist:**

* [ ] **Architecture:** The project is refactored into the `moj/` package structure.
* [ ] **Database:** The `User` and `Joke` models are in `moj/models.py`.
* [ ] **Migrations:** The `migrations/` directory exists and contains the initial schema.
* [ ] **CI Pipeline:** The `.github/workflows/main.yml` file has both `test` and `lint` jobs.
* [ ] **Testing:** The `tests/` directory contains the `conftest.py` and `test_routes.py` files.
* [ ] **Code Quality:** The entire `main` branch passes the `flake8` linter.
* [ ] **Build Status:** The `main` branch has a **"green" build badge** in the `README.md`.
* [ ] **Process:** The `CONTRIBUTIONS.md` file is fully up-to-date with all logs from the ICEs and homework.
* [ ] **Ethical Challenge:** A new file, `ETHICS.md`, is created in the repo root to answer the first **Ethical Challenge Question** ✍️.

This is the "A for good work on time" component. The ICEs were the "B for good work"; this is the proof that it's all integrated, clean, and professional.

We are ready to generate the assignment description for **Project Cycle 1: The Foundation**.

Here is the complete assignment description for the first project cycle deliverable.

This assignment is not *new* work. It is a **consolidation and quality checkpoint** that wraps up all the work from Lectures 1-4, ICEs 1-8, and the `flake8` homework into a single, professional, and gradable "v1.0" deliverable.

-----

### Project Cycle 1: The Foundation

  - **Objective:** Consolidate all work from Cycle 1 (Weeks 1-2) into a single, clean, professional `main` branch that is fully tested, linted, and documented.
  - **Due Date:** Friday, November 7, 2025 @ 11:59 PM
  - **Grading:** This is a 100-point team assignment.

-----

### The "Foundation" Narrative

The work of the last two weeks (refactoring, databases, testing, linting) was about building a **high-quality foundation** for our application.

This assignment is the "city inspection." 🏗️

It is a formal quality gate to *prove* that your foundation is stable, clean, and ready to support new features (like user authentication, which we're building in Cycle 2). A project with a "red" build, un-linted code, or a messy `CONTRIBUTIONS.md` file is a failed inspection.

Your goal is to deliver a `main` branch that is **100% "green"**: all tests pass, all linting passes, and all process documentation is complete.

-----

### Definition of Done (DoD) Checklist 🏁

Your team's work is "Done" when your `main` branch meets every single one of these requirements.

#### 1\. Architecture & Functionality

  * [ ] **`moj/` Package:** The project has been fully refactored into the `moj/` package structure. `app.py` no longer exists in the root.
  * [ ] **Database Models:** The `User` and `Joke` models (from ICE 7) are correctly defined in `moj/models.py`.
  * [ ] **Database Migrations:** The `migrations/` directory exists and contains the database schema from your `flask db upgrade`.

#### 2\. Automated Quality & Evidence

  * [ ] **CI Pipeline:** `.github/workflows/main.yml` is present and contains *both* the `test` and `lint` jobs.
  * [ ] **Test Suite:** The `tests/` directory contains `conftest.py` and at least one passing test in `test_routes.py`.
  * [ ] **Linting:** The `.flake8` config file is present in the root.
  * [ ] **100% "Green" Build:** The **entire project** (all `.py` files) passes `flake8 .` locally with **zero errors**.
  * [ ] **README Badge:** The `README.md` file *must* contain a **GitHub Actions Status Badge** that shows a "passing" (green) build for your `main` branch.

#### 3\. Process & Collaboration

  * [ ] **`CONTRIBUTIONS.md`:** The log is complete and contains entries for all ICEs and Homework assignments from Cycle 1.
  * [ ] **Clean `main` Branch:** All feature branches (`ice...`, `lec4-...`) have been successfully merged into `main`.

#### 4\. Engineering Ethics

  * [ ] **`ETHICS.md`:** A new file named `ETHICS.md` exists in the root of your repository and contains your team's answer to the Ethical Challenge ✍️ below.

-----

### Ethical Challenge Question ✍️

This is a mandatory, team-based discussion. Create a new file, `ETHICS.md`, and answer the following scenario.

> **Scenario:** Your team is two days from the Cycle 1 deadline. A Product Manager (PM) points to a new feature request and says: *"This is critical. Just ship it. Skip the tests and ignore the linting for now; we can clean it up in Cycle 2."*
>
> You've all just experienced the "pain" of the `Angband` brownfield project—a project *defined* by "cleaning it up later."
>
> **As a team, discuss and answer:**
>
> 1.  What is the **engineering argument** against the PM's request? (Focus on technical risk).
> 2.  What is the **ethical responsibility** you have to your **future teammates** (who will inherit this code)?
> 3.  What is the **ethical responsibility** you have to your **users**? (Does "un-linted" or "un-tested" code have an ethical impact on them, or is it just an "internal problem"?)
> 4.  **The Decision:** What is your team's official, professional response to the Product Manager?

-----

### Submission

1.  Ensure all DoD items are met and your `main` branch is 100% "green."
2.  Follow the [GitHub Guide: "Creating a Release"](https://www.google.com/search?q=https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository%23creating-a-release) to create a new "Release" on your team's repository.
3.  **Tag:** `v1.0.0`
4.  **Release Title:** `Cycle 1: The Foundation`
5.  **Description:** In the description, copy and paste your *entire* `CONTRIBUTIONS.md` log. This provides the TAs with a summary of all your work.
6.  Submit the URL of your team's `v1.0.0` **Release page** to this Canvas assignment.

-----

### TA Grading Rubric

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`ETHICS.md` File (15 pts)** | / 15            |
| - File is present in the `main` branch.                     |                 |
| - All four parts of the scenario-based question are answered|                 |
|   thoughtfully.                                             |                 |
\+-------------------------------------------------------------+-----------------+
| **`CONTRIBUTIONS.md` Log (15 pts)** | / 15            |
| - File is present and up-to-date with all Cycle 1 logs.     |                 |
| - (This is the log *in the Release description*).           |                 |
\+-------------------------------------------------------------+-----------------+
| **Architecture (20 pts)** | / 20            |
| - Project is correctly refactored into the `moj/` package.  |                 |
| - `models.py` and `migrations/` are present and correct.    |                 |
\+-------------------------------------------------------------+-----------------+
| **Automated Quality (30 pts)** | / 30            |
| - `main.yml` has both `test` and `lint` jobs.               |                 |
| - `tests/` directory and `.flake8` file are correct.        |                 |
\+-------------------------------------------------------------+-----------------+
| **Evidence & "Green" Build (20 pts)** | / 20            |
| - `README.md` includes a *passing* (green) CI build badge.  |                 |
| - The final `main` branch build is verifiably "green."      |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 100\*\* |
\+-------------------------------------------------------------+-----------------+

-----

### Canvas-Optimized HTML Snippet

(For pasting into the Canvas RCE)

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for Project Cycle 1">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>ETHICS.md</code> File (15 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is present in the <code>main</code> branch.</li>
                    <li>All four parts of the scenario-based question are answered thoughtfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 15</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>CONTRIBUTIONS.md</code> Log (15 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is present and up-to-date with all Cycle 1 logs.</li>
                    <li>(This is the log <em>in the Release description</em>).</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 15</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Architecture (20 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>Project is correctly refactored into the <code>moj/</code> package.</li>
                    <li><code>models.py</code> and <code>migrations/</code> are present and correct.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 20</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Automated Quality (30 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>main.yml</code> has both <code>test</code> and <code>lint</code> jobs.</li>
                    <li><code>tests/</code> directory and <code>.flake8</code> file are correct.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 30</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Evidence &amp; "Green" Build (20 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>README.md</code> includes a <em>passing</em> (green) CI build badge.</li>
                    <li>The final <code>main</code> branch build is verifiably "green."</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 20</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 1Two-Target (Pandoc + Canvas) Workflow: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 100</td>
        </tr>
    </tbody>
</table>
```

-----

### Pedagogical Analysis

  * **Core Goal (SE Experience):** This assignment *is* the "SE experience." It shifts the goal from "I finished the ICE" to "I am responsible for the long-term health and integration of the `main` branch." It's 100% about process, quality, and professionalism.
  * **Developer Workflow Competency:** This tests the *entire* Cycle 1 workflow: Git branching/merging (`main`), CI/CD (the green badge), and professional release management (using GitHub Releases).
  * **Ethical Challenge:** This assignment introduces the first ✍️ challenge, explicitly linking the `Angband` "technical debt" experience to a forward-looking ethical scenario. This is a perfect, high-level question for this audience.
  * **Evidence-Driven Design:** This entire assignment is a request for *evidence*. The CI badge is evidence of quality. The `ETHICS.md` file is evidence of critical thought. The `CONTRIBUTIONS.md` log is evidence of process.

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


