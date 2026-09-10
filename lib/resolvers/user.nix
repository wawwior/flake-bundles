{
  name = "user";
  host =
    {
      users ? { },
      ...
    }:
    [
      (
        { pkgs, ... }:
        {
          users.users = builtins.mapAttrs (name: value: { ... }: {
            imports = map (aspect: aspect.resolve { class = "user"; }) value.aspects;
            config._module.args = {
              inherit pkgs;
            };
          }) users;
        }
      )
    ];
}
