# TA Follow-up Guide

## Collect and forward Contribution Reflections
As you review the PR's for the ICEX, please extract the team reflections and send all of them to me in an email message. 

Students who are making up the ICEX are required to submit an individual reflection with the submission. Please forward those when you process those individual make-up. A Team make-up will be handled as a normal team reflection. 

## ICEX Goals
* **In-Class Goal (Workshop):** Your \#1 priority is to ensure the self-hosted runner is **active and connected** and to help teams diagnose any YAML/pathing issues in the `main.yml` file to achieve the **Initial Green Check ✅**. Any team that doesn't get green by the end of class is blocked on the homework.
* **Final DoD (Due 11:59 PM):** The final submission must be a single team PR (`ice2-ci-workshop`) that is **"Approved"** and has a **Green Check**, and whose `CONTRIBUTIONS.md` links out to a passing PR from *every* team member.

## Pitfalls and Coaching
* **Common Pitfalls & Coaching:**
    1.  **Self-Hosted Runner Offline:**
        * **Symptom:** The CI run is stuck in a "Waiting for a self-hosted runner" state.
        * **The Fix:** The student must run `./run.sh` (or `run.cmd`) in their `actions-runner` directory. Remind them to keep the terminal window open!
    2.  **Improper CR Workflow:**
        * **Symptom:** The `Repo Admin` simply leaves a comment or *Merges* the PR without the formal **"Request Changes"** (Part 4) or **"Approve"** (Part 6) steps.
        * **The Fix:** Coach the team that the CR status badge in GitHub (Required/Approved/Changes Requested) is the **evidence** the system requires. The comment alone isn't enough.
* **Coaching Questions (for next team meeting):**
    * "You just practiced rejecting a PR. What's the trade-off: is it better to **Request Changes** on a small fix or to let a small, safe-looking failure slip into `main` and then revert?"
    * "The `CONTRIBUTIONS.md` log lists all the steps your team took. How could you turn this log into an **onboarding checklist** for a new developer joining MoJ next week?"
* **Feed-Forward Prompts (to prep for the next ICE):**
    * "You now have a safety net for code quality. Next week, we introduce **databases** (SQLAlchemy). What will you need to add to your CI pipeline (`main.yml`) to ensure your tests can successfully connect to and tear down a database instance?"

## TA Grading Rubric (10 Points)

The final `ice2-ci-workshop` PR (due 11:59 PM) will be graded using this rubric.

| Criteria | Points | Description |
| :--- | :--- | :--- |
| **In-Class Demo Evidence** | 4 pts | The PR's history clearly shows the *team's* **Green ✅ $\rightarrow$ Red ❌ $\rightarrow$ Green ✅** loop, the **CR-Approve** loop, and **comments from all members**. |
| **Process Log & Links** | 3 pts | `CONTRIBUTIONS.md` is complete and—most importantly—contains **working links** to every team member's individual demo PR. |
| **Individual Homework** | 3 pts | Each linked individual PR *also* correctly shows the **Green $\rightarrow$ Red $\rightarrow$ Green** loop and a **CR-Approve** loop. (Partial credit if some are missing). |
| **Total** | **10 pts** | |


## Rules for team structure
This decision finalizes the standard team size and establishes a robust, equitable policy for managing team member absences during project-critical In-Class Exercises (ICEs). The policy is designed to uphold the **100% credit for present members** philosophy, while using the 85% grade cap to incentivize attendance for absent members.

### 1. Standard Team Structure and Role Allocation
The default team size is **5 members**, ensuring the `Process Lead` serves as a natural tie-breaker in team decision-making.

| Team Size | Primary Role 1 | Primary Role 2 | Dev Crew Role 3 | Dev Crew Role 4 | Dev Crew Role 5 (Flex/Shadow) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **5 Members** | **Repo Admin** (Branching/Merge) | **Process Lead** (Documentation/DoD/Tie-breaker) | **Dev Crew (A)** | **Dev Crew (B)** | **CR Shadow** (Real-time Review/QA) |
| **4 Members** | **Repo Admin** (Flex) | **Process Lead** | **Dev Crew (A)** | **Dev Crew (B)** | *(Empty)* |

* **4-Member Team Flex Rule:** The **Repo Admin** will act as the flex member, assisting the Dev Crew with any single-threaded tasks to ensure load-balancing.