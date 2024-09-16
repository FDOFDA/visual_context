# Visual Context App

## Overview

Visual Context is a Flutter-based mobile application that provides users with seamless QR code scanning and document edge alignment functionalities. The app is designed to be user-friendly, offering features like scanning, saving aligned documents directly to the gallery. Built with modern UI components and adhering to Android 11+ storage permissions, Visual Context ensures a smooth and appealing experience across various devices.

## Tech Stack

- **Flutter**: The main framework used for building the cross-platform mobile application.
- **Dart**: The programming language used within Flutter for application development.
- **Material Design 3**: Utilized for a modern and visually appealing user interface.
- **Packages Used**:
  - `mobile_scanner`: For QR code scanning functionality.
  - `edge_detection`: For document edge detection and alignment.
  - `permission_handler`: To manage app permissions, especially for camera and storage access.
  - `image_gallery_saver`: For saving images directly to the device gallery, compliant with scoped storage rules in Android 11 and above.
  - `url_launcher`: To handle opening scanned URLs within the app.

## Contribution

The entire project was developed by Derek Oliver, responsible for the following:

- **Application Design and Development**: Designed the UI/UX and implemented the core functionalities, including QR code scanning, edge detection, and document alignment features.
- **Integration of Permissions and Scoped Storage**: Ensured the app is compliant with Android 11+ storage requirements by integrating scoped storage and permissions handling.
- **UI Enhancements**: Implemented modern UI components using Material Design 3, including dark mode support and onboarding screens.
- **Testing and Optimization**: Conducted thorough testing on various Android versions to ensure smooth performance and resolved any bugs related to permissions and storage access.

## Setting Up the Project Locally

Follow these steps to set up the Visual Context app on your local system:

### Prerequisites

- Flutter SDK: Ensure Flutter is installed on your system. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) if it's not already set up.
- Android Studio or VS Code: Recommended IDEs for Flutter development.
- ADB and Android Emulator or Physical Device: For running the application.

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/derekolivr/visual_context.git
   cd visual_context
   ```

2. **Install Dependencies**

   - Ensure you are in the project directory, then run:

   ```bash
   flutter pub get
   ```

3. **Configure Permissions**

   - Update your `AndroidManifest.xml` as per the project requirements to include necessary permissions for camera, storage, and internet access.

4. **Run the App**

   - Connect your Android device via USB or start an emulator.
   - Use the following command to run the app:

   ```bash
   flutter run
   ```

5. **Building for Release**
   - For building the app in release mode, use:
   ```bash
   flutter build apk --release
   ```

### Troubleshooting

- **Permission Issues**: Ensure all required permissions are correctly set in `AndroidManifest.xml` and requested at runtime.
- **Compatibility**: Verify that your device or emulator is running Android 11 or higher to fully experience the scoped storage compliance features.
- **Dependencies**: If you encounter dependency issues, run `flutter pub upgrade` to update to the latest compatible versions.

For any additional help or issues, please refer to the Flutter documentation or contact Derek Oliver via a GitHub issue.


### Video Link
https://drive.google.com/drive/folders/1vJiPKmOlRnxmRk5VBa51fiC33IDCl_q2?usp=drive_link
