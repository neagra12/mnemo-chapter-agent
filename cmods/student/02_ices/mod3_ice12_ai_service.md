# ICE 16: "The AI Rater" (Microservices)

  * **Objective:** Extend your Docker stack to include a second service (the "AI Rater"), and write code to consume its API from your Flask app.
  * **Time Limit:** 45 minutes
  * **Context:** In the lecture, we learned about Microservices and Docker networking. Now we will implement it. You will spin up a pre-made "AI" container and wire your Flask app to send new jokes to it for evaluation.

-----

## Role Kit Selection (Strategy: The Integration Squad 🔌)

This is a cross-service integration task.

  * **`Repo Admin`:** (Dependencies & Config) Adds the `requests` library and configures the environment variables.
  * **`Process Lead (Ops)`:** (Infrastructure) Updates `docker-compose.yml` to add the new `ai-service` container.
  * **`Dev Crew (Backend)`:** (Integration Logic) Modifies the `create_joke` route to call the AI service using `requests`.
  * **`QA Crew`:** (Verification) Verifies the integration by running the full stack and checking the logs.



## Task Description: Calling the "Black Box"

**Prerequisite:** You must have a working Docker setup from ICE 15.

### Phase 1: Dependencies (Repo Admin)

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

### Phase 2: The Mock AI Service (Process Lead - Ops)
1. **Create Service Driectory:** Create a new folder named `ai-service/` in your project root.
2. Create the `ai-service/ai_rater.py` program file with the following content:
   ```python
   import os
   import time
   import random
   from flask import Flask, request, jsonify

   # Flask application setup
   app = Flask(__name__)

   # Define the possible, random ratings
   POSSIBLE_SCORES = list(range(1, 6)) # [1, 2, 3, 4, 5]
   POSSIBLE_RATINGS = ["G", "PG", "NSFW"]

   # Mock AI Service: The Black Box
   @app.route('/rate_joke', methods=['POST'])
   def rate_joke():
       """
       Mocks an AI service call. It expects a JSON body with a 'joke_text' field
       and returns a random rating and score for the joke.
       """
       
       # 1. Enforce content type
       if not request.is_json:
           # 400 Bad Request
           return jsonify({"error": "Request must contain JSON payload."}), 400

       data = request.get_json()
       joke_text = data.get('joke_text', 'No joke provided')

       # Simulate network/processing latency to be more realistic
       time.sleep(0.05) 

       # --- NEW RANDOM LOGIC ---
       # Randomly select a score (1-5) and a rating (G, PG, NSFW)
       random_score = random.choice(POSSIBLE_SCORES)
       random_rating = random.choice(POSSIBLE_RATINGS)
       # -------------------------

       # Log the request details for debugging in the Docker logs
       print(f"--- Mock AI Service received request from client ---")
       print(f"--- Joke: '{joke_text[:75]}{'...' if len(joke_text) > 75 else ''}'")

       # 2. Mock AI Logic: Return a consistent result for deterministic testing
       mock_rating = {
           "score": random_score,  # Random 1-5
           "rating": random_rating, # Random G, PG, or NSFW (new key: 'rating')
           "analysis": f"AI decided: Score {random_score} and Rating {random_rating}. Integration successful!"
       }

       # 3. Return the rating as JSON
       # 200 OK
       return jsonify(mock_rating), 200

   # The service runs on port 5001 internally. 
   # Docker Compose will map this to the service name 'ai-service' for inter-container communication.
   if __name__ == '__main__':
       # Use 0.0.0.0 for access within the Docker network
       app.run(debug=False, host='0.0.0.0', port=5002)
    ```
3. Create the Dockerfile for the ai-service:
   ```Dockerfile
   # Use a minimal Python image for a small, fast container
   FROM python:3.11-slim

   # Set non-root user to improve security
   # This is a good practice for production images
   ARG USERNAME=appuser
   RUN useradd -m ${USERNAME}
   USER ${USERNAME}

   # Set the working directory inside the container
   WORKDIR /home/${USERNAME}/app

   # Copy the requirements file and install dependencies
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt

   # Copy the application code
   COPY app.py .

   # The Flask app is configured to run on port 5001 internally
   EXPOSE 5002

   # Command to run the application
   # Use the correct internal port
   CMD ["python", "app.py"]
   ```
4. Modify the moj/config.py file to add the line:
   ```python
   AI_SERVICE_URL = os.environ.get('AI_SERVICE_URL')
   ```
5. Copy the requirements.txt file from the root of your repo to the ai-service directory. We will build the mock ai service with the same requirements as our web service. This is an expedience since this is just a mock service.
6. Commit and push the changes.

-----

### Phase 2: The Infrastructure (Dev Crew - Ops)

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
          - AI_SERVICE_URL=http://ai-service:5001
        depends_on:
          - db
          - ai-service # Wait for AI to start

      # ... (keep db service) ...

      # NEW SERVICE definition
      ai-service:
        build: ./ai-service  # <-- Build from the local folder
        ports:
          - "5001:5002" # Map 5000 inside to 5001 outside (for debugging)
    ```

3.  **Commit & Push.**

-----

### Phase 3: The Integration Logic (Dev Crew - Backend)

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

### Phase 4: The Integration Test (QA Crew & Team)

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

### Phase 5: Log & Submit (Repo Admin)

1.  **Log:** Fill out `CONTRIBUTIONS.md`.
2.  **Reflection:** "We used the hostname `http://ai-service:5000`. How did our Flask container know that `ai-service` meant that specific IP address? (Hint: Docker DNS)."
3.  **Submit:** Push and open the PR.

-----

## `CONTRIBUTIONS.md` Log Entry

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