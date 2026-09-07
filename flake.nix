{
  description = "composable stuff";

  outputs =
    { ... }:
    {
      flakeModule = import ./lib/flakeModule.nix;

      flakeBundleResolvers = {
        nixos = import ./lib/resolvers/nixos.nix;
        home = import ./lib/resolvers/home.nix;
      };

      flakeBundleTargets = {
        host = import ./lib/targets/host.nix;
      };
    };
}
