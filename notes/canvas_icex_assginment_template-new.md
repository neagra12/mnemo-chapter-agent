<h1 id="ice-7-the-ministrys-filing-cabinet">ICE 7: The Ministry&rsquo;s Filing Cabinet</h1>
<ul>
    <li><strong>Objective:</strong> Define the core database models (<code>User</code>, <code>Joke</code>) using SQLAlchemy and create the initial <strong>SQLite</strong> database migration.</li>
    <li><strong>Time Limit:</strong> 25 minutes</li>
    <li><strong>Context:</strong> The Ministry of Jokes can&rsquo;t just shout &ldquo;Hello World!&rdquo; into the void; it needs to <em>store</em> the jokes it receives. This exercise builds the &ldquo;digital filing cabinet&rdquo; (the database schema) that will form the foundation of our application. We&rsquo;ll use <strong>SQLite</strong> for this first cycle because it&rsquo;s simple, file-based, and lets us focus on the <em>models</em> without worrying about a separate database server.</li>
</ul>
<hr />
<h2 id="role-kit-selection-strategy-1-parallel-processing">Role Kit Selection (Strategy 1: Parallel Processing ⚡)</h2>
<p>For this ICE, we will use the <strong>Database Architect Kit</strong>. Assign these three roles immediately. <em>Remember the course policy: You cannot hold the same role for more than two consecutive weeks.</em></p>
<ul>
    <li><strong><code>Repo Admin</code>:</strong> (Environment) Installs new Python packages, updates <code>requirements.txt</code>, and handles all Git operations (branching, committing, PR).</li>
    <li><strong><code>Process Lead</code>:</strong> (Integration) Configures the Flask app (<code>app.py</code> or <code>__init__.py</code>) to connect to the SQLite database and initializes the <code>flask-migrate</code> tool.</li>
    <li><strong><code>Dev Crew</code>:</strong> (Feature) Defines the data schema by writing and completing the <code>User</code> and <code>Joke</code> models in a new <code>models.py</code> file.</li>
</ul>
<hr />
<h2 id="task-description-commissioning-the-filing-system">Task Description: Commissioning the Filing System</h2>
<h3 id="part-1-branch-and-install-repo-admin">Part 1: Branch and Install (Repo Admin)</h3>
<ol type="1">
    <li>
        <p>Pull the latest <code>main</code> branch.</p>
    </li>
    <li>
        <p>Create a new feature branch named <code>ice7-models-and-migrations</code>.</p>
    </li>
    <li>
        <p>In your active virtual environment (<code>venv</code>), install the new packages:</p>
        <div id="cb1" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true"></a><span class="ex">pip</span> install flask-sqlalchemy flask-migrate</span></code></pre>
        </div>
    </li>
    <li>
        <p>Update your <code>requirements.txt</code> file:</p>
        <div id="cb2" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true"></a><span class="ex">pip</span> freeze <span class="op">&gt;</span> requirements.txt</span></code></pre>
        </div>
    </li>
    <li>
        <p><code>git add requirements.txt</code> and <code>git commit -m "feat: add sqlalchemy and migrate packages"</code>.</p>
    </li>
    <li>
        <p><em>Communicate to the Process Lead and Dev Crew that the branch is ready.</em></p>
    </li>
</ol>
<h3 id="part-2-configure-the-database-process-lead">Part 2: Configure the Database (Process Lead)</h3>
<ol type="1">
    <li>
        <p>Ensure you are on the <code>ice7-models-and-migrations</code> branch (<code>git checkout ice7-models-and-migrations</code> &amp; <code>git pull</code>).</p>
    </li>
    <li>
        <p>Open your main application file (e.g., <code>app.py</code> or <code>project/__init__.py</code>).</p>
    </li>
    <li>
        <p>Add the following Python code to configure the app. <em>Place imports at the top and configuration logic near your <code>app = Flask(...)</code> line.</em></p>
        <div id="cb3" class="sourceCode">
            <pre class="sourceCode python"><code class="sourceCode python"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true"></a><span class="im">import</span> os</span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true"></a><span class="im">from</span> flask_sqlalchemy <span class="im">import</span> SQLAlchemy</span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true"></a><span class="im">from</span> flask_migrate <span class="im">import</span> Migrate</span>
