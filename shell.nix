{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs {},
}:
let
  build = import ./default.nix { inherit sources pkgs; };
  types-bleach = pkgs.python3.pkgs.buildPythonPackage {
    pname = "types-bleach";
    version = "6.2.0.20250809";
    pyproject = true;

    src = pkgs.python3.pkgs.fetchPypi {
      pname = "types_bleach";
      version = "6.2.0.20250809";
      hash = "sha256-GI16ERn2yVMUC1E+1XukITdVaVgVRywZ0MIqwJx5uQs=";
    };

    build-system = [ pkgs.python3.pkgs.setuptools ];
    dependencies = [ pkgs.python3.pkgs.types-html5lib ];

    pythonImportsCheck = [ "bleach-stubs" ];
  };
  types-cachetools = pkgs.python3.pkgs.buildPythonPackage {
    pname = "types-cachetools";
    version = "6.1.0.20250717";
    pyproject = true;

    src = pkgs.python3.pkgs.fetchPypi {
      pname = "types_cachetools";
      version = "6.1.0.20250717";
      hash = "sha256-SsyOJd6fX4TdF26oHc/6fLJDk4absuWeaS39ATmh5m8=";
    };

    build-system = [ pkgs.python3.pkgs.setuptools ];

    pythonImportsCheck = [ "cachetools-stubs" ];
  };
in
  pkgs.mkShellNoCC {
    inputsFrom = [ build ];
    packages = with pkgs.python3.pkgs; [
      black
      flake8
      mypy
      isort
      invoke
      libsass
      pytest
      respx
      # boussole
      types-bleach
      types-markdown
      factory-boy
      pytest-asyncio
      types-pillow
      # types-emoji (includes annotations)
      types-cachetools
      # sqlalchemy2-stubs (includes annotations)
      types-python-dateutil
      types-tabulate
      types-requests
    ];
  }
