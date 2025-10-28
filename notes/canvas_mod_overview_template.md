<div id="dp-wrapper" class="dp-wrapper">
    <h2 style="background-color: #990000; width: 100%; text-align: left; padding-left: 30px;"><strong><span style="color: #ffffff;">Week 10: Building the Foundation (Databases, Refactoring &amp; Quality)</span></strong></h2>
    <p>&nbsp;</p>
    <h2 style="margin-top: 18px; background-color: #f3f2eb; border-bottom: 5px inset #990000;"><strong>&nbsp;Introduction</strong></h2>
    <p>Welcome to Week 10. This week is the most critical "level-up" of the entire module. We are moving beyond simple scripts and building the professional foundation for our "Ministry of Jokes" application. In Lecture 3, we'll use our past "pain" from the <code>Angband</code> flat files to justify why we use a structured database, and you'll build your first models and migrations with SQLAlchemy. In Lecture 4, we'll perform a major "refactor" to evolve our simple <code>app.py</code> script into a scalable, professional <code>moj/</code> package. We'll then immediately build our first automated "safety nets" (<code>pytest</code> and <code>flake8</code>) to protect our new architecture.</p>
    <p>This week also introduces a critical new course policy: the <strong>Standard Blocker Protocol (SBP)</strong>. This protocol is your "safe harbor" when you get stuck on a technical error during an ICE. If you are individually blocked for more than 15 minutes, you can "invoke the SBP." This means you'll stop coding, create a new branch, and file a detailed <strong>After-Action Report (AAR)</strong> as a pull request. Submitting this AAR on time guarantees you 5/10 points (our "B for good work"), and you'll earn the final 5 points after applying the instructor's fix. This policy is designed to reward professional communication and diagnostic effort, not just a perfect result.</p>
    <p>&nbsp;</p>
    <h2 style="margin-top: 18px; background-color: #f3f2eb; border-bottom: 5px inset #990000;"><strong>&nbsp;Weekly Learning Objectives</strong></h2>
    <p>By the end of this week, your team will be able to:</p>
    <ul>
        <li>Justify the use of an ORM (SQLAlchemy) over flat files by referencing your <code>Angband</code> experience.</li>
        <li>Define database models (<code>User</code>, <code>Joke</code>) and run your first schema migration (<code>flask db upgrade</code>).</li>
        <li>Describe the core trade-offs between SQL (Postgres) and NoSQL (MongoDB) databases.</li>
        <li>Describe and execute the Standard Blocker Protocol (SBP) by filing an After-Action Report (AAR).</li>
        <li>Refactor a single-file Flask app (<code>app.py</code>) into a scalable, professional package (<code>moj/</code>).</li>
        <li>Write a <code>pytest</code> fixture (<code>conftest.py</code>) and your first unit test for a Flask route.</li>
        <li>Implement an automated <code>flake8</code> linter to enforce PEP 8 style.</li>
        <li>Add a new, parallel "Lint" job to an existing GitHub Actions CI pipeline (<code>main.yml</code>).</li>
    </ul>
    <p>&nbsp;</p>
    <p><strong>Tuesday Lecture (Lec 3: Databases, Models, &amp; SBP)</strong></p>
    <p>Morning Class (11:10AM-12:25PM Luddy 1106)</p>
    <p>Pending</p>
    <p>Evening Class (5:30PM-6:45PM Ballantine Hall 003</p>
    <p>Pending</p>
    <p><strong>Thursday Lecture (Lec 4: Refactoring, Testing, &amp; Linting)</strong></p>
    <p>Morning Class (11:10AM-12:25PM Luddy 1106)</p>
    <p>Pending</p>
    <p>Evening Class (5:30PM-6:45PM Ballantine Hall 003</p>
    <p>Pending</p>
    <h2 style="margin-top: 18px; background-color: #f3f2eb; border-bottom: 5px inset #990000;"><strong>&nbsp;</strong><strong>Readings and Resources</strong></h2>
    <p>Use these official docs as a primary reference for this week's topics. The lecture slides are your guide; these are your technical manuals.</p>
    <ul>
        <li><strong>Lecture 3 (Databases &amp; Models):</strong>
            <ul>
                <li><a href="https://flask-sqlalchemy.palletsprojects.com/en/3.1.x/quickstart/" target="_blank" rel="noopener">Flask-SQLAlchemy: Quickstart Guide</a> (The official docs for connecting Flask to SQLAlchemy).</li>
                <li><a href="https://flask-migrate.readthedocs.io/en/latest/" target="_blank" rel="noopener">Flask-Migrate: Official Documentation</a> (The docs for our schema migration tool).</li>
                <li><a href="https://www.mongodb.com/compare/sql-vs-nosql" target="_blank" rel="noopener">MongoDB: SQL vs. NoSQL Explained</a> (Supports your <code>MongoDB</code> weekly challenge).</li>
            </ul>
        </li>
        <li><strong>Lecture 4 (Refactoring &amp; Quality):</strong>
            <ul>
                <li><a href="https://flask.palletsprojects.com/en/3.0.x/patterns/packages/" target="_blank" rel="noopener">Flask Docs: Larger Applications</a> (The official pattern for our <code>app.py</code>-to-<code>moj/</code> refactor).</li>
                <li><a href="https://docs.pytest.org/en/latest/getting-started.html" target="_blank" rel="noopener">Pytest: Get Started</a> (The official docs for our testing framework).</li>
                <li><a href="https://pytest-flask.readthedocs.io/en/latest/" target="_blank" rel="noopener">Pytest-Flask Documentation</a> (The extension that gives us the <code>client</code> fixture).</li>
                <li><a href="https://peps.python.org/pep-0008/" target="_blank" rel="noopener">PEP 8 -- Style Guide for Python Code</a> (The *rules* we are enforcing with <code>flake8</code>).</li>
            </ul>
        </li>
    </ul>
    <p>&nbsp;</p>
    <h2 style="margin-top: 18px; background-color: #f3f2eb; border-bottom: 5px inset #990000;"><strong>&nbsp;To-Do This Week</strong></h2>
    <p><strong>Team Readiness Checklist (Verify Before Class):</strong></p>
    <p>Ensure your <code>main</code> branch is ready for this week's workshops. Your team's <code>Repo Admin</code> should verify:</p>
    <ul>
        <li>[ ] <strong>Repository:</strong> The team repository is accessible to all members.</li>
        <li>[ ] <strong>Application:</strong> The <code>app.py</code> file exists and successfully runs a "Hello World" Flask app.</li>
        <li>[ ] <strong>CI Pipeline:</strong> The <code>.github/workflows/main.yml</code> file exists from ICE 2.</li>
        <li>[ ] <strong>Process Log:</strong> The <code>CONTRIBUTIONS.md</code> file exists and has complete log entries for ICE 1 and ICE 2.</li>
        <li>[ ] <strong>Team Roles:</strong> The team has reviewed the roles from last week and is prepared to rotate.</li>
    </ul>
    <p><strong>This Week's Deliverables:</strong></p>
    <ul>
        <li><strong>SUBMIT:</strong> ICE 7: The Ministry's Filing Cabinet</li>
        <li><strong>SUBMIT:</strong> ICE 8: Enforcing Quality (The Refactoring Workshop)</li>
        <li><strong>SUBMIT:</strong> Homework 3: The Linter Audit</li>
        <li><strong>SUBMIT:</strong> Weekly Challenge: AI-Assisted Tech Evaluation (MongoDB)</li>
    </ul>
</div>