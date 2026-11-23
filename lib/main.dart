import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'src/three_by_three_solver.dart';
import 'src/cube_color_validator.dart';

void main() => runApp(const SolveCubeApp());

class SolveCubeApp extends StatelessWidget {
  const SolveCubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6C7CFF);
    return MaterialApp(
      title: 'Solve Cube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF101116),
      ),
      home: const PuzzleHomePage(),
    );
  }
}

enum PuzzleKind { cube, pyraminx, mirror, comingSoon }

class Puzzle {
  const Puzzle(this.name, this.subtitle, this.kind, this.size, this.symbol);
  final String name;
  final String subtitle;
  final PuzzleKind kind;
  final int size;
  final String symbol;
}

const puzzles = <Puzzle>[
  Puzzle('2×2 Cube', 'Pocket cube · beginner friendly', PuzzleKind.cube, 2, '▦'),
  Puzzle('3×3 Cube', 'The classic Rubik’s Cube', PuzzleKind.cube, 3, '▦'),
  Puzzle('4×4 Cube', 'Rubik’s Revenge', PuzzleKind.cube, 4, '▦'),
  Puzzle('5×5 Cube', 'Professor’s Cube', PuzzleKind.cube, 5, '▦'),
  Puzzle('6×6 Cube', 'Large cube', PuzzleKind.cube, 6, '▦'),
  Puzzle('7×7 Cube', 'Largest first-release cube', PuzzleKind.cube, 7, '▦'),
  Puzzle('Pyraminx', 'Four-sided triangular puzzle', PuzzleKind.pyraminx, 3, '△'),
  Puzzle('Mirror Cube', 'Shape-shifting 3×3 puzzle', PuzzleKind.mirror, 3, '◇'),
  Puzzle('Gear Cube', 'A mechanical twisty puzzle', PuzzleKind.comingSoon, 0, '⚙'),
];

class PuzzleHomePage extends StatelessWidget {
  const PuzzleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final available = puzzles.where((p) => p.kind != PuzzleKind.comingSoon).toList();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
              sliver: SliverToBoxAdapter(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(color: const Color(0xFF252A43), borderRadius: BorderRadius.circular(15)),
                      child: const Icon(Icons.view_in_ar_rounded, color: Color(0xFF9AA6FF), size: 27),
                    ),
                    const SizedBox(width: 12),
                    const Text('SOLVE CUBE', style: TextStyle(fontSize: 13, letterSpacing: 2.2, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    const Icon(Icons.offline_bolt_rounded, color: Color(0xFF8DDBB2), size: 18),
                    const SizedBox(width: 5),
                    const Text('OFFLINE', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Color(0xFF8DDBB2), fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 34),
                  const Text('Let’s solve\nsomething.', style: TextStyle(fontSize: 36, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.2)),
                  const SizedBox(height: 12),
                  Text('Choose your puzzle to get started.', style: TextStyle(color: Colors.white.withOpacity(.62), fontSize: 15)),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF292E50), Color(0xFF202438)]),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF41496F)),
                    ),
                    child: const Row(children: [
                      Icon(Icons.tips_and_updates_outlined, color: Color(0xFFAAB3FF), size: 25),
                      SizedBox(width: 13),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Your puzzle. Your pace.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        SizedBox(height: 4),
                        Text('No account. No cloud. Your puzzle state stays on this device.', style: TextStyle(fontSize: 12, height: 1.35, color: Color(0xFFC3C8DF))),
                      ])),
                    ]),
                  ),
                  const SizedBox(height: 29),
                  const Text('CUBES', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PuzzleCard(puzzle: available[index]),
                  childCount: 6,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.22,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 26, 18, 10),
              sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('SHAPE PUZZLES', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
                const SizedBox(height: 12),
                ...puzzles.where((p) => p.kind == PuzzleKind.pyraminx || p.kind == PuzzleKind.mirror || p.kind == PuzzleKind.comingSoon).map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ShapePuzzleTile(puzzle: p),
                )),
                const SizedBox(height: 18),
                Center(child: Text('SOLVE CUBE  •  VERSION 0.1.0', style: TextStyle(fontSize: 10, letterSpacing: 1.4, color: Colors.white.withOpacity(.35)))),
                const SizedBox(height: 22),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzleCard extends StatelessWidget {
  const PuzzleCard({super.key, required this.puzzle});
  final Puzzle puzzle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PuzzleWorkspacePage(puzzle: puzzle))),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1A1C25), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFF2C2F3D))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Center(child: CubeMark(size: puzzle.size))),
          Text(puzzle.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 3),
          Text(puzzle.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF9DA4BC))),
        ]),
      ),
    );
  }
}

