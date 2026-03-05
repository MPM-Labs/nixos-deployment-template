# NixOS deployment template
_**Unfinished**_
The Purpose of this repo is to provide a template for deploying nixos to a server.
NixOS anywhere is used for the deployment itself.
This is the general idea:
1. You generate an ssh-keypair and store the public key on the server for root user(any linux distro).
2. You put the private key, IP adress, and desired hostname as GitHub repository secrets.
3. You run the bootstrap pipeline, which installs NixOS on the target machine, and crucially does a couple of things:
  - The template config in the repo is copied and given the desired hostname. It is placed under modules/hosts/[hostname].
  - That config is installed, and disko is used for partitioning.
  - The generated hardware config is uploaded to github and placed under modules/hosts/[hostname].
  - The machine config is changed to import the hardware config.
4. Using the module system, it is possible(and very useful) to have common baseline config imported in the template config.
5. Extra config and rebuilding is possible for all machines or specific machines.

This is designed to make it simpler to host staging servers and migrate servers for web projects and the like.

## WIP docs
The config in `modules/hosts/bootstrap` can be deployed with this mostrocity:
```bash
nix run github:nix-community/nixos-anywhere \
  -- --generate-hardware-config nixos-generate-config ./modules/hosts/bootstrap/_hardware-configuration.nix \
  --flake .#bootstrap \
  --target-host root@<IP> \
  -i /path/to/ssh_private_key
```

The following commands will copy the bootstrap config and module for a new config:
```bash
mkdir -p modules/hosts/$HOSTNAME

sed -e '/^[[:space:]]*#/d' \
  -e "s/bootstrapConfig/$HOSTNAME/" \
  modules/hosts/bootstrap/configuration.nix > modules/hosts/$HOSTNAME/configuration.nix

sed -e '/^[[:space:]]*#/d' \
  -e "s/bootstrapConfig/$HOSTNAME/" \
  modules/nixosModules/bootstrap-specific.nix > modules/nixosModules/$HOSTNAME-specific.nix
```