module.exports = {
    platform: "github",
    automergeType: "pr",
    platformAutomerge: true,
    gitLabIgnoreApprovals: true,
    onboarding: false,
    onboardingConfigFileName: "renovate.json",
    enabledManagers: [
      "github-actions",
      "terraform",
      "custom.regex"
    ],
    extends: [
      // "config:base", - those that seem to make sense
      ":semanticPrefixFixDepsChoreOthers",
      ":ignoreModulesAndTests",
      ":autodetectRangeStrategy",
      "group:monorepos",
      "group:recommended",
      "workarounds:all",
      // end "config:base",
      ":prHourlyLimitNone",
      ":prConcurrentLimitNone",
      ":label(renovate)",
      ":rebaseStalePrs",
      // add docker digests if missing
      "docker:pinDigests",
      // automerge digest bumps e.g. in docker references
      "default:automergeDigest",
      // automatically pin action digests
      "helpers:pinGitHubActionDigests",
    ],
    //autodiscover: true,
    // autodiscoverFilter: [
    //   "dependabot-renovate",
    // ],
    packageRules: [
      {
        description: "Label major",
        matchUpdateTypes: ["major"],
        addLabels: ["major"],
      },
      {
        description: "Label non-major",
        matchUpdateTypes: ["minor", "patch", "pin"],
        addLabels: ["non-major"],
      },
      {
        groupName: "pinned digests",
        matchUpdateTypes: ["digest"],
      },
      {
        matchManagers: ["terraform"],
        groupName: "terraform providers",
        matchUpdateTypes: ["minor", "patch"],
      },
    ],
    customManagers: [
      {
        customType: "regex",
        fileMatch: [
          "tf-deploy.yml",
          "tf-validation.yml",
          "_variables.tf"
        ],
        matchStrings: [
          //"# renovate: datasource=(?<datasource>.*?) depName=(?<depName>.*?)( versioning=(?<versioning>.*?))?\n.*?: (?<currentValue>.*)",
          '# renovate: datasource=(?<datasource>.*?) depName=(?<depName>.*?)( versioning=(?<versioning>.*?))?\n.*?[:=] "?v?(?<currentValue>[^"\n]*)"?'
        ],
      },
    ],
    allowedPostUpgradeCommands: [".*"],
  };
