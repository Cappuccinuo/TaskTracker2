#!/bin/bash

export PORT=5103

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start

