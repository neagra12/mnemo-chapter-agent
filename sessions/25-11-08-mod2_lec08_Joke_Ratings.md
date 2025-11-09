# Session log of lec 8 - Joke Ratings

## **---- PROMPT ----**
```markdown
Cool. Let's see lecture 8 then.
```

Here is the plan for Lecture 8.

This lecture is 100% dedicated to implementing the "Joke Rating" system. Its primary pedagogical goal is to teach **many-to-many database relationships** for the first time, using an "association model" (`Rating`) that holds extra data (the `score`).

-----

### Lecture 8: "Joke Ratings" (Many-to-Many Relationships)

  * **Topic:** Implementing a "Rating" Feature using Many-to-Many Relationships
  * **Cycle 2:** Building the "Ministry of Jokes" (MoJ) v2.0
  * **Time:** 30-35 minutes

-----

### \#\# Slide 1: Title Slide

  * **Topic:** Joke Ratings & Many-to-Many
  * **Subtitle:** Implementing a complex database relationship with an "association model."
  * **Course:** Software Engineering (Greenfield Development)

### \#\# Slide 2: Learning Objectives

  * By the end of this lecture, you will be able to:
  * **Design** a "many-to-many" database relationship.
  * **Implement** this relationship using a third "association model" (e.g., the `Rating` table).
  * **Store** extra data (a "payload") on the association model (e.g., the `score`).
  * **Write** advanced SQLAlchemy queries using `func.avg()` to calculate an average score.
  * **Reinforce** our RBAC rules by preventing users from rating their own jokes.

### \#\# Slide 3: The "Why": Feedback is a Feature

  * **Key Point:** Our app allows users to create jokes, but there's no feedback loop. We want to implement a 1-5 star rating system.
  * This *sounds* simple, but it creates a complex database design problem.
  * **The Core Problem:**
      * A `User` needs to rate *many* `Jokes`.
      * A `Joke` needs to be rated by *many* `Users`.
  * We cannot solve this by adding a column to the `User` or `Joke` table. We need a *third* table to act as a bridge.

### \#\# Slide 4: The Design: A Many-to-Many "Association Model"

  * 
  * **Key Concept:** We will create a new model, `Rating`, that links `User` and `Joke` together.
  * This is called an **Association Model**. It's the "bridge" that holds the relationship.
  * The `Rating` model will hold:
    1.  The `user_id` of the person rating.
    2.  The `joke_id` of the joke being rated.
    3.  The **"payload"**: the `score` (1-5) they gave.
  * This design is powerful. It's the *exact same pattern* you would use for a shopping cart (a `CartItem` links a `User` and a `Product` with a `quantity`).

### \#\# Slide 5: Worked Example 1: The `Rating` Model

  * **Step 1:** We add the new `Rating` model to `moj/models.py`.
  * **Speaker Note:** "This is the most important slide. This new class *is* the relationship."
    ```python
    # In moj/models.py

    class Rating(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        # The "payload"
        score = db.Column(db.Integer, index=True, nullable=False)
        timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
        
        # The "links"
        user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
        joke_id = db.Column(db.Integer, db.ForeignKey('joke.id'))

        def __repr__(self):
            return f'<Rating {self.score} for Joke {self.joke_id} by User {self.user_id}>'

    class Joke(db.Model):
        # ... (all the old columns)
        
        # We add this "ratings" relationship to the Joke model
        # It's the "magic" that connects Joke to Rating
        ratings = db.relationship('Rating', backref='joke', lazy='dynamic')

    # (No change needed to the User model!)
    ```
  * **Speaker Note:** "Your first task in the ICE will be to add this, then run `flask db migrate` and `flask db upgrade`."

### \#\# Slide 6: Worked Example 2: The `Rating` Form

  * **Step 2:** We need a form to submit the rating. This one is simple.
  * **`moj/forms.py`:**
    ```python
    # ... (other imports)
    from wtforms import SelectField

    class RatingForm(FlaskForm):
        # We use 'coerce=int' to make sure the data comes back as a number
        score = SelectField('Rating (1-5)',
                            choices=[(1, '1 Star'), (2, '2 Stars'), (3, '3 Stars'),
                                     (4, '4 Stars'), (5, '5 Stars')],
                            coerce=int)
        submit = SubmitField('Submit Rating')
    ```

