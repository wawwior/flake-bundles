{ lib, ... }: {
  name = "user";
  host =
    {
      users ? { },
      ...
    }:
    let
      aspects = lib.flatten (lib.mapAttrsToList (_: value: value.aspects) users);
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects)
    ++ [
      {
        users = {
          mutableUsers = lib.mkDefault false;
          users = builtins.mapAttrs (name: user: {
            name = user.name or name;
            isNormalUser = user.normal or lib.mkDefault false;
          }) users;
        };
      }
    ]
    ++ (lib.flatten (
      lib.mapAttrsToList (
        name: user:
        map (aspect: {
          users.users.${name} = aspect.resolve { class = "user"; };
        }) user.aspects
      ) users
    ));
}