class CubeMark extends StatelessWidget {
  const CubeMark({super.key, required this.size});
  final int size;
  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFFFFD166), const Color(0xFFEF6A6A), const Color(0xFF66C99A), const Color(0xFF6C8CFF), const Color(0xFFF4F1E8), const Color(0xFFFFA45B)];
    return Transform.rotate(
      angle: -.12,
      child: Container(
        width: 70, height: 70, padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: const Color(0xFF292D3C), borderRadius: BorderRadius.circular(14)),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(), crossAxisCount: size, mainAxisSpacing: 2, crossAxisSpacing: 2,
          children: List.generate(size * size, (i) => Container(
            decoration: BoxDecoration(color: colors[(i + size) % colors.length], borderRadius: BorderRadius.circular(2)),
          )),
        ),
      ),
    );
  }
}

class ShapePuzzleTile extends StatelessWidget {
  const ShapePuzzleTile({super.key, required this.puzzle});
  final Puzzle puzzle;
  @override
  Widget build(BuildContext context) {
    final soon = puzzle.kind == PuzzleKind.comingSoon;
    return Material(
      color: const Color(0xFF1A1C25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF2C2F3D)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(width: 43, height: 43, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFF292D3C), borderRadius: BorderRadius.circular(13)), child: Text(puzzle.symbol, style: const TextStyle(fontSize: 24, color: Color(0xFFB4BCFF)))),
        title: Text(puzzle.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(puzzle.subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9DA4BC))),
        trailing: soon ? const Text('COMING SOON', style: TextStyle(fontSize: 9, letterSpacing: .8, color: Color(0xFFFFC76B), fontWeight: FontWeight.w800)) : const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Color(0xFF9DA4BC)),
        onTap: soon ? null : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PuzzleWorkspacePage(puzzle: puzzle))),
      ),
    );
  }
}

class PuzzleWorkspacePage extends StatefulWidget {
  const PuzzleWorkspacePage({super.key, required this.puzzle});
  final Puzzle puzzle;
  @override
  State<PuzzleWorkspacePage> createState() => _PuzzleWorkspacePageState();
}

String _solverMessage(String result) {
  if (result.startsWith('INVALID:')) {
    return 'The entered stickers do not describe a physically reachable cube. (${result.substring(8)})';
  }
  if (result == 'TIMEOUT') {
    return 'The local solver did not find a solution within 20 seconds.';
  }
  return 'The solver could not process this state.';
}

class _PuzzleWorkspacePageState extends State<PuzzleWorkspacePage> {
  static const palette = [Color(0xFFF4F1E8), Color(0xFFFFD166), Color(0xFFEF6A6A), Color(0xFFFF9D45), Color(0xFF66C99A), Color(0xFF6C8CFF)];
  static const labels = ['White', 'Yellow', 'Red', 'Orange', 'Green', 'Blue'];
  int selectedColor = 0;
  late List<List<int>> faces;
  final ImagePicker _picker = ImagePicker();
  final Map<int, Uint8List> _facePhotos = {};

