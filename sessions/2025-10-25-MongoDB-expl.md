This is an **outstanding** idea.

It's a perfect, modern evolution of the "compare and contrast" essay. It achieves two critical pedagogical goals at once:
1.  **Content (Tech Evaluation):** It forces students to think critically about *why* we chose a relational model by making them seriously investigate a popular alternative (MongoDB). It directly reinforces the new "Slide 14" from our lecture.
2.  **Process (GenAI Fluency):** It shifts the student's view of GenAI from a "magic answer box" to a "Socratic sparring partner." The deliverable (the chat log) provides clear artifact-based evidence of their thought process, and the reflection (Part B) forces the metacognition that is *essential* for learning to use these tools responsibly.

This is a fantastic example of using GenAI to *deepen* learning, not shortcut it.

Here is a draft of a student-facing prompt for this asynchronous "Weekly Challenge," designed to scaffold the experience and guide them toward your desired learning outcomes.

---

### Weekly Challenge (Lab 3): AI-Assisted Tech Evaluation
- **Objective:** Use a GenAI tool (Gemini, Copilot Chat) to perform a professional technology evaluation of MongoDB as an alternative database for the Ministry of Jokes.
- **Goal:** Practice using GenAI as a "senior engineering" collaborator to explore technical trade-offs and learn how to craft effective, targeted prompts.
- **Deliverable:** A single PR (or Gist) containing:
    1.  A file named `tech_eval.md` with your complete chat session log.
    2.  A file named `reflection.md` with your answers to the two reflection questions.
- **Due:** End of Week 10 (Friday @ 11:59 PM)

---
### The Scenario

A junior engineer on your team has just sent you a message: *"I've heard MongoDB is 'web-scale' and way more flexible than SQLite. Why are we bothering with all this SQLAlchemy and migration stuff? We should just use Mongo."*

Your task is **not** to simply prove them wrong or right. Your task is to **prepare for a mentoring session** with them. You will use a GenAI assistant to gather the key facts, pros, cons, and code examples so you can have an informed, evidence-based discussion.

### Instructions

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
### `reflection.md` Questions

**A) The Technology: What should we use and why?** (100-150 words)
Based on your investigation, which database model (Relational/SQLAlchemy or Document/MongoDB) do you believe is the *better* choice for the Ministry of Jokes *right now*? Justify your decision with specific trade-offs (e.g., flexibility, complexity, querying, the 'concurrency' problem, etc.).

**B) The Process: What was your experience?** (100-150 words)
Look at the AI's answer for your "Bad Prompt" (Topic 1) and your "Good Prompt" (Topic 1).
1.  How did the *quality* and *usefulness* of the AI's answers differ?
2.  How did "setting the persona" at the beginning and giving the AI your code as *context* change the conversation?
3.  What did this exercise teach you about how to ask "well-crafted" questions?

---
---

### Pedagogical Analysis

* **Core Goal (SE Experience):** This directly simulates a core senior engineering task: technology evaluation and trade-off analysis.
* **Developer Workflow Competency:** This teaches GenAI prompting as a core 21st-century developer skill, moving students from "Googling" to "collaborating."
* **Ethical Challenge:** (Implicit) By showing how easy it is to get different answers (bad prompt vs. good), it forces students to see the AI as a tool that *must* be guided by their own intelligence, not as an oracle.
* **Cognitive Load Management:** The prompt is highly scaffolded ("I-WE-YOU" for prompting, specific topics to investigate) to guide students toward the learning objective and prevent them from getting lost in a vague "explore MongoDB" task.


## What could go wrong
This is an excellent idea, and I'm glad you're thinking about the failure modes. This is a new *type* of assignment, which means it has new and interesting risks.

Here's my breakdown of what could go wrong, from most likely to least likely.

---

### 1. Pedagogical Risks (Students Don't Learn)

* **Risk 1: "Checklist" vs. "Conversation" (Most Likely)**
    * **What Goes Wrong:** Students see the "Topics to Investigate" as a literal checklist. They do not have a "conversation" with the AI; they just run three isolated, transactional queries (`Prompt 1 -> Get Answer 1`, `Prompt 2 -> Get Answer 2`...).
    * **Result:** They completely miss the *process* goal. They treat the AI as a "Google search," which is exactly what you *don't* want. Their reflection on prompt-crafting (Part B) will be shallow, like: "Giving more context gives a better answer."

