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
mkdir -p "tests"
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

moj/forms.py:
    - CONTAINS: The *completed* LoginForm and RegistrationForm from ICE 9.
    - NEW: Adds the 'JokeForm' class from Lecture 6.

moj/routes.py:
    - CONTAINS: The *completed* login, register, and logout routes from ICE 9.
    - NEW: Adds the 'submit_joke' route from Lecture 6.
    - MODIFIED: The 'index' route now queries for all jokes.

templates/base.html:
    - (Unchanged) The main layout with flash messages.

templates/_navigation.html:
    - (Unchanged) Navigation bar with conditional links.

templates/login.html:
    - CONTAINS: The *completed* template with Jinja2 form rendering.

templates/register.html:
    - CONTAINS: The *completed* template with Jinja2 form rendering.

templates/index.html:
    - MODIFIED: Adds a "Submit Joke" link and a 'for' loop to display jokes.

templates/submit_joke.html:
    - NEW: The template for the 'submit_joke' route from Lecture 6.


EOF


# --- moj/ Files ---

echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
import sys
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager

# Set the template folder to be in the root
app = Flask(__name__, template_folder='../templates')
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app)
login.login_view = 'login' # Tell flask-login which route to redirect to

from moj import routes, models
EOF

echo "   -> Writing moj/config.py..."
cat << EOF > "moj/config.py"
import os

# Go UP one level to the project root
basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

class Config:
    """Set Flask configuration variables."""
    
    # This is a "bad practice" hardcoded key.
    # It's required for flask-wtf (forms) to work.
    # TODO: In Week 12, we will fix this and move it to a .env file.
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'a-temporary-and-insecure-fallback-key'
    
    # Database configuration (in project root)
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'moj.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

echo "   -> Writing moj/models.py..."
cat << EOF > "moj/models.py"
from moj import db, login
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
import datetime

@login.user_loader
def load_user(id):
    return User.query.get(int(id))

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(10), index=True, default='user')
    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User {}>'
EOF

echo "   -> Writing moj/forms.py (Solution to ICE9 + JokeForm)..."
cat << EOF > "moj/forms.py"
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField, TextAreaField
from wtforms.validators import DataRequired, ValidationError, Email, EqualTo, Length
from moj.models import User

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember_me = BooleanField('Remember Me')
    submit = SubmitField('Sign In')

class RegistrationForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    password2 = PasswordField(
        'Repeat Password', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Register')

    def validate_username(self, username):
        user = User.query.filter_by(username=username.data).first()
        if user is not None:
            raise ValidationError('Please use a different username.')

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user is not None:
            raise ValidationError('Please use a different email address.')

class JokeForm(FlaskForm):
    """Form for submitting a new joke."""
    body = TextAreaField('Joke Body', validators=[
        DataRequired(), Length(min=1, max=280)])
    submit = SubmitField('Submit Joke')
EOF

echo "   -> Writing moj/routes.py (Solution to ICE9 + CRUD)..."
cat << EOF > "moj/routes.py"
from moj import app, db
from flask import render_template, redirect, url_for, request, abort, flash
from flask_login import login_user, logout_user, current_user, login_required
from moj.models import User, Joke
from moj.forms import LoginForm, RegistrationForm, JokeForm

@app.route('/')
@app.route('/index')
@login_required 
def index():
    """Renders the main index.html page with a feed of jokes."""
    # 1. Query the database
    jokes_list = Joke.query.order_by(Joke.timestamp.desc()).all()
    
    # 2. Pass the list to the template
    return render_template('index.html', title='Home', jokes=jokes_list)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash('Invalid username or password')
            return redirect(url_for('login'))
        login_user(user, remember=form.remember_me.data)
        return redirect(url_for('index'))
        
    return render_template('login.html', title='Sign In', form=form)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
        
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(username=form.username.data, email=form.email.data)
        user.set_password(form.password.data)
        db.session.add(user)
        db.session.commit()
        flash('Congratulations, you are now a registered user!')
        return redirect(url_for('login'))
        
    return render_template('register.html', title='Register', form=form)

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))

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

@app.route('/staff_lounge')
@login_required 
def staff_lounge():
    return "Welcome to the staff lounge, {}!".format(current_user.username)

@app.route('/admin_panel')
@login_required 
def admin_panel():
    if current_user.role != 'admin':
        abort(403) 
    return "Welcome to the ADMIN PANEL, {}.".format(current_user.username)
EOF

# --- templates/ Files ---
echo "   -> Writing all HTML templates..."

