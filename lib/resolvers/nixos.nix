{ lib, ... }: {
  name = "nixos";
  host =
    {
      users ? { },
      aspects ? [ ],
      ...
    }:
    let
      aspects' = aspects ++ (lib.flatten (lib.mapAttrsToList (_: value: value.aspects or [ ]) users));
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects')
    ++ [
      {
        users = {
          mutableUsers = lib.mkDefault false;
          groups = builtins.mapAttrs (name: _: { }) users;
          users = builtins.mapAttrs (name: value: {
            name = value.name or name;
            group = name;
            extraGroups = value.groups or [ ];
            isSystemUser = value.system or false;
            isNormalUser = !(value.system or false);
            openssh.authorizedKeys.keys = value.keys or [ ];
          }) users;
        };
      }
    ];
}
