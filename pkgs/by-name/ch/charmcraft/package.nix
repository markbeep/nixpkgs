{
  lib,
  git,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pydantic-yaml = super.pydantic-yaml.overridePythonAttrs (old: rec {
        version = "0.11.2";
        src = fetchFromGitHub {
          owner = "NowanIlfideme";
          repo = "pydantic-yaml";
          rev = "refs/tags/v${version}";
          hash = "sha256-AeUyVav0/k4Fz69Qizn4hcJKoi/CDR9eUan/nJhWsDY=";
        };
        dependencies = with self; [
          deprecated
          importlib-metadata
          pydantic_1
          ruamel-yaml
          types-deprecated
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "charmcraft";
  version = "2.7.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = "refs/tags/${version}";
    hash = "sha256-yMcGXi7OxEtfOv3zLEUlnZrR90TkFc0y9RB9jS34ZWs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version=determine_version()' 'version="${version}"'

    # TODO remove setuptools from dependencies once this is removed
    substituteInPlace charmcraft/env.py \
      --replace-fail "distutils.util" "setuptools.dist"
  '';

  dependencies = with python.pkgs; [
    craft-cli
    craft-parts
    craft-providers
    craft-store
    distro
    humanize
    jinja2
    jsonschema
    pydantic_1
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    requests-unixsocket
    setuptools # see substituteInPlace above
    snap-helpers
    tabulate
    urllib3
  ];

  build-system = with python.pkgs; [ setuptools ];

  pythonRelaxDeps = [ "urllib3" ];

  nativeCheckInputs =
    with python.pkgs;
    [
      pyfakefs
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      responses
      setuptools
    ]
    ++ [ git ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Relies upon the `charm` tool being installed
    "test_validate_missing_charm"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "charmcraft";
    description = "Build and publish Charmed Operators for deployment with Juju";
    homepage = "https://github.com/canonical/charmcraft";
    changelog = "https://github.com/canonical/charmcraft/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