cat << EOF > "templates/base.html"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-t-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{% if title %}{{ title }} - MoJ{% else %}MoJ{% endif %}</title>
    <style>
      body { font-family: sans-serif; margin: 2em; }
      nav { background: #f0f0f0; padding: 1em; }
      nav a { margin-right: 1em; }
      .flash { background: #cee5F5; padding: 1em; margin: 1em 0; }
    </style>
  </head>
  <body>
    {% include '_navigation.html' %}
    <hr>
    {% with messages = get_flashed_messages() %}
    {% if messages %}
    <ul class="flash">
      {% for message in messages %}
      <li>{{ message }}</li>
      {% endfor %}
    </ul>
    {% endif %}
    {% endwith %}
    {% block content %}{% endblock %}
  </body>
</html>
EOF

cat << EOF > "templates/_navigation.html"
<nav>
  <a href="{{ url_for('index') }}">Home</a>
  
  {% if current_user.is_anonymous %}
  <a href="{{ url_for('login') }}">Login</a>
  <a href="{{ url_for('register') }}">Register</a>
  {% else %}
  <a href="{{ url_for('submit_joke') }}">Submit Joke</a>
  <a href="{{ url_for('staff_lounge') }}">Staff Lounge</a>
  
  {% if current_user.role == 'admin' %}
  <a href="{{ url_for('admin_panel') }}">Admin</a>
  {% endif %}
  
  <a href="{{ url_for('logout') }}">Logout</a>
  <span>(Logged in as: {{ current_user.username }})</span>
  {% endif %}
</nav>
EOF

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

cat << EOF > "templates/login.html"
{% extends "base.html" %}

{% block content %}
    <h1>Sign In</h1>
    <form action="" method="post" novalidate>
        {{ form.hidden_tag() }} <p>
            {{ form.username.label }}<br>
            {{ form.username(size=32) }}
        </p>
        <p>
            {{ form.password.label }}<br>
            {{ form.password(size=32) }}
        </p>
        <p>{{ form.remember_me() }} {{ form.remember_me.label }}</p>
        <p>{{ form.submit() }}</p>
    </form>
    <p>New User? <a href="{{ url_for('register') }}">Click to Register!</a></p>
{% endblock %}
EOF

cat << EOF > "templates/register.html"
{% extends "base.html" %}

{% block content %}
    <h1>Register</h1>
    <form action="" method="post" novalidate>
        {{ form.hidden_tag() }}
        <p>
            {{ form.username.label }}<br>
            {{ form.username(size=32) }}
        </p>
        <p>
            {{ form.email.label }}<br>
            {{ form.email(size=64) }}
        </p>
        <p>
            {{ form.password.label }}<br>
            {{ form.password(size=32) }}
        </p>
        <p>
            {{ form.password2.label }}<br>
            {{ form.password2(size=32) }}
        </p>
        <p>{{ form.submit() }}</p>
    </form>
    <p>Already have an account? <a href="{{ url_for('login') }}">Click to Login!</a></p>
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


# --- tests/ Files ---
echo "   -> Writing all test files (unchanged from ICE9)..."
cat << EOF > "tests/conftest.py"
import pytest
from moj import app as flask_app
from moj import db

@pytest.fixture
def app():
    flask_app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:", 
        "WTF_CSRF_ENABLED": False, 
    })
    with flask_app.app_context():
        db.create_all() 
        yield flask_app 
        db.session.remove() 
        db.drop_all() 

@pytest.fixture
def client(app):
    return app.test_client()
EOF

cat << EOF > "tests/test_routes.py"
from moj import db
from moj.models import User, Joke

def test_hello_world(client):
    response = client.get('/')
    assert response.status_code == 302
    assert 'login' in response.location 
EOF

cat << EOF > "tests/test_auth.py"
from moj.models import User
from moj import db

def test_register_new_user(client):
    response = client.post('/register', data={
        'username': 'newuser',
        'email': 'new@example.com',
        'password': 'password123',
        'password2': 'password123'
    }, follow_redirects=True) 
    
    assert response.status_code == 200
    assert b'Sign In' in response.data
    assert b'Congratulations' in response.data 

    user = User.query.filter_by(username='newuser').first()
    assert user is not None
    assert user.email == 'new@example.com'
    assert user.check_password('password123')
    assert not user.check_password('wrongpassword')

def test_login_and_logout_user(client, app):
    with app.app_context():
        user = User(username='testuser', email='test@example.com')
        user.set_password('testpassword')
        db.session.add(user)
        db.session.commit()

    response = client.post('/login', data={
        'username': 'testuser',
        'password': 'testpassword'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Home' in response.data 
    assert b'Sign In' not in response.data 
    assert b'Logout' in response.data 

    response = client.get('/logout', follow_redirects=True)
    
    assert response.status_code == 200
    assert b'Sign In' in response.data 
    assert b'Logout' not in response.data 
EOF

echo "   -> Recipe complete. Kit is built."