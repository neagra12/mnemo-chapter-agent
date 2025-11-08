
# Lecture 6: CRUDy Jokes (Create, Read, Update, Delete)

  - **Topic:** Implementing CRUD operations for the `Joke` model.
  - **Cycle 2:** Building the "Ministry of Jokes" (MoJ) v2.0
  - **Time:** 30-35 minutes

-----

## **Slide 1: Title Slide**

  - **Topic:** CRUDy Jokes: Building our Core Feature
  - **Course:** Software Engineering (Greenfield Development)
  - **Module 1:** Building the "Ministry of Jokes" (MoJ)

## **Slide 2: Learning Objectives**

  - By the end of this lecture, you will be able to:
  - **Define** the "CRUD" (Create, Read, Update, Delete) design pattern.
  - **Implement** a "Create" (C) feature using a `flask-wtf` form.
  - **Implement** a "Read" (R) feature by querying the database and passing a list of objects to a template.
  - **Use** `current_user` to "author" a new database object.
  - **Render** a list of objects in a template using a Jinja2 `{% for %}` loop.

## **Slide 3: The "Why" - We Have an Empty Ministry**

  - **Key Point:** We've spent a lot of time on "meta-work" (auth, tests, linting), and it's all been in service of *this*.
  - Our `User` can log in, but they can't *do* anything.
  - Our `Joke` model exists, but we have no way to *create* jokes.
  - This lecture is about building the app's **core feature**: allowing authenticated users to submit and view jokes.

## **Slide 4: The "CRUD" Pattern**

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

## **Slide 5: Worked Example 1: The "C" (Create) Form**

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

## **Slide 6: Worked Example 2: The "C" (Create) Route**

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

## **Slide 7: Worked Example 3: The "C" (Create) Template**

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

## **Slide 8: The "R" (Read) Pattern**

  - **Key Point:** "Read" is a two-step process:
  - **Step 1 (Backend):** The *route* must query the database to get a *list* of objects.
  - **Step 2 (Frontend):** The *route* must pass that list to a *template*, which then uses a **`for` loop** to render them.

## **Slide 9: Worked Example 4: The "R" (Read) Route**

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

## **Slide 10: Worked Example 5: The "R" (Read) Template**

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

## **Slide 11: Key Takeaways**

  - **CRUD (Create, Read, Update, Delete)** is the core pattern for all features.
  - **"Create"** is a 3-part task:
    1.  Define a new form in `forms.py`.
    2.  Define a new route in `routes.py` that handles `GET` and `POST`.
    3.  Define a new template in `templates/` to render the form.
  - **"Read"** is a 2-part task:
    1.  The *route* queries the database (e.g., `Joke.query.all()`).
    2.  The *template* uses a `{% for %}` loop to render the list.
  - We can link models together easily (e.g., `joke.author.username`) because we defined our `db.relationship`.

## **Slide 12: Your Mission (ICE 10)**

  - The lecture code is complete, but it has a design flaw:
  - The `index` page shows *all* jokes from *all* users.
  - The `submit_joke` route works, but what about *seeing* your jokes?
  - **Your Task (ICE 10): The Profile Page**
  - You will build a new **Profile Page** (`/profile/<username>`) that:
    1.  **Reads** and displays the `User` object for that username.
    2.  **Reads** and displays a list of *only the jokes submitted by that user*.
  - You will also modify the `_navigation.html` template to add a link to the user's *own* profile page.

## **Insert before Slide 7: What is Jinja2? (The "T" in MVT)**

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


## New Slide (Insert following slide as Slide 8)

This slide explains the "template of templates" concept.

## **Slide 8: Template Inheritance (The DRY Principle)**

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
