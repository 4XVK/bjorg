#!/usr/bin/env bash
HISTSIZE=0
set +o history

#TODO this

read -p "Create database tunnel? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "no"
fi