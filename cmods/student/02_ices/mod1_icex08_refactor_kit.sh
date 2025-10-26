#!/bin/bash
#
# cmods/student/02_ices/mod1_icex08_refactor_kit.sh
#
# This is a "recipe" script for the main build_kit.sh tool.
# It *assumes* it is being run from within an empty
# staging directory, and its job is to populate it.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "tests"

# --- moj/config.py ---
echo "   -> Writing moj/config.py..."
cat << EOF > "moj/config.py"
import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    """Set Flask configuration variables."""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    
    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

# --- moj/__init__.py ---
echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

# Create the core application object
app = Flask(__name__)
app.config.from_object(Config)

# Initialize extensions
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Import routes and models *after* extensions are initialized
# This avoids circular imports.
#
# NOTE: The student's first task will be to move
# their 'models.py' file into this 'moj/' directory,
# which will make this import work.
from moj import routes, models
EOF

# --- moj/routes.py ---
echo "   -> Writing moj/routes.py..."
cat << EOF > "moj/routes.py"
from moj import app

@app.route('/')
@app.route('/index')
def index():
    """The main 'Hello World' route."""
    return "Hello World!"
EOF

# --- tests/conftest.py ---
echo "   -> Writing tests/conftest.py..."
cat << EOF > "tests/conftest.py"
import pytest
from moj import app as flask_app

@pytest.fixture
def app():
    """Create and configure a new app instance for each test."""
    flask_app.config.update({
        "TESTING": True,
    })
    yield flask_app

@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()
EOF

# --- .flake8 ---
echo "   -> Writing .flake8..."
cat << EOF > ".flake8"
[flake8]
# F401: 'module' imported but unused
# E722: do not use bare 'except'
# W292: no newline at end of file
ignore = F401, E722, W292

# Set max line length to a more modern 100
max-line-length = 100

# Exclude folders we don't control
exclude =
    .git,
    __pycache__,
    moj/__pycache__,
    venv,
    migrations
EOF

echo "   -> Recipe complete."
