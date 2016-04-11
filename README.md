# Gitwatch
Gitwatch is a generic method for sending email alerts when commits happen to a git repo.

[[ https://raw.githubusercontent.com/datamachines/gitwatch/master/logo.gif ]]

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
Clone your repo to a nearby directory, this should be that directory.
Subsequent pull operations have to
be accomplished without typing in login credentials. In our case the server
side of the repo (the directory with the .git extension) is elsewhere on the
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

## Scheduling and runtime
On first run, gitwatch will do nothing but record the current time to a runfile
in it's local directory. In this runfile, the current time is recorded. Subsequent
runs of gitwatch will use and maintain this time as a basis for determining which
commits should generate email alerts. Only commits that happen after the time in this
file will generate email alerts.

The run.sh file contains code which updates your local copy of the repository.
Since there are many ways to do this, you'll have to decide what works best for you.
In our case, we change directory to the code respository and then issue a 'git pull'
command. The next command in the run.sh initiates the gitwatch.py script by pointing
it at the location of your configuration file. We recommend copying run.sh and the
configuration file outside of the gitwatch directory and giving them both descriptive
names. That way, new repositories can be watched by copying and configuring more of
these files.

Scheduling of the watcher can be initiated in any way. To keep it simple, we
just used cron. A more robust solution might be to add a loop to your version
of run.sh and manage it in supervisord.

To add your run.sh script to cron and run it every minute, type 'crontab -e' and
add the following line to your cron file:

    * * * * * /full/path/to/your/descriptively-named-run.sh

After that, you're done.

## Using this to watch GitLab wikis.
Gitlab and Github wikis use Gollum. Github has a nice API for tracking changes,
you should use that if your wiki is there. Gitlab is a bit trickier. The repositories
for wikis aren't exposed through the normal user interface, but they are available
on the file system of the server. Unfortunately, when the Gitlab web UI commits to them
no hooks are triggered, so we have to poll for changes.

To use Gitwatch to watch a Gitlab wiki, login
to your Gitlab server, go to the directory you want the cloned repo to reside,
and then issue the following command:

    git clone /var/opt/gitlab/git-data/repositories/YOUR-WIKI-NAME/

The prompt will say "cloning into ....". After that you can go into that directory
and issue 'git pull' commands via the Gitwatch run.sh to get the latest commits
and generate alerts.

## Roadmap
This project is pretty much done. It serves the purpose it was needed for and there
are no plans for improvement at this time.

If you do end up using git hooks to send email alerts showing changes, the gitwatch.py
script is probably useful. If you end up doing this in reusable and useful way, please
send a pull request to this repo so we can document that use case. I know it's possible
I just haven't done it yet. Using a hook would be much cleaner than using cron.
