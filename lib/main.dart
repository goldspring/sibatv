import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sibatv/ui/pages/top_page.dart';
import 'package:sibatv/utils/size_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    //AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    // 强制横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MaterialApp(
      title: 'SibaTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer timer;

  @override
  void initState() {
    init();
    startTimeout();
    super.initState();
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.audio.request();
      await Permission.microphone.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      primary: true,
      backgroundColor: Colors.black54,
      body: const Center(
        child: const Text(
          'SibaTV',
          style: const TextStyle(
              fontSize: 50,
              color: Colors.deepOrange,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  _toPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TopPage()),
      (route) => route == null,
    );
  }

  //倒计时处理
  static const timeout = const Duration(microseconds: 1);

  startTimeout() {
    timer = Timer(timeout, handleTimeout);
    return timer;
  }

  void handleTimeout() {
    _toPage();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }
}
