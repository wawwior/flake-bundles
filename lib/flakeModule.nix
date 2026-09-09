args@{ lib, config, ... }:
let
  types = import ./types.nix args;
in
{
  options = {
    flake-bundles = lib.mkOption {
      type =
        with lib.types;
        submodule {
          options = {
            bundles = lib.mkOption {
              type = attrsOf (submodule {

                freeformType = lazyAttrsOf types.anythingConcatLists;

                options = {
                  target = lib.mkOption { type = raw; };
                  resolvers = lib.mkOption {
                    type = listOf raw;
                    default = [ ];
                  };
                };
              });
              default = { };
            };
            targets = lib.mkOption {
              type = attrsOf raw;
              default = { };
            };
            resolvers = lib.mkOption {
              type = attrsOf raw;
              default = { };
            };
          };
        };
      default = { };
      description = "";
    };
  };

  config.flake =
    (import ./resolve.nix args) config.flake-bundles.bundles
    // (lib.optionalAttrs (config.flake-bundles.targets != { }) {
      flakeBundleTargets = config.flake-bundles.targets;
    })
    // (lib.optionalAttrs (config.flake-bundles.resolvers != { }) {
      flakeBundleResolvers = config.flake-bundles.resolvers;
    });
}
