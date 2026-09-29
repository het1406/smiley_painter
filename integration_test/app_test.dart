import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:het_jani_smiley_painter/main.dart';

import '../test/support/activity_checks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android portrait and landscape interactions', (tester) async {
    addTearDown(() => SystemChrome.setPreferredOrientations([]));
    for (final orientation in [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
    ]) {
      await SystemChrome.setPreferredOrientations([orientation]);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpWidget(const SmileyApp());
      await tester.pumpAndSettle();
      final size = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(
        size.width > size.height,
        orientation == DeviceOrientation.landscapeLeft,
      );
      await checkInteractions(tester);
    }
  });
}
