## New Slide: "The Data Lifecycle: What Happens When We Delete?"

The Ticking Time Bomb: We have a huge problem in our app.

A User has many Jokes (db.relationship).

A User has many UserActions (db.relationship).

Question: What happens if we DELETE a User?

Answer: The database will crash with an IntegrityError! The jokes table has rows that point to a user.id that no longer exists.

The Lifecycle Problem: We haven't defined the lifecycle rules for our data. We need to tell the database what to do.

The "Senior" Solution: Cascading Deletes

We need to tell our User model: "When you are deleted, you must also delete all the child records that depend on you."

We will refactor our models.py to add cascade rules.

moj/models.py (The Refactor):

```Python
class User(UserMixin, db.Model):
    # ...
    # This relationship...
    jokes = db.relationship('Joke', backref='author', lazy='dynamic')

    # ...becomes THIS:
    jokes = db.relationship('Joke', backref='author', lazy='dynamic',
                            cascade="all, delete-orphan")

    # We do the same for UserAction...
    actions = db.relationship('UserAction', backref='user', lazy='dynamic',
                              cascade="all, delete-orphan")

class Joke(db.Model):
    # ...
    # This foreign key...
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    # ...becomes THIS (to support the cascade):
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"))
```

Speaker Note: "This is not optional. This is the fix that makes our app stable. The cascade tells SQLAlchemy what to do, and the ondelete tells the database itself what to do. Now, when we delete a user, all their jokes and actions are safely deleted with them, and our app won't crash."