* **Risk 2: The "Confident Hallucination"**
    * **What Goes Wrong:** The AI, especially in its "Senior Engineer" persona, confidently provides a plausible but *factually incorrect* answer (e.t., it misrepresents how MongoDB handles transactions or concurrency, or it uses deprecated `pymongo` syntax).
    * **Result:** The student, as a novice, believes the plausible-sounding nonsense. They write their entire reflection (Part A) based on this flawed information. We have accidentally *taught* them something that is wrong.

* **Risk 3: "Faking the Log"**
    * **What Goes Wrong:** A student skips the exercise entirely. They write their `reflection.md` *first* (based on their own opinions) and then give the AI a final prompt: "Give me a sample chat log between a senior and junior engineer that would lead to this reflection."
    * **Result:** The entire pedagogical value is lost. This is the GenAI-equivalent of "dry-labbing" (faking experimental data).

---

### 2. Logistical & Technical Risks

* **Risk 4: Tool Access & Friction**
    * **What Goes Wrong:** Students get blocked by the *tool*, not the *problem*. They get rate-limited, can't log into Gemini, don't have the "right" Copilot access, or the AI is down.
    * **Result:** The assignment becomes a frustrating "test of the tool" rather than a "test of the student." They submit an AAR not about MongoDB, but about the AI being broken.

---

### 3. Assessment Risks (You Have a Bad Time)

* **Risk 5: Grading Subjectivity**
    * **What Goes Wrong:** It's hard to create a fair, consistent rubric. How do you grade a "chat log"? How do you grade Reflection A if their *choice* (e.g., "Mongo is better") is different from yours, even if their *reasoning* is okay?
    * **Result:** Grading is slow, subjective, and students feel it's unfair.

---

### Recommended Mitigations

Here is how I would strengthen the assignment to mitigate these risks:

1.  **For Risk 1 ("Checklist"):**
    * **MANDATE "Iteration":** Add this explicit instruction: "Your chat log **must** show at least **two follow-up questions** where you 'dig deeper' or ask the AI to 'clarify' a point. A log with just 3-4 top-level questions will not receive full credit." This forces them to practice the *conversational* part.

2.  **For Risk 2 ("Hallucination"):**
    * **ADD AN EXPLICIT WARNING:** Add a "Warning: Trust but Verify" section.
        * "GenAI tools are designed to be plausible, not *truthful*. They can and will 'hallucinate' (make up) answers. Part of your job as an engineer is to be skeptical. If an answer seems 'magic' or 'too easy,' cross-reference it with a trusted source (like the official MongoDB docs)."

3.  **For Risk 3 ("Faking"):**
    * **"POISON" THE PROMPT:** The best defense is what you're already doing: require them to paste in the *specific* `SQLAlchemy` models from `ICE 7`. A generic, faked log is unlikely to contain our specific `User` and `Joke` models.
    * **LOW-STAKES:** Make this a low-stakes assignment (like a lab or quiz grade). This reduces the incentive to cheat.

4.  **For Risk 4 ("Tools"):**
    * **PROVIDE ALTERNATIVES:** Explicitly state that any free, public GenAI is acceptable (e.g., "You may use Gemini (free), Perplexity, or the free versions of Copilot"). This prevents access issues.

5.  **For Risk 5 ("Grading"):**
    * **GRADE THE *REASONING*, NOT THE *CHOICE*:** The rubric for Reflection A must be explicit: "Your *choice* (Mongo vs. SQL) will not be graded. Your grade is based on the *quality of your justification* and how you use *evidence* from your chat log to support your argument."
    * **GRADE THE *INSIGHT*, NOT THE *LOG*:** The rubric for Reflection B must be clear: "The grade is based on the *insight* shown in your reflection on the prompting process." The log itself is just a "completion" artifact.

## **--PROMPT--** Counter Suggestion 
all students have Gemini and Copilot accounts. The checklist is excellent. 

