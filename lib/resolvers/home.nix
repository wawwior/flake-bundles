{ inputs, ... }:
{
  name = "home";
  host =
    {
      aspects ? [ ],
      ...
    }:
    [
      {
        imports = [ inputs.home-manager.nixosModules.default ];

        home-manager = {
          sharedModules = map (aspect: aspect.resolve { class = "home"; }) aspects;
        };
      }
    ];
}
