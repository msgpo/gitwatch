# gitwatch
A generic method for sending email alerts when commits happen to a git repo.

This is a hack that shouldn't exist in a perfect world. This is only useful
when there is no other way monitor changes or updates to a code repository.
When possible, git hooks, APIs, or other organic methods should be used.

This program was necessary to provide email alerts when a private gitlab wiki
page is updated. Hooks weren't fired and there was no native functionality
for alerting at the time of this writing. So here we are. 

## Use
Step 1: Copy the file config-example.yaml to a safe place and edit the variables.  
Step 2: Edit run.sh and add it to a cron job that runs as often as you want updates.   
Step 3: Profit.
