# Session to build the ICE11 - containerization

# **---- PROMPT ----**
```markdown

```

Here is the In-Class Exercise for Module 3, Lecture 11.

This is a pivotal moment in the semester. The team stops running the app "locally" and starts running it "in a container."

-----

### ICE 15: "Shipping Containers" (Docker & Postgres)

  * **Objective:** Containerize the MoJ application using Docker, replace SQLite with PostgreSQL, and successfully launch the full stack using Docker Compose.
  * **Time Limit:** 45 minutes
  * **Context:** We are leaving "it works on my machine" behind. We will implement **12-Factor Rule IV (Backing Services)** by attaching a real PostgreSQL database. Your goal is to get the app running without using a virtual environment or a local `moj.db` file.

-----

### Role Kit Selection (Strategy: Infrastructure Squad 🏗️)

This is an "Ops-heavy" assignment. We are splitting the infrastructure files among the team.

  * **`Repo Admin`:** (Config & Deps) Handles `requirements.txt` updates (adding Postgres support) and `config.py` changes.
  * **`Dev Crew (Systems)`:** (The Builder) Writes the `Dockerfile` to package the Python application.
  * **`Process Lead (Ops)`:** (The Orchestrator) Writes the `docker-compose.yml` to define the stack (App + DB).
  * **`QA Crew`:** (The Deployment Engineer) Responsible for the first successful launch, running database migrations *inside* the container, and verifying data persistence.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Branch Created & Dependencies Pushed (Repo Admin)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Dockerfile & Compose File Pushed (Dev & Process)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> "It's Alive\!" (Successful \<code\>docker-compose up\</code\>)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Persistence Verified (Data survives a restart)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> Docker Daemon isn't running / Build failed.\</li\> \</ul\> \</div\>

### Task Description: Containerizing the Stack

**Prerequisite:** Ensure **Docker Desktop** is running on your machine.

#### Phase 1: The Setup (Repo Admin)

1.  **Branch:** Pull `main` and create `ice15-docker`.
2.  **Update `requirements.txt`:** We need a library to talk to Postgres. Add this line:
    ```text
    psycopg2-binary
    ```
    *(Note: We use `-binary` for ease of installation in development)*.
3.  **Update `moj/config.py`:** Ensure your `SQLALCHEMY_DATABASE_URI` logic handles the Docker environment variable.
    ```python
    class Config:
        SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
        # This will grab the Postgres URL from docker-compose
        SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
            'sqlite:///' + os.path.join(basedir, 'moj.db')
    ```
4.  **Commit & Push.**

-----

#### Phase 2: The Infrastructure (Parallel Work)

**Sync:** Everyone pull the Repo Admin's changes. Then work in parallel.

**Task A: The `Dockerfile` (Dev Crew - Systems)**
Create a file named `Dockerfile` (no extension) in the project root.

```dockerfile
FROM python:3.10-slim

WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose the port Flask runs on
EXPOSE 5000

# Command to run the app (listening on all interfaces)
CMD ["flask", "run", "--host=0.0.0.0"]
```

**Task B: The `docker-compose.yml` (Process Lead - Ops)**
Create a file named `docker-compose.yml` in the project root.

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_APP=moj.py
      - FLASK_DEBUG=1
      - SECRET_KEY=docker-secret-key
      # Connect to the 'db' service using the credentials below
      - DATABASE_URL=postgresql://moj:password@db:5432/moj
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=moj
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=moj
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

**Commit & Push:** Both roles commit and push their files.

-----

#### Phase 3: The Launch (QA Crew & Team)

**Sync:** Everyone pull all changes. Now, the moment of truth.

1.  **Build & Run:** Run this command in your terminal:

    ```bash
    $ docker-compose up --build
    ```

    *Watch the logs. You will see Postgres starting, then Python installing dependencies, then Flask starting.*

2.  **Verify:** Go to `http://localhost:5000`.

      * You should see an **Internal Server Error** (or a database error).
      * **WHY?** Because we have a new database (Postgres), but it's empty\! We haven't run migrations yet.

3.  **Run Migrations (The "Ops" Task):**
    Open a **new** terminal tab (leave the logs running in the first one). Run the migration command *inside* the container:

    ```bash
    $ docker-compose exec web flask db upgrade
    ```

    *You should see the migration apply successfully.*

4.  **Verify Again:** Refresh `http://localhost:5000`. The app should load\!

5.  **Initialize Data:**

      * Register a new user.
      * Run the admin command *inside* the container:
        ```bash
        $ docker-compose exec web flask init-admin <your_username>
        ```
      * Log in and verify everything works.

-----

#### Phase 4: Testing Persistence (QA Crew)

Prove that we followed 12-Factor Rule IV correctly.

1.  **Stop the containers:** In the log terminal, hit `Ctrl+C` (or run `docker-compose down`).
2.  **Restart:** Run `docker-compose up`.
3.  **Check:** Go back to localhost. Log in.
      * **Pass:** Your user and data are still there (because of the `postgres_data` volume).
      * **Fail:** The database is empty (volume misconfiguration).

-----

#### Phase 5: Log & Submit (Repo Admin)

1.  **Log:** Fill out `CONTRIBUTIONS.md`.
2.  **Reflection:** Discussion point for the log: "Why did we have to use `--host=0.0.0.0` in the Dockerfile? What happens if we change the `POSTGRES_PASSWORD` in the compose file but not the `web` environment variables?"
3.  **Submit:** Push and open the PR.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 15: "Shipping Containers"
* **Date:** 2025-XX-XX
* **Roles:**
    * Repo Admin: `@github-userX`
    * Dev Crew (Systems): `@github-userY`
    * Process Lead (Ops): `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary:** [e.g., "Containerized the MoJ app. Created a Dockerfile and docker-compose.yml. Successfully migrated from SQLite to a persistent PostgreSQL container instance."]
* **Evidence:**
    * Screenshot of `docker ps` showing the `web` and `db` containers running.
    * Screenshot of the app running on localhost:5000.
```

# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



