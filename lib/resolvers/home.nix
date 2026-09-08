{ inputs, lib, ... }:
{
  name = "home";
  host =
    {
      aspects ? [ ],
      users ? { },
      version ? null,
      ...
    }:
    let
      users' = builtins.mapAttrs (_: value: value.aspects) users;
    in
    [
      {
        imports = [ inputs.home-manager.nixosModules.default ];

        home-manager = {
          sharedModules = map (aspect: aspect.resolve { class = "home"; }) aspects ++ [
            {
              home.stateVersion = lib.mkIf (version != null) version;
            }
          ];
          users = builtins.mapAttrs (_: aspects: {
            imports = map (aspect: aspect.resolve { class = "home"; }) aspects;
          }) users';
        };
      }
    ];
}
