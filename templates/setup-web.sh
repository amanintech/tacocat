#!/bin/bash

# Setup logging
logfile="/home/${admin_username}/custom-data.log"
exec > $logfile 2>&1

python3 -V
sudo apt update
sudo apt install -y python3-pip python3-flask
python3 -m flask --version

sudo cat << SCRIPT > /home/${admin_username}/hello.py
from flask import Flask
import requests

app = Flask(__name__)

import requests
@app.route('/')
def hello_world():
    return """<!DOCTYPE html>
<html>
<head>
    <title>Kittens from ${vm_name}</title>
</head>
<body>
    <h1>Kittens say Meow from the ${project} project!</h1>
    <img src="https://placekitten.com/200/300" alt="User Image">
</body>
</html>"""
SCRIPT

chmod +x /home/${admin_username}/hello.py

sudo -b FLASK_APP=/home/${admin_username}/hello.py flask run --host=0.0.0.0 --port=${flask_port}

