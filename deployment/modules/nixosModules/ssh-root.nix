{ ... }: {
  flake.nixosModules.ssh-root = { ... }: {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqVpl7w1HPMm5GPqTAMXKbBdPEiRZzMPqHwWI9EtoyT" # Bootstrap key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4BdXgpvrAV1m4S/djUnrNsdUDInRJcFzzriE9G+zyo" # FOR TESTING ONLY
    ];
  };
}