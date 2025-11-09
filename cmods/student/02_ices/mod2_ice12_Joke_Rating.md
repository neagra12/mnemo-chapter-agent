# ICE 12: "Joke Ratings" (Many-to-Many)

  * **Objective:** Implement the full "Joke Rating" feature, including the many-to-many database model, forms, routes, templates, and tests.
  * **Time Limit:** 45 minutes
  * **Context:** In the lecture, we designed the complete "Joke Rating" system. This feature's main goal is to teach you how to build a **many-to-many relationship** using an "association model" (`Rating`) that links `User` and `Joke` and holds an extra "payload" (the `score`). Your mission is to implement this full design.

-----

## Role Kit Selection (Strategy 1: Parallel Processing ⚡)

This is a full-stack feature. Assign these four roles immediately.

  * **`Repo Admin`:** (Git & DB) Handles all Git operations and is the **only one** who runs `flask db migrate`.
  * **`Process Lead`:** (Forms & Templates) Creates the `RatingForm` and all new/modified HTML templates.
  * **`Dev Crew (Backend)`:** (Logic & Routes) Implements the `rate_joke` route and its business logic.
  * **`QA Crew`:** (Testing) Creates a new test file and writes all unit and functional tests for the new feature.

## \<div style="background-color: \#f5f5f5; border: 2px dashed \#990000; padding: 12px 24px; margin: 20px 0px;"\> \<h4\>\<span style="color: \#990000;"\>📈 Triage Dashboard (TopHat)\</span\>\</h4\> \<p\>As your team completes each major part of the ICE, the \<strong\>team member who completed the part\</strong\> should check in on TopHat. All checkpoints are open from the start. Please log them as you go:\</p\> \<ul style="margin-top: 0px;"\> \<li\>\<strong\>Checkpoint 1:\</strong\> Part 1 Complete (DB Migration Pushed)\</li\> \<li\>\<strong\>Checkpoint 2:\</strong\> Part 2 Complete (Rating Form Pushed)\</li\> \<li\>\<strong\>Checkpoint 3:\</strong\> Part 3 Complete (Rating Route Pushed)\</li\> \<li\>\<strong\>Checkpoint 4:\</strong\> Part 4 Complete (Rating Templates Pushed)\</li\> \<li\>\<strong\>Checkpoint 5:\</strong\> Part 5 Complete (Rating Tests Pushed)\</li\> \<li\>\<strong\>🔴 BLOCKED:\</strong\> We are stuck and need TA help.\</li\> \</ul\> \</div\>

## Task Description: Building the Rating Feature

This ICE does **not** have a starter kit. Your "starter" is the code you just completed in `A11`.

### Phase 1: The Database Models (Repo Admin)

You are responsible for updating the database schema.

1.  **Branch:** Pull `main` and create a new feature branch: `ice12-joke-ratings`.
2.  **Open:** `moj/models.py`.
3.  **Add `func` import:** At the **top** of the file, add this:
    ```python
    from sqlalchemy.sql import func
    ```
4.  **Add `Rating` Model:** Add this new class to the **bottom** of `moj/models.py`:
    ```python
    class Rating(db.Model):
        id = db.Column(db.Integer, primary_key=True)
        score = db.Column(db.Integer, index=True, nullable=False)
        timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
        user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
        joke_id = db.Column(db.Integer, db.ForeignKey('joke.id'))

        def __repr__(self):
            return f'<Rating {self.score} for Joke {self.joke_id} by User {self.user_id}>'
    ```
5.  **Update `Joke` Model:** Find the `Joke` class and add the `ratings` relationship and the `average_rating()` method inside it.
    ```python
    class Joke(db.Model):
        # ... (all the old columns) ...
        user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
        
        # ADD THIS RELATIONSHIP:
        ratings = db.relationship('Rating', backref='joke', lazy='dynamic')

        # ADD THIS METHOD:
        def average_rating(self):
            """Calculates the average rating for this joke."""
            avg = db.session.query(func.avg(Rating.score)) \
                .filter(Rating.joke_id == self.id) \
                .scalar() # .scalar() returns a single value (or None)
            
            return round(avg, 1) if avg else "Not rated"

        def __repr__(self):
            return '<Joke {}>'.format(self.body)
    ```
