import 'package:flutter_test/flutter_test.dart';
import 'package:solve_cube/main.dart';
import 'package:solve_cube/src/cube_color_validator.dart';

void main() {
  mainValidatorTests();
  testWidgets('shows puzzle choices and coming soon state', (tester) async {
    await tester.pumpWidget(const SolveCubeApp());
    expect(find.text('Let’s solve\nsomething.'), findsOneWidget);
    expect(find.text('2×2 Cube'), findsOneWidget);
    expect(find.text('3×3 Cube'), findsOneWidget);
    expect(find.text('Gear Cube'), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
  });

  testWidgets('opens manual entry workspace for 3x3', (tester) async {
    await tester.pumpWidget(const SolveCubeApp());
    await tester.tap(find.text('3×3 Cube'));
    await tester.pumpAndSettle();
    expect(find.text('ENTER YOUR PUZZLE'), findsOneWidget);
    expect(find.text('FRONT'), findsOneWidget);
    expect(find.text('Reset all stickers'), findsOneWidget);
  });
}

void mainValidatorTests() {
  test('accepts six faces with balanced sticker counts', () {
    final faces = List.generate(6, (face) => List<int>.filled(9, face));
    expect(CubeColorValidator.validate(size: 3, faces: faces), isEmpty);
  });

  test('rejects unbalanced sticker counts', () {
    final faces = List.generate(6, (_) => List<int>.filled(9, 0));
    expect(CubeColorValidator.validate(size: 3, faces: faces), isNotEmpty);
  });
}
