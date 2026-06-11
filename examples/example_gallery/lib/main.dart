import 'package:basic_drag_drop/basic_drag_drop.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/kanban_board.dart';
import 'package:multi_container_sortable/multi_container_sortable.dart';

void main() => runApp(const ExampleGalleryApp());

@immutable
final class _DemoEntry {
  const _DemoEntry({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

final _demos = <_DemoEntry>[
  _DemoEntry(
    label: 'Basic',
    icon: Icons.drag_indicator,
    builder: (_) => const BasicDragDropExample(),
  ),
  _DemoEntry(
    label: 'Kanban',
    icon: Icons.view_kanban_outlined,
    builder: (_) => const KanbanBoardExample(),
  ),
  _DemoEntry(
    label: 'Multi-container',
    icon: Icons.dashboard_customize_outlined,
    builder: (_) => const MultiContainerSortableExample(),
  ),
];

class ExampleGalleryApp extends StatelessWidget {
  const ExampleGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dnd_kit Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2563eb)),
        useMaterial3: true,
      ),
      home: const ExampleGalleryShell(),
    );
  }
}

class ExampleGalleryShell extends StatefulWidget {
  const ExampleGalleryShell({super.key});

  @override
  State<ExampleGalleryShell> createState() => _ExampleGalleryShellState();
}

class _ExampleGalleryShellState extends State<ExampleGalleryShell> {
  var _selectedIndex = 0;

  void _selectDemo(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout = constraints.maxWidth >= 900;
        final selectedDemo = _demos[_selectedIndex];
        final demo = KeyedSubtree(
          key: ValueKey<String>(selectedDemo.label),
          child: selectedDemo.builder(context),
        );

        if (useWideLayout) {
          return Scaffold(
            body: Row(
              children: [
                _GalleryRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectDemo,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: demo),
              ],
            ),
          );
        }

        return Scaffold(
          body: demo,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectDemo,
            destinations: [
              for (final demo in _demos)
                NavigationDestination(
                  icon: Icon(demo.icon),
                  label: demo.label,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GalleryRail extends StatelessWidget {
  const _GalleryRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 232,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        extended: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Row(
            children: [
              Icon(Icons.open_with, color: colorScheme.primary),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'dnd_kit',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        destinations: [
          for (final demo in _demos)
            NavigationRailDestination(
              icon: Icon(demo.icon),
              label: Text(demo.label),
            ),
        ],
      ),
    );
  }
}
