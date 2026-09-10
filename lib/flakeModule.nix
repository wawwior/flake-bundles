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
          };
        };
      default = { };
      description = "";
    };
  };

  config.flake = (import ./resolve.nix args) config.flake-bundles.bundles;
}