<span id="cb3-4"><a href="#cb3-4" aria-hidden="true"></a></span>
<span id="cb3-5"><a href="#cb3-5" aria-hidden="true"></a><span class="co"># Get the absolute path of the directory this file is in</span></span>
<span id="cb3-6"><a href="#cb3-6" aria-hidden="true"></a>basedir <span class="op">=</span> os.path.abspath(os.path.dirname(<span class="va">__file__</span>))</span>
<span id="cb3-7"><a href="#cb3-7" aria-hidden="true"></a></span>
<span id="cb3-8"><a href="#cb3-8" aria-hidden="true"></a><span class="co"># ... (your existing app = Flask(...) line) ...</span></span>
<span id="cb3-9"><a href="#cb3-9" aria-hidden="true"></a></span>
<span id="cb3-10"><a href="#cb3-10" aria-hidden="true"></a><span class="co"># --- Database Configuration ---</span></span>
<span id="cb3-11"><a href="#cb3-11" aria-hidden="true"></a><span class="co"># Use SQLite. The database file will be named 'moj.db'</span></span>
<span id="cb3-12"><a href="#cb3-12" aria-hidden="true"></a><span class="co"># and stored in the same directory as this file.</span></span>
<span id="cb3-13"><a href="#cb3-13" aria-hidden="true"></a>app.config[<span class="st">'SQLALCHEMY_DATABASE_URI'</span>] <span class="op">=</span> <span class="st">'sqlite:///'</span> <span class="op">+</span> os.path.join(basedir, <span class="st">'moj.db'</span>)</span>
<span id="cb3-14"><a href="#cb3-14" aria-hidden="true"></a>app.config[<span class="st">'SQLALCHEMY_TRACK_MODIFICATIONS'</span>] <span class="op">=</span> <span class="va">False</span></span>
<span id="cb3-15"><a href="#cb3-15" aria-hidden="true"></a></span>
<span id="cb3-16"><a href="#cb3-16" aria-hidden="true"></a>db <span class="op">=</span> SQLAlchemy(app)</span>
<span id="cb3-17"><a href="#cb3-17" aria-hidden="true"></a>migrate <span class="op">=</span> Migrate(app, db)</span>
<span id="cb3-18"><a href="#cb3-18" aria-hidden="true"></a><span class="co"># --- End Database Configuration ---</span></span></code></pre>
        </div>
    </li>
    <li>
        <p><strong>CRITICAL:</strong> The <code>moj.db</code> file is your database. It should <em>never</em> be committed to Git. Open your <code>.gitignore</code> file and add this line to the bottom:</p>
        <pre><code># Local database file
moj.db</code></pre>
    </li>
    <li>
        <p><code>git add .gitignore app.py</code> (or <code>project/__init__.py</code>) and <code>git commit -m "config: initialize sqlalchemy and migrate for sqlite"</code>.</p>
    </li>
    <li>
        <p><em>Communicate to the Dev Crew that the <code>db</code> object is ready to be used.</em></p>
    </li>
</ol>
<h3 id="part-3-define-the-models-dev-crew">Part 3: Define the Models (Dev Crew)</h3>
<ol type="1">
    <li>
        <p>Ensure you are on the <code>ice7-models-and-migrations</code> branch and have pulled the Process Lead&rsquo;s changes (<code>git pull</code>).</p>
    </li>
    <li>
        <p>Create a new file: <code>project/models.py</code>.</p>
    </li>
    <li>
        <p>Add the following code to <code>project/models.py</code>. <strong>Your task is to fill in the commented-out stubs</strong> based on the comments and the worked examples.</p>
        <div id="cb5" class="sourceCode">
            <pre class="sourceCode python"><code class="sourceCode python"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true"></a><span class="co"># We must import the 'db' object from our main app file</span></span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true"></a><span class="im">from</span> app <span class="im">import</span> db </span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true"></a><span class="co"># Or, if using a factory pattern: from . import db</span></span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true"></a><span class="im">import</span> datetime</span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true"></a></span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true"></a><span class="kw">class</span> User(db.Model):</span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true"></a>    <span class="co"># --- "I" (Worked Example) ---</span></span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true"></a>    <span class="co"># Here is a complete, working example for you to copy.</span></span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true"></a>    <span class="bu">id</span> <span class="op">=</span> db.Column(db.Integer, primary_key<span class="op">=</span><span class="va">True</span>)</span>
