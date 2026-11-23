class CubeColorValidator {
  static const int colorCount = 6;

  /// Checks sticker totals only. This is not a full cube reachability test.
  static List<String> validate({
    required int size,
    required List<List<int>> faces,
  }) {
    if (size < 2 || size > 7) return ['Unsupported cube size.'];
    if (faces.length != 6) return ['A cube must have six faces.'];

    final expectedPerColor = size * size;
    final counts = List<int>.filled(colorCount, 0);
    final issues = <String>[];

    for (var face = 0; face < faces.length; face++) {
      if (faces[face].length != expectedPerColor) {
        issues.add('Face ${face + 1} must contain $expectedPerColor stickers.');
        continue;
      }
      for (final color in faces[face]) {
        if (color < 0 || color >= colorCount) {
          issues.add('Face ${face + 1} contains an unknown colour.');
        } else {
          counts[color]++;
        }
      }
    }

    if (issues.isNotEmpty) return issues;
    for (var color = 0; color < colorCount; color++) {
      if (counts[color] != expectedPerColor) {
        issues.add(
            'Colour ${color + 1}: expected $expectedPerColor stickers, found ${counts[color]}.');
      }
    }
    return issues;
  }
}
