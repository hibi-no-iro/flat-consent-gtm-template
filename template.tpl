___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Flat Consent - Cookie Banner and Consent Mode",
  "categories": [
    "TAG_MANAGEMENT",
    "UTILITY"
  ],
  "brand": {
    "id": "github.com_hibi-no-iro",
    "displayName": "Flat Consent"
  },
  "description": "Loads the Flat Consent cookie banner and sets Google Consent Mode v2 defaults, by region if you choose. The banner sends each visitor's choice to Google tags.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "siteId",
    "displayName": "Flat Consent site ID",
    "simpleValueType": true,
    "help": "Find it in the Flat Consent dashboard under Install: it is the part of the script address between /s/ and .js.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^[A-Za-z0-9_-]{3,64}$"
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "defaults",
    "displayName": "Default consent",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "defaultsNote",
        "displayName": "Everywhere not listed below, all four signals start as denied. The banner then sends the visitor's choice, or grants consent where the site's rules show no banner."
      },
      {
        "type": "PARAM_TABLE",
        "name": "regionDefaults",
        "displayName": "Regional defaults",
        "paramTableColumns": [
          {
            "param": {
              "type": "TEXT",
              "name": "region",
              "displayName": "Region (ISO 3166-2 codes, comma-separated, e.g. US, CA-QC)",
              "simpleValueType": true,
              "valueValidators": [
                {
                  "type": "NON_EMPTY"
                }
              ]
            },
            "isUnique": true
          },
          {
            "param": {
              "type": "SELECT",
              "name": "ad_storage",
              "displayName": "ad_storage",
              "macrosInSelect": false,
              "selectItems": [
                {
                  "value": "denied",
                  "displayValue": "Denied"
                },
                {
                  "value": "granted",
                  "displayValue": "Granted"
                }
              ],
              "simpleValueType": true,
              "defaultValue": "denied"
            },
            "isUnique": false
          },
          {
            "param": {
              "type": "SELECT",
              "name": "analytics_storage",
              "displayName": "analytics_storage",
              "macrosInSelect": false,
              "selectItems": [
                {
                  "value": "denied",
                  "displayValue": "Denied"
                },
                {
                  "value": "granted",
                  "displayValue": "Granted"
                }
              ],
              "simpleValueType": true,
              "defaultValue": "denied"
            },
            "isUnique": false
          },
          {
            "param": {
              "type": "SELECT",
              "name": "ad_user_data",
              "displayName": "ad_user_data",
              "macrosInSelect": false,
              "selectItems": [
                {
                  "value": "denied",
                  "displayValue": "Denied"
                },
                {
                  "value": "granted",
                  "displayValue": "Granted"
                }
              ],
              "simpleValueType": true,
              "defaultValue": "denied"
            },
            "isUnique": false
          },
          {
            "param": {
              "type": "SELECT",
              "name": "ad_personalization",
              "displayName": "ad_personalization",
              "macrosInSelect": false,
              "selectItems": [
                {
                  "value": "denied",
                  "displayValue": "Denied"
                },
                {
                  "value": "granted",
                  "displayValue": "Granted"
                }
              ],
              "simpleValueType": true,
              "defaultValue": "denied"
            },
            "isUnique": false
          }
        ],
        "help": "Optional. A different starting state for some regions, for example granted in regions where the site's rules show no banner. Leave regions in the EEA, UK and Switzerland denied."
      },
      {
        "type": "TEXT",
        "name": "waitForUpdate",
        "displayName": "Wait for update (milliseconds)",
        "simpleValueType": true,
        "defaultValue": "500",
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ],
        "help": "How long Google tags wait for the banner's update before they use the default."
      },
      {
        "type": "CHECKBOX",
        "name": "adsDataRedaction",
        "checkboxText": "Redact ads data when ad_storage is denied",
        "simpleValueType": true,
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "urlPassthrough",
        "checkboxText": "Pass ad click information through URLs",
        "simpleValueType": true,
        "defaultValue": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const setDefaultConsentState = require('setDefaultConsentState');
const gtagSet = require('gtagSet');
const injectScript = require('injectScript');
const encodeUriComponent = require('encodeUriComponent');
const makeInteger = require('makeInteger');

// Google's developer ID for Flat Consent.
const DEVELOPER_ID = 'dZDRhNz';

const SIGNALS = ['ad_storage', 'analytics_storage', 'ad_user_data', 'ad_personalization'];
const waitForUpdate = makeInteger(data.waitForUpdate) || 0;

const splitRegions = (input) => input.split(',').map((r) => r.trim()).filter((r) => r.length > 0);

// Regional defaults first, as the site chose them.
(data.regionDefaults || []).forEach((row) => {
  const state = { region: splitRegions(row.region), wait_for_update: waitForUpdate };
  SIGNALS.forEach((s) => { state[s] = row[s] === 'granted' ? 'granted' : 'denied'; });
  setDefaultConsentState(state);
});

// Everywhere else: denied until the visitor chooses.
setDefaultConsentState({
  ad_storage: 'denied',
  analytics_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  functionality_storage: 'denied',
  personalization_storage: 'denied',
  security_storage: 'granted',
  wait_for_update: waitForUpdate,
});

gtagSet('developer_id.' + DEVELOPER_ID, true);
gtagSet('ads_data_redaction', data.adsDataRedaction === true);
gtagSet('url_passthrough', data.urlPassthrough === true);

// gcm=update tells the banner the defaults are set here, so it only sends the visitor's choice.
const url = 'https://cdn.flatconsent.com/s/' + encodeUriComponent(data.siteId) + '.js?gcm=update';
injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, 'flatconsent');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "developer_id.dZDRhNz"
              },
              {
                "type": 1,
                "string": "ads_data_redaction"
              },
              {
                "type": 1,
                "string": "url_passthrough"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://cdn.flatconsent.com/s/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Sets denied defaults and loads the banner
  code: |-
    let loaded;
    mock('injectScript', (url, onSuccess) => { loaded = url; onSuccess(); });
    runCode({ siteId: 'abc123', waitForUpdate: '500', adsDataRedaction: true, urlPassthrough: false });
    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied', analytics_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied',
      functionality_storage: 'denied', personalization_storage: 'denied', security_storage: 'granted', wait_for_update: 500,
    });
    assertApi('gtagSet').wasCalledWith('ads_data_redaction', true);
    assertThat(loaded).isEqualTo('https://cdn.flatconsent.com/s/abc123.js?gcm=update');
    assertApi('gtmOnSuccess').wasCalled();
- name: Sets regional defaults
  code: |-
    mock('injectScript', (url, onSuccess) => { onSuccess(); });
    runCode({ siteId: 'abc123', waitForUpdate: '500', regionDefaults: [
      { region: 'US, CA-QC', ad_storage: 'granted', analytics_storage: 'granted', ad_user_data: 'granted', ad_personalization: 'denied' },
    ] });
    assertApi('setDefaultConsentState').wasCalledWith({
      region: ['US', 'CA-QC'], wait_for_update: 500,
      ad_storage: 'granted', analytics_storage: 'granted', ad_user_data: 'granted', ad_personalization: 'denied',
    });
- name: Fails the tag when the banner can't load
  code: |-
    mock('injectScript', (url, onSuccess, onFailure) => { onFailure(); });
    runCode({ siteId: 'abc123', waitForUpdate: '500' });
    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created for Flat Consent (https://flatconsent.com).
