{
  description = "composable stuff";

  outputs =
    { ... }:
    {
      flakeModule = import ./lib/flakeModule.nix;

      flakeBundleResolvers = {
        nixos = import ./lib/resolvers/nixos.nix;
        disko = import ./lib/resolvers/disko.nix;
        home = import ./lib/resolvers/home.nix;
      };

      flakeBundleTargets = {
        host = import ./lib/targets/host.nix;
      };
    };
}