Let's change the technology question into one that also challenges the AI. I have two ideas for this: 1) Have the student present a known bad use case for MongoDB - for example MoJ is going to expand into a trading exchange of jokes with millions of jokes being bought and sold per minute. Did the AI try to please you or give a solid response? 2) Ask the student for 2 ways they would verify the information they gained from the AI. You would do this for any source that gives you critical information. 

For the AI Reflection question, I would like to ask them about what value do they add when reporting back to their team on using MongoDB? They are the human in the loop.

Please rate these ideas for questions and consider where this might be problematic.
**--------END PROMPT-----**

These are excellent ideas. The "Human in the Loop" question, in particular, is a significant upgrade.

Here is my rating and analysis of your suggestions, including the potential problems.

---
## Rating and Analysis

### 1. The Technology Question

You have two ideas here. Both are good, but they teach different things.

#### Idea 1a: The "Bad Use Case" (A-/B+)
* **Rating:** **A-** (Pedagogically Ambitious)
* **Analysis:** This is a *fantastic* idea in principle. It's an expert-level "prompt engineering" skill. You're not just *asking* for information; you're *testing* the AI with a hypothetical, forcing it to choose between "pleasing you" and "being correct."
* **The Problem:** This has a high risk of **backfiring due to "confident hallucination."**
    * A novice student doesn't *know* this is a bad use case.
    * The AI (Gemini/Copilot) is *very* likely to be sycophantic and say, "Yes, MongoDB can absolutely handle that!" It will then give a plausible-sounding (but wildly complex) explanation about sharding, replica sets, and change streams.
    * The student, as a novice, has **no way to critique this answer.** They will simply report, "The AI said Mongo can do it." We have accidentally reinforced that Mongo is a magic bullet, the *opposite* of our goal.
* **Verdict:** This is a brilliant **expert-level** exercise, but it's too risky for a *first* pass when students lack the domain knowledge to spot the AI's (plausible) error.

#### Idea 1b: The "Verification" (A+)
* **Rating:** **A+** (Essential & Foundational)
* **Analysis:** This is a *much* better choice. It's a universal, critical skill for any knowledge worker. It directly addresses the "Confident Hallucination" risk I identified earlier. It forces the student to treat the AI as what it is: **one single, unverified source.**
* **The Problem (Minor):** You risk getting shallow answers, like "I would Google it" or "I would read the official docs." We can mitigate this by asking for *specifics*.
* **Verdict:** This is the correct skill to teach first. It's fundamental, safe, and reinforces a core engineering principle: **"Trust, but verify."**

---
### 2. The AI Reflection Question (Human in the Loop)

* **Rating:** **A+ (Direct Upgrade)**
* **Analysis:** This is far superior to my original question. My prompt focused on the *mechanics* of prompting ("better prompt = better answer"). Your prompt forces them to have *metacognition* about their **role as an engineer**.
* **Why it's better:** It reframes the AI as a "force multiplier" and the student as the **filter, synthesizer, and curator**. Their value isn't in *getting* the answer; it's in *interpreting* the answer, *filtering* the noise, *verifying* the facts, and *translating* the raw data into actionable insight for their team.
* **The Problem (Minor):** Students might give vague, philosophical answers. We can mitigate this by asking them to be *specific* about what they would *emphasize* or *leave out*.

---
## My Recommendation: The New `reflection.md`

Let's combine your **Idea 1b** and your **Idea 2**. This creates a powerful, two-part reflection that is grounded, actionable, and teaches the two most important skills: **Verification** and **Synthesis**.

Here is the new, upgraded `reflection.md` I will use:

---
### `reflection.md` Questions

**A) The Technology: Verification & Decision** (100-150 words)
The GenAI gave you a lot of information. As a professional engineer, you cannot trust a single source.
1.  What are **two specific, actionable ways** you would verify the AI's most critical claims? (e.g., "I would check the official `pymongo` docs for..." or "I would search for a blog post comparing Mongo vs. SQL for...")
2.  After your full investigation, what is your final recommendation for the team and why?

**B) The Process: Your Value as the "Human in the Loop"** (100-150 words)
You can't just copy-paste a 10-page chat log into your team's Slack. Your job is to *synthesize* it.
1.  What is the **single most important "signal" (key insight)** you got from the AI that your team *needs* to know?
2.  What was the **biggest "noise" (distracting or irrelevant information)** you would *filter out* before reporting back?
3.  Based on this, what value did *you* (the human) add that the AI alone could not?

