#!/bin/bash
#
# cmods/student/02_ices/mod2_ice10_crud_kit.sh
#
# This is a "snapshot" kit for ICE 10.
# It contains the *solution* to ICE 9 (all forms)
# PLUS all the new CRUD/Jinja code from Lecture 6.
#
# This ensures all teams start ICE 10 from the same,
# known-good baseline.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "templates"
# No 'migrations/' folder, students manage their own.

# --- Manifest ---
echo "   -> Writing manifest.txt..."
cat << EOF > "manifest.txt"
This is the "CRUD" kit for ICE 10.

This kit is a full "snapshot" of the project. It contains the
complete, correct solution to ICE 9 (login/register forms)
PLUS all the new code from Lecture 6 (submit joke form,
index page feed).

Your task in ICE 10 is to build the Profile Page *on top* of
this new baseline.

FILE MANIFEST:
================

moj/forms_append.py:
    - NEW: Adds the 'JokeForm' class from Lecture 6.
    - APPEND: Append contents to moj/forms.py

moj/routes_append.py:
    - NEW: Adds the 'submit_joke' route from Lecture 6.
    - MODIFIED: The 'index' route now queries for all jokes.
    - APPEND: Append contents to moj/routes.py

templates/index.html:
    - MODIFIED: Adds a "Submit Joke" link and a 'for' loop to display jokes.

templates/submit_joke.html:
    - NEW: The template for the 'submit_joke' route from Lecture 6.


EOF


# --- moj/ Files ---

echo "   -> Writing moj/forms_append.py ( JokeForm)..."
cat << EOF > "moj/forms_append.py"
# *** APPEND TO moj/forms.py ***

class JokeForm(FlaskForm):
    """Form for submitting a new joke."""
    body = TextAreaField('Joke Body', validators=[
        DataRequired(), Length(min=1, max=280)])
    submit = SubmitField('Submit Joke')
EOF

echo "   -> Writing moj/routes_append.py (Solution to ICE9 + CRUD)..."
cat << EOF > "moj/routes_append.py"
# *** APPEND TO moj/routes.py ***

# !!! REMOVE /index ROUTE ABOVE !!!
@app.route('/')
@app.route('/index')
@login_required 
def index():
    """Renders the main index.html page with a feed of jokes."""
    # 1. Query the database
    jokes_list = Joke.query.order_by(Joke.timestamp.desc()).all()
    
    # 2. Pass the list to the template
    return render_template('index.html', title='Home', jokes=jokes_list)

# *** PEP 8 ***
# says these lines should be moved to the top or integrated with existing `from` statements
from wtforms import TextAreaField
from wtforms.validators import Length


@app.route('/submit_joke', methods=['GET', 'POST'])
@login_required
def submit_joke():
    form = JokeForm()
    if form.validate_on_submit():
        joke = Joke(body=form.body.data, author=current_user)
        db.session.add(joke)
        db.session.commit()
        flash('Your joke has been submitted!')
        return redirect(url_for('index'))
        
    return render_template('submit_joke.html', title='Submit Joke', form=form)
EOF

# --- templates/ Files ---
echo "   -> Writing all HTML templates..."

cat << EOF > "templates/index.html"
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
            </D
            <p>{{ joke.body }}</p>
        </div>
    {% else %}
        <p>No jokes yet! Be the first to submit one.</p>
    {% endfor %}
{% endblock %}
EOF

cat << EOF > "templates/submit_joke.html"
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
EOF

echo "   -> Recipe complete. Kit is built."