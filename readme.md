# NixOS Everywhere
_**Unfinished**_

_**Please do not use this tool without understanding the code and the risks involved. This tool is unfinished, and unfit for use with high stakes deployment. It relies on string manipulation of several files that may break if the included workflows or config files are modified. The tool is meant for personal projects. It has only been tested with Hetzner cloud VPSs. Use with other servers may need reconfiguring of disk-config.nix.**_

The Purpose of this repo is to provide a template for deploying nixos to a server.
NixOS anywhere is used for the deployment itself.

## Who is this tool for?
This tool exists to automate and manage deployments that meet the following criteria:
- **NixOS-based**: The server configuration is a NixOS configuration. This is what is actually deployed to the machine.
- **Public codebase**: I use this for personal open-source projects and have not accounted for private codebases. The code may be adapted if this is a requirement for you.
- **Secrets are stored in environment variables**: The only built in secrets management is designed to bake github environment variables and secrets into a .env encrypted with agenix.
- **Single server**: The deployment consists of a single server.

## What problem does this solve?
The tool allows you to take a declarative NixOS deployment, and manage updates for that deployment via github actions.
For example, say you have a web app. You may want a staging server along with a production server. This tool allows you to write a single NixOS config and put all your secrets and environment-specific config in the github repo.
You can use the 2 supplied actions, `Bootstrap host` and `Update host` to configure and deploy any number of servers running this config.
The generated config files for each deployment is commited to github, allowing easy updates and configuration of one or more specific hosts without affecting others.

## How to use
The tool is designed to be forked and integrated into a project codebase or maintained as a seperate project.
After cloning the repo, you must configure:
- SSH_ROOT_KEY (secret): A private key that will have root access to all hosts.
- SSH_AGENIX_KEY (secret): A private key that will have access to encrypted secrets(may not actually be necessary).

The next step is creating an environment for a new deployment. This environments name will be used as the hostname of the machine.
The environment only requires 1 secret: `IP_ADDRESS`. IPv6 is not supported on github runners(and may have issues with nixos-anywhere).

You only need to equip the server you are deploying to with the public key corresponding to SSH_ROOT_KEY, and the `Bootstrap host` workflow is ready to be triggered.
Running it will:
1. Create a config based on the bootstrap config to install barebones NixOS.
2. Generate an agenix-key for secret access.
3. Re-encrypt secrets to include the new key.
4. Swap the bootstrap module for a `common` module that includes agenix, granting access to secrets and env-config.
5. Run nixos-rebuild switch to change to the full config.

Running the `Update host` workflow simply reincrypts environment and runs nixos-rebuild switch.

### Configuring environment
In order to configure environment, you have several options:
1. For config that is shared no matter the deployment and are not secret, you can simply place env variables in .env.template.
2. For config that varies between envs and is not secret, you can configure them in the deployment environment, and use ${vars.ENV_VAR} in .env.template.
3. For config that is secret, you can configure them in the deployment environment, and use ${secrets.ENV_VAR} in .env.template.

The .env file is made available on the running machine at `/run/agenix/.env` and is readable by the `app` user, that you may use in your deployment.

### Configuring hosts
You can configure the NixOS install in modules/nixosModules/common.nix. Changes to this file affect all hosts, but only once they are updated with the included action.

#### Configuring a specific host
You can configure any one host with the generated [hostname]-specific.nix file, found in modules/nixosModules.