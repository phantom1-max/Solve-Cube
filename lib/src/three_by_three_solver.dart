import 'package:cuber/cuber.dart';

/// Converts six row-major faces ordered U, R, F, D, L, B into cuber notation.
/// Sticker values are palette indices; each face's centre defines its face letter.
String? cubeDefinitionFromFaces(List<List<int>> faces) {
  if (faces.length != 6 || faces.any((face) => face.length != 9)) return null;
  const letters = ['U', 'R', 'F', 'D', 'L', 'B'];
  final centerToLetter = <int, String>{};
  for (var face = 0; face < 6; face++) {
    final center = faces[face][4];
    if (centerToLetter.containsKey(center)) return null;
    centerToLetter[center] = letters[face];
  }
  final result = StringBuffer();
  for (final face in faces) {
    for (final sticker in face) {
      final letter = centerToLetter[sticker];
      if (letter == null) return null;
      result.write(letter);
    }
  }
  return result.toString();
}

/// Isolate entry point used by Flutter's compute().
String solveCubeDefinition(String definition) {
  try {
    final cube = Cube.from(definition);
    final status = cube.verify();
    if (status != CubeStatus.ok) return 'INVALID:${status.name}';
    final solution = cube.solve(timeout: const Duration(seconds: 20));
    if (solution == null) return 'TIMEOUT';
    if (solution.isEmpty) return 'SOLVED';
    final replayed = solution.algorithm.apply(cube);
    if (!replayed.isSolved) return 'ERROR';
    return solution.algorithm.toString();
  } on ArgumentError {
    return 'INVALID:definition';
  } catch (_) {
    return 'ERROR';
  }
}
