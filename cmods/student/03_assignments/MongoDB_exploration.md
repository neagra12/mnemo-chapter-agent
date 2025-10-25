# Weekly Challenge (Lab 3): AI-Assisted Tech Evaluation
- **Objective:** Use a GenAI tool (Gemini, Copilot Chat) to perform a professional technology evaluation of MongoDB as an alternative database for the Ministry of Jokes.
- **Goal:** Practice using GenAI as a "senior engineering" collaborator to explore technical trade-offs and learn how to craft effective, targeted prompts.
- **Deliverable:** A single PR (or Gist) containing:
    1.  A file named `tech_eval.md` with your complete chat session log.
    2.  A file named `reflection.md` with your answers to the two reflection questions.
- **Due:** End of Week 10 (Friday @ 11:59 PM)

---
## The Scenario

A junior engineer on your team has just sent you a message: *"I've heard MongoDB is 'web-scale' and way more flexible than SQLite. Why are we bothering with all this SQLAlchemy and migration stuff? We should just use Mongo."*

Your task is **not** to simply prove them wrong or right. Your task is to **prepare for a mentoring session** with them. You will use a GenAI assistant to gather the key facts, pros, cons, and code examples so you can have an informed, evidence-based discussion.

## Instructions

1.  **Set the Persona:** Start your chat session by giving the AI a role.
    * **Good Prompt:** *"Act as a Senior Staff Engineer with deep expertise in both relational (PostgreSQL, SQLite) and NoSQL (MongoDB) databases. I am a junior engineer evaluating which database to use for a new Flask application. I need you to help me compare the trade-offs."*

2.  **Investigate the Trade-Offs (Build your Chat Log):**
    You must get your AI assistant to provide answers for the following topics. **Do not ask one giant prompt.** Ask a series of targeted, conversational questions. Your goal is to have a *discussion*, not get a single "dump."

    * **Topic 1: Data Modeling (The "I-WE-YOU" Task)**
        * **"I" (The Bad Prompt):** First, ask a "Google-style" prompt like: `is mongodb good for a joke app?` (Copy the (likely vague) answer).
        * **"WE" (The Good Prompt):** Now, ask a well-crafted prompt. *Show* the AI your Python models from ICE 7 (the `User` and `Joke` classes) and ask: `Given these Python SQLAlchemy models, show me the equivalent data structure for a *single document* in a MongoDB collection. Explain the pros and cons of this "denormalized" document approach vs. the "normalized" two-table relational approach.`
    * **Topic 2: Schema Flexibility**
        * Craft a prompt that asks the AI to explain what "schema-on-read" (Mongo) vs. "schema-on-write" (SQL) means. Ask for a specific example related to the `Joke` model (e.g., "what happens if we want to add a `rating` field to *some* jokes but not others?").
    * **Topic 3: Concurrency**
        * Craft a prompt to ask how MongoDB handles the "race condition" problem (from Slide 4) compared to a relational database like SQLite or PostgreSQL.
    * **Topic 4: Code Implementation**
        * Craft a prompt asking for a simple Python code snippet showing how to (a) connect to a MongoDB database using `pymongo` and (b) insert one new `Joke` document.

3.  **Submit Your Deliverables:**
    * Create `tech_eval.md` and paste the *entire* chat session log (your prompts and the AI's answers).
    * Create `reflection.md` and answer the two questions below.
    * Submit a link to the PR or Gist.

---

## `reflection.md` Questions

**A) The Technology: Verification & Decision** (100-150 words)
The GenAI gave you a lot of information. As a professional engineer, you cannot trust a single source.
1.  What are **two specific, actionable ways** you would verify the AI's most critical claims? (e.g., "I would check the official `pymongo` docs for..." or "I would search for a blog post comparing Mongo vs. SQL for...")
2.  After your full investigation, what is your final recommendation for the team and why?

**B) The Process: Your Value as the "Human in the Loop"** (100-150 words)
You can't just copy-paste a 10-page chat log into your team's Slack. Your job is to *synthesize* it.
1.  What is the **single most important "signal" (key insight)** you got from the AI that your team *needs* to know?
2.  What was the **biggest "noise" (distracting or irrelevant information)** you would *filter out* before reporting back?
3.  Based on this, what value did *you* (the human) add that the AI alone could not?