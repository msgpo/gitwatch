#!/bin/sh
# Update your local copy of the repo and run the script
cd /your/repo/
git pull
cd /location/of/script
python gitwatch.py config-example.yaml