### \#\# Slide 7: Worked Example 3: The "Rate Joke" Route

  * **Step 3:** We need a new route to show the form and handle the `POST`.
  * **`moj/routes.py`:**
    ```python
    # ... (import RatingForm and Rating model)
    from moj.forms import RatingForm
    from moj.models import Rating

    @app.route('/rate_joke/<int:joke_id>', methods=['GET', 'POST'])
    @login_required
    def rate_joke(joke_id):
        joke = Joke.query.get_or_404(joke_id)
        form = RatingForm()

        # --- RBAC / Business Logic Checks ---
        # 1. You can't rate your own joke
        if joke.author == current_user:
            flash("You cannot rate your own joke.", "error")
            return redirect(url_for('index'))
            
        # 2. You can only rate a joke once
        existing_rating = Rating.query.filter_by(user_id=current_user.id, 
                                                 joke_id=joke.id).first()
        if existing_rating:
            flash("You have already rated this joke.", "info")
            return redirect(url_for('index'))
        # --- End Checks ---

        if form.validate_on_submit():
            new_rating = Rating(
                score=form.score.data,
                user_id=current_user.id,
                joke_id=joke.id
            )
            db.session.add(new_rating)
            db.session.commit()
            flash("Your rating has been submitted!", "success")
            return redirect(url_for('index'))

        return render_template('rate_joke.html', title='Rate Joke', 
                                form=form, joke=joke)
    ```

### \#\# Slide 8: Worked Example 4: The Frontend (The Links)

  * **Step 4:** How do users *find* this new route? We need to add links to our templates.
  * **`templates/index.html` (or `profile.html`)**
    ```html
    {% for joke in jokes %}
        <p>{{ joke.body }} (by {{ joke.author.username }})</p>
        
        {% if joke.author != current_user %}
            <p><a href="{{ url_for('rate_joke', joke_id=joke.id) }}">Rate this Joke</a></p>
        {% endif %}
        
    {% endfor %}
    ```
  * We also need to create the `templates/rate_joke.html` file (a simple template that renders the `RatingForm`).

### \#\# Slide 9: Worked Example 5: The *Average* Rating (Advanced Query)

  * **Key Concept:** We don't just want to *store* ratings; we want to *show* the average. This requires an advanced query.
  * **The "Clean" Way:** We'll put this complex logic *inside the `Joke` model* to keep our routes simple.
  * **`moj/models.py` (Inside the `Joke` class):**
    ```python
    # At the top of models.py, add this new import
    from sqlalchemy.sql import func

    class Joke(db.Model):
        # ... (all the old columns and the 'ratings' relationship)
        
        # Add this new method:
        def average_rating(self):
            """Calculates the average rating for this joke."""
            
            # This is a raw SQLAlchemy query
            # It translates to: SELECT AVG(Rating.score) FROM Rating WHERE Rating.joke_id = self.id
            avg = db.session.query(func.avg(Rating.score)) \
                .filter(Rating.joke_id == self.id) \
                .scalar() # .scalar() returns a single value (or None)
            
            return round(avg, 1) if avg else "Not rated"
    ```

### \#\# Slide 10: Worked Example 6: Displaying the Average

  * **Step 5:** Now that our model is smart, our template is easy.
  * **`templates/index.html` (Final version):**
    ```html
    {% for joke in jokes %}
        <p>{{ joke.body }} (by {{ joke.author.username }})</p>
        
        <p><b>Rating: {{ joke.average_rating() }} / 5.0</b></p>
        
        {% if joke.author != current_user %}
            <p><a href="{{ url_for('rate_joke', joke_id=joke.id) }}">Rate this Joke</a></p>
        {% endif %}
    {% endfor %}
    ```

### \#\# Slide 11: Key Takeaways

  * To link two models in a "many-to-many" relationship, we must create a third **"association model"** as a bridge.
  * This association model (our `Rating` table) can store *extra data* (a "payload"), like the `score`.
  * We can **encapsulate** complex queries (like `func.avg()`) inside a model method (`average_rating()`) to keep our templates and routes clean.
  * We continue to **reinforce RBAC** by checking rules (like `joke.author != current_user`) in our routes and templates.