<span id="cb5-10"><a href="#cb5-10" aria-hidden="true"></a>    username <span class="op">=</span> db.Column(db.String(<span class="dv">80</span>), unique<span class="op">=</span><span class="va">True</span>, nullable<span class="op">=</span><span class="va">False</span>)</span>
<span id="cb5-11"><a href="#cb5-11" aria-hidden="true"></a>    password_hash <span class="op">=</span> db.Column(db.String(<span class="dv">128</span>))</span>
<span id="cb5-12"><a href="#cb5-12" aria-hidden="true"></a></span>
<span id="cb5-13"><a href="#cb5-13" aria-hidden="true"></a>    <span class="co"># --- "WE" (Guided Practice) ---</span></span>
<span id="cb5-14"><a href="#cb5-14" aria-hidden="true"></a>    <span class="co"># Complete the definitions below using the worked example as a guide.</span></span>
<span id="cb5-15"><a href="#cb5-15" aria-hidden="true"></a></span>
<span id="cb5-16"><a href="#cb5-16" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the email column</span></span>
<span id="cb5-17"><a href="#cb5-17" aria-hidden="true"></a>    <span class="co"># Requirements: String(120), unique, cannot be null</span></span>
<span id="cb5-18"><a href="#cb5-18" aria-hidden="true"></a>    <span class="co">#email = db.Column(...)</span></span>
<span id="cb5-19"><a href="#cb5-19" aria-hidden="true"></a></span>
<span id="cb5-20"><a href="#cb5-20" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the role column</span></span>
<span id="cb5-21"><a href="#cb5-21" aria-hidden="true"></a>    <span class="co"># Requirements: String(20), cannot be null, default value is 'user'</span></span>
<span id="cb5-22"><a href="#cb5-22" aria-hidden="true"></a>    <span class="co"># role = db.Column(...)</span></span>
<span id="cb5-23"><a href="#cb5-23" aria-hidden="true"></a></span>
<span id="cb5-24"><a href="#cb5-24" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Uncomment this relationship *after* you define the Joke model</span></span>
<span id="cb5-25"><a href="#cb5-25" aria-hidden="true"></a>    <span class="co">#jokes = db.relationship('Joke', backref='author', lazy=True)</span></span>
<span id="cb5-26"><a href="#cb5-26" aria-hidden="true"></a></span>
<span id="cb5-27"><a href="#cb5-27" aria-hidden="true"></a>    <span class="kw">def</span> <span class="fu">__repr__</span>(<span class="va">self</span>):</span>
<span id="cb5-28"><a href="#cb5-28" aria-hidden="true"></a>        <span class="cf">return</span> <span class="ss">f'&lt;User </span><span class="sc">{</span><span class="va">self</span><span class="sc">.</span>username<span class="sc">}</span><span class="ss">&gt;'</span></span>
<span id="cb5-29"><a href="#cb5-29" aria-hidden="true"></a></span>
<span id="cb5-30"><a href="#cb5-30" aria-hidden="true"></a><span class="kw">class</span> Joke(db.Model):</span>
<span id="cb5-31"><a href="#cb5-31" aria-hidden="true"></a>    <span class="co"># --- "YOU" (Independent Practice) ---</span></span>
<span id="cb5-32"><a href="#cb5-32" aria-hidden="true"></a>    <span class="co"># Now, define this entire model based on what you learned from User.</span></span>
<span id="cb5-33"><a href="#cb5-33" aria-hidden="true"></a></span>
<span id="cb5-34"><a href="#cb5-34" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the id column</span></span>
<span id="cb5-35"><a href="#cb5-35" aria-hidden="true"></a>    <span class="co"># Requirements: Integer, primary key</span></span>
<span id="cb5-36"><a href="#cb5-36" aria-hidden="true"></a>    <span class="co">#id = db.Column(...)</span></span>
<span id="cb5-37"><a href="#cb5-37" aria-hidden="true"></a></span>
<span id="cb5-38"><a href="#cb5-38" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the joke_text column</span></span>
<span id="cb5-39"><a href="#cb5-39" aria-hidden="true"></a>    <span class="co"># Requirements: Text (use db.Text), cannot be null</span></span>
<span id="cb5-40"><a href="#cb5-40" aria-hidden="true"></a>    <span class="co">#joke_text = db.Column(...)</span></span>
<span id="cb5-41"><a href="#cb5-41" aria-hidden="true"></a></span>
<span id="cb5-42"><a href="#cb5-42" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the created_at column</span></span>
<span id="cb5-43"><a href="#cb5-43" aria-hidden="true"></a>    <span class="co"># Requirements: DateTime, cannot be null, default to the current time</span></span>
<span id="cb5-44"><a href="#cb5-44" aria-hidden="true"></a>    <span class="co"># Hint: You'll need `default=datetime.datetime.utcnow`</span></span>
<span id="cb5-45"><a href="#cb5-45" aria-hidden="true"></a>    <span class="co">#created_at = db.Column(...)</span></span>
<span id="cb5-46"><a href="#cb5-46" aria-hidden="true"></a></span>
<span id="cb5-47"><a href="#cb5-47" aria-hidden="true"></a>    <span class="co"># </span><span class="al">TODO</span><span class="co">: Define the user_id (foreign key)</span></span>
<span id="cb5-48"><a href="#cb5-48" aria-hidden="true"></a>    <span class="co"># Requirements: Integer, foreign key to 'user.id', cannot be null</span></span>
<span id="cb5-49"><a href="#cb5-49" aria-hidden="true"></a>    <span class="co"># Hint: Use `db.ForeignKey('user.id')`</span></span>
<span id="cb5-50"><a href="#cb5-50" aria-hidden="true"></a>    <span class="co"># user_id = db.Column(...)</span></span>
<span id="cb5-51"><a href="#cb5-51" aria-hidden="true"></a></span>
<span id="cb5-52"><a href="#cb5-52" aria-hidden="true"></a>    <span class="kw">def</span> <span class="fu">__repr__</span>(<span class="va">self</span>):</span>
<span id="cb5-53"><a href="#cb5-53" aria-hidden="true"></a>        <span class="cf">return</span> <span class="ss">f'&lt;Joke </span><span class="sc">{</span><span class="va">self</span><span class="sc">.</span><span class="bu">id</span><span class="sc">}</span><span class="ss">&gt;'</span></span></code></pre>
        </div>
    </li>
    <li>
        <p><strong>CRITICAL STEP:</strong> The migration tool needs to &ldquo;see&rdquo; these models. Go back to your <em>main app file</em> (<code>app.py</code> or <code>project/__init__.py</code>) and add this import <em>after</em> the <code>migrate = Migrate(app, db)</code> line:</p>
        <div id="cb6" class="sourceCode">
            <pre class="sourceCode python"><code class="sourceCode python"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true"></a><span class="co"># Import models so migrations tool can find them</span></span>
