# Lecture 1 (Week 9): The Modern Web & The Engineering Mindset
## Slide 1: Title Slide
- **Topic:** The Engineering Mindset & The Modern Web
- **Course:** Software Engineering (CSCI-P 465)

## Slide 2: Learning Objectives
- By the end of this lecture and ICE, you will be able to:
- **Describe** the "greenfield" software development model and how it contrasts with our "brownfield" `Angband` project.
- **Define** the client-server model and the basic roles of HTTP (`GET`/`POST`).
- **Explain** the role of a web framework (like Flask).
- **Run** a local web server using the Flask starter kit.
- **Set up** your team's complete, professional GitHub environment (ICE 1).

## Slide 3: Welcome to "Part 2" - Greenfield Development
- **Key Point:** We are shifting from "archaeology" to "architecture."
- **Part 1 (Brownfield - `Angband`):**
  - You were an engineer on a complex, mature, legacy project.
  - Your main skills were **reading C code**, **analysis**, and **navigation**.
  - This is a *realistic* experience for many first-time engineers.
- **Part 2 (Greenfield - "MoJ"):**
  - You are a founding engineer on a brand-new project.
  - Your main skills will be **building architecture**, **making design decisions**, and **automating process**.
  - This is the *other* realistic experience.

## Slide 4: Our New Project: "The Ministry of Jokes" (MoJ)
- **Key Point:** We are building a full-stack web application from scratch.
- **The Concept:** A simple, self-sustaining content economy.
- **The Core Business Logic:**
  1.  A new user can *only* register or log in.
  2.  To *see* jokes from the community, a user must first *contribute* a joke of their own.
- **Your Job:** To build and deploy this entire system as an engineering team.

## Slide 5: The Big Picture: The Client-Server Model
- **Key Point:** All web applications share this basic architecture.
- **The Client:**
  - The web browser (Chrome, Firefox, Safari) on a user's machine.
  - Its job is to *request* data and *display* it.
- **The Server:**
  - **This is what you are building.** It's a computer running your Flask application.
  - Its job is to *listen* for requests, *process* them (e.g., talk to a database), and *send back* a response.
- **The Diagram:**
  `[Client (Browser)] <---- (The Internet) ----> [Server (Your Flask App)]`

## Slide 6: Historical Hook: Where did the "Web" come from?
- **Key Point:** The web was invented at **CERN** in 1989 by Tim Berners-Lee.
- **The Problem:** Scientists at CERN needed to share research documents with colleagues all over the world.
- **The Solution:** He invented three core technologies to solve this:
  1.  **URL (Uniform Resource Locator):** A standard "address" for every document (e.g., `http://info.cern.ch`).
  2.  **HTML (HyperText Markup Language):** The standard "format" for the documents.
  3.  **HTTP (HyperText Transfer Protocol):** The standard "language" for a client to *request* a document from a server.

## Slide 7: Core Concept: What is HTTP?
- **Key Point:** HTTP is the "language" of the web. It's a simple, text-based **request-response protocol**.
- **The "Request" (from Client):**
  - "Hello Server, I'm a Chrome browser."
  - "I would like to `GET` the document at the URL `/jokes`."
- **The "Response" (from Server):**
  - "OK, I found that. The request was successful (Status: `200 OK`)."
  - "Here is the HTML document you asked for: `<html>...</html>`"
- Speaker Note: Emphasize that HTTP is just a set of rules for formatting these two text messages.

## Slide 8: HTTP "Verbs": The Two You Need to Know
- **Key Point:** Verbs tell the server *what action* the client wants to perform.
- **`GET`**
  - The most common verb.
  - **Meaning:** "Please **give me** this resource."
  - **Used for:** Loading a web page, fetching a list of jokes, downloading an image. It's a read-only operation.
- **`POST`**
  - The second most common verb.
  - **Meaning:** "Please **accept this data** from me."
  - **Used for:** Submitting a login form, posting a new joke, updating your profile. It *changes* data on the server.

## Slide 9: The Problem: Handling Requests is Hard
- **Key Point:** If we had to build a server from scratch, we'd have to:
  1.  Open a network "socket" on our server.
  2.  Listen for new connections.
  3.  Manually read the raw HTTP request text (e.g., `GET /jokes ...`).
  4.  Manually parse that text to figure out what the user wants.
  5.  Manually format a valid HTTP response.
