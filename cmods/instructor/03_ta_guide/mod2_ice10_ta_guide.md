# TA Guide & Rubric

  * **Goal:** This ICE tests two "Read" skills: fetching a *single object* (`User.query.first_or_404()`) and fetching a *filtered list* (`Joke.query.filter_by(author=user)`). It's the core of relational data.
  * **Common Pitfalls:**
    1.  **`AttributeError: 'NoneType' object has no attribute 'username'`:** This will happen if a student uses `.first()` instead of `.first_or_404()` for a user that doesn't exist. The reflection question is designed to make them catch this.
    2.  **`BuildError` (for `url_for`):** The `Process Lead` will get this error if they forget to pass `username=current_user.username` into the `url_for('profile', ...)` in `_navigation.html`. This is a key teaching moment about dynamic routes.
    3.  **`UndefinedError: 'user' is undefined`:** The `Dev Crew` built the route, but the `Process Lead` forgot to pull the changes before starting the template.

\+-------------------------------------------------------------+-----------------+
| Criteria                                                    | Points          |
\+=============================================================+=================+
| **`CONTRIBUTIONS.md` Log (3 pts)** | / 3             |
| - File is completed with all fields (roles, summary).       |                 |
| - Reflection question is answered thoughtfully.             |                 |
\+-------------------------------------------------------------+-----------------+
| **Profile Route Logic (4 pts)** | / 4             |
| - `moj/routes.py` has a new, dynamic `@app.route(...)`     |                 |
| - Route correctly queries for the `User` (using `first_or_404`).|               |
| - Route correctly queries for the filtered `Joke` list.     |                 |
\+-------------------------------------------------------------+-----------------+
| **Templates & Links (3 pts)** | / 3             |
| - `moj/templates/profile.html` exists and renders the user/jokes.|              |
| - `_navigation.html` has a working "My Profile" link.       |                 |
| - `index.html` has working links on author usernames.       |                 |
\+-------------------------------------------------------------+-----------------+
| **Total** | \*\* / 10\*\* |
\+-------------------------------------------------------------+-----------------+

## Canvas-Optimized HTML Snippet

```html
<table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;" summary="Grading rubric for ICE 10">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th style="width: 70%; padding: 12px; border: 1px solid #ccc; text-align: left;">Criteria</th>
            <th style="width: 30%; padding: 12px; border: 1px solid #ccc; text-align: right;">Points</th>
        </tr>
    </thead>
    <tbody>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong><code>CONTRIBUTIONS.md</code> Log (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li>File is completed with all fields (roles, summary).</li>
                    <li>Reflection question is answered thoughtfully.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr>
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Profile Route Logic (4 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>moj/routes.py</code> has a new, dynamic <code>@app.route(...)</code></li>
                    <li>Route correctly queries for the <code>User</code> (using <code>first_or_404</code>).</li>
                    <li>Route correctly queries for the filtered <code>Joke</code> list.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 4</td>
        </tr>
        <tr style="background-color: #f9f9f9;">
            <td style="padding: 12px; border: 1px solid #ccc; vertical-align: top;">
                <strong>Templates &amp; Links (3 pts)</strong>
                <ul style="margin-top: 5px; margin-bottom: 5px; padding-left: 20px;">
                    <li><code>moj/templates/profile.html</code> exists and renders the user/jokes.</li>
                    <li><code>_navigation.html</code> has a working "My Profile" link.</li>
                    <li><code>index.html</code> has working links on author usernames.</li>
                </ul>
            </td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; vertical-align: top;">/ 3</td>
        </tr>
        <tr style="background-color: #f2f2f2;">
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">Total</td>
            <td style="padding: 12px; border: 1px solid #ccc; text-align: right; font-weight: bold;">/ 10</td>
        </tr>
    </tbody>
</table>
```
