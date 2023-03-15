{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, cmakeMinimal
, pciutils
, zlib
}:
stdenv.mkDerivation rec {
  name = "gpufetch";
  version = "0.25";

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "gpufetch";
    rev = "v${version}";
    hash = "sha256-1j23h3TDxa2xu03o37fXfRL3XFYyhMWFGupAlkrYpBY=";
  };

  nativeBuildInputs = [
    installShellFiles
    cmakeMinimal
    pciutils
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -Dm755 gpufetch   $out/bin/gpufetch
    install -Dm644 ../LICENSE    $out/share/licenses/gpufetch/LICENSE
    installManPage ../gpufetch.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple yet fancy GPU architecture fetching tool";
    license = licenses.gpl2Only;
    homepage = "https://github.com/Dr-Noob/gpufetch";
    changelog = "https://github.com/Dr-Noob/gpufetch/releases/tag/v${version}";
    maintainers = with maintainers; [ markbeep ];
  };
}
