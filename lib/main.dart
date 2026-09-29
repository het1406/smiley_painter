// In-Class Activity 06 — Drawing with Flutter
// Student: Het Jani
// Date: September 29, 2026

import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

enum FaceType { classic, sleepy, surprised }

String faceName(FaceType type) => switch (type) {
  FaceType.classic => 'Classic',
  FaceType.sleepy => 'Sleepy',
  FaceType.surprised => 'Surprised',
};

// Random color variations stay in the required cool/yellow/warm mood bands.
Color moodColor(double mood, [double variation = 0.5]) {
  if (mood < 0.35) {
    return Color.lerp(
      const Color(0xFFACD8F4),
      const Color(0xFF73AFE1),
      variation,
    )!;
  }
  if (mood <= 0.70) {
    return Color.lerp(
      const Color(0xFFFFED9B),
      const Color(0xFFFFD95A),
      variation,
    )!;
  }
  return Color.lerp(
    const Color(0xFFFFC36B),
    const Color(0xFFFFA24C),
    variation,
  )!;
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Het's Smiley Lab",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7354A6),
        scaffoldBackgroundColor: const Color(0xFFF7F3FC),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F3FC),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF342440),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType faceType = FaceType.classic;
  Color faceColor = moodColor(0.8);
  final random = math.Random();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _cycleFace() {
    setState(() {
      faceType = FaceType.values[(faceType.index + 1) % FaceType.values.length];
    });
    _showMessage('Face changed to ${faceName(faceType)}.');
  }

  void _randomize() {
    setState(() {
      mood = random.nextDouble();
      faceColor = moodColor(mood, random.nextDouble());
      faceType = FaceType.values[random.nextInt(FaceType.values.length)];
    });
    _showMessage('Randomized mood, color, and face!');
  }

  Widget _drawing() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: Semantics(
            label:
                '${faceName(faceType)} face, mood ${mood.toStringAsFixed(2)}',
            hint: 'Tap to change style. Long press to randomize.',
            button: true,
            child: GestureDetector(
              key: const Key('faceGesture'),
              behavior: HitTestBehavior.opaque,
              onTap: _cycleFace,
              onLongPress: _randomize,
              child: CustomPaint(
                key: const Key('smileyCanvas'),
                size: Size.square(side),
                painter: SmileyPainter(
                  mood: mood,
                  faceColor: faceColor,
                  faceType: faceType,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _controls() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFE4D9F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Het Jani • Activity 06',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: const Color(0xFF7354A6)),
            ),
            const SizedBox(height: 12),
            Text(
              'Current face: ${faceName(faceType)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              key: const Key('faceSelector'),
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: FaceType.values.map((type) {
                return ChoiceChip(
                  key: Key('select_${type.name}'),
                  label: Text(faceName(type)),
                  selected: type == faceType,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => faceType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Mood: ${mood.toStringAsFixed(2)}'),
            Slider(
              value: mood,
              min: 0.0,
              max: 1.0,
              label: mood.toStringAsFixed(2),
              onChanged: (double value) {
                setState(() {
                  mood = value;
                  faceColor = moodColor(value);
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Sad'), Text('Neutral'), Text('Happy')],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap face to change style • Long press to randomize',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              return Row(
                children: [
                  Expanded(child: _drawing()),
                  Expanded(child: SingleChildScrollView(child: _controls())),
                ],
              );
            }
            // Scrolling also supports small phones and enlarged system text.
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: math.min(
                      constraints.maxWidth,
                      constraints.maxHeight * 0.55,
                    ),
                    child: _drawing(),
                  ),
                  _controls(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceColor,
    required this.faceType,
  });

  final double mood;
  final Color faceColor;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = const Color(0xFF342440)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final eyes = Paint()
      ..color = const Color(0xFF342440)
      ..style = PaintingStyle.fill;

    // Draw the soft background halo before the face and its features.
    final halo = Paint()..color = const Color(0xFFEAE0F6);
    canvas.drawCircle(center, radius * 1.13, halo);
    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, stroke);
    switch (faceType) {
      case FaceType.classic:
        _drawClassic(canvas, center, radius, eyes, stroke);
      case FaceType.sleepy:
        _drawSleepy(canvas, center, radius, stroke);
      case FaceType.surprised:
        _drawSurprised(canvas, center, radius, eyes, stroke);
    }
  }

  void _drawClassic(
    Canvas canvas,
    Offset center,
    double radius,
    Paint eyes,
    Paint stroke,
  ) {
    final eyeY = center.dy - radius * 0.22;
    final eyeDx = radius * 0.32;
    final glint = Paint()..color = Colors.white;
    for (final direction in [-1, 1]) {
      final eye = Offset(center.dx + direction * eyeDx, eyeY);
      canvas.drawCircle(eye, radius * 0.105, eyes);
      canvas.drawCircle(
        eye - Offset(radius * 0.025, radius * 0.035),
        radius * 0.025,
        glint,
      );
    }
    _drawMoodMouth(canvas, center, radius, stroke);
  }

  void _drawMoodMouth(
    Canvas canvas,
    Offset center,
    double radius,
    Paint stroke,
  ) {
    final sad = mood < 0.35;
    // The upper arc is a frown; the lower arc is a smile. Angles use
    // radians, and every mouth dimension scales with the face radius.
    final depth = sad
        ? 0.20 + (0.35 - mood) * 0.95
        : mood <= 0.70
        ? 0.12 + (mood - 0.35) * 0.5
        : 0.45 + (mood - 0.70) * 1.0;
    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * (sad ? 0.53 : 0.18)),
      width: radius * (mood > 0.70 ? 1.06 : 0.86),
      height: radius * depth,
    );
    canvas.drawArc(
      mouthRect,
      (sad ? 1.15 : 0.15) * math.pi,
      0.70 * math.pi,
      false,
      stroke,
    );
  }

  void _drawSleepy(Canvas canvas, Offset center, double radius, Paint stroke) {
    final eyeY = center.dy - radius * 0.22;
    for (final direction in [-1, 1]) {
      final eyeX = center.dx + direction * radius * 0.35;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(eyeX, eyeY),
          width: radius * 0.30,
          height: radius * 0.16,
        ),
        0.1 * math.pi,
        0.8 * math.pi,
        false,
        stroke,
      );
    }
    _drawMoodMouth(canvas, center, radius * 0.55, stroke);
  }

  void _drawSurprised(
    Canvas canvas,
    Offset center,
    double radius,
    Paint eyes,
    Paint stroke,
  ) {
    final highlight = Paint()..color = Colors.white;
    for (final direction in [-1, 1]) {
      final eye = Offset(
        center.dx + direction * radius * 0.35,
        center.dy - radius * 0.28,
      );
      canvas.drawCircle(eye, radius * 0.17, eyes);
      canvas.drawLine(
        eye + Offset(-radius * 0.12, -radius * 0.27),
        eye + Offset(radius * 0.12, -radius * 0.30),
        stroke,
      );
      canvas.drawCircle(
        eye - Offset(radius * 0.04, radius * 0.05),
        radius * 0.05,
        highlight,
      );
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.35),
        width: radius * (0.30 + mood * 0.10),
        height: radius * (0.30 + mood * 0.24),
      ),
      eyes,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceColor != faceColor ||
        oldDelegate.faceType != faceType;
  }
}
