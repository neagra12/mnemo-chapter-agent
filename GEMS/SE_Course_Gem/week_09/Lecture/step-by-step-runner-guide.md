# 🛠️ GitHub Self-Hosted Runner Setup Guide (MoJ Project)

This guide will set up your local machine to act as a **CI Server** for your Ministry of Jokes (MoJ) project. This is a mandatory, project-critical task that must be completed before Lecture 2.

### Essential Pre-Flight Checklist

Before starting, check these assumptions, as they are the most likely failure points:

1.  **SSH Keys:** You successfully completed ICE 1 and can use **SSH** (`git clone git@...`) with a private key. **Action:** Run `ssh-add` to ensure your private key is loaded into your `ssh-agent`.
2.  **Python 3.10:** You have **Python 3.10+** installed on your machine. The Lecture 2 CI job will run *directly on your laptop*, not in a container.
     * **Action:** Open your terminal and run `python --version` (or `python3 --version`). Ensure it reports Python 3.10 or newer and that the command is in your `PATH`.
     * **Need to install?** [Windows Guide](https://www.python.org/downloads/windows/) | [macOS Guide](https://www.python.org/downloads/macos/)
3.  **Permissions:** You have a working terminal and the ability to create directories in your user's home folder.

-----

## Step 1: Create Runner Directory and Download Package

The runner software will live outside your project repository.

### Procedure

1.  Open your terminal/command prompt.

2.  Navigate to your home directory (`~` or `%USERPROFILE%`).

3.  Create a folder for your runner:

    ```bash
    mkdir actions-runner
    cd actions-runner
    ```

4.  Download the runner package. **Note:** Your GitHub URL is `github.iu.edu`. Replace `<OS>` and `<Arch>` below with your system's values (e.g., `linux-x64`, `osx-arm64`, `win-x64`).

    ```bash
    # Check the latest release page on github.iu.edu for the exact link
    # This example is for Linux/macOS
    curl -o actions-runner.tar.gz -L 'https://github.iu.edu/actions/runner/releases/download/v2.309.0/actions-runner-<OS>-<Arch>-2.309.0.tar.gz'

    # Unzip the package
    tar xzf ./actions-runner.tar.gz
    ```

    *(Windows users will download the zip file and use PowerShell's `Expand-Archive` or a GUI tool to extract it).*

### 🛠️ Verification 1 (Package Download)

  * **Check:** Run `ls` (or `dir` on Windows).
  * **Success:** You should see the files `config.sh` (or `config.cmd`), `run.sh` (or `run.cmd`), and the main `Runner.Listener` binary.

-----

## Step 2: Configure the Runner

You need a **Registration Token** from your team's GitHub repository settings.

### Procedure

1.  **Get the Token:** Navigate to your MoJ repository on `github.iu.edu`.

      * Go to **Settings** $\rightarrow$ **Actions** $\rightarrow$ **Runners**.
      * Click **New self-hosted runner**.
      * Follow the on-screen prompts to select your OS and architecture.
      * Copy the **registration token** provided. **This token is single-use\!**

2.  **Configure:** Run the configuration script using the token you just copied.

    ```bash
    # Linux/macOS
    ./config.sh --url https://github.iu.edu/<Your_Team_Org>/<Your_Repo> --token <YOUR_EPHEMERAL_TOKEN>

    # Windows (PowerShell)
    .\config.cmd --url https://github.iu.edu/<Your_Team_Org>/<Your_Repo> --token <YOUR_EPHEMERAL_TOKEN>
    ```

3.  **Prompts:** You will be prompted to enter the runner name and label.

      * **Runner Name:** Use your `TeamName-YourName` (e.g., `MoJTeam4-Alice`).
      * **Labels:** Leave the default (`self-hosted`) and press Enter.

### 🛠️ Verification 2 (Configuration)

  * **Check:** The terminal output should end with: `Settings Saved.`
  * **Success:** Go back to your GitHub repository: **Settings** $\rightarrow$ **Actions** $\rightarrow$ **Runners**. Your newly named runner should appear with a status of **Offline**.

-----

## Step 3: Run the Runner Agent

This step officially brings your CI server online. **Do not close this terminal window; it is now your CI server.**

### Procedure

1.  From the same `actions-runner` directory, execute the run script:

    ```bash
    # Linux/macOS
    ./run.sh

    # Windows (Command Prompt, NOT PowerShell)
    .\run.cmd
    ```

### 🛠️ Verification 3 (Online Status)

  * **Check:** The terminal output should show: `Listening for jobs...`
  * **Success:** Refresh your GitHub repository: **Settings** $\rightarrow$ **Actions** $\rightarrow$ **Runners**. Your runner's status should immediately change from **Offline** to **Idle** (green dot).

-----

## Step 4: Final Round-Trip Verification (CI Job Test)

This is the **Evidence-Driven Design** check. We will ensure the runner can pull a job, execute it, and report back.

### Procedure

1.  **Access GitHub:** Use a local copy of a repository in github.iu.edu. You must have commit privileges. Any text file in the repo is sufficient.

2.  **Make a Test Commit:** Add a comment (e.g., `# Test comment for runner verification`) and commit to a feature branch.

    ```bash
    git commit -am "test: verify self-hosted runner is working"
    git push
    ```

3.  **Run CI Job (Implicit):** This push will automatically trigger a test job. Your terminal (running `./run.sh`) should immediately display: `Job <JobName> was requested.`

4.  **Watch the Job:** The runner will execute the job (it will fail, as you don't have a workflow yet, but it should *start*).

### 📈 Final Verification (Quantitative Evidence)

  * **Check:** Navigate to your repository's **Actions** tab.
  * **Success:** You must see a new workflow run initiated by your push. Click on the job and verify that the runner name is **`TeamName-YourName`**. This confirms your local machine is correctly hosting the runner and communicating with `github.iu.edu`.
  * **Goal:** Your runner is now ready for **Lecture 2 (CI)**, where you will write the workflow file to define what this runner actually does.

-----

## Common Failures & Diagnostics

| Symptom | Cause | Diagnostic Check |
| :--- | :--- | :--- |
| **Runner is "Offline" (Never "Idle")** | Outbound Port 443 blocked, or runner process is not running. | **Check 1:** Is the ./run.sh (or run.cmd) script still running in your terminal? **Check 2:** Is your machine connected to the university Wi-Fi/VPN? |
| **Configuration Fails (Step 2)** | Token expired or incorrect URL. | **Check 1:** Get a **NEW** single-use registration token. **Check 2:** Double-check the URL: `https://github.iu.edu/<Org>/<Repo>`. |
| **Job Starts, but Fails Immediately** | Missing dependency required by the job (e.g., Python, `pytest`). | **Check:** Ensure Python is in your machine's `$PATH` (`which python` or `where python`) and that the correct `requirements.txt` dependencies are installed *globally* for the runner user, or that the job explicitly installs them. |
| **Permissions Error during `run.sh`** | Runner needs to execute a file but lacks permissions (Linux/macOS). | **Check:** Run `chmod +x run.sh config.sh`. |



-----
-----
