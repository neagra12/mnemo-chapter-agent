# Lecture 13: "Exposing Services" (The API-First App)

  * **Topic:** REST APIs, Flask `jsonify`, and Frontend Decoupling
  * **Cycle 3:** Deployment & Services
  * **Time:** 30-35 minutes

-----

## \#\# Slide 1: Title Slide 🌐

  * **Topic:** Exposing Services (The API-First App)
  * **Subtitle:** Decoupling the Frontend and Backend
  * **Course:** Software Engineering (Greenfield Development)

-----

## \#\# Slide 2: Learning Objectives

  * By the end of this lecture, you will be able to:
      * **Explain** the difference between a traditional Monolith and an API-First architecture.
      * **Build** a dedicated API endpoint using Flask's `jsonify` utility.
      * **Apply** basic REST principles to define resource endpoints (e.g., GET `/api/jokes`).
      * **Identify** and resolve the **Cross-Origin Resource Sharing (CORS)** problem.
      * **Understand** how a separate frontend (React/JS) consumes your Flask API.

-----

## \#\# Slide 3: The Architectural Shift: Monolith vs. API-First

  * **Monolith (Current State):** Our app is a monolith. The backend (Flask) handles the data *and* renders the HTML (`render_template`). The frontend and backend are tightly coupled.
      * *User asks for `/` -\> Flask queries DB -\> Flask builds HTML -\> Flask sends HTML.*
  * **API-First (New Goal):** We want a **decoupled** architecture.
      * The **Backend (Flask)** only handles data and returns JSON.
      * The **Frontend (React/JS)** handles the UI and makes API calls to get the data.
      * This is essential for mobile apps, external partners, or specialized web UIs.

-----

## \#\# Slide 4: Building the API Endpoint with `jsonify`

  * Instead of returning the output of `render_template()`, we return JSON data.

<!-- end list -->

```python
from flask import jsonify # <-- NEW IMPORT

@app.route('/api/jokes', methods=['GET'])
def api_jokes():
    # 1. Query the data
    jokes = Joke.query.order_by(Joke.timestamp.desc()).all()
    
    # 2. Convert complex objects to Python dictionaries
    jokes_list = []
    for joke in jokes:
        jokes_list.append({
            'id': joke.id,
            'body': joke.body,
            'timestamp': joke.timestamp.isoformat(),
            'author_username': joke.author.username
        })
        
    # 3. Use jsonify to send it as a JSON response
    return jsonify({'jokes': jokes_list, 'count': len(jokes_list)})

# Test this route with Postman or your browser!
```

-----

## \#\# Slide 5: The "Gotcha": CORS (Cross-Origin Resource Sharing)

  * **The Problem:** Your Flask API is running on `http://localhost:5000`. Your simple React frontend might be running on `http://localhost:3000`.
  * **The Browser Security Rule:** Browsers **block** JavaScript from making requests from one domain (origin: 3000) to another domain (origin: 5000) unless the server explicitly allows it.
  * **The Solution:** We must tell Flask, "It's okay for applications on other domains to talk to me."
  * **The Tool:** We use the `flask-cors` extension.

<!-- end list -->

```bash
(venv) $ pip install flask-cors
```

## \#\# Slide 6: Implementing CORS

  * **File:** `moj/__init__.py` (or wherever your app is initialized)

<!-- end list -->

```python
from flask_cors import CORS # <-- NEW IMPORT

# ... (rest of your imports) ...

app = Flask(__name__)
# Initialize the CORS extension
# Allows all origins (*) to access all routes
CORS(app) 

# ... (rest of the app initialization) ...
```

  * **Speaker Note:** For production, you would replace `*` with the exact domain of your React application (e.g., `CORS(app, origins="https://my-react-app.com")`).

-----

## \#\# Slide 7: The Frontend Consumer (Conceptual)

  * The frontend (written in JavaScript/React) simply uses the built-in `fetch` API to get the data.

<!-- end list -->

```javascript
// --- Code running in the browser on http://localhost:3000 ---

async function fetchJokes() {
    const response = await fetch('http://localhost:5000/api/jokes');
    
    // Check for success
    if (!response.ok) {
        throw new Error('Failed to fetch jokes');
    }
    
    const data = await response.json();
    console.log("Received Joke Count:", data.count);
    
    // RENDER data.jokes to the user interface
}
```

  * This completes the picture: the backend is pure JSON, and the frontend is pure UI.

-----

## \#\# Slide 8: Key Takeaways

  * Moving to an API-First architecture requires the backend to return **JSON** (via `jsonify`) instead of HTML.
  * We use **REST** principles to define clean, resource-based endpoints (e.g., `/api/jokes`).
  * **CORS** is a browser security measure that must be addressed, typically using the `flask-cors` extension in development.
  * This decoupling sets the stage for any frontend technology—web, mobile, or even external services—to consume your data.

-----

## \#\# Slide 9: Your Mission (ICE 17 & A17)

  * **ICE 17 (Today):**
      * **Install** `flask-cors`.
      * **Create** the `/api/jokes` endpoint.
      * **Test** it using a separate tool (browser/Postman) to verify the JSON output.
  * **A17 (Homework):**
      * **Integrate** a simple pre-built React frontend (which we will provide the starter code for) to consume your new `/api/jokes` endpoint and display the data.
