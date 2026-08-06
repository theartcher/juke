import 'package:flutter/material.dart';
import 'package:juke/pages/home/create_sub_screen.dart';
import 'package:juke/pages/home/scan_sub_screen.dart';
import 'package:provider/provider.dart';
import 'package:juke/models/mode_option.dart';
import 'package:juke/stores/homepage_store.dart';
import 'package:juke/widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageNotifier(),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomePageNotifier>();
    final currentIndex = store.currentMode == ModeOption.create ? 0 : 1;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: const [CreateSubScreen(), ScanSubScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
