{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncplay;

  cmdArgs =
    [ "--port" cfg.port ]
    ++ optionals (cfg.salt != null) [ "--salt" cfg.salt ]
    ++ optionals (cfg.certDir != null) [ "--tls" cfg.certDir ];

in
{
  options = {
    services.syncplay = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, start the Syncplay server.";
      };

      port = mkOption {
        type = types.port;
        default = 8999;
        description = ''
          TCP port to bind to.
        '';
      };

      salt = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Salt to allow room operator passwords generated by this server
          instance to still work when the server is restarted.
        '';
      };

      certDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          TLS certificates directory to use for encryption. See
          <link xlink:href="https://github.com/Syncplay/syncplay/wiki/TLS-support"/>.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          User to use when running Syncplay.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group to use when running Syncplay.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.syncplay = {
      description = "Syncplay Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network-online.target "];

      serviceConfig = {
        ExecStart = "${pkgs.syncplay}/bin/syncplay-server ${escapeShellArgs cmdArgs}";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
