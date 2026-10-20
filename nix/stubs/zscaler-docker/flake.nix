# Stand-in for the private zscaler-docker input (git+ssh), for a first build
# on a machine without a GitHub SSH key yet: nix/bootstrap.sh passes it with
# --override-input. It accepts the real module's options and does nothing;
# the next `make switch`, with the key, brings the real one.
{
  outputs = _: {
    nixosModules.zscaler = { lib, ... }: {
      options.services.zscaler = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
        description = "Accepted and ignored until the real zscaler-docker is reachable.";
      };
    };
  };
}
