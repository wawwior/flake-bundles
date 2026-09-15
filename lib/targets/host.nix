{
  inputs,
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
        specialArgs = {
          inherit inputs;
        };
        inherit (bundle) system;
        inherit modules;
      };
    };
}
