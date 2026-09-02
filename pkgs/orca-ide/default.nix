{ pkgs ? import <nixpkgs> {}, fetchurl }:

let
  pname = "orca-ide";
  version = "1.4.161";

  src = fetchurl {
    url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
    sha256 = "05ngy2alygs5w40skghn03y8zsivi0snya99kjs68xnjyxx4cqf3";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/orca-ide.desktop $out/share/applications/orca-ide.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/orca-ide.png $out/share/icons/hicolor/512x512/apps/orca-ide.png
    substituteInPlace $out/share/applications/orca-ide.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  meta = with pkgs.lib; {
    description = "Next-gen IDE for parallel agentic development";
    homepage = "https://github.com/stablyai/orca";
    platforms = [ "x86_64-linux" ];
  };
}
