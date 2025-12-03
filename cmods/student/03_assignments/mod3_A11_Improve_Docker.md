# Homework 10: The Deployment Spec A16

  * **Module:** 3
  * **Assignment:** A16
  * **Topic:** Docker Optimization, Entrypoint Scripts, and Service Health
  * **Points:** 10
  * **Type:** "Team Best"

## The "Why": Robustness & Automation

In `ICE 15`, you got the app running. But if you delete the database volume and restart, the app crashes. Why? Because the database tables are missing. You have to manually run `docker-compose exec web flask db upgrade` every time. That's manual labor, and manual labor causes outages.

Furthermore, sometimes the Flask app starts *faster* than the Postgres database. If Flask tries to connect before Postgres is ready, it crashes.

In this assignment, you will write a **Deployment Specification** that solves these problems automatically. Your container will be smart enough to wait for the database, upgrade itself, and then launch.

## The "Team Best" Workflow

1.  **Branch:** The `Repo Admin` creates a branch `hw10-docker-optimize`.
2.  **Individual PRs:** Each student creates their own PR implementing the changes.
3.  **Merge & Log:** The team picks the best implementation, merges it, and logs it.

-----

## Core Task 1: The `.dockerignore` File

Your Docker build is likely sending your local `venv` and `__pycache__` folders to the Docker daemon. This makes builds slow and the image huge.

1.  **Create `.dockerignore`:** Create this file in your project root (it works exactly like `.gitignore`).
2.  **Add Content:** Exclude the heavy/unnecessary files.
    ```text
    venv/
    __pycache__/
    .git/
    .env
    *.db
    ```
3.  **Verify:** Re-run `docker-compose build`. It should be slightly faster.

## Core Task 2: The Entrypoint Script (`boot.sh`)

We want the container to automatically run database migrations *every time* it starts. We can't put this in the `Dockerfile` because the database isn't running during the build process. We need a script that runs at **runtime**.

1.  **Create `boot.sh`:** Create this file in your project root.
    ```bash
    #!/bin/bash
    # this script is used to boot a Docker container

    # 1. Run migrations
    flask db upgrade

    # 2. If migrations failed, exit
    if [ $? -eq 0 ]; then
        echo "Migrations successful."
    else
        echo "Migrations failed."
        exit 1
    fi

    # 3. Run the app (exec replaces the shell process with python)
    exec flask run --host=0.0.0.0
    ```
2.  **Update `Dockerfile`:**
      * Copy the script into the container.
      * Make it executable.
      * Change the `CMD` to run the script instead of flask directly.
    <!-- end list -->
    ```dockerfile
    # ... (previous steps)

    COPY boot.sh .
    RUN chmod +x boot.sh

    CMD ["./boot.sh"]
    ```

> **⚠️ CRITICAL WARNING FOR WINDOWS USERS:**
> If you create `boot.sh` on Windows, it may save with `CRLF` (Carriage Return + Line Feed) line endings. Linux **hates** this and will crash with a weird error like `exec: no such file or directory`.
> **Fix:** Ensure your editor (VS Code) is set to save this specific file with **LF** (Linux) line endings (look at the bottom right of VS Code).

## Core Task 3: The "Healthcheck" (Waiting for DB)

We need to ensure Flask doesn't crash if Postgres is slow to start.

1.  **Update `docker-compose.yml`:** Add a `healthcheck` to the `db` service, and a condition to the `web` service.
    ```yaml
    services:
      db:
        # ... image, env, volumes ...
        # Add this Healthcheck:
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U moj"]
          interval: 5s
          timeout: 5s
          retries: 5

      web:
        # ... build, ports, env ...
        depends_on:
          db:
            condition: service_healthy # <-- WAIT until db is actually ready!
    ```

-----

## ⭐ Extra Credit (+2 Points): The Gunicorn Server

The Flask development server (`flask run`) is not meant for production. It is slow and insecure. Real deployments use a WSGI server like **Gunicorn**.

1.  **Add `gunicorn`:** Add `gunicorn` to your `requirements.txt`.
2.  **Update `boot.sh`:** Change the final execution line to use Gunicorn instead of Flask.
    ```bash
    # exec flask run --host=0.0.0.0  <-- OLD
    exec gunicorn -b :5000 --access-logfile - --error-logfile - moj:app
    ```
    *(Note: `moj:app` assumes your main Flask file is `moj.py` and the variable is `app`. Adjust if yours is different, e.g., `app:app`).*

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 10 (A15): The Deployment Spec
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link]
* **Justification:** [Why was this implementation chosen?]
* **Reflection:** We added a script (`boot.sh`) to run migrations automatically. Why couldn't we just add `RUN flask db upgrade` inside the `Dockerfile`?
```

-----

## Rubric (For TA Use)

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for A15">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 1: Optimization (.dockerignore) (2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>.dockerignore</code> exists.</li>
                    <li>Correctly excludes <code>venv</code>, <code>__pycache__</code>, and <code>.git</code>.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 2</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 2: Automation (boot.sh) (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>boot.sh</code> is created and executes <code>flask db upgrade</code>.</li>
                    <li><code>Dockerfile</code> copies the script, <code>chmod +x</code> it, and sets it as <code>CMD</code>.</li>
                    <li>App starts successfully via <code>docker-compose up</code> without manual intervention.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Task 3: Reliability (Healthcheck) (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>docker-compose.yml</code> has a <code>healthcheck</code> block for the <code>db</code> service.</li>
                    <li><code>web</code> service uses <code>depends_on: db: condition: service_healthy</code>.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>EC: Gunicorn (+2 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>App runs using <code>gunicorn</code> in the container instead of the development server.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ +2</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 10</td>
        </tr>
    </tbody>
</table>
```
