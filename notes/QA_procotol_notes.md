# Notes concerning development of QA process

## Initial test of QA protocol on ICE09
1. Configuration of roles:
   1. Cloned repo for radmin, plead, dcrew from qa-ta repo
   2. One devaiation from instructions. We will branch fomr the tag for the last stage completion. `git branch -b 
   3. Setup corrections repo and basic structure for ice09
   4. Created a corrections.md file for ice09.
   5. When running the final test of the process lead I realized it never completed the templates. It left placeholders and expected a task in the ICE would cover the issue but Clio failed to include it in the ICE. When I pointed it out, Clio realized the mistake. 
   6. clio generated specific changes to insert into the ICE 9.
   7. The database issue was a nightmare
      1. `flask db upgrade` will create a db if it does not exist.
      2. The migrate is done when you have changed the model. It is tied to the repo commits. Each migration is part of achain. 
      3. need to make sure pip install is up to date in each transition.
      4. Need to upgrade the db in each transition as precaution.
      5. Determined the style to maintain the H1 and H2 in Canvas. I really need to add a stle to the pandoc sheet. 
      6. It royally screwed up the migrations by imagining it had to create one. I suspect this is an issue with GenAI having to think out loud so to speak to read its own thoughts.
   8. Finally retested everythign through the simulation and it went smoothly.