6.  **DB Migrate:** Your code is now ahead of your DB. Run:
    ```bash
    (venv) $ flask db migrate -m "Add Rating model for many-to-many"
    ```
7.  **Commit:** `git add .` and `git commit -m "feat: add Rating model and average_rating method"`.
8.  **Push:** `git push --set-upstream origin ice12-joke-ratings`.
9.  *Announce to the team: "The database model is updated\! Pull now and run `flask db upgrade` to sync your local DB\!"*

-----

### Phase 2: Sync & Implement (All Other Roles)

**Everyone *except* the Repo Admin** must now run these commands:

```bash
# 1. Get all the changes
$ git pull

# 2. Apply the new DB migration to your local moj.db
(venv) $ flask db upgrade
```

Now, you can all work in parallel on your assigned tasks.

-----

### Phase 3: The Rating Form (Process Lead)

1.  **Open:** `moj/forms.py`.
2.  **Add Imports:** At the top, add `SelectField`.
    ```python
    from wtforms import StringField, PasswordField, BooleanField, SubmitField, TextAreaField, SelectField
    ```
3.  **Add `RatingForm`:** Add this new class to the **bottom** of `moj/forms.py`.
    ```python
    class RatingForm(FlaskForm):
        # We use 'coerce=int' to make sure the data comes back as a number
        score = SelectField('Rating (1-5)',
                            choices=[(1, '1 Star'), (2, '2 Stars'), (3, '3 Stars'),
                                     (4, '4 Stars'), (5, '5 Stars')],
                            coerce=int)
        submit = SubmitField('Submit Rating')
    ```
4.  **Commit & Push:** Commit your changes.

-----

### Phase 4: The Rating Route (Dev Crew - Backend)

1.  **Open:** `moj/routes.py`.
2.  **Add Imports:**
    ```python
    from moj.forms import RatingForm  # <-- ADD
    from moj.models import Rating    # <-- ADD
    ```
