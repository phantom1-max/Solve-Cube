import 'package:flutter/material.dart';
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
        cardTheme: CardTheme(
          color: const Color(0xFF1A1C25),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
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
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1A1C25), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF2C2F3D))),
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

class _PuzzleWorkspacePageState extends State<PuzzleWorkspacePage> {
  static const palette = [Color(0xFFF4F1E8), Color(0xFFFFD166), Color(0xFFEF6A6A), Color(0xFFFF9D45), Color(0xFF66C99A), Color(0xFF6C8CFF)];
  static const labels = ['White', 'Yellow', 'Red', 'Orange', 'Green', 'Blue'];
  int selectedColor = 0;
  late List<List<int>> faces;

  @override
  void initState() {
    super.initState();
    final count = widget.puzzle.size * widget.puzzle.size;
    faces = List.generate(6, (_) => List.filled(count, 0));
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.puzzle.size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.puzzle.name), backgroundColor: Colors.transparent),
      body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        const Text('ENTER YOUR PUZZLE', style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
        const SizedBox(height: 8),
        const Text('Tap a sticker to colour it.', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 7),
        Text('Choose a colour below, then fill in each face. This is the manual-entry workspace; scanning and solving are not enabled yet.', style: TextStyle(color: Colors.white.withOpacity(.62), height: 1.45)),
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
              Text(['UP', 'RIGHT', 'FRONT', 'DOWN', 'LEFT', 'BACK'][face], style: const TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800, color: Color(0xFF9DA4BC))),
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
