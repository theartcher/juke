import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/utility/pdf_utils.dart';

class DuplexSideSelector extends StatefulWidget {
  final DuplexFlip selectedFlipSide;
  final Function(DuplexFlip) onChanged;

  const DuplexSideSelector({
    super.key,
    required this.selectedFlipSide,
    required this.onChanged,
  });

  @override
  State<DuplexSideSelector> createState() => _DuplexSideSelectorState();
}

class _DuplexSideSelectorState extends State<DuplexSideSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Which way does the paper inside your printer flip/turn? ',
          style: TextStyle(
            fontFamily: jetBrainsMonoFamily,
            fontSize: subHeaderTextSize,
          ),
        ),
        const SizedBox(height: 16),
        RadioGroup<DuplexFlip>(
          groupValue: widget.selectedFlipSide,
          onChanged: (value) {
            if (value != null) {
              widget.onChanged(value);
            }
          },
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: _DuplexOption(
                  value: DuplexFlip.longEdge,
                  selected: widget.selectedFlipSide == DuplexFlip.longEdge,
                  onTap: () {
                    widget.onChanged(DuplexFlip.longEdge);
                  },
                ),
              ),
              Expanded(
                child: _DuplexOption(
                  value: DuplexFlip.shortEdge,
                  selected: widget.selectedFlipSide == DuplexFlip.shortEdge,
                  onTap: () {
                    widget.onChanged(DuplexFlip.shortEdge);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DuplexOption extends StatefulWidget {
  final DuplexFlip value;
  final bool selected;
  final VoidCallback onTap;

  const _DuplexOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_DuplexOption> createState() => _DuplexOptionState();
}

class _DuplexOptionState extends State<_DuplexOption> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedColor = primaryColor;
    final unselectedColor = theme.colorScheme.outlineVariant;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.selected
                ? selectedColor.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.selected ? selectedColor : unselectedColor,
              width: widget.selected ? 2.5 : 1.5,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.16),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: 105 / 148,
                    child: _PaperDiagram(
                      flip: widget.value,
                      selected: widget.selected,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    height: 4,
                    width: widget.selected ? 32 : 0,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaperDiagram extends StatelessWidget {
  final DuplexFlip flip;
  final bool selected;

  const _PaperDiagram({required this.flip, required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activeColor = primaryColor;
    final inactiveColor = theme.colorScheme.outlineVariant;

    final isLongEdge = flip == DuplexFlip.longEdge;

    final leftColor = isLongEdge ? activeColor : inactiveColor;

    final rightColor = isLongEdge ? activeColor : inactiveColor;

    final topColor = isLongEdge ? inactiveColor : activeColor;

    final bottomColor = isLongEdge ? inactiveColor : activeColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: selected ? 0.12 : 0.06),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Paper
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
            ),

            // Top edge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _EdgeIndicator(color: topColor, selected: selected),
            ),

            // Bottom edge
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _EdgeIndicator(color: bottomColor, selected: selected),
            ),

            // Left edge
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: _EdgeIndicator(
                color: leftColor,
                selected: selected,
                vertical: true,
              ),
            ),

            // Right edge
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _EdgeIndicator(
                color: rightColor,
                selected: selected,
                vertical: true,
              ),
            ),

            // Direction indicator
            Center(
              child: _FlipIndicator(flip: flip, selected: selected),
            ),
          ],
        ),
      ),
    );
  }
}

class _EdgeIndicator extends StatelessWidget {
  final Color color;
  final bool selected;
  final bool vertical;

  const _EdgeIndicator({
    required this.color,
    required this.selected,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: vertical ? 8 : null,
      height: vertical ? null : 8,
      decoration: BoxDecoration(
        color: color,
        boxShadow: selected
            ? [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 6)]
            : [],
      ),
    );
  }
}

class _FlipIndicator extends StatelessWidget {
  final DuplexFlip flip;
  final bool selected;

  const _FlipIndicator({required this.flip, required this.selected});

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? primaryColor
        : Theme.of(context).colorScheme.outline;

    final isLongEdge = flip == DuplexFlip.longEdge;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: selected ? 1 : 0.3,
      child: Icon(
        isLongEdge ? Icons.swap_horiz_rounded : Icons.swap_vert_rounded,
        size: 42,
        color: color,
      ),
    );
  }
}
