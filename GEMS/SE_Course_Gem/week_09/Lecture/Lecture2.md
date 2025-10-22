
# Lecture 2: The "Silliness Detector" (CI/CR)
## Slide 1: Title Slide
- **Topic:** Lecture 2: The "Silliness Detector" (CI/CR)
- **Course:** Software Engineering

## Slide 2: Learning Objectives
- By the end of this lecture **and workshop**, you will be able to:
- **Define** Continuous Integration (CI) and its value as a "safety net."
- **Implement** a basic CI pipeline to automate `pytest`.
- **Diagnose** a failed build (a "Red X" ❌) by reading the workflow log.
- **Practice** the professional Code Review (CR) 🙅‍♂️ $\rightarrow$ 👍 workflow to manage a failed build.

## Slide 3: Bridging Context
- **Key Point:** In Part 1 (`Angband`), our testing was **manual**, **local**, and **"hope-based."**
- You had to *remember* to run `make test`. If you forgot, you could push broken code. This is slow and leads to the "it worked on my machine!" problem.
- **Key Point:** In Part 2 (`MoJ`), our testing will be **automated**, **remote**, and **"evidence-based."**
- Our engineering goal: **Never merge broken code.**
- Speaker Note: "Hands up, who *forgot* to run the tests at least once before pushing a change for Angband? This lecture is the solution to that exact feeling. We are moving from a *hope-based* model to an *evidence-based* one."

## Slide 4: What is Continuous Integration (CI)?
- **Key Point:** CI is the *practice* of automating builds and tests *on every single commit* to get rapid, reliable feedback.
- **Analogy:** We are hiring a "robot" for our team.
- Its only job is to check everyone's work, 24/7.
- For the "Ministry of Jokes," we'll call it our **"Silliness Detector."**
- Speaker Note: "This robot is our first and most important source of *quantitative evidence* about our project's health."

## Slide 5: The "Why": CI as a Safety Net
- **Key Point:** CI builds **team trust** and provides **evidence**.
- **Solves "It Worked on My Machine":** The CI pipeline is a clean, consistent environment. If it passes there, it *really* works.
- **Finds Bugs in Seconds:** You get feedback *immediately*, not days later from an angry teammate or user.
- **Enables "Fearless Refactoring":** You can confidently make changes knowing the "Silliness Detector" will warn you if you break something.

## Slide 6: The "How": GitHub Actions (GHA)
- **Key Point:** GHA is the *tool* (an event-driven system) we use to implement the *practice* (CI).
- **Core Concepts:**
    - **`Event`**: A trigger (e.g., `git push`).
    - **`Workflow`**: The `.yml` file with instructions (e.g., `main.yml`).
    - **`Job`**: A task for a runner (e.g., `build-and-test`).
    - **`Step`**: A single command (e.g., `run: pytest`).
- Speaker Note: "Don't memorize this. The `.yml` file is just the instruction manual for the robot. We are learning this by *doing* it in the workshop."

## Slide 7: Critical Prerequisite: `self-hosted` Runners
- **Key Point:** `github.iu.edu` (our private GitHub) cannot run jobs itself. It needs a "worker" machine.
- Your **"Week 9 ICE Prep"** assignment configured your laptop as that worker.
- **ACTION REQUIRED:** You *must* have your runner script (`./run.sh` or `run.cmd`) active *right now* for ICE 2 to work.
- Speaker Note: "This is the #1 blocker. Please open your terminal and start your runner *now*. If it's not 'Listening for Jobs', your team will be blocked. Flag a TA immediately if you're stuck."

## Slide 8: How to Diagnose a "Red X" ❌
- **Key Point:** The Red X is *feedback*, not failure. It's the *start* of the diagnostic process.
- **The Workflow:**
    1.  Find the **Red X** ❌ (on the PR or "Actions" tab).
    2.  Click **"Details"** to open the workflow run.
    3.  Click the failing **Job** (e.g., `build-and-test`).
    4.  Find and **expand** the failing **Step** (e.g., `Run tests with pytest`).
    5.  Read the error message at the bottom.
- Speaker Note: "This is the *real* skill of this exercise. In the ICE, you will *intentionally* cause a Red X. You will use *this exact process* to find the error."

## Slide 9: The *Other* Safety Net: Code Review (CR)
- **Key Point:** CI is the *robot* check ("Is it safe?"). CR is the *human* check ("Is it a good idea?"). You need both.
- **The Core Exchange:**
    - **Author's Goal:** "I have a clean, tested, and valuable change."
    - **Reviewer's Goal:** "I *understand* this change, and I *agree* it's safe and valuable."
- Speaker Note: "As you do the Code Review part of ICE 2, here is your guidance. This is how you build a professional team culture:
    1.  **Critique the code, not the coder.** Never say 'You made a mistake.' Say, 'This code has a bug.'
    2.  **Ask questions, don't give commands.** Instead of 'Fix this,' ask, 'What was the thinking here? I'm worried this might not handle the `None` case.'
    3.  **Automate the small stuff.** A *bad* code review argues about commas or indentation. That's a *linter's* job, which we'll add next week. A *good* code review talks about logic, risk, and design."

## Slide 10: Public Evidence: Status Badges
- **Key Point:** A status badge is a live, public-facing sign of your team's quality and professionalism.
- It's a small image in your `README.md` that automatically shows if your `main` branch is "passing" (green) or "failing" (red).
- 
- **How:** You can get the Markdown for this badge directly from your repository's "Actions" tab.
- Speaker Note: "This aligns with our 'evidence-based' goal. It's a live, quantitative metric of your team's health that is visible to everyone. It's a point of professional pride."

## Slide 11: Handoff to ICE 2 Workshop
- **Topic:** The CI/CR "Fire Drill"
- **Task:** Time to build it, break it, and fix it—as a team.
- **This is a 45-minute "macro-workshop."**
- **Your Goal:**
    1.  Get a **Green Check ✅** (Prove it works).
    2.  Get a **Red X ❌** (Prove it catches bugs).
    3.  Practice the full Code Review **🙅‍♂️ $\rightarrow$ 👍** loop (Prove your *process* works).
- Speaker Note: "This is the main event for today. The goal is *not speed*, it's *accuracy* and *communication*. We are validating our *process* in-class to de-risk your individual homework."

## Slide 12: Key Takeaways
- *(This slide is shown *after* the 45-minute ICE, at the end of the 75-minute class.)*
- **CI** is the *practice* of automating tests; **GHA** is the *tool*.
- The **"Red X"** is the *start* of the diagnostic process, not the end.
- **CI (robot) + CR (human)** are the two safety nets of a professional team.
- **Status Badges** are the public-facing *evidence* of your automated quality.
- Speaker Note: "Great job on the fire drill. You've now all seen a failed build, diagnosed it, and used the professional CR process to manage it. Your homework is to do this *individually*, and the `CONTRIBUTIONS.md` log explains how."