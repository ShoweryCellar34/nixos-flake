{ config, pkgs, firefox-addons, ... }:
{
  stylix.targets.firefox.profileNames = [
    "default"
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      id        = 0;
      isDefault = true;

      extensions.force    = true;
      extensions.packages = with firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        keepassxc-browser
      ];

      extensions.settings."keepassxc-browser@keepassxc.org".settings = {
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
      ];

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
        };
        "keepassxc-browser@keepassxc.org" = {
          default_area = "navbar";
        };
      };
    };
  };
}
