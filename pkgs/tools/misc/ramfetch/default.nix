{ lib
, stdenv
, fetchgit
}:

stdenv.mkDerivation rec {
  name = "ramfetch";
  version = "1.1.0";

  src = fetchgit {
    url = "https://codeberg.org/o69mar/ramfetch.git";
    rev = "v${version}";
    sha256 = "sha256-XUph+rTbw5LXWRq+OSKl0EjFac+MQAx3NBu4rWdWR3w=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    chmod 755 ramfetch
    mv ramfetch $out/bin/ramfetch

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool which displays memory info";
    homepage = "https://codeberg.org/o69mar/ramfetch";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.markbeep ];
  };
}
