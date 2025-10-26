## Slide 3: "Brownfield" Data: The MFE Problem
- **Key Point:** Let's connect your `Angband` experience (Part 1) to our new "greenfield" problem (Part 2).
- **Remember your Monster File Editor (MFE)?**
- **The "Simple" Task:** Edit a monster in `monster.txt`.
- **The *Actual* Problem:** To *validate* a monster's "blows," you also had to manually read, parse, and cross-reference `blow_effects.txt` and `blow_methods.txt`.

| `monster.txt` (One line) | `blow_effects.txt` |
| :--- | :--- |
| `N:Orc:G:o:....` | `1:HURT` |
| `B:CLAW:HURT:1d6` | `2:POISON` |
| `B:BITE:POISON:1d8`| `3:COLD` |

- The **relationship** between these files was *implicit*. It existed only in the C code's logic, and you had to re-build it from scratch in Python.
- **This is a "flat-file database," and it's a nightmare of data integrity problems.**
- **Speaker Note:** "For your MFE, you had to write custom Python code to manually 'join' these files. What happens if a game designer adds a new blow effect but forgets to tell you? Your MFE breaks. What if you add a blow that *doesn't exist* in the effects file? The game crashes. This is a **data integrity** problem, and it's the exact problem SQL was invented to solve."