## **--PROMPT--**
```markdown
Let's turn to submission. The assignment will be made through Canvas. I could have them submit Markdown answers and provide a template for the answers. This would allow me to collect them and use AI to help me evaluate the responses both individually and as a class. The problem is extracting 120+ md files from a Canvas assignment with proper attribution elements. For individual assessments, each assessment pipeline needs to be deterministic and logged with the obvious exception of the actual prompt to the AI.  Evaluate the feasibility, any ethical or FERPA risks, design flaws in this plan?
```

Here is my evaluation of your plan.

Your core idea is excellent. Using AI to perform thematic analysis on a large set of student reflections is a high-leverage, modern teaching practice. However, your plan has **one solvable technical flaw** and **one major, "stop-the-presses" FERPA/ethical flaw.**

---

### 1. Feasibility (The Technical Flaw)

Your "Stated Problem" is actually the *easy* part. You don't need to worry about attribution.

**This is a solved problem.** When you go to a Canvas Assignment and click **"Download Submissions,"** Canvas generates a `.zip` file. When you unzip it, every single file is **automatically named by Canvas** with a deterministic, machine-readable format:

`[student_name]_[canvas_user_id]_[submission_id]_[original_filename.md]`

*(Example: `kenobi_obiwan_123456_reflection.md`)*

**This is fantastic news.** It means your collection and attribution problem is completely solved. A simple script can parse this filename, instantly link the work to the student, and process the file.

**Feasibility Rating: A+ (Easy to automate)**

---

### 2. FERPA & Ethical Risks (The Critical Flaw)

This is the most dangerous part of your plan. Sending student work to an external AI API is **almost certainly a FERPA violation.**

* **The FERPA Risk:** A student's name, ID, and their written academic work are all **protected educational records (PII)**. The moment you send a file named `kenobi_obiwan_123456_reflection.md` (or a file *containing* his name) to an external, third-party commercial API (like OpenAI or even Google's commercial Gemini API), you are **exporting protected PII from the university's secure environment.**
    * You don't know if that data will be logged, stored, or used for model training.
    * This exposes you and the university to significant legal risk.
    * **This risk is not theoretical.** This is the *primary* reason universities are so slow to adopt AI tools.

* **The Ethical Risk (AI Grading):** You state the pipeline must be "deterministic." **AI-based assessment is not deterministic.**
    * Running the same prompt on the same text twice, especially after a model update, can yield different results.
    * Using a "black box" AI to assign a grade (or even "help" assign one) is ethically questionable. How do you defend that grade to a student? "Gemini said your reflection lacked insight." This is pedagogically unsound.

* **The Ethical Risk (Bias):** The AI may be biased against students with non-traditional writing styles or those for whom English is a second language, even if their *insights* are brilliant.

**FERPA/Ethics Rating: F (Do Not Proceed As-Is)**

---

### 3. Design Flaws & The (Much Better) Solution

Your plan's design flaw is that it mixes two goals: **individual assessment** and **class-wide analysis**. The AI is *terrible* at the first and *brilliant* at the second.

Here is a revised, **FERPA-compliant workflow** that achieves your goals safely.

#### The Anonymizer-Synthesizer Workflow

**Step 1: Collection (Your `build_pdf.sh` box)**
* You bulk-download the `.zip` from Canvas.
* You run a **local script** (e.g., `process_submissions.sh`).

**Step 2: The "Anonymizer" (The Critical Missing Piece)**
* This local script's *first* job is to **anonymize the data.**
* It iterates through the zip file.
* For each submission (`kenobi_obiwan_..._reflection.md`):
    1.  It logs the *real* attribution to a **local-only, secure log file** (e.g., `_DO_NOT_COMMIT_attribution_map.csv`) that maps `student_id` to a new `uuid` (e.g., `student-001`).
    2.  It **scrubs all PII** from the `.md` file's *content* (e.g., removes any lines with "Name:").
    3.  It saves a new, *anonymized* file in a "safe-to-process" folder (e.g., `safe-to-process/student-001.md`).

