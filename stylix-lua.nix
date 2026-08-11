{ config, pkgs, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  xdg.configFile."hypr/stylix.lua".text = ''
    base00 = "${colors.base00}"
    base01 = "${colors.base01}"
    base02 = "${colors.base02}"
    base03 = "${colors.base03}"
    base04 = "${colors.base04}"
    base05 = "${colors.base05}"
    base06 = "${colors.base06}"
    base07 = "${colors.base07}"
    base08 = "${colors.base08}"
    base09 = "${colors.base09}"
    base0A = "${colors.base0A}"
    base0B = "${colors.base0B}"
    base0C = "${colors.base0C}"
    base0D = "${colors.base0D}"
    base0E = "${colors.base0E}"
    base0F = "${colors.base0F}"

    fontMonospace = "${config.stylix.fonts.monospace.name}"
    fontSansSerif = "${config.stylix.fonts.sansSerif.name}"
    fontSerif     = "${config.stylix.fonts.serif.name}"
    fontEmoji     = "${config.stylix.fonts.emoji.name}"

    fontSizeApplications = ${toString config.stylix.fonts.sizes.applications}
    fontSizeDesktop      = ${toString config.stylix.fonts.sizes.desktop}
    fontSizePopups       = ${toString config.stylix.fonts.sizes.popups}
    fontSizeTerminal     = ${toString config.stylix.fonts.sizes.terminal}

    opacityApplications = ${toString config.stylix.opacity.applications}
    opacityTerminal     = ${toString config.stylix.opacity.terminal}
    opacityDesktop      = ${toString config.stylix.opacity.desktop}
    opacityPopups       = ${toString config.stylix.opacity.popups}

    polarity = "${config.stylix.polarity}"
  '';
}
