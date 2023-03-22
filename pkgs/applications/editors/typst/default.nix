{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "22-03-21-2";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = version;
    hash = "sha256-bJPGs/Bd9nKYDrCCaFT+20+1wTN4YdkV8bGrtOCR4tM=";
  };

  cargoHash = "sha256-NG7zrQ3M+jGn3VkwkIu/deEqt1Q7FQiyW/LdmNLYVNs=";
  
  postPatch = ''
    rm cli/build.rs
  '';

  TYPST_HASH = "b934a2fd";

  cargoBuildFlags = [ "-p" "typst-cli" ];
  cargoTestFlags = [ "-p" "typst-cli" ];

  postBuild = ''
    echo "#####################"
    ls target/release/build
  '';

  meta = {
    description = "Markup-based typesetting system";
    homepage = "https://typst.app";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.markbeep ];
  };
}
