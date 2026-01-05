# Session for Assignment 12 (A16 to clio) - Service Consumer (ingtegrating an AI)

# **---- PROMPT ----**
```markdown

```

That's right, the next step is **Homework 11 (A16)**. This assignment makes the AI integration permanent by updating the database schema to store the AI's results, moving the feature past the simple "flash message" stage.

-----

# Homework 11: Persisting the AI Analysis (A16)

  * **Module:** 3
  * **Assignment:** 11 (A16)
  * **Topic:** Database Schema Evolution and Service Integration
  * **Points:** 10
  * **Due Date:** [Next Due Date]
  * **Type:** "Team Best"

## The "Why": Making Data Valuable

In ICE 16, the AI rating disappeared once the user clicked away. For the rating to be useful for moderation, filtering, or display, it must be **persisted** in the database. This assignment reinforces the crucial engineering skill of evolving a database schema (`Joke` model) to support a new feature without losing existing data.

## The "Team Best" Workflow

1.  **Branch:** The `Repo Admin` creates a branch `hw11-ai-persistence`.
2.  **Individual PRs:** Each student creates their own PR implementing the changes.
3.  **Merge & Log:** The team picks the best implementation, merges it, and logs the changes.

-----

## Core Task 1: Evolving the Database Schema 📜

You need to update the `Joke` model to store the two pieces of information returned by the AI: the descriptive rating and the numerical score.

1.  **Modify `Joke` Model:** In `moj/models.py`, add two new nullable columns to the `Joke` class:
      * `ai_rating = db.Column(db.String(30), nullable=True)` (e.g., "Dad Joke," "Classic")
      * `ai_score = db.Column(db.Integer, nullable=True)` (e.g., 1, 2, 3)
2.  **Run Migrations:** Since you changed the schema, you must create and apply a migration. This must be done **inside the container**.
    ```bash
    $ docker-compose exec web flask db migrate -m "add ai rating and score to joke"
    $ docker-compose exec web flask db upgrade
    ```
    *Note: The migration must be run before the next step can access the new columns.*

## Core Task 2: Refactoring the Integration Logic

Now that the columns exist, update the `create_joke` route to save the data.

1.  **Refactor `moj/routes.py`:** Update the `create_joke` route to assign the values from the API response to the new `Joke` object fields.
2.  **Ensure Graceful Degradation:** Inside your `try/except` block, ensure that if the AI service fails, you still create the `Joke` object but leave the new `ai_rating` and `ai_score` fields set to `None` (the default `nullable=True`).

<!-- end list -->

```python
# ... inside create_joke() after getting data from the API ...

# 1. Initialize variables with safe defaults (None)
ai_rating = None
ai_score = None

# 2. Assign if API call was successful
if api_resp.status_code == 200:
    ai_data = api_resp.json()
    ai_rating = ai_data.get('rating')
    ai_score = ai_data.get('score')
    
# 3. Create the Joke object
joke = Joke(
    body=form.body.data,
    author=current_user,
    ai_rating=ai_rating, # <-- New Field
    ai_score=ai_score    # <-- New Field
)
db.session.add(joke)
# ...
```

## Core Task 3: Displaying the Permanent Rating

Make the data visible to prove it's been saved.

1.  **Update Template:** Update the `index.html` template (or the user profile template) to display the AI's rating next to the joke body if the rating exists.
      * Example: Next to `{{ joke.body }}` add:
        ```html
        {% if joke.ai_rating %}
          <span class="badge bg-secondary">{{ joke.ai_rating }}</span>
        {% endif %}
        ```

-----

## ⭐ Extra Credit (+2 Points): Testing the Persistence

Add a unit test to `tests/test_joke_create.py` (or similar) that validates the entire persistence process:

1.  Mock the external AI API call (so the test doesn't rely on the Docker container).
2.  Perform a `POST` request to the `/create_joke` route.
3.  Query the database for the new joke.
4.  Assert that `joke.ai_rating` and `joke.ai_score` contain the mocked values.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 11 (A16): Persisting the AI Analysis
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link]
* **Justification:** [Why was this implementation chosen?]
* **Reflection:** Explain the difference between running `flask db migrate` and `flask db upgrade` in the context of this assignment. Which command actually changes the production database (our Postgres container)?
```

-----

### Rubric (For TA Use)

| Criteria | Points |
| :--- | :--- |
| **Task 1: Model Evolution & Migration** | / 3 |
| Joke model updated with `ai_rating` (`db.String`) and `ai_score` (`db.Integer`). Migration file created and applied successfully. | |
| **Task 2: Route Refactor & Persistence** | / 4 |
| `create_joke` successfully extracts data from the API response and saves it to the new Joke model columns. **Includes error handling** (defaults to `None` if the AI service call fails). | |
| **Task 3: Display and Visibility** | / 1 |
| The persisted AI rating is displayed in at least one template (e.g., `index.html`). | |
| **Process & Log** | / 2 |
| Team process followed; `CONTRIBUTIONS.md` is complete, and the reflection question is answered accurately. | |
| **EC: Unit Test Validation (+2 pts)** | / +2 |
| A new test is implemented that successfully mocks the external API and validates the persisted data. | |
| **Total** | **/** 10 |

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