<span id="cb6-2"><a href="#cb6-2" aria-hidden="true"></a><span class="im">from</span> project <span class="im">import</span> models </span></code></pre>
        </div>
    </li>
    <li>
        <p><code>git add project/models.py app.py</code> (or <code>project/__init__.py</code>) and <code>git commit -m "feat: define User and Joke models"</code>.</p>
    </li>
    <li>
        <p><em>Push your commits.</em></p>
    </li>
</ol>
<h3 id="part-4-run-the-first-migration-process-lead-repo-admin">Part 4: Run the First Migration (Process Lead &amp; Repo Admin)</h3>
<ol type="1">
    <li>
        <p><strong>Repo Admin:</strong> Pull all commits from the Dev Crew (<code>git pull</code>).</p>
    </li>
    <li>
        <p><strong>Process Lead:</strong> Share your screen.</p>
    </li>
    <li>
        <p><strong>Process Lead:</strong> Run the <strong>one-time-only</strong> init command. This creates the <code>migrations/</code> directory.</p>
        <div id="cb7" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true"></a><span class="ex">flask</span> db init</span></code></pre>
        </div>
        <ul>
            <li><strong>Verification:</strong> You will see a new <code>migrations</code> folder appear in your project.</li>
        </ul>
    </li>
    <li>
        <p><strong>Process Lead:</strong> Run the migration generator. This &ldquo;reads&rdquo; your models and writes the migration script.</p>
        <div id="cb8" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true"></a><span class="ex">flask</span> db migrate <span class="at">-m</span> <span class="st">"Initial User and Joke models"</span></span></code></pre>
        </div>
        <ul>
            <li><strong>Verification:</strong> You will see output like <code>INFO [alembic.autogenerate.compare] Detected new table 'user'</code> and <code>...Detected new table 'joke'</code>. A new script will appear in <code>migrations/versions/</code>.</li>
        </ul>
    </li>
    <li>
        <p><strong>Process Lead:</strong> Apply the migration to your database.</p>
        <div id="cb9" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true"></a><span class="ex">flask</span> db upgrade</span></code></pre>
        </div>
    </li>
    <li>
        <p><strong>Process Lead (Verification):</strong></p>
        <ul>
            <li>You will see output like: <code>INFO [alembic.runtime.migration] Running upgrade ... -&gt; ...</code></li>
            <li><strong>Crucially:</strong> A new file named <code>moj.db</code> should now exist in your project (in the same directory as your <code>app.py</code>). This is your new SQLite database file!</li>
        </ul>
    </li>
    <li>
        <p><strong>Repo Admin:</strong> You should now see the <code>migrations/</code> directory.</p>
        <div id="cb10" class="sourceCode">
            <pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true"></a><span class="fu">git</span> add migrations/</span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true"></a><span class="fu">git</span> commit <span class="at">-m</span> <span class="st">"chore: add initial migration script"</span></span></code></pre>
        </div>
    </li>
    <li>
        <p><strong>Repo Admin:</strong> Push all new commits to the remote branch (<code>git push</code>).</p>
    </li>
