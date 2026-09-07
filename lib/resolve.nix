args@{ lib, ... }:
let

  bind = f: if builtins.isFunction f then f args else f;

  resolve =
    {
      bundle,
      resolver,
    }:
    (resolver.${bundle.target.name} or (_: [ ])) (
      removeAttrs bundle [
        "target"
        "resolvers"
      ]
    );

  produce =
    {
      name,
      bundle,
      modules,
    }:
    bundle.target.outputs {
      inherit name modules;
      bundle = removeAttrs bundle [
        "target"
        "resolvers"
      ];
    };

  resolveBundle =
    name: bundle:
    produce {
      inherit name;
      bundle = bundle // {
        target = bind bundle.target;
      };
      modules = lib.flatten (
        map (
          resolver:
          resolve {
            bundle = bundle // {
              target = bind bundle.target;
            };
            resolver = bind resolver;
          }
        ) bundle.resolvers
      );
    };

in
bundles:
builtins.foldl' lib.recursiveUpdate { } (
  builtins.attrValues (builtins.mapAttrs resolveBundle bundles)
)
