import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:juke/constants.dart';
import 'package:juke/stores/track_store.dart';
import 'package:juke/widgets/messenger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  MobileScannerPlatform.instance.setWebBarcodeReader(
    WebBarcodeReader.auto,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TrackStore())],
      child: MaterialApp.router(
        routerConfig: router,
        theme: theme,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: MessengerService.messengerKey,
      ),
    );
  }
}
