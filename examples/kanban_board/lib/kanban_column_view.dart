import 'package:dnd_kit/dnd_kit.dart';
import 'package:flutter/material.dart';

import 'kanban_board_utils.dart';
import 'kanban_task_tile.dart';
import 'models.dart';

class KanbanColumnView extends StatefulWidget {
  const KanbanColumnView({
    super.key,
    required this.column,
    required this.onDragEnd,
    this.dropIndicatorIndex,
  });

  final KanbanColumn column;
  final DndDragEndCallback onDragEnd;
  final int? dropIndicatorIndex;

  @override
  State<KanbanColumnView> createState() => _KanbanColumnViewState();
}

class _KanbanColumnViewState extends State<KanbanColumnView> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ValueKey<String>('column:${widget.column.id}'),
      width: 320,
      child: DndDroppable(
        id: columnDndId(widget.column.id),
        data: KanbanDropData(columnId: widget.column.id),
        builder: (context, details, child) {
          return AnimatedContainer(
            key: ValueKey<String>('column-drop:${widget.column.id}'),
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: details.isOver
                  ? const Color(0xfffffbef)
                  : const Color(0xffffffff),
              border: Border.all(
                color: details.isOver
                    ? const Color(0xff2f6f73)
                    : const Color(0xffddd6c8),
                width: details.isOver ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.column.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Text(
                    '${widget.column.tasks.length}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: DndAutoScroll(
                scrollController: _scrollController,
                options: const DndAutoScrollOptions(
                  edgeThreshold: 72,
                  maxVelocity: 12,
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      for (var index = 0;
                          index <= widget.column.tasks.length;
                          index += 1) ...<Widget>[
                        if (widget.dropIndicatorIndex == index)
                          _buildDropIndicator(),
                        if (index < widget.column.tasks.length)
                          Padding(
                            key: ValueKey<String>(
                              'task-padding:${widget.column.tasks[index].id}',
                            ),
                            padding: EdgeInsets.only(
                              // Remove bottom gap when the indicator immediately
                              // follows — the Divider's own height fills it.
                              bottom: (index ==
                                          widget.column.tasks.length - 1 ||
                                      widget.dropIndicatorIndex == index + 1)
                                  ? 0
                                  : 12,
                            ),
                            child: KanbanTaskTile(
                              key: ValueKey<String>(
                                'task-tile:${widget.column.tasks[index].id}',
                              ),
                              columnId: widget.column.id,
                              task: widget.column.tasks[index],
                              onDragEnd: widget.onDragEnd,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropIndicator() => const Divider(
        height: 12,
        // thickness: 2,
        color: Color(0xff2f6f73),
      );
}
