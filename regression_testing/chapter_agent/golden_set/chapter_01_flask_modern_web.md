# Chapter 1: Flask & The Modern Web

- **Course:** Software Engineering (P465/P565)
- **Audience:** Upper-level undergraduates and Master's students
- **Prerequisites:** Python (functions, modules, decorators), basic Git, command-line fluency
- **Estimated Reading Time:** 50–60 minutes
- **Difficulty:** Foundational
- **Chapter Type:** Applied / Mixed

---

## Learning Objectives

By the end of this chapter, you will be able to:

1. **Explain** the role of a web framework and describe how HTTP request-response cycles work at a conceptual level.
2. **Set up** a Flask development environment and run a minimal working web application from scratch.
3. **Implement** URL routing, dynamic route parameters, and basic templating using Jinja2.
4. **Distinguish** between Flask's development server and a production-ready deployment, and articulate why that distinction matters.
5. **Evaluate** when a microframework like Flask is an appropriate tool choice versus a full-stack framework like Django.

---

## The Hook

Imagine you've just finished building a machine learning model that predicts hospital readmission risk with 89% accuracy. The model runs perfectly on your laptop. Your stakeholders — nurses, administrators, case managers — need to use it. They don't have Python installed. They don't know what a terminal is. They need a button.

This is the gap Flask fills. It is the layer between the logic you write and the humans who need to use it. Every time you type a URL into a browser, press a form button, or tap a mobile app, an HTTP request travels across a network and lands on a server running code that looks, in its simplest form, almost exactly like a Flask application. Understanding how that machinery works is not optional background knowledge for a software engineer — it is the foundation on which every web-facing system you will ever build is constructed.

Flask was designed on the premise that a web framework should start small and grow with your needs. Before we add databases, authentication, and deployment pipelines, we are going to understand the skeleton: what a request is, how a server responds to it, and how Flask maps one to the other.

---

## Core Content

### 4a. Concept Introduction — The Worked Example

#### The HTTP Request-Response Cycle

Every web interaction follows the same basic pattern:

```
[Browser / Client]  →  HTTP Request  →  [Server]
[Server]            →  HTTP Response →  [Browser / Client]
```

An HTTP request carries four essential pieces of information:
- **Method** — what action is requested (`GET`, `POST`, `PUT`, `DELETE`)
- **Path** — which resource is being requested (e.g., `/users/42`)
- **Headers** — metadata (content type, authentication tokens, browser info)
- **Body** — optional payload (form data, JSON)

The server processes the request and returns an HTTP response with:
- **Status code** — `200 OK`, `404 Not Found`, `500 Internal Server Error`, etc.
- **Headers** — metadata about the response
- **Body** — the actual content (HTML, JSON, a file)

Flask's job is to sit on the server side and decide: *given this incoming request, what code runs, and what response goes back?*

---

#### Setting Up Flask

First, create a clean project directory and a virtual environment. Using virtual environments is not optional — it is the minimum professional standard for Python project hygiene.

```bash
mkdir flask-intro && cd flask-intro
python -m venv venv
source venv/bin/activate          # On Windows: venv\Scripts\activate
pip install flask
```

Verify installation:

```bash
python -c "import flask; print(flask.__version__)"
```

---

#### A Minimal Flask Application

Create a file named `app.py`:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "<h1>Hello, Software Engineering.</h1>"

if __name__ == "__main__":
    app.run(debug=True)
```

Run it:

```bash
python app.py
```

Open `http://127.0.0.1:5000` in your browser. You should see your heading.

**Let's unpack every line:**

| Line | What it does |
|---|---|
| `from flask import Flask` | Imports the Flask class from the flask package |
| `app = Flask(__name__)` | Creates an application instance; `__name__` tells Flask where to find resources |
| `@app.route("/")` | A **decorator** that registers the function below as the handler for `GET /` |
| `def index():` | The **view function** — called when a matching request arrives |
| `return "<h1>...</h1>"` | The response body; Flask wraps this in a `200 OK` HTTP response automatically |
| `app.run(debug=True)` | Starts Flask's built-in development server with auto-reload and error pages |

