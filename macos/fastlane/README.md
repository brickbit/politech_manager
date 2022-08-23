fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Mac

### mac install_pods

```sh
[bundle exec] fastlane mac install_pods
```

Install the Pods from the Podfile file and create the project xcworkspace

### mac manage_cerificates

```sh
[bundle exec] fastlane mac manage_cerificates
```

Manage the app's certificates and app profiles, create, download and renew them

### mac build_adhoc

```sh
[bundle exec] fastlane mac build_adhoc
```

Compile and archive the app, create the adhoc IPA  in the specified folder. Profiles and certificates must be updated

### mac distribute_firebase

```sh
[bundle exec] fastlane mac distribute_firebase
```

Distribute the adhoc IPA using Firebase App Distribution with the IPA generated in build_adhoc lane

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
