#!/bin/bash

export PORT=5104

cd ~/www/tasktracker2
./bin/tasktracker2 stop || true
./bin/tasktracker2 start
