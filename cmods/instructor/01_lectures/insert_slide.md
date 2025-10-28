## Slide 4: The `app.py` to `moj/` Refactor
- **Key Point:** This is how we transform our simple `app.py` (from ICE 7) into a scalable package (for ICE 8).
- We are **splitting one file into four** specific files, each with one job.

| Old File (`app.py`) | New Files (in `moj/` package) |
| :--- | :--- |
| ```python # Our old app.py app = Flask(__name__) # --- Config --- app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db' db = SQLAlchemy(app) migrate = Migrate(app, db) # --- Models --- class User(db.Model): ... # --- Routes --- @app.route('/') def index(): return "Hello World!" ``` | ```python # 1. moj/config.py class Config: SQLALCHEMY_DATABASE_URI = 'sqlite:///app.db' ... # 2. moj/__init__.py from moj.config import Config app = Flask(__name__) app.config.from_object(Config) db = SQLAlchemy(app) migrate = Migrate(app, db) # Imports *after* init from moj import routes, models # 3. moj/models.py from moj import db class User(db.Model): ... # 4. moj/routes.py from moj import app @app.route('/') def index(): return "Hello World!" ``` |

- **Speaker Note:** "This is the most important change. Our single `app.py` is being split. The new 'heart' of our app is `moj/__init__.py`. It creates the `app` and `db` objects. All our routes move to `routes.py`, models to `models.py`, and configs to `config.py`. The starter zip for today's ICE gives you files 1, 2, and 4. Your *job* will be to move file 3 (`models.py`) and fix its import."