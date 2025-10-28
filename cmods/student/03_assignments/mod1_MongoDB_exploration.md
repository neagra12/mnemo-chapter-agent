# Weekly Challenge (Lab 3): AI-Assisted Tech Evaluation
- **Objective:** Use a GenAI tool (Gemini, Copilot Chat) to perform a professional technology evaluation of MongoDB as an alternative database for the Ministry of Jokes.
- **Goal:** Practice using GenAI as a "senior engineering" collaborator to explore technical trade-offs and learn how to craft effective, targeted prompts.
- **Deliverable:** Two separate Markdown files:
    1.  `tech_eval.md`: Your complete chat session log, formatted using the template below.
    2.  `reflection.md`: Your answers to the four reflection questions.
- **Submission:** Upload **both** `.md` files (`tech_eval.md` and `reflection.md`) directly to this Canvas assignment. **Do not** commit this to your MoJ project repository.
- **Grading:** This assignment is worth 10 points, based on the completeness of your chat log and the thoughtfulness of your reflection.

---

## The Scenario

A junior engineer on your team has just sent you a message: *"I've heard MongoDB is 'web-scale' and way more flexible than SQLite. Why are we bothering with all this SQLAlchemy and migration stuff? We should just use Mongo."*

Your task is **not** to simply prove them wrong or right. Your task is to **prepare for a mentoring session** with them. You will use a GenAI assistant to gather the key facts, pros, cons, and code examples so you can have an informed, evidence-based discussion.

## Instructions

### Part 1: The Investigation (Build Your Chat Log)

1.  **Set the Persona:** Start your chat session by giving the AI a role.
    * **Good Prompt:** *"Act as a Senior Staff Engineer with deep expertise in both relational (PostgreSQL, SQLite) and NoSQL (MongoDB) databases. I am a junior engineer evaluating which database to use for a new Flask application. I need you to help me compare the trade-offs."*

2.  **Investigate the Trade-Offs:**
    You must get your AI assistant to provide answers for the following topics. **Do not try to ask for all topics in one single prompt.** Ask a series of targeted, conversational questions.

    * **Topic 1A: The Vague (Google-Style) Prompt**
        * First, ask a prompt that is *vague* and *lacks context*, like a typical search engine query. (e.g., `is mongodb good for a joke app?`).
    * **Topic 1B: The Context-Rich (Engineering-Style) Prompt**
        * Now, ask a well-crafted prompt that provides **specific context**. *Show* the AI your Python models from ICE 7 (the `User` and `Joke` classes) and ask: `Given these Python SQLAlchemy models, show me the equivalent data structure for a *single document* in a MongoDB collection. Explain the pros and cons of this "denormalized" document approach vs. the "normalized" two-table relational approach.`
    * **Topic 2: Schema Flexibility**
        * Craft a prompt that asks the AI to explain what "schema-on-read" (Mongo) vs. "schema-on-write" (SQL) means. Ask for a specific example related to the `Joke` model (e.g., "what happens if we want to add a `rating` field to *some* jokes but not others?").
    * **Topic 3: Code Implementation & Concurrency**
        * Craft a prompt asking for a simple Python code snippet showing how to (a) connect to a MongoDB database using `pymongo` and (b) insert one new `Joke` document.
        * Ask a follow-up: `How does this code handle the "race condition" problem we discussed in class?`

3.  **Mandatory Iteration:**
    Your chat log **must** show at least **two follow-up questions** where you "dig deeper" or ask the AI to "clarify" a point (e.g., "That doesn't make sense, can you explain the concurrency part again?" or "What's the performance trade-off of that 'denormalized' approach?").

4.  **Warning: Trust but Verify**
    GenAI tools are designed to be plausible, not *truthful*. They can and will "hallucinate" (make up) answers. Part of your job as an engineer is to be skeptical.

### Part 2: The Deliverables

1.  Create `tech_eval.md`. **You must use the `tech_eval.md Template` provided below.** Copy and paste this template into your file, then use it to log *every* prompt and response in your chat.
2.  Create `reflection.md` and answer the four questions below.
3.  **Submit both files to Canvas.**

---

## `tech_eval.md` Template
*(This is the required format for your log file. Create this file and paste the template to get started.)*

````markdown
# Tech Evaluation: Chat Log

*(Copy and paste this entire "Prompt / Response" block for **each** conversational turn in your session.)*

## ----- PROMPT -----
```
(Paste your full prompt to the AI here)
```

## ----- AI RESPONSE -----

(Paste the AI's full response here)

---

*(Copy the block above for your next prompt)*

## ----- PROMPT -----
```
(Paste your next prompt here)
```

## ----- AI RESPONSE -----

(Paste the AI's full response here)

---

````

*(...continue this pattern for your entire chat...)*


---

## `reflection.md` Questions

*(Answer each question in 100-150 words)*

**1. Verification (Technical Skill)**
The GenAI gave you a lot of information. As a professional engineer, you cannot trust a single, unverified source.

  * What are **two specific, actionable ways** you would verify the AI's most critical claims before presenting them to your team? (e.g., "I would check the official `pymongo` docs for..." or "I would search for a benchmark comparing...")

**2. The Decision (Technical Skill)**
Based on your *entire* investigation (your chat log *and* your verification research):

  * What is your final recommendation for the team: **SQLAlchemy or MongoDB?**
  * **Defend your choice** with specific, evidence-based reasoning, referencing the trade-offs you discovered (e.g., flexibility, complexity, querying, concurrency, etc.).

**3. Signal vs. Noise (Reflection Skill)**
You can't just copy-paste a 10-page chat log into your team's Slack. Your job is to *synthesize* it.

  * What was the **single most important "signal" (key insight)** you got from the AI that your team *needs* to know?
  * What was the **biggest "noise" (distracting, irrelevant, or overly complex information)** you would *filter out* before reporting back?

**4. The "Human-in-the-Loop" (Reflection Skill)**
This final question is the most important part of the challenge.

  * What value did *you* (the human) add that the AI alone could not?
  * The AI can provide data, but what part of this task *required* your human intelligence? (e.g., setting context, synthesizing, filtering, verifying, making a judgment call, etc.).

---

## A Final Thought: The Core Lesson

You will likely find that Question 4 was the hardest to answer. This is intentional.

This entire challenge was designed to move you from treating GenAI as a "magic answer box" to treating it as a **"force-multiplying intern."**

An AI can generate 10 pages of *plausible text*. It cannot, however, set a strategic goal, filter noise from signal, verify facts, or synthesize a complex recommendation for a specific business context.

That is *your* job. That is the human value you add.
