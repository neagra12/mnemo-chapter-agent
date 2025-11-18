# Session for ICE 12 - Service Consumer (ingtegrating an AI)

# **---- PROMPT ----**
```markdown

```

Here is the In-Class Exercise for Module 3, Lecture 12.

-----

### ICE 16: "The AI Rater" (Microservices)

  * **Objective:** Extend your Docker stack to include a second service (the "AI Rater"), and write code to consume its API from your Flask app.
  * **Time Limit:** 45 minutes
  * **Context:** In the lecture, we learned about Microservices and Docker networking. Now we will implement it. You will spin up a pre-made "AI" container and wire your Flask app to send new jokes to it for evaluation.

-----

### Role Kit Selection (Strategy: The Integration Squad 🔌)

This is a cross-service integration task.

  * **`Repo Admin`:** (Dependencies & Config) Adds the `requests` library and configures the environment variables.
  * **`Process Lead (Ops)`:** (Infrastructure) Updates `docker-compose.yml` to add the new `ai-service` container.
  * **`Dev Crew (Backend)`:** (Integration Logic) Modifies the `create_joke` route to call the AI service using `requests`.
  * **`QA Crew`:** (Verification) Verifies the integration by running the full stack and checking the logs.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Dependencies & Config Pushed (Repo Admin)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Docker Compose Updated (Ops)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Route Logic Updated (Dev Crew)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> "AI says..." message appears on screen (Success\!)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> Connection Refused / Docker Networking Error.\</li\> \</ul\> \</div\>

### Task Description: Calling the "Black Box"

**Prerequisite:** You must have a working Docker setup from ICE 15.

#### Phase 1: Dependencies (Repo Admin)

1.  **Branch:** Pull `main` and create `ice16-microservices`.
2.  **Update `requirements.txt`:** Add the library we use for HTTP requests.
    ```text
    requests
    ```
3.  **Update `moj/config.py`:** Add the configuration for the AI URL.
    ```python
    class Config:
        # ... existing config ...
        # Default to localhost for testing without docker, but override in prod
        AI_SERVICE_URL = os.environ.get('AI_SERVICE_URL') or 'http://localhost:5001'
    ```
4.  **Commit & Push.**

-----

#### Phase 2: The Infrastructure (Process Lead - Ops)

Your job is to add the new container to the "private network."

1.  **Pull:** Get the Repo Admin's changes.

2.  **Edit `docker-compose.yml`:**

      * **Add** the `ai-service` definition.
      * **Update** the `web` service to know about it.

    <!-- end list -->

    ```yaml
    services:
      web:
        # ... (keep existing build/ports) ...
        environment:
          - FLASK_APP=moj.py
          - FLASK_DEBUG=1
          - DATABASE_URL=postgresql://moj:password@db:5432/moj
          # NEW: Tell Flask where the AI lives (by service name!)
          - AI_SERVICE_URL=http://ai-service:5000
        depends_on:
          - db
          - ai-service # Wait for AI to start

      # ... (keep db service) ...

      # NEW SERVICE definition
      ai-service:
        image: pkimber/moj-ai-rater:latest
        ports:
          - "5001:5000" # Map 5000 inside to 5001 outside (for debugging)
    ```

3.  **Commit & Push.**

-----

#### Phase 3: The Integration Logic (Dev Crew - Backend)

Your job is to make the phone call.

1.  **Pull:** Get the latest changes.

2.  **Edit `moj/routes.py`:**

      * Import `requests` and `os` at the top.
      * Modify `create_joke`.

    <!-- end list -->

    ```python
    import requests # <-- Add this
    # ...

    @app.route('/create_joke', methods=['GET', 'POST'])
    @login_required
    def create_joke():
        form = JokeForm()
        if form.validate_on_submit():
            # 1. Call the AI Service
            ai_url = app.config['AI_SERVICE_URL']
            try:
                # Send the joke text to the AI
                response = requests.post(
                    f"{ai_url}/rate_joke",
                    json={'body': form.body.data},
                    timeout=2 # Don't hang forever!
                )
                data = response.json() # e.g. {'rating': 'Dad Joke', 'score': 2}
                
                # 2. Just Flash it (for now)
                flash(f"AI Analysis: {data.get('rating')} (Score: {data.get('score')})", "info")
                
            except requests.exceptions.RequestException:
                flash("AI Service invalid or down.", "warning")

            # 3. Standard Save Logic (Unchanged)
            joke = Joke(body=form.body.data, author=current_user)
            db.session.add(joke)
            # ... (commit and redirect)
    ```

3.  **Commit & Push.**

-----

#### Phase 4: The Integration Test (QA Crew & Team)

**Sync:** Everyone pull all changes.

1.  **Rebuild:** Since we changed `requirements.txt` and `docker-compose.yml`, we must rebuild.
    ```bash
    $ docker-compose up --build
    ```
2.  **Watch Logs:** You should see `ai-service_1` starting up alongside `web` and `db`.
3.  **Test:**
      * Go to `http://localhost:5000`.
      * Log in.
      * **Create a Joke:** Type "Why did the chicken cross the road? To get to the other side."
      * **Submit.**
4.  **Verify:**
      * Did the page reload?
      * **Did you see a Flash message?** It should say something like: *"AI Analysis: Classic (Score: 3)"* (or whatever the mock AI returns).
      * If yes, your containers are talking to each other\!

-----

#### Phase 5: Log & Submit (Repo Admin)

1.  **Log:** Fill out `CONTRIBUTIONS.md`.
2.  **Reflection:** "We used the hostname `http://ai-service:5000`. How did our Flask container know that `ai-service` meant that specific IP address? (Hint: Docker DNS)."
3.  **Submit:** Push and open the PR.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 16: "The AI Rater"
* **Date:** 2025-XX-XX
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead (Ops): `@github-userY`
    * Dev Crew (Backend): `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary:** [e.g., "Added the 'ai-service' container to our stack. Updated routes.py to send new jokes to the AI service via HTTP POST. Successfully verified that the AI returns a rating flash message."]
* **Evidence:**
    * Screenshot of the "AI Analysis" flash message on the website.
```

# **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



## **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



#