args@{ lib, ... }:
let

  bind = f: if builtins.isFunction f then f args else f;

  preprocess = { bundle, resolver }: {
    inherit bundle resolver;
    result = (bundle.target.${resolver.name} or (_: _)) (
      removeAttrs bundle [
        "target"
        "resolvers"
      ]
    );
  };

  resolve =
    {
      bundle,
      resolver,
      result,
    }:
    (resolver.${bundle.target.name} or (_: [ ])) result;

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
          resolve (preprocess {
            bundle = bundle // {
              target = bind bundle.target;
            };
            resolver = bind resolver;
          })
        ) bundle.resolvers
      );
    };

in
bundles:
builtins.foldl' lib.recursiveUpdate { } (
  builtins.attrValues (builtins.mapAttrs resolveBundle bundles)
)
