args@{ lib, config, ... }:
let
  targetType =
    with lib.types;
    submodule {
      options = {
        name = lib.mkOption {
          type = str;
        };
        outputs = lib.mkOption {
          type = raw;
          default = _: { };
        };
        patches = lib.mkOption {
          type = attrsOf raw;
          default = { };
        };
      };
    };

  resolverType =
    with lib.types;
    submodule {

      freeformType = attrsOf raw;

      options = {
        name = lib.mkOption {
          type = str;
        };
      };
    };
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

                freeformType = lazyAttrsOf anything;

                options = {
                  target = lib.mkOption { type = either targetType raw; };
                  resolvers = lib.mkOption {
                    type = listOf (either resolverType raw);
                    default = [ ];
                  };
                };
              });
              default = { };
            };
            targets = lib.mkOption {
              type = attrsOf (either targetType raw);
              default = { };
            };
            resolvers = lib.mkOption {
              type = attrsOf (either resolverType raw);
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