3.  **Create `rate_joke`:** Add this new route (e.g., after the `edit_joke` route):
    ```python
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
4.  **Commit & Push:** Commit your changes.

-----

### Phase 5: The Templates (Process Lead)

You have two template tasks:

1.  **Create `templates/rate_joke.html`:**
      * This new file will render the form.
    <!-- end list -->
    ```html
    {% extends "base.html" %}
    {% block content %}
        <h1>Rate Joke</h1>
        <p>You are rating: <i>"{{ joke.body }}"</i> by {{ joke.author.username }}</p>
        
        <form action="" method="post" novalidate>
            {{ form.hidden_tag() }}
            <p>
                {{ form.score.label }}<br>
                {{ form.score() }}
            </p>
            <p>{{ form.submit() }}</p>
        </form>
    {% endblock %}
    ```
2.  **Update `templates/index.html` (or `profile.html`):**
      * Find your `{% for joke in jokes %}` loop.
      * Inside the loop, add the code to display the average rating and the "Rate this Joke" link.
    <!-- end list -->
    ```html
    <p>{{ joke.body }} (by {{ joke.author.username }})</p>

    <p><b>Rating: {{ joke.average_rating() }} / 5.0</b></p>

    {% if joke.author != current_user %}
        {% set existing_rating = joke.ratings.filter_by(user_id=current_user.id).first() %}
        {% if not existing_rating %}
            <p><a href="{{ url_for('rate_joke', joke_id=joke.id) }}">Rate this Joke</a></p>
        {% else %}
            <p><i>(You rated this joke {{ existing_rating.score }} stars)</i></p>
        {% endif %}
    {% endif %}
    <hr>
    ```
3.  **Commit & Push:** Commit your changes.

-----

### Phase 6: The Tests (QA Crew)

1.  **Create new file:** Create `tests/test_ratings.py`.
2.  **Add Tests:** Add these four tests:
    ```python
    from moj import db
    from moj.models import User, Joke, Rating
    import pytest

    # Helper function to create users & jokes
    @pytest.fixture
    def setup_db(app):
        with app.app_context():
            user_a = User(username='user_a', email='a@a.com')
            user_a.set_password('a')
            user_b = User(username='user_b', email='b@b.com')
            user_b.set_password('b')
            joke_a = Joke(body="Joke from A", author=user_a)
            db.session.add_all([user_a, user_b, joke_a])
            db.session.commit()
            yield user_a, user_b, joke_a

    def test_average_rating_model(app, setup_db):
        """
        GIVEN a Joke and two Ratings
        WHEN the joke.average_rating() method is called
        THEN the correct average is returned
        """
        user_a, user_b, joke_a = setup_db
        with app.app_context():
            # Add two ratings
            r1 = Rating(score=5, user_id=user_a.id, joke_id=joke_a.id)
            r2 = Rating(score=3, user_id=user_b.id, joke_id=joke_a.id)
            db.session.add_all([r1, r2])
            db.session.commit()
            
            # Check the average
            assert joke_a.average_rating() == 4.0

    def test_rate_joke_happy_path(client, setup_db):
        """
        GIVEN user_B (logged in) and joke_A (by user_A)
        WHEN user_B POSTs a rating
        THEN a new Rating is created in the database
        """
        user_a, user_b, joke_a = setup_db
        
        # Log in as user_B
        client.post('/login', data={'username': 'user_b', 'password': 'b'})
        
        # Post the rating
        response = client.post(f'/rate_joke/{joke_a.id}', data={
            'score': 5
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b"Your rating has been submitted!" in response.data
        
        # Check the DB
        rating = Rating.query.first()
        assert rating is not None
        assert rating.score == 5
        assert rating.user_id == user_b.id

    def test_cant_rate_own_joke(client, setup_db):
        """
        GIVEN user_A (logged in) and joke_A (by user_A)
        WHEN user_A tries to POST a rating
        THEN no Rating is created and a flash message is shown
        """
        user_a, user_b, joke_a = setup_db
        
        # Log in as user_A
        client.post('/login', data={'username': 'user_a', 'password': 'a'})
        
        response = client.post(f'/rate_joke/{joke_a.id}', data={
            'score': 5
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b"You cannot rate your own joke." in response.data
        
        # Check DB
        rating = Rating.query.first()
        assert rating is None

    def test_cant_rate_twice(client, setup_db):
        """
        GIVEN user_B has already rated joke_A
        WHEN user_B tries to POST a rating again
        THEN no new Rating is created
        """
        user_a, user_b, joke_a = setup_db
        with app.app_context():
            # Add the first rating
            r1 = Rating(score=5, user_id=user_b.id, joke_id=joke_a.id)
            db.session.add(r1)
            db.session.commit()
            
        # Log in as user_B
        client.post('/login', data={'username': 'user_b', 'password': 'b'})
        
        # Try to post again
        response = client.post(f'/rate_joke/{joke_a.id}', data={
            'score': 1
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b"You have already rated this joke." in response.data
        
        # Check DB
        assert Rating.query.count() == 1
    ```
3.  **Commit & Push:** Commit your changes.

-----

### Phase 7: Final Test & Log (Repo Admin)

1.  **Pull:** `git pull` to get all changes from all team members.
2.  **Test:** Run `pytest`. All tests (including the new `test_ratings.py` tests) should pass.
3.  **Manual Test:** Run `flask run`.
      * Log in as `user_A`. Create a joke.
      * Log out. Log in as `user_B`.
      * Rate `user_A`'s joke. Does the average rating appear?
      * Try to rate it *again*. Does it stop you?
      * Try to rate *your own* joke (create one as `user_B`). Does it stop you?
4.  **Log:** Fill out the `CONTRIBUTIONS.md` log.
5.  **Submit:** Commit the log, push, and open a Pull Request.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### ICE 12: "Joke Ratings" (Many-to-Many)
* **Date:** 2025-XX-XX
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * Repo Admin: `@github-userX`
    * Process Lead: `@github-userY`
    * Dev Crew (Backend): `@github-userZ`
    * QA Crew: `@github-userA`
* **Summary of Work:** [1-2 sentence summary, e.g., "Implemented a full-stack 'Joke Rating' feature. This required creating a new 'Rating' association model (many-to-many), building a form, adding business logic to the route (no self-rating), and testing all new logic."]
* **Evidence & Reflection:** This was our first many-to-many relationship. What other features could we build using this *exact* database pattern (a "join" table with a "payload")?
```
