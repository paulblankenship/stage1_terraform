#!/usr/bin/python3.6

# wrapper script for use with Terraform to ensure our configs are clean each
# time and we are able to maintain state in S3.  For sanity, I opted to leave
# the prompts from Terraform that says you really want to do whatever action
# it is you're about to perform until some level of sane testing is adopted.

import os
import subprocess
import shutil
import sys

def usage():
    print("\nUsage: " + sys.argv[0] + " [plan|apply|destroy] [directory_of_configs]\n")

def tf_exe( action, path ):
    if os.path.exists('.terraform'):
        shutil.rmtree('.terraform/')
    subprocess.check_call(["terraform", "init", "-backend-config=" + path + "/remote_state_config.hcl"])
    subprocess.check_call(["terraform", action, "-var-file=" + path + "/overrides.tfvars", "-var-file=" + path + "/secrets.tfvars"])

if len(sys.argv) < 3:
    usage()
    sys.exit(1)

arg = sys.argv[1]

if arg == 'plan' or arg =='apply' or arg == 'destroy':
    tf_exe(sys.argv[1], sys.argv[2])
else:
    usage()
