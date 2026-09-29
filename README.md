# Het Jani — Smiley Painter Lab

In-Class Activity 06: Drawing with Flutter.

A purple-themed drawing playground with Classic, Sleepy, and Surprised faces.
Use the face buttons to choose a design, move the mood slider to change its
expression and color, tap the face to cycle styles, or long press to randomize.

The app extends the instructor's `SmileyApp`, `DrawingPlayground`, and
`SmileyPainter` structure. The drawing uses circles, lines, arcs, and ovals
calculated from the canvas size. The UI adapts to portrait and landscape.

## Run

```powershell
flutter pub get
flutter run
```

## Check

```powershell
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d emulator-5554
```

Use the Android device ID reported by `flutter devices` if it differs.

See [submission instructions](docs/submission.md) and
[the critical-thinking draft](docs/critical_thinking.md).
