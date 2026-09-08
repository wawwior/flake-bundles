{ ... }: {
  name = "nixos";
  host =
    {
      aspects ? [ ],
      ...
    }:
    (map (aspect: aspect.resolve { class = "nixos"; }) aspects);
}
