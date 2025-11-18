# Lecture 12: "Consuming Services" (The AI Integration)

  * **Topic:** Microservices, Docker Networking, and the `requests` library
  * **Cycle 3:** Deployment & Services
  * **Time:** 30-35 minutes

-----

## Slide 1: Title Slide

  * **Topic:** Consuming Services & Docker Networking
  * **Subtitle:** Integrating an "AI" Microservice into our stack.
  * **Course:** Software Engineering (Greenfield Development)

## Slide 2: Learning Objectives

  * By the end of this lecture, you will be able to:
      * **Define** "Microservices Architecture" vs. "Monolithic Architecture."
      * **Configure** Docker Compose to run multiple distinct services (`web`, `db`, `ai`).
      * **Utilize** Docker's internal DNS to communicate between containers by name.
      * **Use** the Python `requests` library to consume an internal HTTP API.
      * **Implement** a feature where your app sends data to another service and saves the response.

## Slide 3: The "Why": The Monolith is Lonely

  * **Current State:** We have a **Monolith**. Our Flask app does everything (auth, database, logic, HTML).
  * **The Problem:** Some tasks are too heavy, too specialized, or written in different languages.
      * *Example:* We want an AI to rate our jokes. Running a Neural Network inside our web process will slow down the website for everyone.
  * **The Solution:** **Microservices**.
      * We spin up a *separate* container dedicated to the AI logic.
      * Our Web App sends the joke to the AI App.
      * The AI App does the heavy lifting and replies with the result.

## Slide 4: Architecture Diagram

  * 
  * **The Network:** Docker Compose creates a private "virtual WiFi" for our containers.
  * **Service Discovery:**
      * Our Web container doesn't need to know IP addresses.
      * It just talks to `http://ai-service:5000`.
      * Docker magically routes this request to the right container.

## Slide 5: The "AI" Service (The Black Box)

  * For this lecture, we (the instructors) have built a container image for you: `registry.example.com/moj-ai-rater:latest`.
  * **It is a "Black Box":** You don't need to see its code. You only need its **API Contract**.
  * **The Contract:**
      * **Endpoint:** `POST /rate_joke`
      * **Input JSON:** `{"body": "Why did the chicken cross the road?"}`
      * **Output JSON:** `{"rating": "G-Rated", "score": 3}`

## Slide 6: Worked Example 1: Updating the Stack

  * **Step 1:** We add the new service to `docker-compose.yml`.
    ```yaml
    services:
      web:
        # ... (existing config) ...
        environment:
          - AI_SERVICE_URL=http://ai-service:5000 # <--- Configuration!
        depends_on:
          - db
          - ai-service

      db:
        # ... (existing config) ...

      # NEW SERVICE
      ai-service:
        image: pkimber/moj-ai-rater:latest # Pre-built image
        ports:
          - "5001:5000" # Expose on localhost:5001 for debugging
    ```
  * **Speaker Note:** "Notice `AI_SERVICE_URL`. We inject the location of the service as configuration (12-Factor Rule III)."

## Slide 7: Concept: The `requests` Library

  * How does Python make a web request?
  * We use the industry-standard library: `requests`.
    ```bash
    (venv) $ pip install requests
    ```
  * **Syntax:**
    ```python
    import requests

    response = requests.post("http://google.com", json={'data': 123})
    print(response.status_code) # 200
    print(response.json())      # {'result': ...}
    ```
  * It's exactly like using Postman, but in code.

## Slide 8: Worked Example 2: Consuming the Service

  * **Scenario:** When a user submits a joke, we want to ask the AI for a rating *before* we save it.
  * **File:** `moj/routes.py` (inside `create_joke`)
    ```python
    import requests
    import os

    # ... inside create_joke ...
    if form.validate_on_submit():
        # 1. Get the service URL from config
        ai_url = os.environ.get('AI_SERVICE_URL')

        # 2. Call the AI (Synchronous call)
        try:
            api_resp = requests.post(
                f"{ai_url}/rate_joke",
                json={'body': form.body.data},
                timeout=2 # Always set a timeout!
            )
            ai_data = api_resp.json() # e.g. {"rating": "G", "score": 3}
            
            # 3. Use the data
            flash(f"AI says this joke is {ai_data['rating']}!", "info")
            
        except requests.exceptions.RequestException:
            flash("AI Service is down, but joke saved.", "warning")

        # 4. Save joke to DB...
    ```

## Slide 9: Defensive Coding (What if it fails?)

  * **Key Point:** Distributed systems are **unreliable**. The AI service might be crashed, busy, or the network might glitch.
  * **Rule 1:** Always use a `timeout=2` (seconds). Never let your user hang forever waiting for a background service.
  * **Rule 2:** Handle exceptions (`try/except`). If the AI fails, our app should *not* crash (500 Error). It should degrade gracefully (save the joke, maybe warn the user).

## Slide 10: Key Takeaways

  * **Microservices** allow us to break complex apps into specialized containers.
  * **Docker Compose** creates a private network where services communicate by name (`http://ai-service`).
  * We use the **`requests`** library to consume HTTP APIs from other services.
  * We must code **defensively**: use timeouts and try/except blocks because networks are unreliable.

## Slide 11: Your Mission (ICE 16 & A16)

  * **ICE 16 (Today):**
      * **Update Infrastructure:** Add the `ai-service` to your `docker-compose.yml`.
      * **Connect:** Use `requests` in your `create_joke` route to fetch the AI rating.
      * **Display:** Flash the AI's rating to the user.
  * **A16 (Homework):**
      * **Persist the AI Data.**
      * Currently, we just `flash()` the AI rating. Your homework is to update the `Joke` model to store this data permanently (`ai_score`, `ai_rating`) so we can display it on the profile page forever.
