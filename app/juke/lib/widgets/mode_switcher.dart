import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:provider/provider.dart';
import 'package:juke/models/mode_option.dart';
import 'package:juke/stores/homepage_store.dart';

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key});

  static const _cream = Color(0xFFF3EFE7);
  static const _black = Color(0xFF1C1C1C);
  static const _borderRadius = 200.0;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomePageNotifier>();
    final isCreate = store.currentMode == ModeOption.create;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSegment(
              context,
              label: 'CREATE',
              selected: isCreate,
              isLeftSegment: true,
              onTap: () => context.read<HomePageNotifier>().changeMode(
                ModeOption.create,
              ),
            ),
            _buildSegment(
              context,
              label: 'SCAN',
              selected: !isCreate,
              isLeftSegment: false,
              onTap: () =>
                  context.read<HomePageNotifier>().changeMode(ModeOption.scan),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(
    BuildContext context, {
    required String label,
    required bool selected,
    required bool isLeftSegment,
    required VoidCallback onTap,
  }) {
    final leftSegmentBorder = BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_borderRadius),
        bottomLeft: Radius.circular(_borderRadius),
      ),
      border: Border.all(width: 2, color: _black),
      color: selected ? _black : _cream,
    );
    final rightSegmentBorder = BoxDecoration(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(_borderRadius),
        bottomRight: Radius.circular(_borderRadius),
      ),
      border: Border.all(width: 2, color: _black),
      color: selected ? _black : _cream,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: isLeftSegment ? leftSegmentBorder : rightSegmentBorder,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: jetBrainsMonoFamily,
            color: selected ? _cream : _black,
          ),
        ),
      ),
    );
  }
}
