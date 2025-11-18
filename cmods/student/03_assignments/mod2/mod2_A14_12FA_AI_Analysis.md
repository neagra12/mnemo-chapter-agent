# Assignment 15: Pragmatic Engineering (A 12-Factor App Analysis)

  - **Objective:** Critically analyze the 12-Factor App methodology, using AI to research valid, real-world use cases for *violating* its rules.
  - **Grading:** This is a 10-point "Team Report" assignment. Each team member is responsible for one section of the final report.

-----

## The "Why": Rules vs. Pragmatism

The **12-Factor App** is a blueprint for building a *specific type* of application: a highly-scalable, cloud-native, "software-as-a-service" (SaaS) app. Its rules are excellent for that use case.

But what if you're building a desktop app? A video game? A small internal tool for a 3-person company?

A good engineer knows the rules. A **great** engineer knows *why* the rules exist and *when to break them*. This assignment is about becoming a great engineer. You will explore the "gray areas" and learn to analyze the trade-offs of design decisions.

-----

## The "Team Report" Workflow

This is not a "Team Best" assignment. Instead, your team will work together to produce a single, comprehensive **Analysis Report**.

1.  **`Repo Admin`:** Creates the main branch `A15-factor-report`.
2.  **Team Task (In-Class):** As a team, **assign one 12-Factor App rule to each team member.** (e.g., Alice takes "XI. Logs," Bob takes "IV. Backing Services," etc.).
3.  **Individual Task:** Each member uses AI to research their rule and writes their analysis in a separate text file.
4.  **`Process Lead` (or other role):** Creates a new file in the repo root named `REPORT.md`.
5.  **Team Task:** Each member copies their completed analysis into the shared `REPORT.md` file as a new section.
6.  **`Repo Admin`:** Submits the final PR containing the completed `REPORT.md` and updated `CONTRIBUTIONS.md` log.

-----

## Core Task 1: The AI-Assisted Research (Individual)

Your job is to act as a Senior Engineer evaluating the 12-Factor App for a new project. Use an AI assistant as your research partner.

**Do not** ask "Explain 12-Factor App Rule V."
**Do** ask "What are some valid, real-world scenarios where *violating* 12-Factor App Rule V (Build, Release, Run) is a smart, pragmatic decision? What are the trade-offs?"

**Your Goal:** Find a concrete example of an application design or use case that *intentionally* violates your assigned rule for a *good reason*.

-----

## Core Task 2: The Analysis Write-up (Individual)

In the shared `REPORT.md` file, you must create a section for your assigned rule. Your analysis **must** include these four parts:

1.  **The Rule:** A brief, 1-2 sentence summary of your rule (e.g., "XI. Logs: Treat logs as event streams, writing them to `stdout` instead of to a file.").
2.  **The "Good" Violation:** A clear example of a use case that breaks this rule.
3.  **The Rationale (The "Why"):** Why is this violation a *smart, pragmatic choice* for that specific use case?
4.  **The Trade-off:** What is the team giving up by violating this rule? What risks are they accepting?

-----

## ⭐ Bonus Challenge (+2 Extra Credit Points)

For your analysis, add a fifth section:

5.  **The "Forward-Thinking" Path:** Describe how your "violating" application could be designed to **make it easy to adopt the 12-Factor rule later** if it needed to scale. This shows you are solving today's problem without making tomorrow's problem impossible.

-----

## Example Analysis (for Rule XI: Logs)

Here is a complete example of what one team member's section might look like.

### 5. Rule XI: Logs

  * **The Rule:** "Logs" states that an app should never write to a file. Instead, it should treat logs as "event streams" and write them to `stdout` (the console), letting a separate service capture and manage them.
  * **The "Good" Violation:** A small, internal-only admin dashboard for a 3-person team. The team decides to *violate* this rule by configuring Python's `logging` module to write to a local file (`moj.log`).
  * **The Rationale (The "Why"):** This is a pragmatic choice because the team has no budget or time for a complex log management service (like Splunk or Datadog). For a small app, `stdout` logs are *lost* as soon as the app restarts, and trying to read single-line JSON from a console is a terrible developer experience. Logging to a file is simple, persistent, and searchable with basic tools (`grep`).
  * **The Trade-off:** The team gives up centralized logging. If they ever scale this app to run on more than one server, this solution becomes unmanageable.
  * **The "Forward-Thinking" Path (BONUS):**
      * The team **does not** use `print()` statements (which only go to `stdout`).
      * They **do** use Python's built-in `logging` module for all messages.
      * This **abstracts** the logging. The app code just says `logging.info(...)` and doesn't care *where* it goes.
      * The *configuration* (in `config.py`) tells the `logging` module to use a `FileHandler` in development.
      * **The Win:** If they ever scale and get a real log service, they can switch to the 12-Factor rule by *only changing the config* to use a `StreamHandler` (for `stdout`). **No application code has to change.**

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 7: Pragmatic Engineering (A 12-Factor App Analysis)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Link to Final Report:** [Link to the REPORT.md file in your repo]
* **Assigned Rules:**
    * `@github-userA`: Rule [X - Name]
    * `@github-userB`: Rule [Y - Name]
    * `@github-userC`: Rule [Z - Name]
    * (etc...)
* **Summary of Work:** [As a team, write 1-2 sentences about your key takeaway from this exercise.]
```


