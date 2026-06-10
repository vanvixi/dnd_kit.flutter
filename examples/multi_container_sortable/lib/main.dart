import 'dart:math' as math;
import 'dart:ui';

import 'package:dnd_kit/dnd_kit.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MultiContainerSortableApp());

class MultiContainerSortableApp extends StatelessWidget {
  const MultiContainerSortableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dnd_kit Multi-Container Sortable',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff8b5cf6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MultiContainerSortableExample(),
    );
  }
}

@immutable
class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.owner,
    required this.color,
  });

  final String id;
  final String title;
  final String description;
  final String priority;
  final String owner;
  final Color color;
}

final Map<String, TaskItem> _tasks = {
  'task-1': const TaskItem(
    id: 'task-1',
    title: 'Design Dark Mode UI',
    description:
        'Create premium dark-themed wireframes with nice glassmorphism gradients.',
    priority: 'High',
    owner: 'Mina',
    color: Color(0xffa88beb),
  ),
  'task-2': const TaskItem(
    id: 'task-2',
    title: 'Implement Multi-Container API',
    description:
        'Integrate the new SortableContainer model and compute move details.',
    priority: 'Medium',
    owner: 'Kai',
    color: Color(0xfff3a683),
  ),
  'task-3': const TaskItem(
    id: 'task-3',
    title: 'Write Widget Tests',
    description: 'Cover cross-container sorting scenarios in automated tests.',
    priority: 'Medium',
    owner: 'Sora',
    color: Color(0xff574b90),
  ),
  'task-4': const TaskItem(
    id: 'task-4',
    title: 'Release dnd_kit v1.0.0',
    description:
        'Ship stable version with all benchmarks and telemetry checks.',
    priority: 'Low',
    owner: 'An',
    color: Color(0xff3dc1d3),
  ),
  'task-5': const TaskItem(
    id: 'task-5',
    title: 'Analyze Performance',
    description: 'Ensure drag operations take less than 16ms per frame on web.',
    priority: 'High',
    owner: 'Tuan',
    color: Color(0xfff78fb3),
  ),
};

class MultiContainerSortableExample extends StatefulWidget {
  const MultiContainerSortableExample({super.key});

  @override
  State<MultiContainerSortableExample> createState() =>
      _MultiContainerSortableExampleState();
}

