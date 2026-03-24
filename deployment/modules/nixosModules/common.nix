{ self, inputs, ... }: {
  flake.nixosModules.common = { ... }: {
    imports = with self.nixosModules; [
      bootstrap
      secrets
      inputs.agenix.nixosModules.default
      app-user
      ssh-root
    ];
  };
}