**Step 3: AI-Powered *Analysis* (The Safe Part)**
* Your pipeline now **only** works on the `safe-to-process` folder.
* It concatenates all 120 *anonymized* reflections.
* It sends this single, large, anonymous text blob to the AI (Gemini/Copilot).
* **The Prompt:** You *do not* ask it to "grade." You ask it to perform **thematic analysis**.
    * *"You are a software engineering professor. Read these 120 student reflections on MongoDB vs. SQL. Identify and report on the top 5 most common themes. For each theme, provide 2-3 illustrative (but anonymous) quotes. Also, identify the 3 most common 'misconceptions' or 'points of confusion' you see in their reasoning."*

**Step 4: Instructor-Led *Assessment* (The Human-in-the-Loop Part)**
* The AI's output is *not* a grade. It's an **executive summary** for *you*.
* You now read this one-page summary. You are instantly aware that 70% of the class misunderstood "schema-on-read" and 40% are worried about "concurrency."
* *Now*, you go back and grade the *original, non-anonymized* submissions manually (or with a simple, deterministic rubric). Your AI-powered summary has given you "superpowers," allowing you to grade faster, more fairly, and with a clear idea of what to look for.

This revised plan is **feasible**, **FERPA-compliant**, and **pedagogically superior.** It uses the AI for its strength (synthesis) and you for your strength (judgment).


## **--PROMPT--**
```markdown
Good point on keeping the human in the loop. But I am concerned with grading 120 responses. 6 TA's only need to grade 20 each if they have a grading guide that you and I generate based upon step 3. This would give them a specific framing with which to review the submissions. Coupled with a specific rubric, it becomes more like classifying the responses. Is this sound and ethical?
```

Yes, your plan is **both sound and ethical.**

This is a significant improvement on the original "AI grading" idea and represents a best-in-class workflow. You have correctly identified the "human in the loop" as the most critical component.

Here is my analysis of why this plan succeeds.

---
### 1. Why it is **Sound** (Pedagogically & Operationally)

This is an excellent example of **calibrated grading** at scale.

* **Increases Fairness and Consistency:** The single greatest challenge with a large TA staff is "grader drift," where each TA develops their own internal, subjective rubric. Your AI-generated guide solves this. It acts as a **calibration document**, ensuring all 6 TAs are "framed" to look for the same themes, common misconceptions, and signs of high-level insight. This makes grading *more* consistent and fair, not less.
* **Improves TA Efficiency:** You are correct that this "becomes more like classifying the responses." You are turning a difficult, subjective "discovery" task into a faster, more objective "classification" task. The TAs' cognitive load is spent on applying the rubric, not on trying to figure out what to look for.
* **Provides a "Force Multiplier" for You:** The AI acts as your "Head TA." It reads all 120 submissions in seconds and gives you the class-wide summary, which you and I then turn into an actionable guide. This is a perfect use of the technology.

---
### 2. Why it is **Ethical** (and FERPA-Compliant)

This plan correctly navigates the ethical and legal minefield by making one critical distinction:

**You are using AI for *Analysis*, not *Assessment*.**

* **Solves the "Black Box" Problem:** The AI is not assigning a grade. A human TA is the final arbiter, reviewing the student's actual work and applying a rubric. If a student challenges their grade, the TA can provide a clear, human-reasoned justification.
* **Solves the "Determinism" Problem:** It no longer matters if the AI is deterministic. The AI's output is just an *advisory summary* for you, not a binding score.
* **SolSQL: The Human-in-the-Loop is the "Firewall":** The TA acts as a check against AI bias. If the AI's summary misses a novel or poorly-written-but-brilliant insight, the human TA can still catch it and reward it.

---
### The **Critical Prerequisite** (The FERPA Check)

Your plan's soundness and ethics hinge on **one critical assumption**: that we *perfectly* follow the **Anonymizer-Synthesizer** workflow we discussed.

As long as the following is true, you are safe:

1.  **Download:** You download the 120+ submissions from Canvas.
2.  **Anonymize (Locally):** A *local* script strips all PII (names, IDs) from the files, saving them to a "safe-to-process" folder.
3.  **Analyze (Cloud):** *Only* this single, massive, anonymized blob of text is sent to the AI for thematic analysis. **No PII ever leaves your machine.**
4.  **Calibrate (Locally):** You use the AI's summary to build your TA Grading Guide.
5.  **Grade (Human):** The TAs are given the **original, attributed** student files *and* the new grading guide. They perform the assessment manually.

