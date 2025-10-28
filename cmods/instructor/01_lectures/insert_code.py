# models.py
from app import db

class Joke(db.Model):
    id       = db.Column(db.Integer, primary_key=True)
    text     = db.Column(db.String(280), nullable=False)
    rating   = db.Column(db.Integer, default=0)
    # defines the relationship to User table
    user_id  = db.Column(db.Integer, db.ForeignKey('user.id'))

    # Locate a joke by id
    joke = db.session.get(Joke, joke_id)
    joke_text = joke.text


CREATE TABLE joke (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    text     VARCHAR(280) NOT NULL,
    rating   INTEGER      DEFAULT 0,
    user_id  INTEGER,
    FOREIGN KEY (user_id) REFERENCES "user"(id)
);

SELECT text FROM joke WHERE id = ?;

created_at = db.Column(db.DateTime, default=datetime.utcnow)



# In app.py  
app = Flask(__name__)  
# ... config ...    

# # 1. Initialize extensions BEFORE importing models  
db = SQLAlchemy(app)  
migrate = Migrate(app, db)    

# 2. NOW it's safe to 
import models  from project import models    

# In models.py  
# # 3. This import now works!  
from app import db


# Brittle, hard to maintain, and a HUGE security risk (SQL Injection)  
user_input = "Admin' --"  
db.execute("SELECT * FROM users WHERE username = '" + user_input + "'")


joke:
  id: 101
  text: "Why did the...?"
  rating: 5
  user: "@username"

{
  "joke": {
    "id": 101,
    "text": "Why did the...?",
    "rating": 5,
    "user": "@username"
  }
}