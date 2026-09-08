{ lib, ... }: {
  name = "nixos";
  host =
    {
      users ? { },
      aspects ? [ ],
      ...
    }:
    let
      aspects' = aspects ++ (lib.flatten (lib.mapAttrsToList (_: value: value.aspects) users));
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects')
    ++ [
      {
        users = {
          mutableUsers = lib.mkDefault false;
          users = builtins.mapAttrs (name: value: {
            name = value.name or name;
            isNormalUser = value.normal or lib.mkDefault false;
            openssh.authorizedKeys.keys = value.keys or [ ];
          }) users;
        };
      }
    ];
}
