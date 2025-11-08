# Lecture 6 mod2_lec06_CRUDy Jokes

## **---- PROMPT ----**
```markdown
How about we call this lecture mod2_lec06_CRUDy_Jokes.md
```

That's a perfect name. It's memorable, descriptive, and correctly sets the topic.

Here is the lecture plan for `mod2_lec06_CRUDy_Jokes.md`. This lecture is a "back to basics" sprint that builds on all the work from the last two lessons. Students now have a `Joke` model and authenticated users. This lecture connects them, allowing users to create and see their *own* jokes.

-----

### Lecture 6: CRUDy Jokes (Create, Read, Update, Delete)

  - **Topic:** Implementing CRUD operations for the `Joke` model.
  - **Cycle 2:** Building the "Ministry of Jokes" (MoJ) v2.0
  - **Time:** 30-35 minutes

-----

**Slide 1: Title Slide**

  - **Topic:** CRUDy Jokes: Building our Core Feature
  - **Course:** Software Engineering (Greenfield Development)
  - **Module 1:** Building the "Ministry of Jokes" (MoJ)

**Slide 2: Learning Objectives**

  - By the end of this lecture, you will be able to:
  - **Define** the "CRUD" (Create, Read, Update, Delete) design pattern.
  - **Implement** a "Create" (C) feature using a `flask-wtf` form.
  - **Implement** a "Read" (R) feature by querying the database and passing a list of objects to a template.
  - **Use** `current_user` to "author" a new database object.
  - **Render** a list of objects in a template using a Jinja2 `{% for %}` loop.

**Slide 3: The "Why" - We Have an Empty Ministry**

  - **Key Point:** We've spent a lot of time on "meta-work" (auth, tests, linting), and it's all been in service of *this*.
  - Our `User` can log in, but they can't *do* anything.
  - Our `Joke` model exists, but we have no way to *create* jokes.
  - This lecture is about building the app's **core feature**: allowing authenticated users to submit and view jokes.

**Slide 4: The "CRUD" Pattern**

  - **Key Point:** "CRUD" is the blueprint for almost every feature you will ever build. It stands for:
  - **CREATE:** Add new data.
      - **MoJ:** A user `POSTS` a form to submit a new joke.
  - **READ:** Get existing data.
      - **MoJ:** A user visits their "Profile" page and sees a *list* of all their jokes.
  - **UPDATE:** Change existing data.
      - **MoJ:** A user "Edits" a joke they submitted.
  - **DELETE:** Remove existing data.
      - **MoJ:** A user "Deletes" one oftheir jokes.
  - **Speaker Note:** "Today, we're going to build the 'C' and the 'R'. The 'U' and 'D' will be your job for the homework."

**Slide 5: Worked Example 1: The "C" (Create) Form**

  - **Key Point:** This is *exactly* the same skill we used in ICE 9 and HW 4. We just need a new form class.
  - **Step 1: Define the `JokeForm` in `moj/forms.py`.**

<!-- end list -->

```python
# In moj/forms.py
# ... (other imports)
from wtforms import StringField, SubmitField, TextAreaField # <-- Add TextAreaField
from wtforms.validators import DataRequired, Length

# ... (LoginForm, RegistrationForm, ChangePasswordForm) ...

class JokeForm(FlaskForm):
    """Form for submitting a new joke."""
    body = TextAreaField('Joke Body', validators=[
        DataRequired(), Length(min=1, max=280)])
    submit = SubmitField('Submit Joke')
```

  - **Speaker Note:** "No magic here. It's just a new class. We're using `TextAreaField` instead of `StringField` to get a bigger text box."

**Slide 6: Worked Example 2: The "C" (Create) Route**

  - **Key Point:** This route will look just like our `register` route. It will handle both `GET` (showing the form) and `POST` (processing the form).
  - **Step 2: Add the `submit_joke` route to `moj/routes.py`.**

<!-- end list -->

