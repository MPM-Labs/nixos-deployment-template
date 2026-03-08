{ inputs, self, ... }: {
  flake.nixosConfigurations.production = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      bootstrap
      production-specific # Yes this is jank, see the bootstrap configuration.nix or readme for more details
      disk-config
      ./_hardware-configuration.nix
      {
        networking.hostName = "production";
      }
    ];
  };
}