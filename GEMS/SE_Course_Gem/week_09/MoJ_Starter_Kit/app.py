#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
The core 'Hello World' application for the Ministry of Jokes (MoJ) project.
This file initializes the Flask server.
"""

# SPDX-FileCopyrightText: 2025 The Project Contributors (CSCI-P 465, Indiana University)
# SPDX-License-Identifier: MIT

# Import the main Flask class and the session object
from flask import Flask, session

# Create an instance of the Flask class.
# __name__ is a special Python variable that gets the name of the current module.
# Flask uses this to know where to look for templates, static files, etc.
app = Flask(__name__)

# A secret key is required by Flask to securely manage sessions.
# In a real app, this would be a long, random string loaded from an environment variable.
app.config['SECRET_KEY'] = 'your-super-secret-key'

# This is a "decorator." It's a Python feature that modifies the function below it.
# This specific decorator tells Flask: "When someone visits the root URL ('/'),
# run the hello_world() function."
@app.route('/')
def hello_world():
    # Whatever the function returns is sent back to the user's browser.
    return 'Hello, World!'

# This 'if' block is standard Python. It means "only run the code inside
# if this script is executed directly" (not imported as a module).
if __name__ == '__main__':
    # This line starts the built-in Flask development web server.
    # The --debug flag (or debug=True) is CRITICAL for development.
    app.run(debug=True)