{ lib, ... }: {
  name = "nixos";
  host =
    {
      users ? { },
      aspects ? [ ],
      version ? null,
      ...
    }:
    let
      users' = builtins.mapAttrs (_: value: {
        inherit (value) normal name;
      }) users;
      aspects' = aspects ++ (lib.flatten (lib.mapAttrsToList (_: value: value.aspects) users));
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects')
    ++ [
      {
        system.stateVersion = lib.mkIf (version != null) version;
        users.users = builtins.mapAttrs (name: value: {
          name = value.name or name;
          isNormalUser = value.normal;
        }) users';
      }
    ];
}
