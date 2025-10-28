#!/bin/bash
#
# cmods/student/02_ices/mod1_icex08_refactor_kit.sh
#
# This is a "recipe" script for the main build_kit.sh tool.
# It *assumes* it is being run from within an empty
# staging directory, and its job is to populate it.
#
# This version is "poisoned" with intentional flake8 errors
# for the "Linter Audit" assignment.
#

set -e # Exit on error

echo "   -> Creating directory structure..."
mkdir -p "moj"
mkdir -p "tests"

# --- moj/__init__.py ---
# Common Errors: F401 (import sys), E302 (1 blank line)
# Unique Error: E722 (bare except)
echo "   -> Writing moj/__init__.py..."
cat << EOF > "moj/__init__.py"
import sys # <-- LINT ERROR (F401): 'sys' imported but unused.
from flask import Flask
from moj.config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

# LINT ERROR (E302): expected 2 blank lines, found 1
app = Flask(__name__)
app.config.from_object(Config)

db = SQLAlchemy(app)
migrate = Migrate(app, db)

try:
    # LINT ERROR (E722): do not use bare 'except'
    pass
except:
    # This is bad practice! We are doing it to test the linter.
    pass

from moj import routes, models
EOF

# --- moj/config.py ---
# Common Errors: F401 (import sys), E302 (1 blank line)
# Unique Error: W292 (no newline at end of file)
echo "   -> Writing moj/config.py..."
# We use printf here to *intentionally* omit the final newline.
printf "import sys # <-- LINT ERROR (F401): 'sys' imported but unused.
import os

basedir = os.path.abspath(os.path.dirname(__file__))

# LINT ERROR (E302): expected 2 blank lines, found 1
class Config:
    \"\"\"Set Flask configuration variables.\"\"\"
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    
    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
# <-- LINT ERROR (W292): no newline at end of file. You must add one!" > "moj/config.py"

# --- moj/routes.py ---
# Common Errors: F401 (import sys), E302 (1 blank line)
# Unique Error: E501 (line too long)
echo "   -> Writing moj/routes.py..."
cat << EOF > "moj/routes.py"
import sys # <-- LINT ERROR (F401): 'sys' imported but unused.
from moj import app

# LINT ERROR (E302): expected 2 blank lines, found 1
@app.route('/')
@app.route('/index')
def index():
    """The main 'Hello World' route."""
    # LINT ERROR (E501): This comment is intentionally way, way, way too long to demonstrate a line-length error that flake8 will catch, forcing the student to re-format it or break it up.
    return "Hello World!"
EOF

# --- tests/conftest.py ---
# Common Errors: F401 (import sys), E302 (1 blank line)
# Unique Error: E225 (missing whitespace around operator)
echo "   -> Writing tests/conftest.py..."
cat << EOF > "tests/conftest.py"
import sys # <-- LINT ERROR (F401): 'sys' imported but unused.
import pytest
from moj import app as flask_app

# LINT ERROR (E302): expected 2 blank lines, found 1
@pytest.fixture
def app():
    """Create and configure a new app instance for each test."""
    x=5 # <-- LINT ERROR (E225): missing whitespace around operator
    flask_app.config.update({
        "TESTING": True,
    })
    yield flask_app

@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()
EOF

# --- tests/test_models.py ---
# Common Errors: F401 (import sys), E302 (1 blank line)
# Unique Error: F841 (local variable assigned but not used)
echo "   -> Writing tests/test_models.py..."
cat << EOF > "tests/test_models.py"
import sys # <-- LINT ERROR (F401): 'sys' imported but unused.

# We'll import User later when we write real tests
# from moj.models import User 

# LINT ERROR (E302): expected 2 blank lines, found 1
def test_new_user_stub():
    """
    This is a stub for testing the User model.
    It is intentionally left with lint errors.
    """
    # TODO: This test needs to be written!
    new_user = "test" # <-- LINT ERROR (F841): local variable 'new_user' is assigned to but never used
    assert 1 == 1
EOF

echo "   -> Recipe complete. All 5 files poisoned."