class _MultiContainerSortableExampleState
    extends State<MultiContainerSortableExample> {
  late final DndController _controller;

  List<SortableContainer> _containers = [
    SortableContainer(
      id: const DndId('backlog'),
      itemIds: const [
        DndId('task-1'),
        DndId('task-2'),
      ],
    ),
    SortableContainer(
      id: const DndId('in_progress'),
      itemIds: const [
        DndId('task-3'),
        DndId('task-4'),
      ],
    ),
    SortableContainer(
      id: const DndId('completed'),
      itemIds: const [
        DndId('task-5'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = DndController(
      collisionDetector: _multiContainerCollisionDetector,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragEnd(DndDragEndEvent event) {
    final move = SortableMultiContainer.moveDetailsFor(
      event,
      containers: _containers,
    );

    if (move == null) {
      _controller.reset();
      return;
    }

    final fromId = move.fromContainerId;
    final toId = move.toContainerId;

    if (fromId == null || toId == null) {
      _controller.reset();
      return;
    }

    if (fromId == toId) {
      // Same-container sorting
      setState(() {
        _containers = _containers.map((container) {
          if (container.id == fromId) {
            final items = List<DndId>.from(container.itemIds);
            final removed = items.removeAt(move.fromIndex);
            items.insert(move.toIndex, removed);
            return SortableContainer(id: container.id, itemIds: items);
          }
          return container;
        }).toList();
      });
      _controller.reset();
    } else {
      // Cross-container move
      final activeItem = move.activeId;

      // Phase 1: Remove item from original container to avoid duplicate registration
      setState(() {
        _containers = _containers.map((container) {
          if (container.id == fromId) {
            final items = List<DndId>.from(container.itemIds);
            items.removeAt(move.fromIndex);
            return SortableContainer(id: container.id, itemIds: items);
          }
          return container;
        }).toList();
      });

      // Phase 2: Add item to target container in the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _containers = _containers.map((container) {
            if (container.id == toId) {
              final items = List<DndId>.from(container.itemIds);
              final targetIndex = move.toIndex.clamp(0, items.length);
              items.insert(targetIndex, activeItem);
              return SortableContainer(id: container.id, itemIds: items);
            }
            return container;
          }).toList();
        });
      });
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DndScope(
      controller: _controller,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff090d16),
                Color(0xff111827),
                Color(0xff1f2937),
              ],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Color(0xff8b5cf6),
                                      Color(0xff06b6d4)
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Interactive Board',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Experimental Multi-Container Sortable Showcase (Web Only)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xff8b5cf6)
                                  .withValues(alpha: 0.15),
                              border: Border.all(
                                color: const Color(0xff8b5cf6)
                                    .withValues(alpha: 0.35),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.bolt,
                                    size: 16, color: Color(0xffa78bfa)),
                                SizedBox(width: 4),
                                Text(
                                  'v1.0-dev',
                                  style: TextStyle(
                                    color: Color(0xffa78bfa),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Column Layout
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final container in _containers)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: _BoardColumnWidget(
                                    container: container,
                                    onDragEnd: _handleDragEnd,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Drag Overlay
              DndDragOverlay(
                controller: _controller,
                builder: (context, details) {
                  final taskId = details.activeId.value;
                  final task = _tasks[taskId];
                  if (task == null) return const SizedBox.shrink();

                  return Transform.rotate(
                    angle: math.pi / 60, // 3 degrees rotation
                    child: _TaskCardContent(
                      task: task,
                      isDraggingOverlay: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardColumnWidget extends StatelessWidget {
  const _BoardColumnWidget({
    required this.container,
    required this.onDragEnd,
  });

  final SortableContainer container;
  final DndDragEndCallback onDragEnd;

  String get _title {
    switch (container.id.value) {
      case 'backlog':
        return 'Backlog';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return container.id.value;
    }
  }

  IconData get _icon {
    switch (container.id.value) {
      case 'backlog':
        return Icons.folder_open_outlined;
      case 'in_progress':
        return Icons.incomplete_circle_outlined;
      case 'completed':
        return Icons.task_alt_outlined;
      default:
        return Icons.list_alt_outlined;
    }
  }

  Color get _color {
    switch (container.id.value) {
      case 'backlog':
        return const Color(0xfff3a683);
      case 'in_progress':
        return const Color(0xff06b6d4);
      case 'completed':
        return const Color(0xff10b981);
      default:
        return const Color(0xff8b5cf6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DndDroppable(
      key: ValueKey('column-drop:${container.id.value}'),
      id: container.id,
      builder: (context, details, child) {
        final isOver = details.isOver;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isOver ? 0.06 : 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOver
                  ? _color.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.06),
              width: isOver ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (isOver)
                BoxShadow(
                  color: _color.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Column Header
                Row(
                  children: [
                    Icon(_icon, color: _color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${container.itemIds.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                const SizedBox(height: 16),

                // Cards List
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final itemId in container.itemIds) ...[
                          if (_tasks[itemId.value] != null)
                            Padding(
                              key: ValueKey('task-padding:${itemId.value}'),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _DraggableCard(
                                key: ValueKey('task-card:${itemId.value}'),
                                task: _tasks[itemId.value]!,
                                onDragEnd: onDragEnd,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DraggableCard extends StatefulWidget {
  const _DraggableCard({
    super.key,
    required this.task,
    required this.onDragEnd,
  });

  final TaskItem task;
  final DndDragEndCallback onDragEnd;

  @override
  State<_DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<_DraggableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final taskDndId = DndId(widget.task.id);

    return DndDroppable(
      key: ValueKey('task-drop:${widget.task.id}'),
      id: taskDndId,
      builder: (context, details, child) {
        final isOver = details.isOver;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            border: Border.all(
              color: isOver ? const Color(0xff8b5cf6) : Colors.transparent,
              width: isOver ? 2.0 : 0.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: DndDraggable(
          key: ValueKey('drag:${widget.task.id}'),
          id: taskDndId,
          onDragEnd: widget.onDragEnd,
          activationConstraint:
              const DndSensorActivationConstraint(distance: 4),
          builder: (context, details, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: details.isDragging ? 0.35 : 1.0,
              child: child,
            );
          },
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: _TaskCardContent(
              task: widget.task,
              isHovered: _isHovered,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCardContent extends StatelessWidget {
  const _TaskCardContent({
    required this.task,
    this.isDraggingOverlay = false,
    this.isHovered = false,
  });

  final TaskItem task;
  final bool isDraggingOverlay;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final themeColor = task.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDraggingOverlay ? 0.12 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHovered || isDraggingOverlay
              ? themeColor.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: isDraggingOverlay ? 0.4 : 0.15),
            blurRadius: isDraggingOverlay ? 16 : 8,
            offset: Offset(0, isDraggingOverlay ? 8 : 4),
          ),
          if (isHovered || isDraggingOverlay)
            BoxShadow(
              color: themeColor.withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for Priority & Accent Color Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _priorityColor(task.priority).withValues(alpha: 0.12),
                  border: Border.all(
                    color: _priorityColor(task.priority).withValues(alpha: 0.4),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(
                    color: _priorityColor(task.priority),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            task.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),

          // Owner Avatar & Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.owner,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.drag_indicator,
                size: 16,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xffef4444); // Red
      case 'Medium':
        return const Color(0xfff59e0b); // Amber
      case 'Low':
        return const Color(0xff10b981); // Emerald
      default:
        return const Color(0xff9ca3af); // Gray
    }
  }
}

DndCollisionResult _multiContainerCollisionDetector(DndCollisionInput input) {
  // 1. Pointer inside collisions
  final pointerWithin = DndCollisionDetectors.pointerWithin(input);
  if (pointerWithin.isNotEmpty) {
    // Prioritize task card droppables over column droppables
    final taskResult = DndCollisionResult(
      pointerWithin.collisions.where(
        (collision) => collision.id.value.startsWith('task-'),
      ),
    );
    if (taskResult.isNotEmpty) {
      return taskResult;
    }
    return pointerWithin;
  }

  // 2. Fallback to closest center
  final closest = DndCollisionDetectors.closestCenter(input);
  return DndCollisionResult(
    closest.collisions.take(math.min(closest.collisions.length, 3)),
  );
}