### \#\# Slide 12: Your Mission (ICE 12 & A12)

  * **ICE 12 (Today):**
      * You will implement this **entire "Joke Rating" feature** as a team.
      * You'll add the `Rating` model, run `flask db migrate`, create the `RatingForm`, build the `rate_joke` route, and update the templates to show the average rating.
  * **A12 (Homework):**
      * **The "Decorator" Refactor.** In `A11` and `ICE 11`, you wrote `if current_user.role != 'admin': abort(403)` many times.
      * Your mission is to *master* this pattern by refactoring it into a **custom `@admin_required` decorator**. You will then replace all your manual `if` checks with your new, clean decorator. This is a classic, professional-level refactor.



## **---- PROMPT ----**
```markdown
this looks good but it looks like we neglected the tests. 
```

You are absolutely right. That's a critical omission and a bad mistake on my part, especially after we just emphasized testing in Lecture 7.

A feature isn't "done" until it's tested. The new business logic (like "can't rate your own joke") is *exactly* what unit and functional tests are meant to validate.

Let's insert these new slides into the lecture, right after the "Displaying the Average" slide.

---

### ## New Slide 11: Worked Example 7: Testing the Logic

* **Key Point:** We've written a lot of complex *business logic* (e.g., "can't rate your own joke," "can't rate twice," `average_rating()`). We **must** test this.
* **Test 1: The Model (Unit Test)**
    * We need to test our `average_rating()` method directly.
    * **File:** `tests/test_models.py`
    * **GIVEN:** A `Joke` and two `Rating` objects (one with `score=5`, one with `score=3`) are added to the in-memory DB.
    * **WHEN:** We call `joke.average_rating()`.
    * **THEN:** The result is `4.0`.

* **Test 2: The Route (Functional "Happy Path")**
    * We need to test the full, successful `POST` request.
    * **File:** `tests/test_routes.py` (or a new `test_ratings.py`)
    * **GIVEN:** `user_A`, `user_B`, and a `joke_A` (authored by `user_A`).
    * **WHEN:** `user_B` (logged in) `POST`s to `/rate_joke/1` with a score of 5.
    * **THEN:**
        1.  The response is a `302` redirect.
        2.  A new `Rating` object is created in the database, linked to `user_B` and `joke_A`.

### ## New Slide 12: Worked Example 8: Testing the *Security* & Business Rules

* **Key Point:** We must also test our *failure* cases. This is often more important than the happy path.
* **Test 3: "Can't Rate Your Own Joke" (RBAC)**
    * **GIVEN:** `user_A` and `joke_A` (authored by `user_A`).
    * **WHEN:** `user_A` (logged in) `POST`s to `/rate_joke/1`.
    * **THEN:**
        1.  The response is a redirect (not a 200 or 403).
        2.  **No `Rating` object is created** in the database.
        3.  The response data contains the flash message (e.g., `b"You cannot rate your own joke"`).

* **Test 4: "Can't Rate Twice" (Business Logic)**
    * **GIVEN:** `user_B` has already rated `joke_A`.
    * **WHEN:** `user_B` `POST`s to `/rate_joke/1` *again*.
    * **THEN:**
        1.  The response is a redirect.
        2.  **No *new* `Rating` object is created** (the count remains 1).
        3.  The response data contains the flash message (e.g., `b"You have already rated this joke"`).

---

### ## Updated Slide 13: Key Takeaways (New Version)

* To link two models in a "many-to-many" relationship, we create a third **"association model"** (`Rating`) as a bridge.
* We can **encapsulate** complex queries (like `func.avg()`) inside a model method (`average_rating()`) to keep our routes clean.
* We **reinforce RBAC** and business logic by adding checks (like `joke.author != current_user`) in our routes.
* We **must** write unit tests for our new model logic (`test_average_rating`) and functional tests for our new security and business rules (`test_cant_rate_own_joke`).

### ## Updated Slide 14: Your Mission (ICE 12 & A12) (New Version)

* **ICE 12 (Today):**
    * You will implement this **entire "Joke Rating" feature** as a team.
    * This includes the `Rating` model, `flask db migrate`, the `RatingForm`, the `rate_joke` route, and updating the templates.
    * **A `QA Crew` member** will be responsible for writing the `pytest` tests to validate all the new logic.
* **A12 (Homework):**
    * **The "Decorator" Refactor.** You will refactor all your `if current_user.role != 'admin': abort(403)` checks into a custom `@admin_required` decorator.



## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





## **---- PROMPT ----**
```markdown

```





