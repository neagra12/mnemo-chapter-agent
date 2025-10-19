Here is the Week 9 Quiz in Markdown format, covering the core concepts from Lectures 1 and 2.

---

### Week 9 Quiz: CI & Web Foundations

**Instructions:** This quiz covers the foundational concepts of web servers (Flask, HTTP) and Continuous Integration (GitHub Actions) from Module 1 of the "Ministry of Jokes" project.

---

**1. In Lecture 1, we contrasted our "Angband" and "MoJ" projects. What is the key difference between "brownfield" and "greenfield" development?**

1.  'Brownfield' means building a new project from scratch, while 'greenfield' means working with a new client.
2.  **'Brownfield' means working within a large, existing, legacy codebase, while 'greenfield' means starting a brand-new project. (Correct) ✅**
3.  'Brownfield' projects use old programming languages like C, while 'greenfield' projects use modern languages like Python.
4.  'Brownfield' development focuses on frontend UI, while 'greenfield' development focuses on backend databases.

**Rationale:** This correctly defines 'brownfield' as navigating an existing system (like an archaeologist) and 'greenfield' as building a new one (like an architect).

---

**2. The web runs on a client-server model. In our Flask application, which component is the 'server'?**

1.  The user's web browser (like Chrome or Firefox).
2.  The Python `requests` library.
3.  The `pytest` script that runs tests.
4.  **The Flask application (`app.py`) running on a machine, listening for HTTP requests. (Correct) ✅**

**Rationale:** The server is the program that 'serves' content by listening for and responding to network requests. This is the role of our Flask app.

---

**3. What is the primary semantic difference between an HTTP `GET` request and an HTTP `POST` request?**

1.  `GET` is used for submitting sensitive data like passwords, while `POST` is for public data.
2.  **`GET` requests are used to retrieve (or 'get') data from a server, while `POST` requests are used to submit new data to a server. (Correct) ✅**
3.  `GET` requests can only return HTML, while `POST` requests can only return JSON.
4.  `GET` requests are handled by Flask, while `POST` requests are handled by the database.

**Rationale:** This is the core convention. `GET` is for reading data, and `POST` is for creating or updating data.

---

**4. In Lecture 2, we defined Continuous Integration (CI) as a *practice*. What is the main *purpose* of this practice?**

1.  To write documentation for new features automatically.
2.  To give every team member 'admin' access to the repository.
3.  **To automate the building and testing of code on every commit, providing rapid feedback and evidence of quality. (Correct) ✅**
4.  To replace the need for `git pull` by automatically syncing all team members' computers.

**Rationale:** This is the core definition. CI is about automating the test process to catch bugs early and prove that new code integrates correctly.

---

**5. In a GitHub Actions workflow file, what is the relationship between a `job` and a `step`?**

1.  A `job` is a single command, and a `step` is a collection of jobs.
2.  **A `job` is a sequence of `steps` that execute on a runner. A `step` is a single task, like running a command or using an action. (Correct) ✅**
3.  `jobs` and `steps` are interchangeable names for the same thing.
4.  A `job` defines *when* to run, and a `step` defines *what* to run.

**Rationale:** This correctly describes the hierarchy. A workflow has jobs, and each job has one or more steps.

---

**6. What is the purpose of the `uses: actions/checkout@v4` step in our `main.yml` file?**

1.  It checks if the YAML syntax is correct before running.
2.  It 'checks out' the workflow log so you can see the results in the 'Actions' tab.
3.  **It runs the `git checkout` command, allowing the workflow's runner to access the repository's code. (Correct) ✅**
4.  It checks out a license from GitHub to allow the self-hosted runner to operate.

**Rationale:** A runner starts as a blank slate. This action is the equivalent of `git clone`, downloading your repo's code onto the runner so it can be tested.

---

**7. In our `main.yml` file, what is the *critical* difference between `runs-on: ubuntu-latest` and `runs-on: self-hosted`?**

1.  `ubuntu-latest` is for Linux, while `self-hosted` is for Windows or macOS.
2.  **`ubuntu-latest` uses a virtual machine provided by GitHub, while `self-hosted` uses a machine we control (like our own laptop). (Correct) ✅**
3.  `ubuntu-latest` is free, while `self-hosted` costs money.
4.  `ubuntu-latest` can run `pytest`, while `self-hosted` can only run `flake8`.

**Rationale:** This is the correct distinction. `ubuntu-latest` (a GitHub-hosted runner) is a public, shared machine, while `self-hosted` is a private machine we registered.

---

**8. Why is a 'red' (failing) build in your CI pipeline, as seen in ICE 2 (v3), considered a *success* from an engineering perspective?**

1.  It's not a success; it means the `main.yml` file is broken and needs to be deleted.
2.  **It's a success because it proves the 'Silliness Detector' (CI) is working and successfully caught a bug or test failure. (Correct) ✅**
3.  It's a success because red builds run faster than green builds, saving runner time.
4.  It's not a success; it means the self-hosted runner is offline.

**Rationale:** This is the core pedagogical point. A red build is 'evidence' that your automated safety net is functional and just prevented a bug from being merged.

---

**9. What is the primary role of a web framework like Flask?**

1.  **To handle the low-level details of parsing HTTP requests and routing them to the correct Python functions. (Correct) ✅**
2.  To automatically test Python code for bugs and style errors.
3.  To provide a graphical interface for writing Python code.
4.  To manage the `git` repository and versions.

**Rationale:** This is exactly right. Flask abstracts away the complexity of raw network sockets and HTTP parsing, letting you focus on application logic.

---

**10. In ICE 2, each `run:` block in our `main.yml` file (e.g., for 'Install dependencies' and 'Run tests') had to *start* with `source venv/bin/activate`. Why?**

1.  This is a security command to log in to the runner as an administrator.
2.  It's a mistake; only the first `run:` block needed to activate the `venv`.
3.  **Each `run:` command starts a new, clean shell session. The `venv` must be re-activated in each new session to make its packages (like `pytest`) available. (Correct) ✅**
4.  The `source` command is what tells GitHub Actions to print the output to the log.

**Rationale:** This is a key concept of CI workflows. Each `run:` line is isolated, so the environment (like an activated `venv` or exported variables) does not persist between them.