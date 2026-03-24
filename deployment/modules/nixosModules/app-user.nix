{ ... }: {
  flake.nixosModules.app-user = { ... }: {
    users.users.app = {
      isNormalUser = true;
      home = "/home/app";
      extraGroups = [ "networkmanager" "app" ];
    };
    users.groups.app = {};
  };
}