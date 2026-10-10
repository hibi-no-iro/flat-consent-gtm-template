# Flat Consent – Google Tag Manager template

Loads the [Flat Consent](https://flatconsent.com) cookie banner from Google Tag Manager and sets Google Consent Mode v2 defaults.

- All four Consent Mode signals (`ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`) start as denied, with optional different defaults per region.
- The banner then sends each visitor's choice as a Consent Mode update, or grants consent where the site's rules show no banner.

## Setup

1. In Tag Manager, add a tag of type **Flat Consent – Cookie Banner and Consent Mode**.
2. Enter your site ID (Flat Consent dashboard, Install tab: the part of the script address between `/s/` and `.js`).
3. Use the **Consent Initialization – All Pages** trigger.
4. Remove the Flat Consent script line from your pages if you added it there, so the banner loads once.

Documentation: https://flatconsent.com/docs/google-and-microsoft/

Support: hello@flatconsent.com

## License

Apache 2.0. See [LICENSE](LICENSE).