  Future<void> _pickFacePhoto(int face, ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 88);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _facePhotos[face] = bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the image source on this device.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final count = widget.puzzle.size * widget.puzzle.size;
    faces = List.generate(6, (_) => List.filled(count, 0));
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.puzzle.size;
    if (widget.puzzle.kind != PuzzleKind.cube) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.puzzle.name), backgroundColor: Colors.transparent),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.construction_rounded, size: 42, color: Color(0xFFAAB3FF)),
              const SizedBox(height: 18),
              const Text('Custom puzzle editor in progress', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(
                widget.puzzle.kind == PuzzleKind.pyraminx
                    ? 'Pyraminx needs a four-sided piece editor and its own solver. It will not be treated as a standard cube.'
                    : 'Mirror Cube needs a shape-based editor and its own state validation. It will not be treated as a standard cube.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(.65), height: 1.5),
              ),
            ]),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.puzzle.name), backgroundColor: Colors.transparent),
      body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        const Text('ENTER YOUR PUZZLE', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
        const SizedBox(height: 8),
        const Text('Tap a sticker to colour it.', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 7),
        Text('Choose a colour below, then fill in each face. Photos can be attached as references; automatic colour recognition is still in development. The local solver is currently available only for 3×3.', style: TextStyle(color: Colors.white.withOpacity(.62), height: 1.45)),
        const SizedBox(height: 22),
        Wrap(spacing: 10, runSpacing: 10, children: List.generate(palette.length, (i) => InkWell(
          onTap: () => setState(() => selectedColor = i),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(color: selectedColor == i ? const Color(0xFF303653) : const Color(0xFF1A1C25), borderRadius: BorderRadius.circular(14), border: Border.all(color: selectedColor == i ? const Color(0xFF8995FF) : const Color(0xFF303342))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: palette[i], shape: BoxShape.circle)),
              const SizedBox(width: 7),
              Text(labels[i], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ),
        ))),
        const SizedBox(height: 22),
        ...List.generate(6, (face) => Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF1A1C25), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF2C2F3D))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(['UP', 'RIGHT', 'FRONT', 'DOWN', 'LEFT', 'BACK'][face], style: const TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => faces[face] = List<int>.filled(n * n, selectedColor)),
                  child: const Text('Fill face', style: TextStyle(fontSize: 11)),
                ),
                if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS))
                  IconButton(
                    tooltip: 'Take face photo',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _pickFacePhoto(face, ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 19),
                  ),
                IconButton(
                  tooltip: 'Choose face photo',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _pickFacePhoto(face, ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 19),
                ),
              ]),
              if (_facePhotos.containsKey(face)) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(_facePhotos[face]!, height: 100, width: double.infinity, fit: BoxFit.contain),
                ),
              ],
              const SizedBox(height: 10),
              Center(child: SizedBox(
                width: (n * 39.0) + ((n - 1) * 4),
                child: GridView.builder(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n, crossAxisSpacing: 4, mainAxisSpacing: 4),
                  itemCount: n * n,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => setState(() => faces[face][index] = selectedColor),
                    child: Container(decoration: BoxDecoration(color: palette[faces[face][index]], borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black.withOpacity(.35), width: 2))),
                  ),
                ),
              )),
            ]),
          ),
        )),
        OutlinedButton.icon(
          onPressed: () => setState(() => faces = List.generate(6, (_) => List.filled(n * n, 0))),
          icon: const Icon(Icons.refresh_rounded), label: const Text('Reset all stickers'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () {
            final issues = CubeColorValidator.validate(size: n, faces: faces);
            final message = issues.isEmpty
                ? 'Colour counts are balanced. Full puzzle legality is not checked yet.'
                : issues.join('  ');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('Check colour counts'),
        ),
        if (widget.puzzle.kind == PuzzleKind.cube && n == 3) ...[
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () async {
              final definition = cubeDefinitionFromFaces(faces);
              if (definition == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Set six different centre colours before solving.')),
                );
                return;
              }
              final result = await compute(solveCubeDefinition, definition);
              if (!mounted) return;
              final isSolution = result != 'SOLVED' &&
                  !result.startsWith('INVALID:') &&
                  result != 'TIMEOUT' &&
                  result != 'ERROR';
              final heading = result == 'SOLVED'
                  ? 'Already solved'
                  : result.startsWith('INVALID:')
                      ? 'Invalid cube state'
                      : result == 'TIMEOUT'
                          ? 'Solver timed out'
                          : result == 'ERROR'
                              ? 'Solver error'
                              : 'Solution found';
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(heading),
                  content: SingleChildScrollView(
                    child: SelectableText(isSolution ? result : _solverMessage(result)),
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                ),
              );
            },
            child: const Text('Solve 3×3 cube'),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: const Color(0xFF282B39), borderRadius: BorderRadius.circular(16)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFFAAB3FF), size: 19),
            SizedBox(width: 10),
            Expanded(child: Text('Input validation and solver support are still under development. No solution will be shown until the entered state can be checked safely.', style: TextStyle(fontSize: 12, height: 1.45, color: Color(0xFFD0D4E6)))),
          ]),
        ),
      ])),
    );
  }
}
