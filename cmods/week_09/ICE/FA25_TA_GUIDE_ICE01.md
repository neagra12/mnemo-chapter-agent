
# TA Follow-up Guide

  * **In-Class Goal (Workshop):** Blocker removal. Your **\#1 priority** is getting every team to **Sync 1 (Part 4)**. Swarm on any team stuck there, as it's the SSH key blocker *and* the ICE 2 dependency. Your **\#2 priority** is unblocking the `Dev Crew` in **Part 5** (usually `venv` issues). The final DoD is Part 7.

  * **Final DoD (Due 11:59 PM):** The team submits a clean PR to Canvas that meets all "Done-Done" criteria.

  * **Grading Rubric (10 points):** (See table above)

  * **Common Pitfalls & Coaching:**

    1.  **SSH Key Hell (The First Blocker):**
          * **Symptom:** `git clone` (Part 2) or `git pull` (Part 4) fails with `Permission denied (publickey)`.
          * **The Fix:** This is the *first test*. Students should *already* have keys from the `Angband` project. The most common issue is the key not being loaded. Have them run `ssh-add` (or `ssh-add ~/.ssh/id_rsa`) to load their key into the agent.
    2.  **`venv` Path Hell (The Second Blocker):**
          * **Symptom:** `pip install` installs globally, or `pytest` / `flask run` says `command not found` (in Part 5).
          * **The Fix:** Remind them to **activate** the `venv`. Their prompt *must* show `(venv)`. The command is `source venv/bin/activate`, and they must run it from the repo's root directory.
    3.  **Workflow Confusion:**
          * **Symptom:** Team is stuck, waiting. "What do we do now?"
          * **The Fix:** Point them to the "Announce" steps. This is a multi-stage, dependent workflow. The `Dev Crew` *must* wait for the `Process Lead` (Part 3), and the `Process Lead` *must* wait for the `Dev Crew` (Part 5).

  * **Coaching Questions (for next team meeting):**

      * "Why did we have the `Process Lead` push the `requirements.txt` and `tests/` folder *before* the `Dev Crew` wrote `app.py`?"
      * "In Part 5, why did the `Dev Crew` have to run `pytest` *before* they even wrote `app.py`? What did that verify?"

  * **Feed-Forward Prompts (to prep for the next ICE):**

      * "You just *locally* proved the test harness works. In our next class, we are going to build a CI pipeline to *automatically* run `pytest` for us."
      * "This automation **will not work** unless you have completed the **'Week 9 ICE Prep'** assignment on Canvas. That guide (`step-by-step-runner-guide.md`) is what enables your personal machine to act as a CI server for `github.iu.edu`. Please make sure *every single team member* does this before our next lecture."

