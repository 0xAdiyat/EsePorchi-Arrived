# EsePorchi - Arrived

EsePorchi - Arrived is a Flutter mobile application that helps users set alarms for specific destinations and receive notifications when they reach those destinations.

## Features

- Set multiple alarms for different destinations.
- Receive notifications when approaching a destination.
- Display the current location and distance to each destination.
- Allow users to add, edit, and delete destinations.
- Persist alarm data using SharedPreferences.

## Screenshots

Include some screenshots of your app here to give readers a visual overview of its features.

## Installation

To run the app locally, you need to have Flutter installed on your machine. Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) for detailed instructions on setting up Flutter.

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/EsePorchi-Arrived.git
   ```

2. Change to the project directory:

   ```bash
   cd EsePorchi-Arrived
   ```

3. Install the dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## Project Structure

Here is the basic project structure of the app:

```
├── android
│   ├── app
│   │   ├── src
│   │   │   ├── main
│   │   │   │   ├── java
│   │   │   │   │   └── com
│   │   │   │   │       └── example
│   │   │   │   │           └── eseporchi
│   │   │   │   │               └── arrived
│   │   │   │   │                   ├── MainActivity.java
│   │   │   │   │                   └── ...
│   │   │   │   └── ...
│   │   └── ...
├── ios
│   ├── Runner
│   │   ├── AppDelegate.swift
│   │   └── ...
│   └── ...
├── lib
│   ├── models
│   │   └── ...
│   ├── screens
│   │   ├── home_screen.dart
│   │   ├── search_location_screen.dart
│   │   └── ...
│   ├── utilities
│   │   ├── constants.dart
│   │   ├── utilities.dart
│   │   └── ...
│   ├── main.dart
│   └── ...
├── test
│   ├── models
│   │   └── ...
│   ├── screens
│   │   └── ...
│   └── ...
├── pubspec.yaml
└── ...
```

- **`android`**: Contains the Android-specific project files.
- **`ios`**: Contains the iOS-specific project files.
- **`lib`**: Contains the Dart source code for the app.
  - **`models`**: Contains the data models used in the app.
  - **`screens`**: Contains the different screens of the app.
  - **`utilities`**: Contains utility functions and constants.
  - **`main.dart`**: The entry point of the app.
- **`test`**: Contains unit tests for the app.
- **`pubspec.yaml`**: Defines the app's dependencies and configuration.

## Dependencies

- `android_alarm_manager`: ^2.0.0: Used for scheduling alarms on Android devices.
- `flutter_local_notifications`: ^3.1.1: Used for displaying local notifications.
- `google_maps_flutter`: ^2.1.0: Used for displaying maps and calculating distances.
- `shared_preferences`: ^2.0.8: Used for persisting alarm data.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE).
