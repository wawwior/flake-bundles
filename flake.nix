{
  description = "composable stuff";

  outputs =
    { ... }:
    {
      flakeModule = import ./lib/flakeModule.nix;
    };
}
