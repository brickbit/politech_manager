fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios install_pods

```sh
[bundle exec] fastlane ios install_pods
```

Install the Pods from the Podfile file and create the project xcworkspace

### ios manage_cerificates

```sh
[bundle exec] fastlane ios manage_cerificates
```

Manage the app's certificates and app profiles, create, download and renew them

### ios build_adhoc

```sh
[bundle exec] fastlane ios build_adhoc
```

Compile and archive the app, create the adhoc IPA  in the specified folder. Profiles and certificates must be updated

### ios distribute_firebase

```sh
[bundle exec] fastlane ios distribute_firebase
```

Distribute the adhoc IPA using Firebase App Distribution with the IPA generated in build_adhoc lane

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
