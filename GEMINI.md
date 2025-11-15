# FlutterConf App Description

This document describes the FlutterConf mobile application, its purpose, implementation details, and the layout of its files.

## Purpose

The FlutterConf app is the official mobile application for the FlutterConf conference. It provides attendees with information about the conference schedule, speakers, events, and other relevant details. The app aims to enhance the conference experience by providing easy access to information and facilitating engagement.

## Implementation Details

The app is built using Flutter, a UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

Key implementation aspects include:

-   **State Management:** The app utilizes the `bloc` library for state management, ensuring a clear separation of concerns and predictable state changes.
-   **Navigation:** `go_router` is used for declarative routing, enabling deep linking and robust navigation within the application.
-   **Theming:** The app supports both light and dark themes, with a centralized `ThemeData` object for consistent styling across the application. Custom design tokens are implemented using `ThemeExtension`.
-   **Asset Management:** Images and other assets are managed within the `assets/` directory and declared in `pubspec.yaml`.
-   **API Integration:** (If applicable, describe how the app interacts with any backend APIs, e.g., for fetching schedule data, speaker information, etc.)
-   **Platform-Specific Features:** (If applicable, describe any platform-specific implementations for Android or iOS, e.g., native integrations, specific UI components.)

## File Layout

The project follows a standard Flutter project structure with additional organization for features and concerns:

-   `lib/`: Contains the main application source code.
    -   `main.dart`: The application's entry point.
    -   `config/`: Configuration files for the app.
    -   `extensions/`: Dart extension methods.
    -   `favorites/`: Feature-specific code for managing favorite talks/speakers.
        -   `cubit/`: BLoC cubits for state management.
        -   `views/`: UI widgets and screens for the feature.
        -   `widgets/`: Reusable widgets specific to the feature.
    -   `launchpad/`: (Describe purpose)
    -   `location/`: (Describe purpose)
    -   `organizers/`: Feature-specific code for displaying organizer information.
        -   `data/`: Data models and repositories.
        -   `models/`: Data models.
        -   `view/`: UI widgets and screens.
    -   `schedule/`: Feature-specific code for the conference schedule.
    -   `settings/`: Feature-specific code for application settings.
    -   `speaker_details/`: Feature-specific code for individual speaker details.
    -   `speakers/`: Feature-specific code for listing speakers.
    -   `sponsors/`: Feature-specific code for displaying sponsor information.
    -   `talk_details/`: Feature-specific code for individual talk details.
    -   `theme/`: Application-wide theming and styling definitions.
    -   `twitter/`: (Describe purpose)
    -   `updater/`: (Describe purpose)
    -   `workshop_details/`: Feature-specific code for individual workshop details.
-   `assets/`: Contains static assets like images.
    -   `logo.png`: Application logo.
    -   `activities/`: Images related to activities.
    -   `organizers/`: Images of organizers.
    -   `speakers/`: Images of speakers.
    -   `sponsors/`: Images of sponsors.
-   `art/`: Contains marketing and promotional art assets.
-   `android/`: Android-specific project files.
-   `ios/`: iOS-specific project files.
-   `web/`: Web-specific project files.
-   `test/`: Unit and widget tests.
-   `pubspec.yaml`: Project dependencies and metadata.
-   `analysis_options.yaml`: Dart static analysis options.
-   `build.yaml`: Build configuration for code generation.
-   `devtools_options.yaml`: Dart DevTools configuration.
-   `LICENSE`: Project license.
-   `README.md`: Project overview and setup instructions.
-   `MODIFICATION_DESIGN.md`: Document outlining the design decisions for modifications.
-   `MODIFICATION_IMPLEMENTATION.md`: Document outlining the implementation plan for modifications.
