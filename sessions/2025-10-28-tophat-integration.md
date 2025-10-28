# Tophat integration investgation

# **---- PROMPT ----**
```markdown
Yes, let's take a look at this for ICE 7. I consider these pretty much done unless something comes up in my TA's test runs. So I want any additions for TopHat to be surgical updates rather than rewrites at this point.
```

Yes, this is a perfect, "surgical" addition. It adds the data-gathering mechanism without rewriting any of the core instructions.

We will add a single, non-intrusive `<div>` block right after the "Role Kit" section. This places it "above the fold" so students see it immediately, but it doesn't interrupt the main task flow.

-----

### 1\. The New HTML Block

Here is the new HTML block to add. It creates a "callout box" for the TopHat Checkpoints.

```html
<div style="background-color: #f5f5f5; border: 2px dashed #990000; padding: 12px 24px; margin: 20px 0px;">
    <h4><span style="color: #990000;">📈 Triage Dashboard (TopHat)</span></h4>
    <p>As your team completes each major part of the ICE, the <strong>team member who completed the part</strong> should check in on TopHat. This is <em>not</em> a race and is <em>not</em> a public leaderboard. This is our private "Triage Dashboard" to help us see if you're blocked.</p>
    <p>All checkpoints are open from the start. Please log them as you go:</p>
    <ul style="margin-top: 0px;">
        <li><strong>Checkpoint 1:</strong> Part 1 Complete (Branch &amp; Install)</li>
        <li><strong>Checkpoint 2:</strong> Part 2 Complete (DB Config)</li>
        <li><strong>Checkpoint 3:</strong> Part 3 Complete (Models Defined)</li>
        <li><strong>Checkpoint 4:</strong> Part 4 Complete (Migration Succeeded)</li>
        <li><strong>🔴 BLOCKED:</strong> We are stuck and need TA help.</li>
    </ul>
</div>
```

-----

### 2\. Where to Paste It

In your **Canvas HTML Editor (`</>`)** for the **ICE 7** assignment page, find the end of the "Role Kit" section.

You will see this HTML:

```html
<li><strong><code>Dev Crew</code>:</strong> (Feature) Defines the data schema... </li>
</ul>
<hr />
<h3 id="task-description-commissioning-the-filing-system">Task Description: ...</h3>
```

**Paste the new HTML block** right on that blank line *after* the `</ul>` and *before* the `<hr />`, like this:

```html
<li><strong><code>Dev Crew</code>:</strong> (Feature) Defines the data schema... </li>
</ul>

<div style="background-color: #f5f5f5; border: 2px dashed #990000; padding: 12px 24px; margin: 20px 0px;">
    <h4><span style="color: #990000;">📈 Triage Dashboard (TopHat)</span></h4>
    <p>As your team completes each major part of the ICE, ...</p>
    </div>
<hr />
<h3 id="task-description-commissioning-the-filing-system">Task Description: ...</h3>
```

This will place the "Triage Dashboard" callout box neatly between the Role Kit and the first task, exactly as you wanted.

# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



# **---- PROMPT ----**
```markdown

```



