# Week 9 Quiz: Foundations & The "Ministry of Jokes" Project

## Quiz Overview
This is a short quiz consisting of 5 multiple-choice questions and 2 short-answer questions, mirroring the format of our Week 1 quiz.

This covers our discussion of the "Ministry of Jokes" (MoJ) project, the client-server model, HTTP, and core Flask concepts. It also includes two refresher questions on SSH from Week 1 to test retention.

You will have 15 minutes to complete the quiz. This, like all quizzes in the class, is an individual activity.

---
### Question 1 (1 pt)
In which file do you place an ssh public key to enable ssh authentication to a remote system?

- [ ] `localhost:$HOME/.ssh/authorized_keys`
- [x] `remote:$HOME/.ssh/authorized_keys`
- [ ] `remote:$HOME/.ssh/known_hosts`
- [ ] `localhost:$HOME/.ssh/known_hosts`

### Question 2 (1 pt)
What is the `ssh-agent`?

- [ ] A daemon running on the *remote* system that stores private keys.
- [ ] A command to store private key passphrases, like a password manager.
- [x] A daemon running on the *localhost* that provides unencrypted private keys to `ssh` commands.
- [ ] A tool to generate new SSH key pairs.

### Question 3 (1 pt)
What is the critical difference between HTTP and HTML?

- [ ] There is no difference; they are two names for the same technology.
- [ ] HTTP is the new, secure version of HTML.
- [x] HTTP is the *protocol* (the "messenger") used to transfer data, while HTML is the *markup language* (the "letter") used to format that data.
- [ ] HTML is the protocol used to request documents, and HTTP is the language those documents are written in.

### Question 4 (1 pt)
Which of the following *best* describes the "client-server" model?

- [ ] A model where two servers (a "client" server and a "main" server) exchange data.
- [x] A model where a "client" (like a browser) requests resources from a "server" (like our Flask app), which processes the request and sends a response.
- [ ] A model where the client and server are the same machine, used for debugging.
- [ ] A model where the server (our Flask app) *requests* data from the client (the browser).

### Question 5 (1 pt)
In Flask, what is the primary purpose of the `session` object?

- [ ] To define the URL routes (e.g., `@app.route('/')`).
- [ ] To run the built-in web server with the debug reloader.
- [ ] To describe the *entire* user interaction, from first click to last.
- [x] To store data (like a `user_id`) between individual requests, overcoming the "stateless" nature of HTTP.

### Question 6 (2 pts)
(Short Answer) Defend or refute the following statement in 3-5 sentences:

"The two most important types of software documentation are user reference material and comments in the source code."

### Question 7 (3 pts)
(Short Answer) Provide a definition of "domain knowledge" and describe its value in the context of our new **"Ministry of Jokes" (MoJ) project**. (3-5 sentences)