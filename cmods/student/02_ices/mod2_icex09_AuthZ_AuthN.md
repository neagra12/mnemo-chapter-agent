





----

Here is the Team Readiness Statement for ICE 9.

This protocol should be inserted at the very top of your `mod2_ice09_AuthZ_AuthN.md` file, right after the main title and "Purpose" section. It is designed to be a "do-this-first" checklist.

-----

### Surgical Insertion for `mod2_ice09.md`

```html
<div style="background-color: #fcf8e3; border: 2px solid #c09853; padding: 12px 24px; margin: 20px 0px;">
    <h4><span style="color: #c09853;">🛑 Team Readiness Protocol (5 Minutes)</span></h4>
    <p>This ICE <strong>requires</strong> all your completed work from Cycle 1 (ICE 7, ICE 8, and HW3). The <strong>Repo Admin</strong> must share their screen and lead the entire team through these verification steps.</p>
    
    <ol>
        <li>
            <strong>Step 1: Verify Git Repository State (Single Source of Truth)</strong>
            <p>Run these commands from your terminal in the root of your project:</p>
            <pre style="background: #333; color: #fff; padding: 10px;">
$ git checkout main
$ git pull
$ git status</pre>
            <p>✅ <strong>CHECK:</strong> Does the output say: <code>Your branch is up to date with 'origin/main'.</code>?</p>
            <ul>
                <li>If **YES**, proceed.</li>
                <li>If **NO**, your `main` branch is not clean. This means your previous work (like the Linter Audit) is not merged. **STOP** and get your TA.</li>
            </ul>
        </li>
        <li>
            <strong>Step 2: Verify File Prerequisites</strong>
            <p>Run <code>ls</code> (Mac/Linux) or <code>dir</code> (Windows). You are verifying that the *results* of Cycle 1 are present.</p>
            <p>✅ <strong>CHECK:</strong> Do you see all of these files/folders in your root directory?</p>
            <ul>
                <li><code>moj/</code> (From the ICE 8 refactor)</li>
                <li><code>tests/test_routes.py</code> (From the ICE 8 test)</li>
                <li><code>.flake8</code> (From the HW3 Linter Audit)</li>
            </ul>
            <p>If you are missing *any* of these, your Cycle 1 work is not on <code>main</code>. **STOP** and get your TA.</p>
        </li>
        <li>
            <strong>Step 3: Verify Virtual Environment (Venv)</strong>
            <p>Run your `venv` activation command:</p>
            <pre style="background: #333; color: #fff; padding: 10px;">
# Mac/Linux
$ source venv/bin/activate
# Windows
$ .\venv\Scripts\activate</pre>
            <p>✅ <strong>CHECK:</strong> Does your terminal prompt now show <code>(venv)</code>?</p>
            <p>Now, run this command to check your installed packages:</p>
            <pre style="background: #333; color: #fff; padding: 10px;">(venv) $ pip freeze</pre>
            <p>✅ <strong>CHECK:</strong> Does the list show <code>flake8</code>, <code>pytest</code>, <code>Flask-SQLAlchemy</code>, and <code>Flask-Migrate</code>?</p>
            <ul>
                <li>If **YES**, you are ready.</li>
                <li>If **NO**, your venv is missing the Cycle 1 packages. Run <code>pip install -r requirements.txt</code>.</li>
            </ul>
        </li>
    </ol>
    <p><strong>Once all three steps are confirmed green ✅, the Repo Admin may proceed to Phase 1: Kit & Installation.</strong></p>
</div>
```