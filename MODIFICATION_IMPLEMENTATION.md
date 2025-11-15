# FlutterConf App Rebranding Implementation Plan

This document outlines the phased implementation plan for rebranding the "Flutter & Friends" conference app to "FlutterConf".

## Journal

*Chronological log of actions, learnings, surprises, and deviations from the plan.*

-   **2025-11-12:**
    -   Created the `flutterconf-rebrand` branch.
    -   Created and received approval for the `MODIFICATION_DESIGN.md` document.
    -   Attempted to run tests, but no `test` directory was found. Proceeding without initial test run.

## Phase 1: Initial Setup and Verification

-   [x] Run all tests to ensure the project is in a good state before starting modifications.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 2: App Name, Identifiers, and Basic Configuration

-   [ ] **pubspec.yaml:**
    -   [ ] Change the `name` to `flutterconf`.
    -   [ ] Change the `description` to "The official app for FlutterConf."
-   [ ] **Android:**
    -   [ ] In `android/app/build.gradle`, change the `applicationId` to `es.flutterconf.app`.
    -   [ ] In `android/app/src/main/AndroidManifest.xml`, change the `android:label` to "FlutterConf".
    -   [ ] In `android/app/src/main/AndroidManifest.xml`, change the `package` attribute in the manifest tag to `es.flutterconf.app`.
    -   [ ] Rename the directory structure under `android/app/src/main/kotlin` from `dev/flutterandfriends/app` to `es/flutterconf/app`.
    -   [ ] Update the package declaration in `MainActivity.kt`.
-   [ ] **iOS:**
    -   [ ] In `ios/Runner/Info.plist`, change `CFBundleName` to "FlutterConf".
    -   [ ] In `ios/Runner/Info.plist`, change `CFBundleIdentifier` to `es.flutterconf.app`.
    -   [ ] In `ios/Runner.xcodeproj/project.pbxproj`, replace all occurrences of the old bundle identifier (`dev.flutterandfriends.app`) with `es.flutterconf.app`.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 3: Codebase String and File Content Replacement

-   [ ] Perform a global search for "Flutter & Friends" and replace it with "FlutterConf" in all files.
-   [ ] Perform a global search for "flutterandfriends" and replace it with "flutterconf" in all files.
-   [ ] Review all changes to ensure they are correct and context-appropriate.
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 4: Visual Asset Replacement

-   [ ] Replace `assets/logo.png` with a placeholder logo.
-   [ ] Replace the Android app icons (`ic_launcher.png` in `mipmap` directories).
-   [ ] Replace the iOS app icons (`AppIcon` in `ios/Runner/Assets.xcassets`).
-   [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
-   [ ] Run the `dart_fix` tool to clean up the code.
-   [ ] Run the `analyze_files` tool one more time and fix any issues.
-   [ ] Run any tests to make sure they all pass.
-   [ ] Run `dart_format` to make sure that the formatting is correct.
-   [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 5: Finalization

-   [ ] Update the `README.md` file with relevant information from the modification.
-   [ ] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, implementation details, and the layout of the files.
-   [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.
-   [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
-   [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
-   [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
-   [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.
