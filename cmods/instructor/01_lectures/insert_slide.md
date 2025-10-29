# Replacement slide for mod2_lec5_AuthZ_AuthN


## 2\. Update Slide 11: The "Magic" of Sessions

We just need to label the diagram's arrows with the functions we just introduced.

<!-- #### **AFTER (New Slide 11):** -->

| Part 1: The Login Response | Part 2: The Next Request |
| :--- | :--- |
| 1. Client `POSTS` to `/login`. | 1. Client `GETS` `/staff_lounge`. |
| 2. Your route validates the password. | 2. Browser attaches the `session` cookie. |
| 3. You call `login_user(user)`. | 3. Flask verifies the cookie. |
| 4. `flask-login` creates the `session` cookie. | 4. `flask-login` reads the `user.id`. |
| 5. **`return redirect(url_for('index'))`** | 5. `flask-login` calls your `@login.user_loader`. |
| 6. Flask sends a `Set-Cookie` header. | 6. Your function returns the `User` object. |
| 7. Browser stores the cookie. | 7. `flask-login` populates `current_user`. |
| | 8. **`return render_template('staff_lounge.html')`** |

<!-- 

### The Real Solution: Modify 2 Existing Slides

The problem isn't the ICE; it's that the *lecture* is incomplete. We need to introduce `render_template` and `redirect` *within the lecture's existing code examples*. This makes the lecture a better "scaffold" for the ICE.

Here are the surgical edits.

-----

### 1\. Update Slide 10: The `login` and `logout` Routes

We will change the "placeholder" code to use the *real* functions. This makes the lecture code identical to the code they'll use in the ICE.

#### **BEFORE (Old Slide 10):**

```python
@app.route('/login')
def login():
    # ...
    # 1. Get the one user from our DB
    user = User.query.get(1)
    # 2. "Log them in"
    login_user(user)
    return "You are now logged in!" # <-- WEAK

@app.route('/logout')
def logout():
    logout_user()
    return "You are now logged out!" # <-- WEAK
```

#### **AFTER (New Slide 10):**

```python
# In moj/routes.py
from flask import render_template, redirect, url_for, request # <-- ADDED
from flask_login import login_user, logout_user, current_user 
from moj.models import User, Joke

# ...

@app.route('/login')
def login():
    # We will build the *real* form in the ICE.
    # For now, we'll just log in a "hardcoded" user.

    # 1. Get the one user from our DB
    user = User.query.get(1)
    # 2. "Log them in"
    login_user(user)
    # 3. Send them to the index page
    return redirect(url_for('index')) # <-- FIXED

@app.route('/logout')
def logout():
    logout_user()
    # 4. Send them back to the login page
    return redirect(url_for('login')) # <-- FIXED

@app.route('/index')
def index():
    # 5. Use render_template to show a real HTML page
    return render_template('index.html', title='Home') # <-- NEW
```

**New Speaker Note:** "Notice we are no longer just returning strings. We're using `redirect(url_for(...))` to send the user to a *different route*, and `render_template('index.html')` to send them a full HTML file from our `templates/` folder. This is the core of any web framework."

-----

### 2\. Update Slide 11: The "Magic" of Sessions

We just need to label the diagram's arrows with the functions we just introduced.

#### **AFTER (New Slide 11):**

| Part 1: The Login Response | Part 2: The Next Request |
| :--- | :--- |
| 1. Client `POSTS` to `/login`. | 1. Client `GETS` `/staff_lounge`. |
| 2. Your route validates the password. | 2. Browser attaches the `session` cookie. |
| 3. You call `login_user(user)`. | 3. Flask verifies the cookie. |
| 4. `flask-login` creates the `session` cookie. | 4. `flask-login` reads the `user.id`. |
| 5. **`return redirect(url_for('index'))`** | 5. `flask-login` calls your `@login.user_loader`. |
| 6. Flask sends a `Set-Cookie` header. | 6. Your function returns the `User` object. |
| 7. Browser stores the cookie. | 7. `flask-login` populates `current_user`. |
| | 8. **`return render_template('staff_lounge.html')`** |


-->