The decorator `@app.route("/")` is doing something precise: it is registering a mapping between the URL path `"/"` and the function `index` in a data structure Flask calls the **URL map**. When a request arrives, Flask looks up the path in the URL map and calls the associated function. The return value of that function becomes the response body.

---

#### Dynamic Routes

Most useful URLs carry data. Flask handles this with route parameters:

```python
@app.route("/user/<username>")
def user_profile(username):
    return f"<p>Profile page for: {username}</p>"

@app.route("/item/<int:item_id>")
def get_item(item_id):
    return f"<p>Fetching item number {item_id}</p>"
```

The angle-bracket syntax `<username>` tells Flask to capture that segment of the URL and pass it as a keyword argument to the view function. The optional type converter `<int:item_id>` ensures Flask only matches routes where that segment is a valid integer — any other value returns a `404` automatically.

Try navigating to `/user/maria` and `/item/7` to verify both work.

---

#### Jinja2 Templating

Returning raw HTML strings from Python functions does not scale. Flask ships with **Jinja2**, a templating engine that separates your HTML structure from your Python logic.

**Project structure:**

```
flask-intro/
├── app.py
└── templates/
    └── profile.html
```

`templates/profile.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head><title>{{ username }}'s Profile</title></head>
<body>
  <h1>Welcome, {{ username }}!</h1>
  {% if is_admin %}
    <p><strong>Admin privileges active.</strong></p>
  {% else %}
    <p>Standard user account.</p>
  {% endif %}
</body>
</html>
```

`app.py` — updated view function:

```python
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/user/<username>")
def user_profile(username):
    admin_users = ["alice", "bob"]
    return render_template(
        "profile.html",
        username=username,
        is_admin=(username in admin_users)
    )
```

`render_template` finds `profile.html` in the `templates/` directory, injects the variables, renders the result to a string, and returns it as the response body. The `{{ }}` syntax outputs a value; `{% %}` syntax runs control logic (conditionals, loops).

This separation — logic in Python, structure in HTML — is the foundation of the **MVC (Model-View-Controller)** pattern you will use throughout this course.

---

### 4b. Guided Practice — Fill-in-the-Blank

You are building a simple course catalog application. A starter `app.py` and a template skeleton are provided below. Your task is to fill in the marked sections.

**`app.py` (starter):**

```python
from flask import Flask, render_template

app = Flask(__name__)

COURSES = [
    {"id": 1, "name": "Software Engineering", "credits": 3},
    {"id": 2, "name": "Operating Systems",   "credits": 3},
    {"id": 3, "name": "Machine Learning",    "credits": 4},
]

@app.route("/")
def catalog():
    # [YOUR TASK 1]: Pass the COURSES list to the template "catalog.html"
    # using render_template. The template expects a variable named "courses".
    pass

@app.route("/course/<int:course_id>")
def course_detail(course_id):
    # [YOUR TASK 2]: Find the course in COURSES whose "id" matches course_id.
    # If found, render "detail.html" passing the matched course dict.
    # If not found, return the string "Course not found", with HTTP status 404.
    # Hint: Flask lets you return a tuple: return "message", 404
    pass

if __name__ == "__main__":
    app.run(debug=True)
```

**`templates/catalog.html` (starter):**

```html
<!DOCTYPE html>
<html><body>
  <h1>Course Catalog</h1>
  <ul>
    <!-- [YOUR TASK 3]: Use a Jinja2 for-loop to render each course name as a list item.
         Each item should link to /course/<id> using the course's id.
         Example output: <li><a href="/course/1">Software Engineering</a></li>  -->
  </ul>
</body></html>
```

**`templates/detail.html` (starter):**

