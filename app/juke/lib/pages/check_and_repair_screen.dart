import 'package:flutter/material.dart';
import 'package:juke/pages/check_and_repair/deck_check_sub_screen.dart';
import 'package:juke/pages/check_and_repair/deck_repair_sub_screen.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/header.dart';
import 'package:provider/provider.dart';

enum _CheckAndRepairStep { check, repair }

class CheckAndRepairScreen extends StatefulWidget {
  const CheckAndRepairScreen({super.key});

  @override
  State<CheckAndRepairScreen> createState() => _CheckAndRepairScreenState();
}

class _CheckAndRepairScreenState extends State<CheckAndRepairScreen> {
  _CheckAndRepairStep _step = _CheckAndRepairStep.check;

  void _goToRepair() {
    setState(() {
      _step = _CheckAndRepairStep.repair;
    });
  }

  void _goToCheck() {
    setState(() {
      _step = _CheckAndRepairStep.check;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TrackStore>();
    final currentIndex = _step.index;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(showModeSwitcher: false),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: [
                DeckCheckSubScreen(store: store, onContinue: _goToRepair),
                DeckRepairSubScreen(store: store, onBack: _goToCheck),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
