# Contributing to instantsearch-ios

Hello and welcome to this contributing guide. Thanks for considering participating in our project 🙇.

If this guide does not contain what you are looking for and thus prevents you from contributing, don't hesitate to [open an issue](https://github.com/algolia/instantsearch-ios/issues/new/choose).

## Getting help

### Reporting issues

Use [GitHub issues](https://github.com/algolia/instantsearch-ios/issues/new?template=Bug_report.md) to report a bug.

Before creating a new issue:

* Make sure you are using the [latest release](https://github.com/algolia/instantsearch-ios/releases)
* Check if the issue was [already reported or fixed](https://github.com/algolia/instantsearch-ios/issues?q=is%3Aissue). Notice that it may not be released yet

If you found a match add a brief comment "I have the same problem" or "+1". This helps prioritize the issues addressing the most common and critical first. If possible, add additional information to help us reproduce and fix the issue. Please use your best judgement.

When reporting issues, please include the following information to help maintainers to fix the problem faster:
* Xcode version you are using
* iOS version you are targeting
* Full Xcode console output of stack trace or code compilation error
* Any other additional detail you think it would be useful to understand and solve the problem

### Suggesting a feature

We would love to hear your ideas and make a discussion about it. You can use [GitHub issues](https://github.com/algolia/instantsearch-ios/issues/new?template=Feature_request.md) to make feature proposals.

Before submitting your proposal, make sure there is [no similar feature request](https://github.com/algolia/instantsearch-ios/labels/feature%20request). If you found a match feel free to join the discussion or just add a brief "+1" if you think the feature is worth implementing.

Be as specific as possible providing a precise explanation of feature request so anyone can understand the problem and the benefits of solving it.

## Contributing code

### Setup

To set up this project, you will need to install [Xcode](https://developer.apple.com/xcode/) and [Ruby](https://www.ruby-lang.org/en/documentation/installation/).

### Code contribution process

For any code contribution, you need to:

- Fork and clone the project
- Create a new branch for what you want to solve (fix/_issue-number_, feat/_name-of-the-feature_)
- Make your changes
- Open a pull request

Then:

- Peer review of the pull request (by at least one core contributor)
- Automatic checks
- When everything is green, your contribution is merged 🚀

### Commit conventions

This project follows the [conventional changelog](https://conventionalcommits.org/) approach. This means that all commit messages should be formatted using the following scheme:

```
type(scope): description
```

In most cases, we use the following types:

- `fix`: for any resolution of an issue (identified or not)
- `feat`: for any new feature
- `refactor`: for any code change that neither adds a feature nor fixes an issue
- `chore`: for any change that has no impact on the published packages

Finally, if your work is based on an issue on GitHub, please add in the body of the commit message "fix #1234" if it solves the issue #1234 (read "[Closing issues using keywords](https://help.github.com/en/articles/closing-issues-using-keywords)").

Some examples of valid commit messages (used as first lines):

> - feat(helper): implement method X
> - chore(deps): update dependency Y to v1.2.3
> - fix(insights): ensure proeprty Z is valid

### Publishing

All packages in this project are available through the following package managers:

- [Swift Package Manager](https://www.swift.org/documentation/package-manager/)
- [Carthage](https://github.com/Carthage/Carthage)
- [CocoaPods](https://cocoapods.org/pods/InstantSearch)

To publish a new version, trigger a new deployment [from GitHub Actions](https://github.com/algolia/instantsearch-ios/actions/workflows/deployment.yml). It will require specifying the type of release (patch / minor / major) before launching the workflow. It will then prepare the packages by:

- updating version numbers in relevant locations
- updating CHANGELOG.md
- creating git tags and drafting a GitHub release

These changes will be then pushed in a pull request, ready to be merged.

#### CocoaPods specifics

While both Swift Package Manager and Carthage rely on GitHub and git tags to retrieve the library, CocoaPods has its own repository.

[Since Xcode 14.3](https://github.com/CocoaPods/CocoaPods/issues/11839), the deployment fails at the `pod_push` step, requiring the library to be manually published to the CocoaPods repository. The Fastlane deploy does not include this step anymore.

InstantSearch iOS should be published to CocoaPods manually from an authorized user's local environment. Xcode 14.2 cannot be used to build as it's incompatible with macOS Sonoma and up, but it's possible to [copy some of its files](https://github.com/CocoaPods/CocoaPods/issues/12033#issuecomment-2172608443) that are mistakenly required by CocoaPods for Podfile validation:

```bash
# Install Xcode 14.2 (here, using xcodes CLI)
xcodes install 14.2

# Copy required files
sudo cp /Applications/Xcode-14.2.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc
```

In the meantime, [merge the deploy PR](https://github.com/algolia/instantsearch-ios/pulls) generated by the pipeline and pull it into your local repository.

Finally, register or authenticate with CocoaPods, and publish the new version manually.

**Registering a user** with CocoaPods:

```sh
pod trunk register user@algolia.com 'Username'
```

**Authorizing a user** from an already authorized account:

```sh
pod trunk add-owner InstantSearch user@algolia.com
```

**Publishing a new version** manually:

> Note: macOS, iOS, watchOS and tvOS component platforms need to be downloaded and installed via Xcode prior to running this command

```sh
pod trunk push --allow-warnings
```
