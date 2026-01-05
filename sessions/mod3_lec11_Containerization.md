# content for lecture 11 on Containerization.

# **---- PROMPT ----**
```markdown

```

Here is the plan for **Lecture 11**, the kickoff for Cycle 3.

This lecture marks a major shift in the course. We move from "Application Development" (Python/Flask) to "DevOps & Systems" (Docker/Architecture). This is often the "aha\!" moment where students realize how professional software is actually shipped.

-----

### Lecture 11: "It Works on My Machine" (Containerization)

  * **Topic:** Docker, Docker Compose, and Production-Grade Databases
  * **Cycle 3:** Deployment & Services
  * **Time:** 30-35 minutes

-----

### \#\# Slide 1: Title Slide

  * **Topic:** Containerization & Orchestration
  * **Subtitle:** Solving "It Works on My Machine" with Docker.
  * **Course:** Software Engineering (Greenfield Development)

### \#\# Slide 2: Learning Objectives

  * By the end of this lecture, you will be able to:
      * **Explain** why "It works on my machine" is a dangerous engineering failure.
      * **Write** a `Dockerfile` to package our Flask app and its dependencies into a portable image.
      * **Write** a `docker-compose.yml` file to define our full application stack.
      * **Replace** our local SQLite file with a production-grade **PostgreSQL** container.
      * **Launch** the entire stack with a single command: `docker-compose up`.

### \#\# Slide 3: The "Why": The Matrix from Hell

  * **The Problem:**
      * Developer A uses Mac + Python 3.10.
      * Developer B uses Windows + Python 3.11.
      * Production Server uses Linux + Python 3.8.
  * **The Result:** "It works on my machine\!" 🤷‍♂️
      * Code fails in production because of a missing library or version mismatch.
      * Onboarding a new team member takes 3 days of installing stuff.
  * **The Solution:** We need a **Standard Shipping Container**.
    \*

[Image of cargo ship with containers]

```
* We don't ship "code"; we ship the *environment* the code runs in.
```

### \#\# Slide 4: Concept 1: The `Dockerfile`

  * **What is it?** A text file that contains the *instructions* to build our container.
  * **The Analogy:** It's a recipe.
      * "Start with a basic Linux system."
      * "Install Python."
      * "Copy our files in."
      * "Run the start command."
  * If you have this file, you can build the *exact same* environment anywhere, from a laptop to a massive cloud server.

### \#\# Slide 5: Worked Example 1: Writing the `Dockerfile`

  * **Speaker Note:** "This looks scary, but it's just the commands you've been running manually all semester\!"
  * **`Dockerfile` (in project root):**
    ```dockerfile
    # 1. Base Image: Start with a lightweight Python OS
    FROM python:3.10-slim

    # 2. Work Directory: Where do files go inside the container?
    WORKDIR /app

    # 3. Dependencies: Copy requirements and install
    # We do this *first* to use Docker's cache (makes builds faster)
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    # 4. App Code: Copy everything else
    COPY . .

    # 5. Command: How do we start?
    CMD ["flask", "run", "--host=0.0.0.0"]
    ```

### \#\# Slide 6: Concept 2: The "Stack" (Orchestration)

  * **The Problem:** Our app doesn't run alone. It needs a database.
      * So far, we've cheated with `sqlite` (a file).
      * Real apps use services like PostgreSQL, Redis, or ElasticSearch.
  * **The Tool:** **Docker Compose**.
  * We use a YAML file (`docker-compose.yml`) to define our **Services**.
      * Service 1: `web` (Our Flask App)
      * Service 2: `db` (Postgres Database)
  * Docker Compose creates a private **network** so these two can talk to each other.

### \#\# Slide 7: Worked Example 2: The `docker-compose.yml`

  * **`docker-compose.yml` (in project root):**
    ```yaml
    version: '3.8'

    services:
      # Service 1: Our App
      web:
        build: .  # Build from the Dockerfile in this folder
        ports:
          - "5000:5000" # Map container port 5000 to localhost:5000
        environment:
          - FLASK_DEBUG=1
          # Look! We point to the 'db' service by name!
          - DATABASE_URL=postgresql://moj:password@db:5432/moj
        depends_on:
          - db

      # Service 2: The Database
      db:
        image: postgres:15-alpine # Use an official image
        environment:
          - POSTGRES_USER=moj
          - POSTGRES_PASSWORD=password
          - POSTGRES_DB=moj
        volumes:
          - postgres_data:/var/lib/postgresql/data

    volumes:
      postgres_data: # Keep data persistent even if container dies
    ```

### \#\# Slide 8: The "Backing Service" Upgrade (12-Factor)

  * **Key Point:** Remember **12-Factor Rule IV (Backing Services)**? "Treat backing services as attached resources."
  * We are finally doing this\!
  * **Step 1:** We need a library to talk to Postgres.
      * Add `psycopg2-binary` to `requirements.txt`.
  * **Step 2:** We update our config to handle the new URL structure.
      * No code changes needed in `routes.py`\! SQLAlchemy handles the switch from SQLite to Postgres automatically based on the `DATABASE_URL`.

### \#\# Slide 9: The New Workflow

  * **OLD Workflow:**
    1.  `git pull`
    2.  `source venv/bin/activate`
    3.  `pip install -r requirements.txt` (Hope nothing breaks)
    4.  `flask db upgrade`
    5.  `flask run`
  * **NEW Workflow:**
    1.  `git pull`
    2.  `docker-compose up --build`
  * **That's it.** Docker downloads Postgres, builds your app, installs dependencies, creates the network, and launches everything.

### \#\# Slide 10: Common Pitfalls (The "Gotchas")

  * **1. `localhost` vs. `0.0.0.0`:**
      * Inside a container, `localhost` means "the container itself."
      * To let *us* (the outside host) see the app, Flask must listen on `0.0.0.0` (all interfaces).
  * **2. Persistence:**
      * Containers are **ephemeral** (disposable). If you delete the `db` container, your data is gone\!
      * **Fix:** We used a **Volume** (`postgres_data`) in our compose file. This saves the data to your hard drive, outside the container.

### \#\# Slide 11: Key Takeaways

  * **Docker** packages our Code + Runtime + OS into a single, portable unit.
  * **Docker Compose** lets us define a multi-container **stack** (App + DB).
  * We have upgraded from a "toy" database (SQLite) to a **production** database (PostgreSQL) simply by changing configuration.
  * We have achieved **Dev/Prod Parity** (12-Factor Rule X). Our local setup now mirrors a real deployment.

### \#\# Slide 12: Your Mission (ICE 15 & A15)

  * **ICE 15 (Today):**
      * **Containerize\!** You will create the `Dockerfile` and `docker-compose.yml`.
      * **Upgrade\!** You will switch from SQLite to Postgres.
      * **Launch\!** You will get the app running with `docker-compose up`.
  * **A15 (Homework):**
      * **The Deployment Spec.** You will extend your Docker setup.
      * You'll create a `.dockerignore` file (to keep images small).
      * You'll add a **Healthcheck** to your compose file (so the app waits for the DB to be ready).
      * You'll write a `entrypoint.sh` script to automatically run `flask db upgrade` every time the container starts.



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



