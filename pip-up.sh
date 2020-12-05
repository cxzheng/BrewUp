#!/bin/bash

yellow=$(tput setaf 3)
reset=$(tput sgr0)

echo "${yellow}==>${reset} Updating pip3 packages..."
pip3 freeze --user | cut -d'=' -f1 | xargs -n1 pip3 install -U


