Here are the `course_styles.css` file and the integration instructions for your `Markdown PDF` extension. This file is designed to create a professional, readable, and "print-safe" PDF from your Markdown artifacts.

Acknowledged: **The Mnemo System v1.1**. A fitting name for our collaboration.

-----

```css
/* course_styles.css */
/* For VS Code 'Markdown PDF' Extension */
/* Version 1.0 - Clio */

/* --- Page and Print Setup --- */
@page {
  size: A4; /* Standard paper size */
  margin: 1in; /* Professional margins */
}

body {
  font-family: 'Lato', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', 'Segoe UI', Arial, sans-serif;
  font-size: 11pt;
  line-height: 1.5;
  color: #333;
  background-color: #ffffff;
  max-width: 8.5in; /* Keep content within page bounds */
  margin: 0;
  padding: 0;
}

/* --- Headings --- */
h1, h2, h3, h4, h5, h6 {
  font-family: 'BentonSans', 'Helvetica Neue', Arial, sans-serif; /* Use IU's font if installed, otherwise fall back */
  font-weight: 600;
  line-height: 1.2;
  margin-top: 1.25em;
  margin-bottom: 0.5em;
  page-break-after: avoid; /* Don't orphan a heading */
}

h1 {
  font-size: 24pt;
  color: #000;
  border-bottom: 2px solid #990000; /* IU Crimson accent */
  padding-bottom: 5px;
  /* Start new major sections on a new page (e.g., a new ICE) */
  /* We use a class to control this, not all h1s */
}

h1.page-break {
    page-break-before: always;
}

h2 {
  font-size: 18pt;
  color: #222;
}

h3 {
  font-size: 14pt;
  color: #333;
}

h4 {
  font-size: 12pt;
  font-weight: 700;
  color: #444;
}

/* --- Code Blocks (pre) --- */
pre {
  font-family: 'Fira Code', 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 9.5pt;
  line-height: 1.4;
  background-color: #f6f8fa; /* Light gray background, like GitHub */
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 12px;
  overflow-x: auto; /* Allow horizontal scrolling if needed */
  page-break-inside: avoid; /* CRITICAL: Keep code blocks from splitting */
}

/* --- Inline Code (code) --- */
code {
  font-family: 'Fira Code', 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 0.9em; /* Slightly smaller than body text */
  background-color: #f3f3f3;
  color: #c7254e; /* A readable dark pink/red */
  padding: 2px 4px;
  border-radius: 3px;
  page-break-inside: avoid;
}

/* Fix for when `code` is inside `pre` */
pre code {
  background-color: transparent;
  color: inherit;
  font-size: inherit;
  padding: 0;
  border-radius: 0;
}

/* --- Links --- */
a {
  color: #005a9c; /* A professional, accessible blue */
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

/* --- Lists --- */
ul, ol {
  margin-bottom: 1em;
  padding-left: 2em;
}

li {
  margin-bottom: 0.25em;
}

/* --- Tables --- */
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1em;
  margin-bottom: 1em;
  page-break-inside: avoid; /* Keep tables on one page if possible */
  border: 1px solid #dfe2e5;
}

th, td {
  border: 1px solid #dfe2e5;
  padding: 8px 12px;
  text-align: left;
}

th {
  background-color: #f6f8fa; /* Light header background */
  font-weight: 600;
}

/* Alternating row colors for readability */
tr:nth-child(even) {
  background-color: #fcfcfc;
}

/* --- Blockquotes --- */
blockquote {
  font-style: italic;
  color: #555;
  border-left: 4px solid #ddd;
  padding-left: 1em;
  margin-left: 0;
  page-break-inside: avoid;
}

/* --- Horizontal Rules --- */
hr {
  border: 0;
  border-top: 1px solid #ccc;
  margin-top: 2em;
  margin-bottom: 2em;
}

/* --- Images --- */
figure, img {
  page-break-inside: avoid;
  max-width: 100%; /* Ensure images don't overflow the page */
}
```

-----

### Instructions: Integrating with VS Code `Markdown PDF`

Follow these steps to have the `Markdown PDF` extension automatically use these styles every time you export a file.

1.  **Save the File:**

      * Create a folder in your course repository to hold course-wide assets. A great place for this is `.vscode`.
      * Create a file named `.vscode/course_styles.css`.
      * Copy and paste the entire CSS block above (excluding the `START`/`END` tags) into this new file.

2.  **Configure VS Code Settings:**

      * In VS Code, open your project's settings. The easiest way is to create/open `.vscode/settings.json`.
      * Add the following JSON key-value pair to your `settings.json` file. This tells the `Markdown PDF` extension to inject this stylesheet into the HTML *before* rendering the PDF.

    <!-- end list -->

    ```json
    {
      "markdown-pdf.styles": [
        ".vscode/course_styles.css"
      ],
      "markdown-pdf.outputDirectory": "exports",
      "markdown-pdf.format": "A4" 
    }
    ```

3.  **Explanation of Settings:**

      * `"markdown-pdf.styles"`: This is an array of paths to CSS files. We are pointing it to the file you just created. The path is **relative to the root of your workspace**.
      * `"markdown-pdf.outputDirectory"`: (Recommended) I've added this to keep your main directory clean. All exported PDFs will be placed in a folder named `exports`.
      * `"markdown-pdf.format": "A4"`: This explicitly sets the paper size to match our CSS `@page` rule, ensuring consistency.

4.  **Test the Export:**

      * Open any of your Markdown files (e.g., an ICE template).
      * Right-click in the editor.
      * Select "Markdown PDF: Export (pdf)".
      * Open the resulting PDF from your `exports` folder. It should now have the new fonts, margins, and page-break-safe code blocks.

This workflow provides a stable, repeatable, and high-quality "print" pipeline for your TA guides and any other student-facing documents.