import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:het_jani_smiley_painter/main.dart';

SmileyPainter currentPainter(WidgetTester tester) {
  return tester
          .widget<CustomPaint>(find.byKey(const Key('smileyCanvas')))
          .painter!
      as SmileyPainter;
}

Future<void> checkInteractions(WidgetTester tester) async {
  final face = find.byKey(const Key('faceGesture'));
  expect(currentPainter(tester).faceType, FaceType.classic);
  expect(find.text('Mood: 0.80'), findsOneWidget);

  // Tap cycles through all designs, including the return to Classic.
  for (final type in [FaceType.sleepy, FaceType.surprised, FaceType.classic]) {
    await tester.tap(face);
    await tester.pumpAndSettle();
    expect(currentPainter(tester).faceType, type);
    expect(find.text('Current face: ${faceName(type)}'), findsOneWidget);
    expect(find.text('Face changed to ${faceName(type)}.'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  }

  // Give the last SnackBar time to leave before using the controls.
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const Key('select_surprised')));
  await tester.tap(find.byKey(const Key('select_surprised')));
  await tester.pumpAndSettle();
  expect(currentPainter(tester).faceType, FaceType.surprised);

  await tester.ensureVisible(find.byKey(const Key('select_classic')));
  await tester.tap(find.byKey(const Key('select_classic')));
  await tester.pumpAndSettle();

  final slider = find.byType(Slider);
  await tester.ensureVisible(slider);
  final bounds = tester.getRect(slider);
  for (final fraction in [0.0, 0.5, 1.0]) {
    await tester.tapAt(
      Offset(
        bounds.left + 24 + (bounds.width - 48) * fraction,
        bounds.center.dy,
      ),
    );
    await tester.pumpAndSettle();
    final painter = currentPainter(tester);
    expect(painter.mood, closeTo(fraction, 0.08));
    expect(painter.faceColor, moodColor(painter.mood));
    expect(
      find.text('Mood: ${painter.mood.toStringAsFixed(2)}'),
      findsOneWidget,
    );
  }

  await tester.ensureVisible(face);
  final previousMood = currentPainter(tester).mood;
  await tester.longPress(face);
  await tester.pumpAndSettle();
  final randomized = currentPainter(tester);
  expect(randomized.mood, inInclusiveRange(0.0, 1.0));
  expect(randomized.mood, isNot(previousMood));
  expect(find.text('Randomized mood, color, and face!'), findsOneWidget);
  expect(find.byType(SnackBar), findsOneWidget);
  expect(tester.takeException(), isNull);
}