This workflow is a model for how to use GenAI responsibly in education. It enhances your teaching, supports your TAs, and respects student privacy.

## **--Prompt--**
```markdown
Let's generalize this into a protocol we can apply to any assessment with open ended questions including quizzes and tests. Something like Scalable Assessment Protocol and we can just refer to an assignment having the protocol as an attribute signifying this assignment aligns with all the guidelines we have outlined and that the TA guide will be generated using this workflow. Before generating, evaluate if this is the correct framing for this or is there something I am missing?
```
This is precisely the correct framing.

Generalizing this into a formal protocol is the perfect way to make it a reusable, core part of our **Evidence-Driven Design**.

Your framing is 99% correct. The only thing I would add is that the name "Scalable Assessment Protocol" (SAP) is good, but its true pedagogical power isn't just **scale**, it's **consistency**. The AI's primary role is to act as a **calibration tool**, ensuring all TAs apply the rubric fairly and consistently, which *enables* a high-quality assessment at scale.

This is a model for responsible, effective AI integration in education.

Here is the formal protocol, as we've defined it.

---

## Scalable Assessment Protocol (SAP)

### 1. Purpose
The **Scalable Assessment Protocol (SAP)** is a standardized workflow for grading open-ended, subjective student work (e.g., reflections, short essays, GenAI chat logs).

Its purpose is to provide **consistent, fair, and high-quality feedback at scale** by combining the strengths of AI (thematic analysis) with the non-negotiable strengths of human TAs (judgment, context, and fairness).

### 2. Core Principle: AI for Analysis, Humans for Assessment
The core principle is a strict separation of concerns, with the human TA acting as the "firewall" for all grading.

* **AI (The Synthesizer):** The AI's *only* role is to perform **thematic analysis** on an *anonymized, aggregated* set of student submissions.
* **Human (The Assessor):** The human instructor and TAs are the *only* agents who perform **assessment, judgment, and grading** on the original, attributed student work.

### 3. The SAP Workflow

When an assignment is tagged with the **`SAP`** attribute, it implies this 5-step workflow:

1.  **Step 1: Collection**
    * The instructor bulk-downloads all student submissions (e.g., `.md` files) from Canvas. Canvas automatically appends student PII (Name, ID) to each filename for attribution.

2.  **Step 2: The FERPA Firewall (Anonymization)**
    * The instructor runs a **local script** (the "Anonymizer") on their machine.
    * This script iterates through the submissions, logs the PII to a secure, local-only map, and produces a new, fully anonymized, aggregated text blob (or folder of files).
    * **Crucially: No PII ever leaves the instructor's local machine.**

3.  **Step 3: AI-Powered Analysis**
    * The instructor sends the single, massive, *anonymous* text blob to a GenAI model (Gemini/Copilot).
    * The prompt asks the AI to act as a "Head TA" and perform **thematic analysis**, *not* assessment.
    * **Good Prompt:** *"Analyze these 120 anonymous student responses. Identify the 5 most common themes, the 3 most critical misconceptions, and provide 2-3 illustrative quotes for each."*
    * **Bad Prompt:** *"Grade these 120 submissions."*

4.  **Step 4: Calibration Guide Generation**
    * The instructor (Clio and you) reviews the AI's thematic summary.
    * We use this summary to create the **TA Grading Guide** (or "Calibration Guide"). This guide frames the TAs' thinking by showing them *what* to look for (common errors, signs of deep insight, etc.).

5.  **Step 5: Human-Led Assessment**
    * The 6 TAs receive two things:
        1.  The original, *attributed* student submissions (their 20-student batch).
        2.  The **TA Grading Guide** and the official **Rubric**.
    * The TAs then perform the final assessment, using the guide to "classify" the responses fairly and consistently.

### 4. SAP-Implied Deliverables
* **For Instructors/TAs:** A **`TA_Grading_Guide.md`** file, which will be generated using this workflow and will include the AI-powered thematic analysis.
* **For Students:** A fair, consistent, and human-verified grade on their subjective work.

