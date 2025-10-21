# CYCLE_1_SETUP.md (Cycle 1 Starter Kit)

**Objective:** This is your first team workshop. It has two goals:

1.  **In-Class Goal (35-Min Workshop):** Get every single team member "operational." This means everyone can clone the repo, run the app, and pull changes from a teammate. **Identify all blockers** so your TA can help you *now*.
2.  **Final Goal (Due 11:59 PM Tonight):** Submit a perfect Pull Request (PR) that includes your project setup and contributions log.

---
## Recommended Task Allocation (Strategy 1)

This 35-minute workshop is a sprint. The "one-person-driving" model will fail. We **strongly recommend** this "Parallel Processing" strategy to get everyone working at the same time.

**Assign these roles now and add them to your `CONTRIBUTIONS.md` file.**

### The Roles
* **Repo Admin (1 person):** Focuses *only* on the GitHub repository setup.
* **Process Lead (1 person):** Focuses *only* on the GitHub Project (Kanban) board.
* **Dev Crew (3-4 people):** Focus *only* on getting their local machines set up. This is the hardest job.

### The Collaboration "Script"
1.  **Repo Admin:** Does **Part 1** (creates repo, adds all collaborators).
2.  **ALL (at once):**
    * **Process Lead:** Starts **Part 2** (sets up the Kanban board).
    * **Dev Crew:** Starts **Part 3** (clones the empty repo, runs into SSH errors, and calls TA for help).
3.  **Repo Admin:** Pushes the 7 starter files to `main` (end of **Part 3**) and **shouts, "Files are pushed!"**
4.  **Dev Crew:** Runs `git pull` to get the files, creates `venv`, installs packages, and runs `flask run --debug`. They call the TA when they hit blockers.
5.  **Process Lead:** Finishes the Kanban board.
6.  **Team (all together):** Converge for **Part 4**. One "Dev Crew" member will create and push the `CONTRIBUTIONS.md` file.
7.  **Team (all together):** The *rest* of the team runs `git pull` to get the new file.
8.  **Team (all together):** One final member opens the PR for **Part 5**.

---
## Part 1: Repository & Collaborator Setup (5 min)
* **(Repo Admin)**
1.  **Select a "Repo Admin":** One team member will create the repository.
2.  **Use the IU GitHub:** Go to **[https://github.iu.edu](https://github.iu.edu)** (do **NOT** use `github.com`).
3.  **Create Repository:** Name: `fa25-p465-team-XX`, Visibility: `Private`.
4.  **Add Collaborators:** Go to `Settings > Collaborators` and add:
    * Every member of your team.
    * Your assigned Team TA.
    * The Instructor.

---
## Part 2: Project (Kanban) Board Setup (10 min)
* **(Process Lead)**
1.  **Enable GitHub Projects:** Go to the `Projects` tab and create a `New project` using the `Team planning` template.
2.  **Configure Columns:** Rename the columns to: `To Do`, `In Progress`, `Done`.
3.  **Create Starter Tasks:** In `To Do`, create notes for the five main tasks of Cycle 1 and assign them.
    * `Task 1: Complete repository and project setup (ICE 1)`
    * `Task 2: Create initial CI pipeline (pytest) (ICE 2)`
    * `Task 3: Define database models (User, Joke) (ICE 3)`
    * `Task 4: Add Linting & Testing to CI (ICE 4)`
    * `Task 5: Finalize & Submit Cycle 1 Deliverable`
4.  **Action:** Drag `Task 1` to `In Progress`.

---
## Part 3: Local Setup & "Hello World" (15 min)
* **(Repo Admin + Dev Crew)**
1.  **(Dev Crew)** **Clone the Repo:** `git clone [YOUR_SSH_URL_HERE]`
    * **CRITICAL:** Use the **SSH** URL. If this fails, **STOP**. This is your first "blocker." Call your TA over to help fix your SSH keys.
2.  **(Repo Admin)** **Add Starter Code:** The "Repo Admin" will add all 7 starter files (`app.py`, `requirements.txt`, `.gitignore`, `README.md`, `LICENSE`, `CHANGELOG.md`, `DOCUMENTATION_POLICY.md`) to the repo, commit, and push them *directly to `main`*.
    ```bash
    git add .
    git commit -m "Initial commit: Add 7 starter kit files"
    git push origin main
    ```
3.  **(Dev Crew)** **Pull Starter Code:** Everyone else run `git pull origin main`.
4.  **(Dev Crew)** **Create ICE 1 Branch:** **Everyone** must now create the *same* branch:
    ```bash
    git checkout -b ice1-setup
    ```
5.  **(Dev Crew)** **Setup Python Environment:**
    * Create `venv`: `python -m venv venv`
    * Activate `venv`: `source venv/bin/activate` (or `.\venv\Scripts\activate`)
    * Install packages: `pip install -r requirements.txt`
6.  **(Dev Crew)** **Run the App:** Run `flask --app app run --debug`. If it fails, call your TA.

---
## Part 4: `CONTRIBUTIONS.md` & Team Sync (10 min)
* **(Entire Team)**
1.  **One Person Opens the File:** One team member (from the "Dev Crew") will open the `CONTRIBUTIONS.md` file (which is already in your repo) on the `ice1-setup` branch.
2.  **Add Content:** As a team, find the section for `ICE 1` and fill in the details:
    * `Date`
    * `Team Members Present`
    * `Roles:` (List who was Repo Admin, Process Lead, etc.)
    * `Summary of Work`
3.  **Commit & Push the File:**
     ```bash
     git add CONTRIBUTIONS.md
     git commit -m "feat: Add contributions log for ICE 1"
     git push origin ice1-setup 
     ```
4.  **All *Other* Members Pull the File:**
   * Everyone else on the team must now run:
     ```bash
     git pull origin ice1-setup
     ```
   * Confirm that the *updated* `CONTRIBUTIONS.md` file (with your names in it) now appears in your local project folder.


**If your team completes this, you have met the in-class objective. Your team is officially "un-blocked."**

---
## Part 5: Submission (Due 11:59 PM Tonight)
* **(Entire Team)**
1.  **Open the PR:** One team member opens a Pull Request to merge `ice1-setup` into `main`.
2.  **Title:** `ICE 1: Repository & Project Setup`
3.  **Assign Reviewer:** Assign your **Team TA** as a "Reviewer".
4.  **Submit to Canvas:** Copy the PR URL and submit it to the Canvas assignment.
   


