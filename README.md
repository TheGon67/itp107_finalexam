# Post Reader & Favorites — Pixel Library + MockAPI — v5

A Flutter application for ITP107, following the supplied Finals Lab Exam and Finals Module lessons 11 (routing), 12 (Hive), and 13 (HTTP). It uses an original pixel library interior and an original bundled pixel heading font. Body text stays readable. No online fonts, paid services, database server, API key, or code generation are needed.

## Start here — Windows / VS Code / Android Studio

1. Install the current stable Flutter SDK using https://docs.flutter.dev/install. Add its `bin` folder to PATH. Close and reopen your terminal/IDE. Installing the IDE plugin alone does not install Flutter.
2. Install Android Studio, the Android SDK, SDK command-line tools, and an Android emulator through Android Studio's SDK Manager and Device Manager.
3. In PowerShell or CMD run `flutter doctor` and `flutter doctor --android-licenses`. Resolve Android toolchain errors. Start an emulator, or connect a phone with USB debugging enabled.
4. Extract this ZIP into a writable folder, for example `C:\FlutterProjects\post_reader_favorites`. Do not run inside the ZIP.
5. Open the extracted project folder in VS Code or Android Studio. Open its terminal. You must be in the folder containing `pubspec.yaml`.
6. Run the following in the terminal:

```powershell
dart tool/setup.dart
flutter devices
flutter run
```

You can instead double-click `setup_windows.bat` for step 6's setup, then run `flutter run` in the project terminal. On macOS/Linux use `bash setup.sh`.

The setup script generates `android/` and `web/` using your own Flutter version, preserves the supplied app source, adds the Android INTERNET permission to the main manifest (including release builds), sets the Android application label, downloads dependencies, runs analysis, and runs the included tests. It stops on failure. Platform boilerplate and dependency lockfiles are deliberately generated on your machine; this source bundle has not been compiled here.

To use a browser instead of an emulator:

```powershell
flutter run -d chrome
# Or, if flutter devices lists Edge:
flutter run -d edge
```

For browser persistence, keep the same browser profile and origin/port:

```powershell
flutter run -d chrome --web-port 7357
```

Use regular browsing. Incognito mode, clearing site data, or changing the web origin can lose or separate favorites. On Android, force-closing retains data; clearing app data or uninstalling removes it.

## How to use the app

- Posts: automatically loads all posts on opening. Tap a card to read it. Pull down or tap refresh to reload. A star marks favorites.
- Details: read title/body; press Save to Favorites. The string post ID is the Hive key, so duplicates are prevented. Existing notes are preserved when saving.
- Favorites: tap the AppBar star from Posts. Tap a favorite to read it. Edit note stores a short local note (200 characters maximum). An empty note clears it. Remove asks for confirmation and then deletes the Hive record.
- New post: the floating button opens a title/body dialog. Both fields reject empty/whitespace-only content. Submission uses HTTP POST with JSON. The dialog shows HTTP 201 success or a failure message. Close with Done/Cancel.
- MockAPI stores created posts remotely. Tap Done after a successful POST; the list refreshes from the server. Delete a remote post with its trash icon or the Delete post from MockAPI button on Details, then confirm. A successful deletion refreshes the list and removes the matching favorite on this device. Removing only a favorite does not delete the server post. Other devices keep their local favorite snapshots until those users remove them.
- Loading, empty, network-error, invalid-route, and local-storage-error states appear on screen. Network requests time out after 20 seconds. Notes and favorites remain usable offline once saved; the remote post list needs internet.

## Files and responsibilities

| File | Responsibility |
| --- | --- |
| `lib/main.dart` | Flutter binding, Hive initialization/openBox before runApp, MaterialApp named routes |
| `lib/theme/app_theme.dart` | Shared ThemeData, walnut/parchment/copper/sage colors, pixel heading font, spacing/button styling |
| `lib/screens/posts_screen.dart` | initState GET through PostsApi, ListView.builder/ListTile, refresh after create/delete, named routes |
| `lib/data/posts_api.dart` | Shared endpoint; HTTP GET/POST/DELETE, status checks, JSON parsing, string IDs |
| `lib/widgets/delete_post.dart` | Remote delete confirmation, request errors and matching local-favorite cleanup |
| `lib/screens/details_screen.dart` | ModalRoute arguments, post content, Save to Favorites |
| `lib/screens/favorites_screen.dart` | Hive values list, note dialog, remove confirmation, delete |
| `lib/data/favorites_store.dart` | Hive Map put/read/update/delete using string ID keys |
| `lib/widgets/create_post_dialog.dart` | Validated form, JSON POST, status 201, result displayed in dialog |
| `lib/widgets/quest_widgets.dart` | Shared bordered panels, landscape header, empty/error states, SnackBars |
| `assets/images/valley.png` | Original pixel library interior |
| `assets/fonts/quest_pixel.ttf` | Original pixel font, uppercase-style headings |
| `tool/setup.dart` | Platform setup, permissions, dependencies, analyze and test |
| `test/` | Form validation test and real Hive CRUD/deduplication/reopen persistence test |

## Module alignment

The app keeps the taught methods rather than replacing them with other navigation/database frameworks:

