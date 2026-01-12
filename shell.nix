{
  pkgs ? import <nixpkgs> {},
}:
(pkgs.buildFHSEnv {
  name = "microblogpub-dev-env";
  targetPkgs = pkgs: (with pkgs; [ python3 poetry ]);
  extraInstallCommands = ''
    poetry sync
  '';
  runScript = "bash -c 'eval $(poetry env activate) && bash'";
}).env