</ol>
<hr />
<h2 id="contributions.md-log-entry"><code>CONTRIBUTIONS.md</code> Log Entry</h2>
<p><em>One team member share their screen.</em> Open <code>CONTRIBUTIONS.md</code> on your feature branch and add the following entry <strong>using this exact format</strong>:</p>
<pre><code>```markdown
#### ICE 7: The Ministry's Filing Cabinet
* **Date:** 2025-10-27
* **Team Members Present:** `@github-user1`, `@github-user2`, ...
* **Roles:**
    * `Repo Admin`: `@github-userX`
    * `Process Lead`: `@github-userY`
    * `Dev Crew`: `@github-userZ`, ...
* **Summary of Work:** Defined the `User` and `Joke` SQLAlchemy models, configured the Flask app to use **SQLite**, and generated the initial database migration.
* **Evidence &amp; Reflection:** In the `Angband` project, all "data" was stored in flat `.txt` files (e.g., `monster.txt`). What specific, practical problems will using a relational database (like SQLite) and an ORM (like SQLAlchemy) solve for the Ministry of Jokes project?
```</code></pre>
<p><em>After logging, commit and push this file. All other members must <code>git pull</code> to get the change.</em></p>
<hr />
<h2 id="definition-of-done-dod">Definition of Done (DoD) 🏁</h2>
<p>Your team&rsquo;s work is &ldquo;Done&rdquo; when you can check all of the following:</p>
<ul class="task-list">
    <li><strong>Artifact:</strong> <code>requirements.txt</code> is updated with <code>flask-sqlalchemy</code> and <code>flask-migrate</code>.</li>
    <li><strong>Artifact:</strong> <code>project/models.py</code> exists and is <em>fully completed</em> (no commented-out stubs).</li>
    <li><strong>Artifact:</strong> The Flask app is configured for SQLite.</li>
    <li><strong>Artifact:</strong> <code>.gitignore</code> is updated to ignore <code>moj.db</code>.</li>
    <li><strong>Artifact:</strong> A <code>migrations/</code> directory exists with a successful, committed migration script.</li>
    <li><strong>Process:</strong> <code>CONTRIBUTIONS.md</code> is updated and <em>all team members</em> have the pulled file locally.</li>
    <li><strong>Submission:</strong> A Pull Request is open and correctly configured (see below).</li>