- Lesson 11: MaterialApp `initialRoute` and `routes`; `Navigator.pushNamed` with Map arguments; `ModalRoute.of(context)!.settings.arguments`; `Navigator.pop` for back actions.
- Lesson 12: `Hive.initFlutter`, `Hive.openBox`, Map values, `box.put`, `box.values`, and `box.delete`. No custom objects or adapters are needed for Maps. `box.listenable()` refreshes screens when storage changes.
- Lesson 13: `http.get(Uri.parse(...))`, `statusCode == 200`, `jsonDecode`, initState, setState, ListView.builder/ListTile; `http.post`, JSON Content-Type, `jsonEncode`, and status 201. Unlike the module's console-only examples, results and errors are shown on screen as required by the exam.

## Required demonstration / screenshot checklist

Capture real screenshots from your running app. No screenshots or recording in this bundle are claimed as runtime evidence.

1. Posts list after successful GET.
2. Details with the selected ID, title, and body.
3. New post success message after submitting nonempty title/body.
4. Favorites after saving a post (tap Save twice/return to verify no duplicate).
5. Favorites with a saved personal note.
6. Remove confirmation and list after deletion.
7. Save another post and note. Force-close the Android app without clearing data. Reopen it, open Favorites, and capture the same post/note.
8. Optional: blank POST validation and network failure screen (turn internet off before refreshing, then restore and retry).

Fill in the exam form yourself: name, student number, section, professor, and actual GitHub link. These values were not provided. Use the required submission name `ITP107_FinalsLabExam_Section_LastName.zip`, replacing Section and LastName with your actual information. After setup, submit the complete project folder including generated platform directories, lib, pubspec.yaml, pubspec.lock, assets, and your evidence. Exclude build and .dart_tool caches.

## Troubleshooting

- `flutter`/`dart` not recognized: add Flutter's bin folder to PATH and reopen the terminal. Run `where flutter` in CMD or `Get-Command flutter` in PowerShell.
- No device: start an emulator or select Chrome/Edge from `flutter devices`.
- Downloads fail: check your internet, proxy, and access to pub.dev / Flutter SDK servers. Run setup again after fixing the connection.
- Gradle/JDK errors: use Android Studio's bundled JDK and run flutter doctor. Avoid manually copying Gradle files from another project.
- Android network requests fail: verify emulator internet access. The setup script adds INTERNET permission; inspect android/app/src/main/AndroidManifest.xml if you skipped setup.
- Favorites appear missing in web: use the same browser and the fixed port above. Do not clear site data.
- To rerun checks: `flutter analyze` then `flutter test`.

## Validation status

The source files, pubspec asset paths, bundled TTF/PNG, requirement coverage, and ZIP integrity were checked in the authoring environment. Flutter and Dart are not installed there, so Flutter analysis, tests, build, actual requests from the app, and emulator/browser screenshots could not be executed. The supplied setup script runs analysis and tests on your machine; capture runtime evidence using the checklist above before submission.

Official references: https://docs.flutter.dev/cookbook/navigation/named-routes · https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments · https://docs.flutter.dev/cookbook/networking/fetch-data · https://docs.flutter.dev/cookbook/networking/send-data · https://pub.dev/packages/hive · https://pub.dev/packages/hive_flutter

## v4 design update

A cozy indoor pixel library replaces the night valley. Walnut walls, layered wooden bookcases, colorful book spines, a reading desk, parchment pages, a woven rug, and brass lamps give the interface a retro reading-room identity. The shared palette uses warm brown foundations, parchment text, copper borders, amber actions, and restrained sage and terracotta accents. The v4 visual design is retained in v5.

## v5 MockAPI and deployment

Endpoint: https://6acc9ec1b406cb8ec0c60bd4.mockapi.io/api/v1/posts

The resource needs automatically generated `id` plus string `title` and `body` fields. The app sends title/body JSON without assigning an ID. String IDs are preserved without integer conversion. MockAPI favorites use a new `mockApiFavoritesBox` to avoid conflicts with older JSONPlaceholder favorites sharing the same IDs. Old favorites are not deleted but do not appear in the new collection.

For an existing Android/web project, copy the new `lib/`, `assets/`, `test/`, `tool/`, and `.github/` folders and `pubspec.yaml` into it, then run `flutter pub get`, `flutter analyze`, and `flutter test`. If you have not generated platforms yet, run `dart tool/setup.dart`. Restart the app fully after changing its Hive box name.

`test/posts_api_test.dart` uses an HTTP mock client to check string IDs, POST payload/status parsing, selected-ID DELETE, invalid schema, and failure responses. No tests mutate the live endpoint. The included API_VERIFICATION.txt records separate live HTTP checks performed during authoring; it does not claim emulator verification.

See GITHUB_PAGES_SETUP.md for publication. The included `.github/workflows/deploy.yml` runs setup/checks, builds Flutter web with the repository's Pages base path, and deploys it. You must commit this folder at the repository root and select GitHub Actions as the Pages source. No GitHub repository was supplied, so the workflow has not been run or published here.

Capture extra evidence for this version: add a post, tap Done, reopen/refresh and see it; delete that post with confirmation and verify it stays absent after refreshing.