```html
<!DOCTYPE html>
<html><body>
  <!-- [YOUR TASK 4]: Display the course name as an <h1> and its credit hours as a paragraph. -->
</body></html>
```

---

### 4c. Independent Application — Open Challenge

You will build a small **student grade tracker** as a standalone Flask application. The requirements:

1. A home route (`/`) that displays a list of student names, each linking to their individual page.
2. A dynamic route (`/student/<name>`) that displays the student's name and their list of assignment grades.
3. A computed summary on each student's page showing their average grade, and a label of "Pass" (average ≥ 60) or "Fail" (average < 60).
4. At least one Jinja2 template that uses both a for-loop and a conditional.
5. All student data must be stored as a Python data structure in `app.py` — no database required yet.

You decide the data structure, the template design, and the URL scheme beyond the two required routes. There is no single correct solution.

**Optional hints (read only if stuck):**
> **Hint 1:** A list of dictionaries — one per student — is a clean way to store this data. Each dictionary might have keys like `"name"` and `"grades"` (a list of numbers).
>
> **Hint 2:** Jinja2 can call some Python built-ins. `{{ grades | sum }}` and `{{ grades | length }}` are available as Jinja2 filters. Alternatively, compute the average in Python and pass it to the template directly.

---

## Historical Context

Flask was created by **Armin Ronacher** and released in 2010, originally as an April Fool's joke — a "microframework" that was deliberately minimal compared to the then-dominant Django. The joke landed because it actually worked. The underlying insight was that Django, while powerful, bundled in an ORM, an admin interface, a form library, and a templating engine whether you needed them or not. Flask's design philosophy — sometimes called "Werkzeug + Jinja2 + good intentions" — was that a framework should provide routing and request handling and get out of the way for everything else. That philosophy resonated with developers building APIs, data dashboards, and research prototypes who did not need or want Django's full stack. Flask has since become one of the most widely deployed Python web frameworks in production systems worldwide.

---

## Ethical Consideration

> **Ethical Reflection ✍️**
> Flask's `debug=True` mode exposes an interactive Python console in the browser whenever an unhandled exception occurs. This console can execute arbitrary code on your server. During development you will almost certainly forget to turn this off before sharing a link. Beyond this specific flag: when you build a web application, you are creating a publicly accessible interface to a computer system. Who is responsible when that system is exploited because a developer left a default setting in place — the developer, their employer, the framework authors who made the dangerous default easy to reach, or the user who discovered and used the vulnerability? How does your answer change depending on whether the application handles medical records versus a personal hobby project?

---

## Chapter Summary

- HTTP is a request-response protocol; every web interaction consists of a client sending a request (method + path + headers + optional body) and a server returning a response (status code + headers + body).
- Flask maps incoming URL paths to Python functions using the `@app.route()` decorator, building a URL map at application startup.
- Dynamic route parameters (`<variable>` and `<type:variable>`) allow a single route definition to handle a family of URLs, with Flask handling type validation automatically.
- Jinja2 templates separate HTML structure from Python logic using `{{ }}` for output and `{% %}` for control flow, enabling clean and maintainable views.
- The `render_template` function locates a template file, injects named variables, renders the result to a string, and returns it as the HTTP response body.
- Flask's built-in development server (`debug=True`) is strictly for local development; it is single-threaded, insecure, and not designed to handle concurrent production traffic.
- Flask is a deliberate choice for applications where you want fine-grained control over components; when you need a built-in admin interface, ORM, or batteries-included architecture, a full-stack framework like Django is the more appropriate tool.

---

## Self-Assessment Questions

**Factual Recall**

1. What are the four components of an HTTP request? Define each briefly.

2. What does the `__name__` argument to `Flask(__name__)` tell Flask, and why does it matter?

**Application**

