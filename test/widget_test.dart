import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solve_cube/main.dart';
import 'package:solve_cube/src/cube_color_validator.dart';
import 'package:solve_cube/src/three_by_three_solver.dart';

void main() {
  test('accepts six faces with balanced sticker counts', () {
    final faces = List.generate(6, (face) => List<int>.filled(9, face));
    expect(CubeColorValidator.validate(size: 3, faces: faces), isEmpty);
  });

  test('rejects unbalanced sticker counts', () {
    final faces = List.generate(6, (_) => List<int>.filled(9, 0));
    expect(CubeColorValidator.validate(size: 3, faces: faces), isNotEmpty);
  });

  test('maps face centres to standard cube notation', () {
    final faces = List.generate(6, (face) => List<int>.filled(9, face));
    expect(
      cubeDefinitionFromFaces(faces),
      'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB',
    );
  });

  test('expands prime and double turns for 3D playback', () {
    final moves = parseSolutionMoves("R U' F2");
    expect(moves.map((move) => move.name.toUpperCase()).toList(), ['R', 'UI', 'F', 'F']);
  });

  test('recognizes an already-solved 3x3 cube', () {
    const solved = 'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB';
    expect(solveCubeDefinition(solved), 'SOLVED');
  });

  testWidgets('shows puzzle choices and coming soon state', (tester) async {
    await tester.pumpWidget(const SolveCubeApp());
    expect(find.text('Let’s solve\nsomething.'), findsOneWidget);
    expect(find.text('2×2 Cube'), findsOneWidget);
    expect(find.text('3×3 Cube'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Gear Cube'),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Gear Cube'), findsOneWidget);
    expect(find.text('COMING SOON'), findsOneWidget);
  });

  testWidgets('opens manual entry workspace for 3x3', (tester) async {
    await tester.pumpWidget(const SolveCubeApp());
    await tester.ensureVisible(find.text('3×3 Cube'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3×3 Cube'));
    await tester.pumpAndSettle();
    expect(find.text('ENTER YOUR PUZZLE'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('FRONT'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('FRONT'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Reset all stickers'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Reset all stickers'), findsOneWidget);
  });
}