```python
# In moj/routes.py
# ... (other imports)
from moj.forms import JokeForm # <-- 1. Import the new form
from moj.models import Joke # <-- 2. Import the Joke model

# ... (other routes) ...

@app.route('/submit_joke', methods=['GET', 'POST'])
@login_required # <-- 3. MUST be logged in to submit!
def submit_joke():
    form = JokeForm()
    if form.validate_on_submit():
        # 4. Create the new Joke object
        #    We link it to the 'current_user' object!
        joke = Joke(body=form.body.data, author=current_user)
        
        # 5. Add to database
        db.session.add(joke)
        db.session.commit()
        
        flash('Your joke has been submitted!')
        return redirect(url_for('index')) # 6. Redirect to the index
        
    # 7. Show the form on a GET request
    return render_template('submit_joke.html', title='Submit Joke', form=form)
```

**Slide 7: Worked Example 3: The "C" (Create) Template**

  - **Key Point:** The template is *also* identical in structure to `login.html`.
  - **Step 3: Create `templates/submit_joke.html`.**

<!-- end list -->

```html
{% extends "base.html" %}

{% block content %}
    <h1>Submit a New Joke</h1>
    <form action="" method="post" novalidate>
        {{ form.hidden_tag() }} <p>
            {{ form.body.label }}<br>
            {{ form.body(rows=4, cols=50) }}
            {% for error in form.body.errors %}
            <span style="color: red;">[{{ error }}]</span>
            {% endfor %}
        </p>
        <p>{{ form.submit() }}</p>
    </form>
{% endblock %}
```

  - **Speaker Note:** "That's it. With these 3 files, 'Create' is done. This is the power of our architecture. Adding a new feature is just repeating a 3-step pattern."

**Slide 8: The "R" (Read) Pattern**

  - **Key Point:** "Read" is a two-step process:
  - **Step 1 (Backend):** The *route* must query the database to get a *list* of objects.
  - **Step 2 (Frontend):** The *route* must pass that list to a *template*, which then uses a **`for` loop** to render them.

**Slide 9: Worked Example 4: The "R" (Read) Route**

  - **Key Point:** We'll modify our `index` route to be our main "joke feed."
  - **Step 1: Update the `index` route in `moj/routes.py`.**

<!-- end list -->

```python
# In moj/routes.py
# ...

@app.route('/')
@app.route('/index')
@login_required
def index():
    # 1. Query the database
    #    This gets *all* jokes, ordered by the newest first.
    jokes_list = Joke.query.order_by(Joke.timestamp.desc()).all()
    
    # 2. Pass the list to the template
    return render_template('index.html', title='Home', jokes=jokes_list)
```

  - **Speaker Note:** "This is the 'R' in CRUD. We're fetching *all* jokes for now. In a real app, we'd add pagination. Notice we're passing a new variable `jokes` to the template."

**Slide 10: Worked Example 5: The "R" (Read) Template**

  - **Key Point:** We use a Jinja2 `{% for ... %}` loop to render the list.
  - **Step 2: Update `templates/index.html`.**

<!-- end list -->

```html
{% extends "base.html" %}

{% block content %}
    <h1>Hello, {{ current_user.username }}!</h1>
    
    <p><a href="{{ url_for('submit_joke') }}">Submit a New Joke</a></p>
    <hr>

    <h2>Joke Feed:</h2>
    {% for joke in jokes %}
        <div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
            <p>
                <strong>{{ joke.author.username }}</strong> 
                <span style="color: #888;">(on {{ joke.timestamp.strftime('%Y-%m-%d') }})</span>
            </p>
            <p>{{ joke.body }}</p>
        </div>
    {% else %}
        <p>No jokes yet! Be the first to submit one.</p>
    {% endfor %}
{% endblock %}
```

  - **Speaker Note:** "This is a standard `for` loop, just with Jinja's `{%%}` syntax. It will iterate over the `jokes` list we passed from the route. The `joke.author.username` part works because of the `db.relationship` we set up in Lecture 3\!"

**Slide 11: Key Takeaways**

  - **CRUD (Create, Read, Update, Delete)** is the core pattern for all features.
  - **"Create"** is a 3-part task:
    1.  Define a new form in `forms.py`.
    2.  Define a new route in `routes.py` that handles `GET` and `POST`.
    3.  Define a new template in `templates/` to render the form.
  - **"Read"** is a 2-part task:
    1.  The *route* queries the database (e.g., `Joke.query.all()`).
    2.  The *template* uses a `{% for %}` loop to render the list.
  - We can link models together easily (e.g., `joke.author.username`) because we defined our `db.relationship`.

