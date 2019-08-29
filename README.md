# stage1_terraform

## Overview

When building out a new or migrating an existing environment using Terraform, it's difficult to know initially what path to take on what a module should look like, where it should go or even how to maintain it initially.  As technologists we simply do not know what it should look like until we've iterated on things a few times.  If we build modules too early, we are likely to find that the module ends up being a hampering factor rather than helpful as we mature.  This mean that during the initial stage, while we want to avoid hard coding things into configs, but we do want to parameterize what we can to make our code flexible and that is what this repo is to help set an example of how to leverage tfvars for overrides and secrets, an HCL file to help with remote state determination and lastly a simple wrapper script to help manage it all.  This is AWS based, but there's little reason for me to believe it can't be leveraged in GCP, Azure, ESXi or other TF supported platforms.

What this stage is doing for us is providing the same code to use everywhere that each resource has a count parameter that we can set to 0 if that env does not actually need those particular resources, or in other ways manage what we need and where.

Later stages will introduce higher code quality standards, introduce modularization and will ultimately go all the way to full blown CI/CD when we know what our mature code base looks like.  Again, this is the stage where we are purely learning what that will look like for our specific organization.

**NOTE:** This repo will may or may not have working Terraform configurations.  This repo is about showing early stage Terraform code structure and as such there was a lot of copy/paste to create it and while find and replace is handy, sometimes things get missed and the configs have not been tested to actually work, however the layout and the script does do exactly as described.

## Specifics

These configs are broken down into 2 paths.  The first is for account level configurations.  These are mainly to build out the account and create the VPC(s) we may wish to have.  The other directory is the underlying environments and work loads that will be doing the actual work we're wanting to perform or services we would provide.  These will pull outputs from the above account level infrastructure.

### Account level

Inside this directory you'll see there's 2 additional directories.  One for Shared infra services and then one for dev.  Over time there would likely be more depending on how your environment is built out.  I would suspect that at least a production would be added.

These configurations are the 'parent' of anything else we build and as such needs to be applied first.  Downstream will be using various outputs that are provided here.

### Environment level

This level consumes upstream outputs and will usually have its own variables to manage instant count, types, storage etc.  But they also could be outputs from the account level if there's going to be a large amount of similarities between the various different roles and instances being used.  Either way, this is where the rubber meets the road and we start to deploy actual things.

## Usage

### Terraform code layout

The script is pretty rigid what files it's looking for in the nested directory.  This is specifically for code quality and supportability so that any one working with the Terraform code knows what is where.  They specifically need to be named:

- overrides.tfvars
- secrets.tfvars
- remote_state_config.hcl

To apply the terraform code to a different region or environment one just needs to create a directory for the region (e.g. us-east-2) and add the necessary variable overrides.tfvars for that region and a secrets.tfvars so no credentials, keys, etc. get checked into source control.  Due to Terraform not interpolating variables early enough to use for the state file, we also need to add in an HCL file.  Currently s3_config.hcl is the standard but I opted to go with something a bit more descriptive.

Since we have a remote state file and it should be the source of truth for what Terraform believes is there, each time terraform is run the .terraform/ directory is removed and an init is performed to look at the correct state files rather than working with a local copy that may or may not be the same as remote state.

### The script

The `tf_wrapper.py` script in the root of this repo is the work horse of this whole thing.  It is written for python3.6 so you will need to have **python3.6** installed in your path.  The script points to the CentOS location, so Mac users may need to invoked python3.6 and pass the script to it.  The script will print out a simple usage if you don't provide it with some additional parameters, but usage is:

```
tf_wrapper.py [plan|apply|destroy] [directory_of_configs]
```

Specifically it reconfigures the main repo for the config each time so that the source state must be pulled from S3.  For best results, create a symlink to it in a directory in your $PATH.  If this is on a shared system it may be fine to place it in /usr/local/bin, otherwise it might make more sense for a $HOME/bin added to your $PATH.