3. Write a Flask route that accepts a path of the form `/convert/<float:celsius>` and returns a plain-text string containing the equivalent Fahrenheit temperature. The conversion formula is `F = (C × 9/5) + 32`.

4. You have a Jinja2 template that receives a variable `items` (a list of strings). Write the Jinja2 snippet — including a for-loop and a conditional — that renders each item as a list element, but displays the text "(empty list)" if `items` is empty.

**Critical Thinking**

5. A teammate argues: "Flask is too minimal for a real project — we should always use Django to avoid reinventing the wheel." Construct a concrete scenario where Flask is the clearly better engineering choice, and explain the reasoning behind that choice. Then identify one scenario where your teammate's position is correct.

---

## Connections

- **Previous Chapter:** This is Chapter 1. Students are assumed to bring Python, Git, and command-line fluency from prerequisite coursework. The virtual environment setup here reinforces Python packaging concepts from those prior experiences.
- **Next Chapter:** Chapter 2 will introduce HTTP form handling (`POST` requests), Flask's `request` object, and session management — building directly on the routing and templating foundation established here.
- **Real-World Link:** Flask powers production systems at Pinterest, LinkedIn (historically), and is the standard framework for deploying ML models via REST APIs (e.g., Hugging Face Spaces, many FastAPI tutorials use Flask as a conceptual precursor). The pattern introduced here — route → function → template — is architecturally identical to Express.js (Node), Sinatra (Ruby), and Gin (Go).
- **Further Reading:**
  - Flask official documentation, "Quickstart" section: [https://flask.palletsprojects.com/en/stable/quickstart/](https://flask.palletsprojects.com/en/stable/quickstart/)
  - Mozilla Developer Network, "An overview of HTTP": [https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)

---

## Instructor Notes *(Not for Student Distribution)*

### Answer Key

**Q1 — HTTP request components:**
Method (the action: GET, POST, etc.), Path (the resource identifier, e.g., `/users/42`), Headers (key-value metadata: content type, auth tokens, etc.), Body (optional payload carrying data, used in POST/PUT requests).

**Q2 — `Flask(__name__)`:**
`__name__` is a Python built-in that resolves to the name of the current module. Flask uses it to determine the root path of the application — specifically, where to look for the `templates/` and `static/` directories. If you rename or package the file, this ensures Flask can still find its resources correctly.

**Q3 — Temperature conversion route:**
```python
@app.route("/convert/<float:celsius>")
def convert(celsius):
    fahrenheit = (celsius * 9 / 5) + 32
    return f"{celsius}°C is {fahrenheit}°F"
```

**Q4 — Jinja2 for-loop with empty check:**
```html
{% if items %}
  <ul>
    {% for item in items %}
      <li>{{ item }}</li>
    {% endfor %}
  </ul>
{% else %}
  <p>(empty list)</p>
{% endif %}
```

**Q5 — Flask vs. Django (critical thinking):**
A strong answer identifies a concrete axis of comparison. Example Flask scenario: a data scientist needs to expose a trained scikit-learn model as a REST API endpoint that accepts a JSON payload and returns a prediction. Flask adds virtually zero overhead, requires no ORM, no admin interface, and can be running in production in under 50 lines. Django scenario where the teammate is right: a multi-developer team building a content management system with user authentication, role-based permissions, an admin dashboard for non-technical staff, and a relational database — every one of those features ships with Django out of the box, and reimplementing them in Flask would take weeks and introduce security risk. The engineering principle at stake is *accidental complexity*: don't build what the framework should give you for free.

---

### Common Misconceptions

1. **"debug=True is fine in production because it gives better error messages."** Students conflate development convenience with production safety. The Werkzeug debugger exposes a PIN-protected but still real Python REPL on any unhandled exception page. Emphasize: the moment any traffic that isn't you hits the server, debug mode must be off.

2. **"Flask is only for toy projects."** The microframework label misleads students into thinking Flask cannot scale. Instagram was built on Django, but many high-throughput APIs (especially in the ML/data space) run Flask behind a production WSGI server (Gunicorn, uWSGI) with no issues. The framework choice determines development experience and built-in features — not scalability, which is an infrastructure concern.

3. **"The `@app.route()` decorator runs the function when the file is loaded."** Students with limited decorator experience believe the decorated function executes at import time. Clarify: the decorator registers the function in Flask's URL map at import time but does not call it. The function is called only when a matching HTTP request arrives at runtime.

---

### Suggested Lecture Talking Points

- Open by asking students to open their browser's DevTools (Network tab), navigate to any website, and look at a single GET request. Walk through the request headers and response status live. This makes HTTP concrete before a single line of Flask is written.
- Frame Flask's decorator-based routing as a data structure problem: Flask is building a dictionary at startup that maps URL patterns to functions. This demystifies the "magic" and connects to data structures students already know.
- Emphasize the development server limitation early and emphatically. A recurring source of production incidents among new engineers is deploying `app.run()` directly — often on a cloud VM with a public IP. This is worth 60 seconds of explicit warning.

---

### Slide Outline

- **Slide 1:** The gap between code and users — the hospital readmission motivating scenario; define the problem Flask solves.
- **Slide 2:** HTTP request-response diagram — method, path, headers, body on request side; status code, headers, body on response side.
- **Slide 3:** Flask installation and the minimal 8-line application — annotated line-by-line.
- **Slide 4:** The URL map concept — `@app.route()` as a dictionary registration, not a function call.
- **Slide 5:** Dynamic routes and type converters — table of converter types (`string`, `int`, `float`, `path`, `uuid`).
- **Slide 6:** Jinja2 templating — `{{ }}` vs `{% %}`, `render_template`, and the templates/ directory convention.
- **Slide 7:** Development server vs. production — what `debug=True` actually exposes; one-slide summary of WSGI and Gunicorn (preview only).
- **Slide 8:** Flask vs. Django decision matrix — two-column table with decision criteria (project size, built-in needs, team size, timeline).

---

## Pedagogical Review

- **ADDIE Alignment:** Analysis is embedded in the prerequisites and hook (identifying the learning gap between Python knowledge and web deployment). Design is reflected in the five Bloom's-mapped objectives and the I-WE-YOU assessment structure. Development constitutes Sections 3–6. Implementation is satisfied by clean Markdown output ready for Pandoc or direct instructor use. Evaluation is addressed through the self-assessment questions and this review section.
- **Bloom's Taxonomy Coverage:** All six levels are represented: Remember and Understand (Q1, Q2, learning objectives 1–2), Apply (worked example, guided practice, Q3, Q4), Analyze (Flask vs. Django comparison in objective 5 and Q5), Evaluate and Create (independent application challenge, Q5 critical thinking).
- **Cognitive Load Management:** The I-WE-YOU scaffold progresses from a fully worked, annotated example (I) to a partially structured task with explicit fill-in markers (WE) to an open-ended project with optional hints (YOU), reducing scaffolding at each stage as competence builds.
- **Historical Grounding:** Section 5 provides the origin story of Flask, Armin Ronacher's role, and the specific design philosophy that differentiates it from Django, grounding the technical choices students will encounter in human motivation and historical context.
- **Ethical Dimension:** The ethical reflection uses `debug=True` as a concrete, immediately encountered risk to open a broader question about responsibility distribution in software systems — relevant to the audience's near-term professional work.
- **Assessment Variety:** Two factual recall questions, two application/coding questions, and one open-ended critical thinking question are included, matching the catalog's specified `short answer + coding exercise` format.
- **Accessibility:** Technical jargon (WSGI, MVC, Jinja2) is introduced with immediate explanation and never assumed. Code is annotated inline. The audience (upper-level undergraduates and Master's students with Python experience) is assumed competent with Python syntax but not with web concepts, and all web-specific material is explained from first principles.