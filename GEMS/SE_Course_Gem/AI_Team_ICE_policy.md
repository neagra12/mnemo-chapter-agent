# Decision Log for FA25 SE 1 final 7 weeks

---
## 2025-10-21 @ [Current Time] - Finalizing Team Structure, ICE Roles, and Absentee Policy

**Scope:** Course Policy, In-Class Exercises (ICEs), Grading

**Description:**
This decision finalizes the standard team size and establishes a robust, equitable policy for managing team member absences during project-critical In-Class Exercises (ICEs). The policy is designed to uphold the **100% credit for present members** philosophy, while using the 85% grade cap to incentivize attendance for absent members.

### 1. Standard Team Structure and Role Allocation
The default team size is **5 members**, ensuring the `Process Lead` serves as a natural tie-breaker in team decision-making.

| Team Size | Primary Role 1 | Primary Role 2 | Dev Crew Role 3 | Dev Crew Role 4 | Dev Crew Role 5 (Flex/Shadow) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **5 Members** | **Repo Admin** (Branching/Merge) | **Process Lead** (Documentation/DoD/Tie-breaker) | **Dev Crew (A)** | **Dev Crew (B)** | **CR Shadow** (Real-time Review/QA) |
| **4 Members** | **Repo Admin** (Flex) | **Process Lead** | **Dev Crew (A)** | **Dev Crew (B)** | *(Empty)* |

* **4-Member Team Flex Rule:** The **Repo Admin** will act as the flex member, assisting the Dev Crew with any single-threaded tasks to ensure load-balancing.

### 2. Revised ICE Absentee and Grading Policy
The policy is structured to prevent present members from being penalized due to absences, defining two or more absences as an automatic trigger for a low-stress team make-up.

| Scenario | In-Class Outcome & Action | Make-Up Requirement & Grading | Rationale & Evidence |
| :--- | :--- | :--- | :--- |
| **Full Attendance (Team Success)** | Team completes the ICE and merges the artifact to `main` by the deadline. | N/A | **100%** for all members. |
| **One Absence** | Present $\mathbf{4-5}$ members attempt the ICE in class. The team must update `CONTRIBUTIONS.md` with the absent member's status during class. | **Absent Student:** Must complete the **Individual Remedial Drill** and submit a private PR with reflection. | **Present Members:** Eligible for **100%** (if successful). **Absent Student:** Capped at $\mathbf{85\%}$ of the team score. |
| **Two or More Absences (Automatic Failure)** | The present $\mathbf{2-3}$ members **immediately** update the `CONTRIBUTIONS.md` log and pause the in-class ICE. | **Team Make-Up:** The present team members schedule a make-up (within one week) to complete and merge the artifact. | **Present Members:** Receive **100%** of the 10-point ICE rubric score upon successful make-up. **Absent Members:** Capped at $\mathbf{85\%}$ of the team score (conditional on the Individual Drill). |

---
**Reference:** Discussion between Instructor and Lecture Coach, 2025-10-21.

---

That's an excellent point. You are right that penalizing a present, working student because their teammates were absent is counter to the course's goal of delivering an excellent engineering experience. The policy must reward attendance and effort.

I've revised the Absentee and Grading Policy based on your feedback, establishing a clear threshold (two or more absences) for automatic in-class failure and creating a pathway for the remaining team to earn full credit via an equitable make-up.

### Revised ICE Absentee and Grading Policy: "Reward the Present"

This revised policy prioritizes rewarding the present team members with the opportunity for full credit (100%) and uses the 85% cap only as a penalty for the student who misses the primary learning event.

| Scenario | In-Class Outcome & Action | Make-Up Requirement & Grading | Evidence & Grade Rationale |
| :--- | :--- | :--- | :--- |
| **Full Attendance (Team Success)** | Team completes the ICE and merges the artifact to `main` by the deadline. | N/A | **100% of the 10-point ICE rubric score** for all members. |
| **One Absence (Team Success/Failure)** | The present $\mathbf{4-5}$ members attempt the ICE in class. Their outcome is judged on the standard rubric. | **Absent Student:** Must complete the **Individual Remedial Drill** on a private branch and submit a private PR with reflection. | **Present Members:** Receive **100%** (if successful) or **85%** (if late make-up). **Absent Student:** Receives $\mathbf{85\%}$ of the final team score, conditional on completing the Individual Remedial Drill. |
| **Two or More Absences (Automatic In-Class Failure)** | The present $\mathbf{2-3}$ members **immediately** update the `CONTRIBUTIONS.md` log to document the team status and the names of the absent members. **The in-class ICE is paused for the team.** | **Team Make-Up:** The team (with only the present members) schedules a time outside of class (within one week) to complete the ICE and merge the artifact. | **Present Members:** Receive **100%** of the 10-point ICE rubric score upon successful make-up completion. **Absent Members:** Receive $\mathbf{85\%}$ of the final team score, conditional on completing the Individual Remedial Drill. |

---

### Key Policy Rationale

* **Stress Management:** By defining **two or more absences** as an automatic in-class failure, we remove the pressure on the remaining small team to rush through a complex workflow in a high-stress, shortened timeframe. They are immediately rewarded for attending with the opportunity to do the work in a less stressful environment.
* **Rewarding Attendance:** **Present members** who complete the work (either in class or in the make-up session) are eligible for **100% credit**, reinforcing the value of attendance and commitment to the team.
* **Incentivizing Attendance:** The **absent student** must still complete the Individual Remedial Drill and is capped at **85%**, acting as a clear incentive to attend the crucial, project-critical workshop.

This policy is now integrated. Do you want to move on to generating materials, or are there any final process-level details you'd like to address, such as the missing quiz scores from the first half of the course?