# TA Guide: Weekly Challenge (AI-Assisted Tech Evaluation)

## 1\. Grading Goal & Core Philosophy

This is **not** a "right or wrong answer" assignment. The goal is to assess a student's **reflection and critical thinking skills**. We are evaluating their *process* of using AI as a "force-multiplying intern," not just the final recommendation they make.

The student's main task is to act as a "human-in-the-loop". Did they just copy/paste the AI's answer, or did they *critically analyze* it, filter the "noise" from the "signal," and add their own human judgment to form a professional recommendation?

## 2\. The Standard Analysis Protocol (SAP) Workflow

You **must** follow this protocol to ensure consistent, evidence-based grading.

1.  **WAIT:** Do not begin grading this assignment until the instructor (me) has provided the **"Instructor Exemplar"** (`TECH_EVAL.md`).
2.  **RECEIVE:** The instructor will provide you with their own completed version of the assignment. This exemplar serves as our "ground truth" for the analysis.
3.  **ANALYZE:** Before you look at any student work, review the Instructor's Exemplar. Pay close attention to the **"Critical Analysis"** section. Note which key trade-offs the AI *missed* (e.g., "Schema-on-Read" vs. "Schema-on-Write," the complexity of managing "joins" in application code) and how the instructor critiqued it.
4.  **EVALUATE (The "How-To"):**
      * When you grade a student's submission, your primary task is to **compare their "Critical Analysis" (Part 2) to the Instructor's Exemplar.**
      * **High Score:** A high-scoring student will have an analysis that *mirrors the exemplar*. They will have also caught that the AI's answer was shallow. They used the "ground truth" from **Lec 3, Slide 6** to find the *same flaws* in the AI's logic that the instructor did.
      * **Low Score:** A low-scoring student will have a "Critical Analysis" section that just agrees with the AI. They'll say, "The AI did a great job," and their recommendation will just parrot the AI's conclusion. This demonstrates a failure to apply critical thinking.
      * **The Rubric:** Use the 10-point rubric below, applying your findings from the SAP comparison. A student who *disagrees* with the instructor's final recommendation (e.g., they argue *for* MongoDB) can still get a 10/10, *if* their critical analysis is deep and they justify their decision with the *same set of trade-offs*.

## 3\. Common Pitfalls

  * **Pitfall 1: The "Shallow Prompt."** The student used a generic prompt (e.g., "SQL vs NoSQL"). Their AI answer will be generic, and their analysis will be shallow. This loses points in Part 1.
  * **Pitfall 2: The "AI Parrot."** The student's "Critical Analysis" is just a summary of the AI's text. They don't critique it or compare it to the lecture content. This is a 0-1/4 for Part 2.
  * **Pitfall 3: The "Unjustified Recommendation."** The student's recommendation in Part 3 doesn't logically follow from their analysis in Part 2. This shows a lack of cohesive reasoning.

-----

## Rubric (Pandoc Grid Table for PDF)

+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
+=============================================================+=================+
| **Part 1: AI Prompt Engineering (3 pts)**                   |   3             |
|   - Includes the full, unedited AI prompt.                  |                 |
|   - Prompt is high-quality: provides project context        |                 |
|    (Flask,Users/Jokes) and is not just a generic question.  |                 |
+-------------------------------------------------------------+-----------------+
| **Part 2: Critical Analysis (4 pts)**                       |   4             |
|   - Includes the full, unedited AI response.                |                 |
|   - **(SAP COMPARED):** Student *critically analyzes* the   |                 |
|   AI response, identifying key trade-offs the AI missed     |                 |
|   (as seen in the Instructor Exemplar and Lec 3, Slide 6).  |                 |
+-------------------------------------------------------------+-----------------+
| **Part 3: Final Recommendation (3 pts)**                    |   3             |
|   - Provides a clear, decisive recommendation(SQL or NoSQL) |                 |
|   - Uses the specific trade-offs from their Part 2 analysis |                 |
|   to professionally justify their decision.                 |                 |
+-------------------------------------------------------------+-----------------+
| **Total**                                                   | **10**          |
+-------------------------------------------------------------+-----------------+