</ul>
<hr />
<h2 id="Rubric">Rubric</h2>
<table style="width: 100%; border-collapse: collapse;">
    <thead>
        <tr style="background-color: #f2f2f2;">
            <th style="border: 1px solid #ddd; padding: 12px; text-align: left;">Criteria</th>
            <th style="border: 1px solid #ddd; padding: 12px; text-align: center;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="border: 1px solid #ddd; padding: 12px;"><code>requirements.txt</code> updated &amp; <code>.gitignore</code> ignores <code>moj.db</code></td>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: center;">1</td>
        </tr>
        <tr>
            <td style="border: 1px solid #ddd; padding: 12px;"><code>project/models.py</code> complete &amp; Flask app configured for SQLite</td>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: center;">3</td>
        </tr>
        <tr>
            <td style="border: 1px solid #ddd; padding: 12px;"><code>migrations/</code> directory present and committed with script</td>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: center;">3</td>
        </tr>
        <tr>
            <td style="border: 1px solid #ddd; padding: 12px;"><code>CONTRIBUTIONS.md</code> log complete with roles and reflection</td>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: center;">3</td>
        </tr>
        <tr>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: right;"><strong>Total</strong></td>
            <td style="border: 1px solid #ddd; padding: 12px; text-align: center;"><strong>10</strong></td>
        </tr>
    </tbody>
</table>
<hr />
<h2 id="submission-due-by-end-of-class">Submission (Due by end of class)</h2>
<ol type="1">
    <li><strong>Open Pull Request:</strong> Open a new PR to merge your feature branch (<code>ice7-models-and-migrations</code>) into <code>main</code>.</li>
    <li><strong>Title:</strong> <code>ICE 7: The Ministry's Filing Cabinet</code></li>
    <li><strong>Reviewer:</strong> Assign your <strong>Team TA</strong> as a &ldquo;Reviewer.&rdquo;</li>
    <li><strong>Submit to Canvas:</strong> Submit the URL of the Pull Request to the Canvas assignment.</li>
</ol>
<hr />
<h2 id="standard-blocker-protocol-sbp">💡 Standard Blocker Protocol (SBP)</h2>
<p><strong>If you are individually blocked for &gt; 15 minutes</strong> on a technical error you cannot solve, you can invoke the SBP. This is an <em>individual</em> protocol to protect your on-time grade.</p>
<ol type="1">
    <li><strong>Notify Team:</strong> Inform your team that you are invoking the SBP and pivot to helping them with a different task (e.g., documentation, testing, research).</li>
    <li><strong>Create Branch:</strong> Create a new <em>individual</em> branch (e.g., <code>aar-ice7-kseiffert</code>).</li>
    <li><strong>Create AAR File:</strong> Create a new file in your repo: <code>aar/AAR-ICE7-&lt;your_github_username&gt;.md</code>.</li>
    <li><strong>Copy &amp; Complete:</strong> Copy the template below into your new file and fill it out completely.</li>
    <li><strong>Submission (Part 1 - 5 pts):</strong> Open a Pull Request to merge your AAR branch into <code>main</code>.
        <ul>
            <li><strong>Title:</strong> <code>AAR ICE 7: &lt;Brief Description of Blocker&gt;</code></li>
            <li><strong>Reviewer:</strong> Assign your <strong>Instructor</strong> as a &ldquo;Reviewer.&rdquo;</li>
            <li><strong>Submit to Canvas:</strong> Submit the URL of <em>your AAR Pull Request</em> to this Canvas assignment. This counts as your on-time submission.</li>
        </ul>
    </li>
    <li><strong>Submission (Part 2 - 5 pts):</strong> After the instructor provides a hotfix in the PR, you will apply it, achieve the original DoD, and <strong>resubmit your <em>passing</em> PR</strong> <em>to this same assignment</em> to receive the final 5 points.</li>
