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

## Configuration variables

repo_dir: "/directory/of/the/cloned/repo/on/the/filesystem/"  
Clone your repo to a nearby directory. Subsequent pull operations have to
be accomplished without typing in login credentials. In our case the server
side of the repo (the directory with the .git) extension is elsewhere on the
same server, so pull operations are very cheap and don't require credentials. If
you don't have local filesystem access, it might be a good idea to create an
account for gitwatch and allow it to clone using public key authentication.

alert_file: "alert-list.md"  
The Alert file is just a file in the repository that lists the email addresses
that alerts should be sent to. Email addresses are extracted using a regular
expression, so structure and organization of the file doesn't matter as long
as it's text. In our case, we'er using a markdown file and editing it from
gitlab's web interfaces.

md_link_prefix: "https://urlprefixtoyourfiles/"  
This link and link prefix is used to create href links within the alert email.
Clicking on this link should take you to the repository.

smtp_subject: "A descriptive subject"  
smtp_username: nerfed-for-github  
smtp_password: nerfed-for-github  
smtp_server: email-smtp.us-east-1.amazonaws.com  
smtp_from: Gitlab <noreply@whereeveryourgitlabis.com>  
smtp_port: 465  
smtp_max_recepients_per_email: 50  
These email configuration options should be self explanatory. This code was
developed using AWS SES but should work with any smtp server.