**Slide 12: Your Mission (ICE 10)**

  - The lecture code is complete, but it has a design flaw:
  - The `index` page shows *all* jokes from *all* users.
  - The `submit_joke` route works, but what about *seeing* your jokes?
  - **Your Task (ICE 10): The Profile Page**
  - You will build a new **Profile Page** (`/profile/<username>`) that:
    1.  **Reads** and displays the `User` object for that username.
    2.  **Reads** and displays a list of *only the jokes submitted by that user*.
  - You will also modify the `_navigation.html` template to add a link to the user's *own* profile page.

## **---- PROMPT ----**
```markdown
We haven't really introduced the Jinja templating mechanism and notion of extending "base.html". I think we need one slide to formally introduce Jinja and another slide to show how templates extend a bast template allowing us to create patterns that templates complete. (or templates of templates.)
```

You are absolutely right. We've been using these tools (`render_template`, `{% extends %}`) as "magic" because the `ICE09_auth_kit` provided them. We can't move on to *building* our own templates in the next ICE without formally teaching *how* they work.

Your plan is perfect. We will add two new slides to the `mod2_lec06_CRUDy_Jokes` lecture. This will not add significant time, as it's just explaining the "why" behind the code we're about to write.

The perfect place for these is right after **Slide 6 (The "C" (Create) Route)** and *before* we show the "Create" template.

-----

### New Slide (Insert as Slide 7)

This slide introduces Jinja2 as a concept.

**Slide 7: What is Jinja2? (The "T" in MVT)**

  - **Key Point:** We've been calling `render_template`. The tool that *actually* runs is **Jinja2**, Flask's built-in templating engine.
  - **Analogy:** Jinja is "Mad Libs for HTML." 📝
  - Your Python route (`routes.py`) is the "View" (the logic). It gathers the data (the "nouns" and "verbs").
  - Your `.html` file is the "Template." It's the "story" with blanks.
  - `render_template('index.html', title='Home')`
  - **Jinja's Three Syntaxes:**
      - `{{ variable_name }}`: **Prints a variable.** This is the "blank."
          - e.g., `<h1>{{ title }}</h1>` becomes `<h1>Home</h1>`
      - `{% statement %}`: **Runs a command.** This is the "logic."
          - e.g., `{% if current_user.is_authenticated %}`
          - e.g., `{% for joke in jokes %}`
      - `{# comment #}`: A comment that *does not* get sent to the browser.
  - **Speaker Note:** "This is the 'Model-View-Template' (MVT) pattern. Our *Model* is `models.py`, our *View* is `routes.py`, and our *Template* is the `.html` file."

-----

### New Slide (Insert as Slide 8)

This slide explains the "template of templates" concept.

**Slide 8: Template Inheritance (The DRY Principle)**

  - **Key Point:** We don't want to re-write our `<head>`, `<nav>`, and CSS links on *every single page*. (DRY = Don't Repeat Yourself).
  - **The Solution:** We create "templates of templates" using **inheritance**.
  - **`templates/base.html` (The "Parent" Template)**
      - This is our "master stationery" or "letterhead." 📜
      - It contains all the common HTML (`<html>`, `<head>`, `<body>`, `<nav>`).
      - It defines *empty, named sections* called **"blocks."**
      - ```html
        <!doctype html>
        <html>
          <head>...</head>
          <body>
            {% include '_navigation.html' %}
            <hr>
            {# This is the "empty" block other templates will fill #}
            {% block content %}{% endblock %}
          </body>
        </html>
        ```
  - **`templates/submit_joke.html` (The "Child" Template)**
      - It **`{% extends "base.html" %}`** at the *very* top. This is the "puts paper in the printer" command.
      - It then defines the content for the "blocks" from the parent.
      - ```html
        {% extends "base.html" %}

        {% block content %}
          <h1>Submit a New Joke</h1>
          <form>...</form>
        {% endblock %}
        ```
  - **Speaker Note:** "When Flask renders `submit_joke.html`, it first grabs `base.html`, then it 'fills in' the `content` block. This is how we get a consistent look and feel across our entire site."

