{ ... }: {
  name = "nixos";
  host =
    {
      aspects ? [ ],
      ...
    }:
    let
    in
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects);
}
