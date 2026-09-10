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
      cleanRoot =
        name: attrs:
        if name == "root" then
          removeAttrs attrs [
            "name"
            "group"
          ]
        else
          attrs;
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects')
    ++ [
      {
        users = {
          mutableUsers = lib.mkDefault false;
          groups = builtins.mapAttrs (name: _: { }) users;
          users = builtins.mapAttrs (
            name: value:
            cleanRoot name {
              name = value.name or name;
              group = name;
              hashedPassword = lib.mkIf ((value.password or null) != null) value.password;
            }
          ) users;
        };
      }
    ];
}
