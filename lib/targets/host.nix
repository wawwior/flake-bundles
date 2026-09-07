{
  lib,
  ...
}:
{
  name = "host";
  outputs =
    {
      name,
      bundle,
      modules,
    }:
    {
      nixosConfigurations.${name} = lib.nixosSystem {
        inherit (bundle) system;
        inherit modules;
      };
    };
}