</ol>
<hr />
<h2 id="aar-template-copy-into-aaraar-ice7-....md">AAR Template (Copy into <code>aar/AAR-ICE7-....md</code>)</h2>
<div id="cb12" class="sourceCode">
    <pre class="sourceCode markdown"><code class="sourceCode markdown"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true"></a><span class="fu"># AAR for ICE 7: [Blocker Title]</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true"></a></span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true"></a><span class="ss">* </span>**Student:** <span class="in">`@your-github-username`</span></span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true"></a><span class="ss">* </span>**Timestamp:** <span class="in">`2025-10-27 @ HH:MM`</span></span>
<span id="cb12-5"><a href="#cb12-5" aria-hidden="true"></a></span>
<span id="cb12-6"><a href="#cb12-6" aria-hidden="true"></a>---</span>
<span id="cb12-7"><a href="#cb12-7" aria-hidden="true"></a></span>
<span id="cb12-8"><a href="#cb12-8" aria-hidden="true"></a><span class="fu">### Instructor's Diagnostic Hints</span></span>
<span id="cb12-9"><a href="#cb12-9" aria-hidden="true"></a><span class="ss">* </span>**Hint 1:** Migration tool says "No changes detected"? Check your main <span class="in">`app.py`</span>. Did you remember to <span class="in">`import`</span> your <span class="in">`models.py`</span> file *after* you defined the <span class="in">`migrate`</span> object?</span>
<span id="cb12-10"><a href="#cb12-10" aria-hidden="true"></a><span class="ss">* </span>**Hint 2:** <span class="in">`NameError: 'db' is not defined`</span>? Check the top of <span class="in">`models.py`</span>. Did you correctly import the <span class="in">`db`</span> object (e.g., <span class="in">`from app import db`</span>)?</span>
<span id="cb12-11"><a href="#cb12-11" aria-hidden="true"></a><span class="ss">* </span>**Hint 3:** <span class="in">`AttributeError`</span> or <span class="in">`ImportError`</span> on startup? This is often a circular import. Check that your <span class="in">`from project import models`</span> line in <span class="in">`app.py`</span> comes *after* <span class="in">`db = SQLAlchemy(app)`</span> and <span class="in">`migrate = Migrate(app, db)`</span>.</span>
<span id="cb12-12"><a href="#cb12-12" aria-hidden="true"></a></span>
<span id="cb12-13"><a href="#cb12-13" aria-hidden="true"></a>---</span>
<span id="cb12-14"><a href="#cb12-14" aria-hidden="true"></a></span>
<span id="cb12-15"><a href="#cb12-15" aria-hidden="true"></a><span class="fu">### 1. The Blocker</span></span>
<span id="cb12-16"><a href="#cb12-16" aria-hidden="true"></a>*(What is the *symptom*? What is the *exact* error message?)*</span>
<span id="cb12-17"><a href="#cb12-17" aria-hidden="true"></a></span>
<span id="cb12-18"><a href="#cb12-18" aria-hidden="true"></a><span class="at">&gt; </span><span class="co">[</span><span class="ot">Paste error message or describe symptom</span><span class="co">]</span></span>
<span id="cb12-19"><a href="#cb12-19" aria-hidden="true"></a></span>
<span id="cb12-20"><a href="#cb12-20" aria-hidden="true"></a><span class="fu">### 2. The Investigation</span></span>
<span id="cb12-21"><a href="#cb12-21" aria-hidden="true"></a>*(What *exactly* did you try? List the commands you ran, files you edited, and Stack Overflow links you read.)*</span>
<span id="cb12-22"><a href="#cb12-22" aria-hidden="true"></a></span>
<span id="cb12-23"><a href="#cb12-23" aria-hidden="true"></a><span class="ss">* </span>I tried...</span>
<span id="cb12-24"><a href="#cb12-24" aria-hidden="true"></a><span class="ss">* </span>Then I edited...</span>
<span id="cb12-25"><a href="#cb12-25" aria-hidden="true"></a><span class="ss">* </span>This Stack Overflow post suggested...</span>
<span id="cb12-26"><a href="#cb12-26" aria-hidden="true"></a></span>
<span id="cb12-27"><a href="#cb12-27" aria-hidden="true"></a><span class="fu">### 3. The Root Cause Hypothesis</span></span>
<span id="cb12-28"><a href="#cb12-28" aria-hidden="true"></a>*(Based on your investigation, what do you *think* is the real problem? Try to be specific.)*</span>
<span id="cb12-29"><a href="#cb12-29" aria-hidden="true"></a></span>
<span id="cb12-30"><a href="#cb12-30" aria-hidden="true"></a><span class="at">&gt; I believe the problem is...</span></span>
<span id="cb12-31"><a href="#cb12-31" aria-hidden="true"></a></span>
<span id="cb12-32"><a href="#cb12-32" aria-hidden="true"></a><span class="fu">### 4. Evidence</span></span>
<span id="cb12-33"><a href="#cb12-33" aria-hidden="true"></a>*(Paste the *full* terminal output, relevant code snippets, or screenshots that support your hypothesis.)*</span>
<span id="cb12-34"><a href="#cb12-34" aria-hidden="true"></a></span>
<span id="cb12-35"><a href="#cb12-35" aria-hidden="true"></a>  (Paste full logs here)</span>
<span id="cb12-36"><a href="#cb12-36" aria-hidden="true"></a></span>
<span id="cb12-37"><a href="#cb12-37" aria-hidden="true"></a></span>
<span id="cb12-38"><a href="#cb12-38" aria-hidden="true"></a><span class="fu">### 5. The "Aha!" Moment (if any)</span></span>
<span id="cb12-39"><a href="#cb12-39" aria-hidden="true"></a>*(Did you have a moment of clarity or discover the solution just as you were writing this?)*</span>
<span id="cb12-40"><a href="#cb12-40" aria-hidden="true"></a></span>
<span id="cb12-41"><a href="#cb12-41" aria-hidden="true"></a><span class="at">&gt; </span><span class="co">[</span><span class="ot">Describe your realization, or N/A</span><span class="co">]</span></span>
<span id="cb12-42"><a href="#cb12-42" aria-hidden="true"></a></span>
<span id="cb12-43"><a href="#cb12-43" aria-hidden="true"></a><span class="fu">### 6. The Learning</span></span>
<span id="cb12-44"><a href="#cb12-44" aria-hidden="true"></a>*(What new, specific thing did you learn from this? What will you do *differently* next time?)*</span>
<span id="cb12-45"><a href="#cb12-45" aria-hidden="true"></a></span>
<span id="cb12-46"><a href="#cb12-46" aria-hidden="true"></a><span class="at">&gt; I learned that...</span></span>
<span id="cb12-47"><a href="#cb12-47" aria-hidden="true"></a></span>
<span id="cb12-48"><a href="#cb12-48" aria-hidden="true"></a><span class="fu">### 7. The Remaining Question</span></span>
<span id="cb12-49"><a href="#cb12-49" aria-hidden="true"></a>*(What do you *still* not understand? What is the *one key question* you need answered to get unblocked?)*</span>
<span id="cb12-50"><a href="#cb12-50" aria-hidden="true"></a></span>
<span id="cb12-51"><a href="#cb12-51" aria-hidden="true"></a><span class="at">&gt; My one question is...</span></span></code></pre>
</div>