-----

After these two slides, you would then proceed with the *old* Slide 7 (now **Slide 9: Worked Example 3: The "C" (Create) Template**), which now makes perfect sense to the students.

## **---- PROMPT ----**
```markdown
This ICE has three active roles for a 4-5 member team. Anything we can specifically task to the other crew members. Can the workflow test confirmation be a parallel task for the other crew members. ?
```

Yes, this is an excellent observation. You've spotted the "idle hands" problem in this ICE, and your instinct to use testing as a parallel task is spot on.

Your specific proposal of "workflow test confirmation" is good, but it's hard to do in parallel when the feature isn't built yet.

A much stronger and more realistic parallel task is **writing the unit test for the new feature**. This perfectly models a "test-first" or "test-concurrent" professional workflow.

Here is the surgical update to the ICE 10 plan.

### 1\. Update the Role Kit

We will formally define the 4th/5th members' role in the Role Kit.

  * **`Repo Admin`:** (Git & Merge) Handles all Git operations.
  * **`Dev Crew` (Logic):** Implements the new `/profile/<username>` route in `moj/routes.py`.
  * **`Process Lead` (Templating):** Creates `profile.html` and updates the navigation links.
  * **`QA Crew` (Test):** (This is the 4th/5th member) Writes the new `pytest` for the `/profile` route in parallel.

### 2\. Add a Parallel Task: "Phase 2b"

While the `Dev Crew` is doing "Phase 2" and the `Process Lead` is doing "Phase 3," the `QA Crew` does this:

-----

#### Phase 2b: Write the Test (YOU 🫵) (QA Crew)

This is your "YOU do it" task. Your job is to write the automated test that *proves* the `Dev Crew`'s and `Process Lead`'s work is correct.

1.  **Pull:** `git pull` and `git checkout ice10-profile-page`.

2.  **Open:** Open the existing `tests/test_routes.py` file.

3.  **Add Test:** Add this new test function to the bottom of the file. This test will:

      * Create a test user and a test joke.
      * Log that user in.
      * Visit that user's new profile page.
      * Check that the response is `200` (OK).
      * Check that the page content contains the user's name and the body of their joke.

    <!-- end list -->

    ```python
    # In tests/test_routes.py
    from moj import db
    from moj.models import User, Joke

    # ... (existing test_hello_world) ...

    def test_profile_page(client, app):
        """
        GIVEN a logged-in user with one joke
        WHEN the user's profile page is requested (GET)
        THEN check that the user's info and their joke are displayed.
        """
        # 1. SETUP: Create a user and a joke
        with app.app_context():
            user = User(username='testuser', email='test@example.com')
            user.set_password('password')
            db.session.add(user)
            db.session.commit() # Must commit user to get their ID
            
            joke = Joke(body="This is a test joke.", author=user)
            db.session.add(joke)
            db.session.commit()

        # 2. LOGIN: Log the user in (use the login route)
        client.post('/login', data={
            'username': 'testuser',
            'password': 'password'
        }, follow_redirects=True)
        
        # 3. ACTION: Request the profile page
        response = client.get('/profile/testuser')
        
        # 4. ASSERT: Check the page content
        assert response.status_code == 200
        assert b"User Profile: testuser" in response.data
        assert b"This is a test joke." in response.data
    ```

4.  **Commit:** `git add tests/test_routes.py` and `git commit -m "test: add test_profile_page"`.

-----

### 3\. Update the Final "Test" Step

Now, in **Phase 5 (Log and Submit)**, the `Repo Admin`'s "Test" step is no longer just "manual clicking."

  * **New Step (Phase 5):**
    1.  **Pull:** `git pull` to get all final changes (the route, the template, *and* the test).
    2.  **Test:** Run the full test suite from the terminal:
        ```bash
        pytest
        ```
    3.  **Verify:** The new `test_profile_page` must **pass**. This is the team's "Definition of Done."
    4.  **Log:** Share screen and fill out `CONTRIBUTIONS.md`.
    5.  **Submit:** Commit the log, push, and open the PR.

This is a **10/10 solution**. It solves the "idle student" problem, introduces a professional TDD-like workflow, and makes the final "Definition of Done" far stronger and more evidence-based.

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



