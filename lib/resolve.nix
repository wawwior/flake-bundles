args@{ lib, ... }:
let

  bind = f: if builtins.isFunction f then f args else f;

  preprocess = bundle: lib.pipe bundle bundle.preprocessors;

  resolve =
    {
      bundle,
      resolver,
    }:
    (resolver.${bundle.target.name} or bundle.target.patches.${resolver.name} or (_: [ ])) (
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

  bindBundle =
    bundle:
    bundle
    // {
      target = bind bundle.target;
      resolvers = map bind bundle.resolvers;
    };

  resolveBundle =
    name: bundle:
    produce {
      inherit name bundle;
      modules = lib.flatten (
        map (
          resolver:
          resolve {
            bundle = {
              inherit (bundle) target resolvers;
            }
            // preprocess (
              removeAttrs bundle [
                "target"
                "resolvers"
              ]
            );
            inherit resolver;
          }
        ) bundle.resolvers
      );
    };

in
bundles:
builtins.foldl' lib.recursiveUpdate { } (
  builtins.attrValues (
    builtins.mapAttrs (name: bundle: resolveBundle name (bindBundle bundle)) bundles
  )
)
