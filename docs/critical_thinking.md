# Activity 06 Critical Thinking

Student: Het Jani

My face is drawn around `Offset(size.width / 2, size.height / 2)`. Its radius is `size.shortestSide * 0.4`, so the shorter canvas dimension controls its size. I calculate the mouth rectangle's width, height, and position as fractions of that radius. This keeps the mouth proportional to the face when the available space changes. The classic mouth uses `drawArc()` with angles in radians; I use a lower arc for a smile and an upper arc for a frown.

Moving the slider calls `setState()` and passes the new mood and color to the painter. `shouldRepaint()` compares mood, face color, and face type with the previous painter. It returns true when any of these inputs changes and false when they are all unchanged.

## Orientation evidence

Automated checks passed in portrait and landscape on the Pixel 4a Android emulator. They exercised the face buttons, slider, tap, and long press, and checked for layout errors. Local widget tests also passed at 393 × 851, 851 × 393, 320 × 568, and 568 × 320 logical pixels. Review both orientations yourself and add your own observations before submission.

Screenshot evidence:
Insert your own real phone-emulator screenshot here.
