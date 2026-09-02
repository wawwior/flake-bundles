args@{ lib, config, ... }:
let
  targetType =
    with lib.types;
    submodule {

      freeformType = attrsOf raw;

      options = {
        name = lib.mkOption {
          type = str;
        };
        outputs = lib.mkOption {
          type = raw;
          default = _: { };
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
        attrsOf (submodule {

          freeformType = lazyAttrsOf anything;

          options = {
            target = lib.mkOption {
              type = either targetType raw;
            };
            resolvers = lib.mkOption {
              type = listOf (either resolverType raw);
              default = [ ];
            };
          };
        });
      default = { };
      description = "";
    };
  };

  config.flake = (import ./resolve.nix args) config.flake-bundles;
}
