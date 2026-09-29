# Het Jani — Activity 06 submission

Project folder: `D:\Map\het_jani_smiley_painter`

## Requirements covered

- Level 1: bordered circular face, symmetrical round eyes, and an arc smile.
- Level 2: live mood slider with cool blue below 0.35, yellow from 0.35 through 0.70, and warm orange above 0.70. Mood changes the mouth geometry.
- Level 3: Classic, Sleepy, and Surprised designs, selected with buttons.
- Level 4: tap to cycle faces; long press to randomize mood, color, and type. Each gesture clears previous SnackBars before displaying its message.
- Responsive coordinates and a `shouldRepaint()` comparison for every changing painter input.

The app uses `com.hetjani.het_jani_smiley_painter` as its Android application ID and appears as **Het's Smiley Lab** on the phone.

## Build the APK

```powershell
flutter clean
flutter pub get
flutter build apk --release
```

Expected output: `D:\Map\het_jani_smiley_painter\build\app\outputs\flutter-apk\app-release.apk`.

The Flutter Android template uses its debug signing key for this classroom release build.

## GitHub

The destination repository URL is pending. After the initial source commit, the project can be pushed with:

```powershell
git remote add origin YOUR_REPOSITORY_URL
git push -u origin main
```

Source, tests, and documentation belong in Git. The APK stays in the ignored build folder and can be submitted separately.

## Submission packet

1. Release APK.
2. Het's GitHub repository URL.
3. Critical-thinking response with a real screenshot taken by Het.

Read through the implementation, run the app, and ensure the response describes your own understanding and observations. No screenshots are generated automatically.
