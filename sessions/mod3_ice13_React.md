# Session for ICE 13 - Integrating React

# **---- PROMPT ----**
```markdown

```

Here is the In-Class Exercise for Module 3, Lecture 13.

-----

### ICE 17: "The API Blueprint" (Exposing Services)

  * **Objective:** Transform a portion of our backend into an API service by creating a JSON endpoint and enabling Cross-Origin Resource Sharing (CORS).
  * **Time Limit:** 45 minutes
  * **Context:** We are moving toward a decoupled architecture. Your goal is to expose our joke data via a clean REST API, which will be consumed by a separate frontend app in the homework.

-----

### Role Kit Selection (Strategy: API Team 💻)

This task requires cross-cutting changes to dependencies, core logic, and configuration.

  * **`Repo Admin`:** (Dependencies) Installs the necessary library (`flask-cors`).
  * **`Process Lead`:** (Configuration) Initializes and configures the CORS extension.
  * **`Dev Crew (API)`:** (Logic) Creates the new API endpoint using `jsonify` and ensures proper data serialization.
  * **`QA Crew`:** (API Tester) Verifies the output format and validates the presence of CORS headers.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Dependencies Installed (Repo Admin)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> API Endpoint Functional (Dev Crew)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> CORS Enabled (Process Lead)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> JSON output is valid (Success\!)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> 404 Error on \<code\>/api/jokes\</code\> OR Browser CORS Error.\</li\> \</ul\> \</div\>

### Task Description: Creating the `/api/jokes` Endpoint

**Prerequisite:** You must have a working Docker stack running from A16.

#### Phase 1: Setup & Dependencies (Repo Admin & Process Lead)

1.  **Branch:** Pull `main` and create `ice17-api-cors`.
2.  **Install CORS:** The `Repo Admin` must add `flask-cors` to `requirements.txt`.
3.  **Rebuild Container:** Run `docker-compose up --build` to install the new dependency inside the container.
4.  **Configure CORS:** The `Process Lead` must open `moj/__init__.py` and initialize the CORS extension.
    ```python
    from flask import Flask
    from flask_cors import CORS # <-- Add this

    def create_app(config_class=Config):
        app = Flask(__name__)
        app.config.from_object(config_class)
        
        # Enable CORS for all routes and all origins (*)
        CORS(app) # <--- Add this line
        
        # ... rest of init
        return app
    ```
5.  **Commit & Push.**

-----

#### Phase 2: The API Logic (Dev Crew - API)

Your job is to create the new endpoint.

1.  **Pull:** Get the latest changes.

2.  **Edit `moj/routes.py`:** Create a new route that does the following:

      * Queries all jokes (`Joke.query.order_by...`).
      * Loops through the results, converting each SQLAlchemy object into a Python dictionary.
      * Returns the final list wrapped in a `jsonify` response.

    <!-- end list -->

    ```python
    from flask import render_template, flash, redirect, url_for, request, jsonify # <-- Add jsonify

    # ... other routes ...

    @app.route('/api/jokes', methods=['GET'])
    def api_jokes():
        jokes = Joke.query.order_by(Joke.timestamp.desc()).all()
        
        jokes_list = []
        for joke in jokes:
            jokes_list.append({
                'id': joke.id,
                'body': joke.body,
                'timestamp': joke.timestamp.isoformat() if joke.timestamp else None,
                'author_username': joke.author.username,
                'ai_rating': joke.ai_rating
                # NOTE: Only expose data you want the public to see!
            })
            
        return jsonify({'jokes': jokes_list, 'count': len(jokes_list)})
    ```

3.  **Commit & Push.**

-----

#### Phase 3: Verification (QA Crew & Team)

**Sync:** Everyone pull all changes. Ensure Docker is up and running.

1.  **Test Output:** Open your web browser and navigate to `http://localhost:5000/api/jokes`.

      * **Pass:** You should see a page full of perfectly formatted, nested JSON data. If you see HTML, the code failed\!
      * **Fail:** If you see a 404, check the route decorator and URL spelling.

2.  **Test CORS (Optional but valuable):** If you use a tool like Postman or the browser's developer tools (Network tab):

      * **Check the Headers:** When you make the request to `http://localhost:5000/api/jokes`, look at the **Response Headers**.
      * **Pass:** The header `Access-Control-Allow-Origin: *` should be present. This proves that cross-origin access is enabled.

-----

#### Phase 4: Log & Submit (Repo Admin)

1.  **Log:** Fill out `CONTRIBUTIONS.md`.
2.  **Reflection:** "Why did we have to manually loop through the `Joke` objects to build a dictionary? Why can't Flask `jsonify` the entire list of `Joke` objects directly?"
3.  **Submit:** Push and open the PR.

-----

### `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 17: "The API Blueprint"
* **Date:** 2025-XX-XX
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew (API): `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary:** [e.g., "Created the /api/jokes endpoint returning a list of jokes as JSON. Installed and configured flask-cors to allow external access."]
* **Evidence:**
    * Screenshot of the browser displaying the JSON output from /api/jokes.
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