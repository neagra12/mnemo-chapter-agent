#!/bin/bash
#
# cmods/student/02_ices/mod2_ice09_auth_kit.sh
#
# This is a "recipe" script for the main build_kit.sh tool.
# It *assumes* it is being run from within an empty
# staging directory, and its job is to populate it.
#
# This kit provides the complete "backend" for AuthN/AuthZ
# from Lecture 5.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "migrations/versions"
mkdir -p "templates"
mkdir -p "tests"

# --- Manifest ---
echo "   -> Writing manifest.txt..."
cat << EOF > "manifest.txt"
This is the "AuthN/AuthZ Backend" kit for ICE 9.

It provides all the completed code from Lecture 5, allowing your team to
focus on the "frontend" (forms) during the ICE.

FILE MANIFEST:
================
moj/__init__.py:
    - CONTAINS: The Flask 'app' and 'db' objects.
    - NEW: Initializes the 'LoginManager' and sets 'login.login_view'.

moj/config.py:
    - CONTAINS: Standard app configuration.
    - NEW: Adds the 'SECRET_KEY'. This is CRITICAL for Flask-WTF.

moj/models.py:
    - CONTAINS: The 'User' and 'Joke' models.
    - NEW: 'User' model is updated with:
        - 'UserMixin' for session management.
        - 'password_hash' and 'role' columns.
        - 'set_password()' and 'check_password()' methods.
        - The '@login.user_loader' function.

moj/routes.py:
    - CONTAINS: The routes from the end of the lecture.
    - 'index' now uses render_template().
    - 'login' is a "hardcoded" placeholder (you will replace this).
    - 'logout' is functional.
    - 'staff_lounge' and 'admin_panel' are protected route examples.

migrations/versions/xxxx_add_auth_columns.py:
    - The *migration script* to add 'password_hash' and 'role' to the User.
    - Your 'Repo Admin' will need to run 'flask db upgrade' after this kit.

templates/...
    - All HTML templates ('base.html', '_navigation.html', 'index.html',
      'login.html', 'register.html') are provided.

tests/conftest.py:
    - NEW: Updated to automatically create/drop an in-memory database
      for each test and to disable CSRF for easier form testing.

tests/test_routes.py:
    - CONTAINS: The original 'hello_world' test.
    - NOTE: This test now correctly checks for a 302 (redirect) since
      the index page now requires a login.

tests/test_auth.py:
    - NEW: This is the "WE" scaffolding for your A09 homework.
    - It contains complete, working tests for the 'register' and 'login'
      routes that you will build in the ICE.
EOF

# --- moj/__init__.py (Unchanged) ---
echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
import sys
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager

app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
login = LoginManager(app)
login.login_view = 'login'  # Tell flask-login which route to redirect to

from moj import routes, models
EOF

# --- moj/config.py (Unchanged) ---
echo "   -> Writing moj/config.py..."
cat << EOF > "moj/config.py"
import os


basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    """Set Flask configuration variables."""

    # CRITICAL: Flask-WTF (forms) requires a SECRET_KEY
    # This key is used to prevent CSRF attacks.
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess-this-secret'

    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or\\
        'sqlite:///' + os.path.join(basedir, 'moj.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

# --- moj/models.py (Unchanged) ---
echo "   -> Writing moj/models.py..."
cat << EOF > "moj/models.py"
from moj import db, login
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
import datetime


# This "user_loader" callback is used to reload the user object
# from the user ID stored in the session.
@login.user_loader
def load_user(id):
    return User.query.get(int(id))


class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)

    # New columns from Lecture 5
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(10), index=True, default='user')

    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    # New methods from Lecture 5
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __repr__(self):
        return '<User {}>'.format(self.username)


class Joke(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    body = db.Column(db.String(280), nullable=False)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    def __repr__(self):
        return '<Joke {}>'.format(self.body)
EOF

# --- moj/routes.py (Unchanged) ---
echo "   -> Writing moj/routes.py (lecture placeholder version)..."
cat << EOF > "moj/routes.py"
from moj import app
from flask import render_template, redirect, url_for, request, abort
from flask_login import login_user, logout_user, current_user, login_required
from moj.models import User, Joke


@app.route('/')
@app.route('/index')
@login_required  # <-- Note: The index is now protected
def index():
    """The main 'Hello World' route."""
    return "Ministry of Jokes is now serioulsy open! Seriuosly."


@app.route('/login')
def login():
    """
    This is the "hardcoded" placeholder from the lecture.
    Your team will REPLACE this in the ICE.
    """
    # TODO: Build a real login form!

    # 1. Get the one user from our DB (we'll assume it's user 1)
    user = User.query.get(1)

    # 2. "Log them in" using flask-login
    login_user(user)

    # 3. Send them to the index page
    return redirect(url_for('index'))


@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))  # Send them to login page


@app.route('/staff_lounge')
@login_required  # This is the AuthN (authentication) check
def staff_lounge():
    return "Welcome to the staff lounge, {}!".format(current_user.username)


@app.route('/admin_panel')
@login_required  # 1. They must be logged in...
def admin_panel():
    # 2. ...and they MUST be an admin! (AuthZ)
    if current_user.role != 'admin':
        abort(403)  # "Forbidden" error

    return "Welcome to the ADMIN PANEL, {}.".format(current_user.username)
EOF

# --- migrations/... (Unchanged) ---
echo "   -> Writing migrations/ (env.py and initial migration)..."
cat << EOF > "migrations/env.py"
from logging.config import fileConfig

from flask import current_app

from alembic import context

# add this line:
from moj.models import db, User, Joke

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
fileConfig(config.config_file_name)

