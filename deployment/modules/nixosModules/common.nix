{ self, inputs, ... }: {
  flake.nixosModules.common = { ... }: {
    imports = with self.nixosModules; [
      bootstrap
      secrets
      inputs.agenix.nixosModules.default
      app-user
      ssh-root
    ];

    #virtualisation.docker.enable = true;
    virtualisation.oci-containers = {
      backend = "podman";
      containers.envtest = {
        user = "999:999";
        image = "mendhak/http-https-echo:40";
        environmentFiles = [ "/run/agenix/.env" ];
        ports = [ "80:8080" "443:8443" ];
        pull = "newer";
      };
      #containers.test = {
      #  image = "nginx";
      #  ports = [ "80:80" ];
      #};
    };

    systemd.services."podman-envtest" = {
      after = [ "agenix.service" ];
      wants = [ "agenix.service" ];
      restartTriggers = [ config.age.secrets.".env".file ];
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}