- **This is tedious and error-prone. We just want to write Python!**

## Slide 10: The Solution: A Web Framework (Flask)
- **Key Point:** A framework is code *someone else wrote* that handles all the hard, repetitive parts of building a server.
- **Flask is a "micro-framework" that does two key things for us:**
  1.  It runs a simple web server that listens for HTTP requests.
  2.  It provides a way to **route** a request (like `GET /jokes`) to a specific **Python function** you write.
- This lets you stop worrying about HTTP and start focusing on your application's *logic*.

## Slide 11: The Code: `app.py` Starter Kit
- **Key Point:** This is our entire "Hello World" application.
- **Code Example:**
```python
from flask import Flask

# 1. Create the application instance
app = Flask(__name__)

# 2. This is the "route"
# It maps the URL "/" to the function below it
@app.route('/')
def hello_world():
    # 3. This is the "response"
    return 'Hello, World!'

# 4. This runs the server
if __name__ == '__main__':
    app.run(debug=True)
```
- Speaker Note: Point out the `@app.route('/')` decorator. This is the "magic" that connects a URL to a Python function.

## Slide 12: Instructor Demo: The Debugging Workflow
- **Key Point:** The `debug=True` flag is your most important tool.
- I will now demo the **three** key features of the built-in server.
- **1. The Command:**
  ```bash
  # This is the modern way to run Flask
  flask --app app run --debug
  ```
- **2. The Auto-Reloader:**
  - I will change the "Hello, World!" string, save the file, and the server will restart automatically.
- **3. The Interactive Debugger:**
  - I will add a `1/0` (ZeroDivisionError) to the code.
  - When I refresh the browser, we will see a **live, in-browser console** that lets us inspect the code at the moment of the crash.

## Slide 13: Your Turn: ICE 1 Workshop
- **Key Point:** Founding the Ministry!
- **Task:** Your first official act is to charter the Ministry of Jokes. You will requisition your team's repository, establish proper branch protocols (no silly walks!), and hang your "Hello, World!" shingle (a simple Flask app) on the new office.
- **The Goal:** 
  1. Your team's goal is **NOT** to finish. The goal is to get **EVERYONE** "un-blocked" and operational *while the TAs are here to help.*
  2. Create your team's `moj-team-name` repository from the `moj_starter_kit`.
  3. Set up your main branch and CONTRIBUTIONS.md file.
- **The Due Date:** The final deliverable (the PR) is due at **11:59 PM tonight.**

## Slide 14: ICE 1: Core Workshop Goals
- **Your team must complete these in class:**
  1.  **Repo:** Create your `private` repo on `github.iu.edu` and add all collaborators (team, TA, instructor).
  2.  **Local Setup (Everyone):** Everyone must `git clone` (using SSH), create the `venv`, `pip install`, and successfully run `flask --app app run --debug`.
  3.  **Team Sync Test:** One person will create, commit, and `push` the `CONTRIBUTIONS.md` file.
  4.  **Team Sync Test:** Everyone else *must* successfully `git pull` that new file.
- **If you get stuck on *any* step, call a TA!** That is what we are here for.

## Slide 15: Key Takeaways
- We are starting our "greenfield" Ministry of Jokes project, which will be a **server**.
- The web runs on a **client-server** model using the **HTTP** protocol.
- **Flask** is a framework that handles the hard parts of being a server and lets us map **URLs** (like `/`) to our **Python functions**.
- The `debug=True` flag gives us an **auto-reloader** and an **interactive debugger**.

## Slide 16: Next Time
- **Topic:** Lecture 2: Continuous Integration (CI)
- **Preview:** Now that we have a (very simple) server, how do we automate the process of *testing* it every time we make a change?
- Speaker Notes: By the end of this week, you need to install and run the GitHub Self-Hosted Runner on your laptop. Lecture 2 (CI) and ICE 2 will not work without it. Since the university's GitHub doesn't have its own server runners, your laptop is the CI server. We will provide a step-by-step guide on Canvas. Your primary task between Lecture 1 and Lecture 2 is to get your personal runner 'online' and showing 'idle' in your team's GitHub settings.