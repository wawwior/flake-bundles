{ inputs, lib, ... }:
{
  name = "home";
  host =
    {
      aspects ? [ ],
      users ? { },
      ...
    }:
    let
      users' = builtins.mapAttrs (_: value: value.aspects or [ ]) users;
    in
    [
      {
        imports = [ inputs.home-manager.nixosModules.default ];

        home-manager = {
          useGlobalPkgs = lib.mkDefault true;
          useUserPackages = lib.mkDefault true;
          sharedModules = map (aspect: aspect.resolve { class = "home"; }) aspects;
          users = builtins.mapAttrs (_: aspects: {
            imports = map (aspect: aspect.resolve { class = "home"; }) aspects;
          }) users';
        };
      }
    ];
}
