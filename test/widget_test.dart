import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:het_jani_smiley_painter/main.dart';

import 'support/activity_checks.dart';

void main() {
  test('shouldRepaint checks every input and skips identical inputs', () {
    final original = SmileyPainter(
      mood: 0.8,
      faceColor: Colors.orange,
      faceType: FaceType.classic,
    );
    expect(
      SmileyPainter(
        mood: 0.8,
        faceColor: Colors.orange,
        faceType: FaceType.classic,
      ).shouldRepaint(original),
      isFalse,
    );
    expect(
      SmileyPainter(
        mood: 0.2,
        faceColor: Colors.orange,
        faceType: FaceType.classic,
      ).shouldRepaint(original),
      isTrue,
    );
    expect(
      SmileyPainter(
        mood: 0.8,
        faceColor: Colors.blue,
        faceType: FaceType.classic,
      ).shouldRepaint(original),
      isTrue,
    );
    expect(
      SmileyPainter(
        mood: 0.8,
        faceColor: Colors.orange,
        faceType: FaceType.sleepy,
      ).shouldRepaint(original),
      isTrue,
    );
  });

  test('mood bands include the assignment boundaries', () {
    expect(moodColor(0.349), moodColor(0.0));
    expect(moodColor(0.35), moodColor(0.70));
    expect(moodColor(0.701), moodColor(1.0));
    expect(moodColor(0.349), isNot(moodColor(0.35)));
    expect(moodColor(0.70), isNot(moodColor(0.701)));
  });

  for (final size in [
    const Size(393, 851),
    const Size(851, 393),
    const Size(320, 568),
    const Size(568, 320),
  ]) {
    testWidgets('controls and drawing work at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SmileyApp());
      await checkInteractions(tester);
      final canvasSize = tester.getSize(find.byKey(const Key('smileyCanvas')));
      expect(canvasSize.width, greaterThan(0));
      expect(canvasSize.width, lessThanOrEqualTo(size.width));
      expect(canvasSize.height, lessThanOrEqualTo(size.height));
    });
  }
}
