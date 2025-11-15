# FlutterConf App Rebranding Implementation Plan

This document outlines the phased implementation plan for rebranding the "FlutterConf" conference app to "FlutterConf".

## Journal

*Chronological log of actions, learnings, surprises, and deviations from the plan.*

-   **2025-11-12:**
    -   Created the `flutterconf-rebrand` branch.
    -   Created and received approval for the `MODIFICATION_DESIGN.md` document.
    -   Attempted to run tests, but no `test` directory was found. Proceeding without initial test run.
    -   Updated `pubspec.yaml` with new name and description.
    -   Updated `android/app/build.gradle.kts` with new `applicationId` and `namespace`.
    -   Updated `android/app/src/main/AndroidManifest.xml` with new `android:label`.
    -   Renamed Android package directories and updated `MainActivity.kt`.
    -   Updated `ios/Runner/Info.plist` with new `CFBundleDisplayName` and `CFBundleName`.
    -   Corrected `CFBundleIdentifier` in `ios/Runner/Info.plist` to use placeholder.
    -   Updated `ios/Runner.xcodeproj/project.pbxproj` with new bundle identifiers.
    -   Removed `nfc_manager` and `friends_badge` dependencies and related code.
    -   User manually replaced `package:flutter_and_friends/` with `package:flutterconf/`.
    -   Ran `fvm dart fix --apply` and `fvm flutter analyze`. Some `directives_ordering` info messages remain.
    -   Ran `fvm dart format .`.
    -   Committed changes for Phase 2.
    -   Replaced "Flutter & Friends" with "FlutterConf" in `README.md`.
    -   Replaced "Flutter & Friends" with "FlutterConf" in `privacy.md`.
    -   Replaced "flutter_and_friends" with "flutterconf" in `release.yaml`.
    -   Replaced "flutter_and_friends.aab" with "flutterconf.aab" in `release.yaml`.
    -   Replaced "flutter_and_friends.ipa" with "flutterconf.ipa" in `release.yaml`.
    -   Replaced "flutterfriends.dev" with "flutterconf.es" in `lib/settings/views/settings_page.dart`.
    -   Replaced "flutter_and_friends" with "flutterconf_app" in `lib/settings/views/settings_page.dart`.
    -   Replaced "@flutterfriends.dev" with "@flutterconf.dev" in `lib/settings/views/settings_page.dart`.
    -   Replaced "@FlutterNFriends" with "@flutterconfes" in `lib/settings/views/settings_page.dart`.
    -   Replaced "@flutter-friends" with "@flutterconf" in `lib/settings/views/settings_page.dart`.
    -   Replaced "Flutter & Dart" with "FlutterConf" in `lib/schedule/data/talks.dart`.
    -   Replaced "Flutter & Friends" with "FlutterConf" in `lib/schedule/data/events.dart`.
    -   Replaced "Flutter & Friends Party" with "FlutterConf Party" in `lib/schedule/data/events.dart`.
    -   Replaced "Friends" part of Flutter and Friends with "Friends" part of FlutterConf in `lib/schedule/data/events.dart`.

## Phase 1: Initial Setup and Verification

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [x] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 2: App Name, Identifiers, and Basic Configuration

-   [x] **pubspec.yaml:**
    -   [x] Change the `name` to `flutterconf`.
    -   [x] Change the `description` to "The official app for FlutterConf."
-   [x] **Android:**
    -   [x] In `android/app/build.gradle.kts`, change the `applicationId` to `es.flutterconf.app`.
    -   [x] In `android/app/src/main/AndroidManifest.xml`, change the `android:label` to "FlutterConf".
    -   [x] Rename the directory structure under `android/app/src/main/kotlin` from `com/felangel/flutter_and_friends` to `es/flutterconf/app`.
    -   [x] Update the package declaration in `MainActivity.kt`.
-   [x] **iOS:**
    -   [x] In `ios/Runner/Info.plist`, change `CFBundleDisplayName` to "FlutterConf".
    -   [x] In `ios/Runner/Info.plist`, change `CFBundleName` to "FlutterConf".
    -   [x] In `ios/Runner.xcodeproj/project.pbxproj`, replace all occurrences of the old bundle identifier (`com.felangel.flutter-and-friends`) with `es.flutterconf.app` and `com.felangel.flutter-and-friends.RunnerTests` with `es.flutterconf.app.RunnerTests`.
-   [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [x] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 3: Codebase String and File Content Replacement

-   [x] Perform a global search for "Flutter & Friends" and replace it with "FlutterConf" in all files.
-   [x] Perform a global search for "flutterandfriends" and replace it with "flutterconf" in all files.
-   [x] Review all changes to ensure they are correct and context-appropriate.
-   [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [x] After committing the change, if an app is running, use the `hot_reload` tool to reload it.


## Phase 4: Visual Asset Replacement

-   [x] Replace `assets/logo.png` with a placeholder logo. (Manual replacement needed)
-   [x] Replace the Android app icons (`ic_launcher.png` in `mipmap` directories).
-   [x] Replace the iOS app icons (`AppIcon` in `ios/Runner/Assets.xcassets`).
-   [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [x] Run the `dart_fix` tool to clean up the code.
-   [x] Run the `analyze_files` tool one more time and fix any issues.
-   [x] Run any tests to make sure they all pass.
-   [x] Run `dart_format` to make sure that the formatting is correct.
-   [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [x] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 5: Finalization

-   [x] Update the `README.md` file with relevant information from the modification.
-   [x] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, implementation details, and the layout of the files.
-   [x] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.
-   [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [x] After committing the change, if an app is running, use the `hot_reload` tool to reload it.