# set the target metadata
target_metadata = db.metadata

# other values from the config, defined for the needs of env.py,
# can be acquired:
# my_important_option = config.get_main_option("my_important_option")
# ... etc.


def run_migrations_offline():
    """Run migrations in 'offline' mode.

    This configures the context with just a URL
    and not an Engine, though an Engine is acceptable
    here as well.  By skipping the Engine creation
    we don't even need a DBAPI to be available.

    Calls to context.execute() here emit the given string to the
    script output.

    """
    url = current_app.config.get("SQLALCHEMY_DATABASE_URI")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    """Run migrations in 'online' mode.

    In this scenario we need to create an Engine
    and associate a connection with the context.

    """
    connectable = db.engine

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
EOF
cat << EOF > "migrations/versions/abc123_add_auth_columns.py"
"""Add password_hash and role columns to User

Revision ID: abc123_add_auth_columns
Revises: 
Create Date: 2025-11-10 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'abc123_add_auth_columns'
down_revision = None # This assumes this is the *first* migration after init
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.add_column(sa.Column('password_hash', sa.String(length=128), nullable=True))
        batch_op.add_column(sa.Column('role', sa.String(length=10), nullable=True))
        batch_op.create_index(batch_op.f('ix_user_role'), ['role'], unique=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto-generated by Alembic - please adjust! ###
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_user_role'))
        batch_op.drop_column('role')
        batch_op.drop_column('password_hash')
    # ### end Alembic commands ###
EOF

# --- templates/... (Unchanged) ---
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
    <p>Welcome to the Ministry of Jokes (MoJ) v2.0.</p>
{% endblock %}
EOF
cat << EOF > "templates/login.html"
{% extends "base.html" %}

{% block content %}
    <h1>Sign In</h1>
    <p>This is the placeholder HTML for the login form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>

    <p>New User? <a href="{{ url_for('register') }}">Click to Register!</a></p>
EOF
cat << EOF > "templates/register.html"
{% extends "base.html" %}

{% block content %}
    <h1>Register</h1>
    <p>This is the placeholder HTML for the registration form.</p>
    <p>Your task in the ICE is to replace this with a real Flask-WTF form.</p>
    
    <p>Already have an account? <a href="{{ url_for('login') }}">Click to Login!</a></p>
EOF

# --- tests/conftest.py (MODIFIED) ---
echo "   -> Writing tests/conftest.py (Modified for DB testing)..."
cat << EOF > "tests/conftest.py"
import pytest
from moj import app as flask_app
from moj import db


@pytest.fixture
def app():
    """Create and configure a new app instance for each test."""
    flask_app.config.update({
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:",  # Use in-memory db
        "WTF_CSRF_ENABLED": False,  # Disable CSRF for testing forms
    })

    # --- Setup database ---
    with flask_app.app_context():
        db.create_all()  # Create all tables
        yield flask_app  # Run the test
        db.session.remove()  # Clean up
        db.drop_all()  # Drop all tables


@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()
EOF

# --- tests/test_routes.py (Unchanged) ---
echo "   -> Writing tests/test_routes.py (now tests for redirect)..."
cat << EOF > "tests/test_routes.py"
def test_hello_world(client):
    """
    GIVEN a configured test client (from conftest.py)
    WHEN the '/' route is requested (GET)
    THEN check that the response is a 302 (redirect)
    """
    # The index route is now protected by @login_required
    # An unauthenticated client should be redirected.
    response = client.get('/')
    assert response.status_code == 302
    assert 'login' in response.location  # Check that it redirects to login
EOF

# --- tests/test_auth.py (NEW FILE) ---
echo "   -> Writing tests/test_auth.py (NEW - Scaffolding for A09)..."
cat << EOF > "tests/test_auth.py"
from moj.models import User
from moj import db


def test_register_new_user(client):
    """
    GIVEN a client and a new user's details
    WHEN the '/register' route is posted to (POST)
    THEN check that the user is created in the database and they are
            redirected to the login page.
    """
    # 1. Post the form data to the register route
    response = client.post('/register', data={
        'username': 'newuser',
        'email': 'new@example.com',
        'password': 'password123',
        'password2': 'password123'
    }, follow_redirects=True)  # <-- 'follow_redirects' is key!

    # 2. Check the response
    assert response.status_code == 200
    # Check that we were redirected to the login page
    assert b'Sign In' in response.data
    assert b'Congratulations' in response.data  # Check for flash message

    # 3. Check the database
    user = User.query.filter_by(username='newuser').first()
    assert user is not None
    assert user.email == 'new@example.com'
    assert user.check_password('password123')
    assert not user.check_password('wrongpassword')


def test_login_and_logout_user(client, app):
    """
    GCIVEN a client and a test user
    WHEN the '/login' and '/logout' routes are used
    THEN check that the user session is managed correctly.
    """
    # --- Create a test user in the database ---
    # We need a user to log in *with*
    with app.app_context():
        user = User(username='testuser', email='test@example.com')
        user.set_password('testpassword')
        db.session.add(user)
        db.session.commit()

    # --- Test Login ---
    response = client.post('/login', data={
        'username': 'testuser',
        'password': 'testpassword'
    }, follow_redirects=True)

    assert response.status_code == 200
    assert b'Home' in response.data  # Redirected to index
    assert b'Sign In' not in response.data  # Login link is gone
    assert b'Logout' in response.data  # Logout link appears

    # --- Test Logout ---
    response = client.get('/logout', follow_redirects=True)

    assert response.status_code == 200
    assert b'Sign In' in response.data  # Redirected to login
    assert b'Logout' not in response.data  # Logout link is gone
EOF

echo "   -> Recipe complete. Kit is built."