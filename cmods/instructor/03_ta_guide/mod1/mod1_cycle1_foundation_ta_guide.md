# TA Guide: Project Cycle 1 (The Foundation)

## 1. Grading Goal & Core Philosophy

This is a **checkpoint**, not a feature sprint. The 100-point grade is an "all-or-nothing" assessment of the project's foundational health. The team's goal was to deliver a "v1.0.0" release that is **100% "green" and professional**.

Your grading should be a "checklist" against the DoD. Do not grade the *quality* of the "Hello World" route. Instead, grade the *evidence* that their processes are working.
* Does the CI badge exist and is it **green**?
* Are *both* `test` and `lint` jobs present and passing?
* Is the `ETHICS.md` file present and thoughtfully completed?
* Is the `CONTRIBUTIONS.md` log complete and copied into the release?

This assignment assesses architecture, process, and ethics.

## 2. Grading Workflow & Common Pitfalls

Your entire grading workflow should happen on the **GitHub Release page** the students submitted.

1.  **Check the Release Description:** The *first* thing you should see is their complete `CONTRIBUTIONS.md` log. If this is missing, they failed a key instruction.
2.  **Check the `main` Branch (via the `v1.0.0` tag):**
    * Click the `v1.0.0` tag to browse the code at that snapshot.
    * **Go to `README.md`:** Is the build badge present? Is it **GREEN**? This is the single biggest "pass/fail" check.
    * **Check File Structure:** Does the `moj/` package exist? Is `app.py` gone?
    * **Check for Evidence:** Are `ETHICS.md`, `tests/`, `migrations/`, and `.flake8` all present?
    * **Check CI:** Open `.github/workflows/main.yml`. Does it contain *both* a `test:` job and a `lint:` job?

**Pitfalls to Grade On:**

* **No "Green" Badge:** If the badge is missing or "red," they failed the primary objective. This is a *major* deduction. They did not deliver a "green" foundation. (0/20 for that criteria).
* **Missing `ETHICS.md`:** This is a 15-point "all or nothing" item. If the file is missing or contains "N/A", they get 0/15.
* **Missing `CONTRIBUTIONS.md`:** If the log is not in the Release description, this is a 0/15. This proves they didn't follow the final submission instructions.
* **Incomplete CI:** If `main.yml` is missing the `lint:` job (from the HW), they fail that part of the "Automated Quality" criteria.

## 3. Feed-Forward & Coaching Questions (for Cycle 2)

* "Your team's answer on the `ETHICS.md` challenge was excellent. You correctly identified the risk to future teammates. How would you *quantify* that risk to a PM who only speaks in 'time' and 'money'?"
* "I see your CI pipeline is 'green.' What's one more 'quality gate' job you think we should add to `main.yml` in the next cycle? (e.g., test coverage? security audit?)"
* "Your `v1.0.0` release is a great *snapshot*. In a real company, what's the next step after 'releasing' this foundation? Who would you 'deliver' this to?"

---

## Rubric (Pandoc Grid Table for PDF)

+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
+=============================================================+=================+
| **`ETHICS.md` File (15 pts)**                               |   15            |
| - File is present in the `main` branch.                     |                 |
| - All four parts of the scenario-based question are answered|                 |
|   thoughtfully.                                             |                 |
+-------------------------------------------------------------+-----------------+
| **`CONTRIBUTIONS.md` Log (15 pts)**                         |   15            |
| - The log is copied into the `v1.0.0` Release description.  |                 |
| - The log is up-to-date with all Cycle 1 ICEs/HW.           |                 |
+-------------------------------------------------------------+-----------------+
| **Architecture (20 pts)**                                   |   20            |
| - Project is correctly refactored into the `moj/` package.  |                 |
| - `models.py` and `migrations/` are present and correct.    |                 |
+-------------------------------------------------------------+-----------------+
| **Automated Quality (30 pts)**                              |   30            |
| - `main.yml` has both `test` and `lint` jobs.               |                 |
| - `tests/` directory and `.flake8` file are correct.        |                 |
+-------------------------------------------------------------+-----------------+
| **Evidence & "Green" Build (20 pts)**                       |   20            |
| - `README.md` includes a *passing* (green) CI build badge.  |                 |
| - The final `main` branch build is verifiably "green."      |                 |
+-------------------------------------------------------------+-----------------+
| **Total**                                                   | **100**         |
+-------------------------------------------------------------+-----------------+