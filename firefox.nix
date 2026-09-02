{ config, pkgs, ... }:
{
  stylix.targets.firefox.profileNames = [
    "default"
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      id        = 0;
      isDefault = true;

      settings = {
        "browser.startup.homepage"                                    = "about:blank";
        "browser.startup.page"                                        = 3;
        "browser.tabs.closeWindowWithLastTab"                         = true;
        "signon.rememberSignons"                                      = false;
        "extensions.autoDisableScopes"                                = 0;
        "privacy.globalprivacycontrol.enabled"                        = true;
        "privacy.globalprivacycontrol.functionality.enabled"          = true;
        "browser.newtabpage.activity-stream.feeds.topsites"           = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites"    = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "widget.disable-workspace-management"                         = true;
        "browser.download.folderList"                                 = 2;
        "browser.download.dir"                                        = "${config.home.homeDirectory}/downloads";

        "browser.uiCustomization.state" = {
          currentVersion  = 24;
          newElementCount = 4;

          placements = {
            unified-extensions-area = [
              "sponsorblocker_ajay_app-browser-action"
              "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
            ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "customizableui-special-spring1"
              "vertical-spacer"
              "urlbar-container"
              "customizableui-special-spring2"
              "downloads-button"
              "reset-pbm-toolbar-button"
              "ublock0_raymondhill_net-browser-action"
              "keepassxc-browser_keepassxc_org-browser-action"
              "unified-extensions-button"
              "preferences-button"
            ];
            toolbar-menubar = [
              "menubar-items"
            ];
            TabsToolbar = [
              "firefox-view-button"
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            PersonalToolbar = [
              "import-button"
              "personal-bookmarks"
            ];
          };
          seen = [
            "reset-pbm-toolbar-button"
            "keepassxc-browser_keepassxc_org-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "developer-button"
            "screenshot-button"
            "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
            "sponsorblocker_ajay_app-browser-action"
          ];
          dirtyAreaCache = [
            "unified-extensions-area"
            "nav-bar"
            "vertical-tabs"
            "PersonalToolbar"
            "toolbar-menubar"
            "TabsToolbar"
          ];
        };
      };
    };

    policies = {
      DisableAppUpdate       = true;
      DisableTelemetry       = true;
      DisablePocket          = true;
      DisableFirefoxStudies  = true;
      OverrideFirstRunPage   = "";
      OverridePostUpdatePage = "";

      AIControls = {
        Default.Value      = "blocked";
        Translations.Value = "available";
      };

      Extensions.Locked = [
        "uBlock0@raymondhill.net"
        "keepassxc-browser@keepassxc.org"
        "sponsorBlocker@ajay.app"
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}"
      ];

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          default_area      = "navbar";
        };
        "keepassxc-browser@keepassxc.org" = {
          installation_mode = "force_installed";
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          default_area      = "navbar";

          autoReconnect               = true;
          afterFillSorting            = "sortByMatchingCredentials";
          afterFillSortingTotp        = "sortByRelevantEntry";
          autoCompleteUsernames       = true;
          autoFillAndSend             = false;
          autoFillSingleEntry         = false;
          autoFillRelevantCredential  = false;
          autoFillSingleTotp          = true;
          autoRetrieveCredentials     = true;
          autoSubmit                  = false;
          bannerPosition              = 1;
          checkUpdateKeePassXC        = 0;
          clearCredentialsTimeout     = 10;
          colorTheme                  = "system";
          connectionMethod            = "nativemessaging";
          credentialSorting           = "sortByGroupAndTitle";
          debugLogging                = false;
          defaultGroup                = "root";
          defaultPasskeyGroup         = "";
          defaultPasswordManager      = true;
          defaultGroupAlwaysAsk       = false;
          downloadFaviconAfterSave    = false;
          passkeys                    = false;
          passkeysFallback            = true;
          redirectAllowance           = 3;
          saveDomainOnly              = true;
          saveDomainOnlyNewCreds      = true;
          showGroupNameInAutocomplete = true;
          showLoginFormIcon           = true;
          showLoginNotifications      = true;
          showNotifications           = true;
          showOTPIcon                 = true;
          useCompactMode              = false;
          useMonochromeToolbarIcon    = true;
          useObserver                 = true;
          usePredefinedSites          = true;
          usePasswordGeneratorIcons   = true;
        };
        "sponsorBlocker@ajay.app" = {
          installation_mode = "force_installed";
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          installation_mode = "force_installed";
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
        };
      };
    };
  };
}
