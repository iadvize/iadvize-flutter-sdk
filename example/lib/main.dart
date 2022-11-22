import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: todo
  //TODO: replace by real values
  final int projectId = 8047;
  final String chatTargetingRule = '3ad856a4-f151-486d-8879-f9924d81a596';
  final String videoTargetingRule = 'e891e20c-fad9-4b53-ada3-f5fd956d5b57';
  final String? userId = null;
  final String? grpdUrl = null;

  final double spaceBetweenButton = 20;

  final _iAdvizeSdk = IavizeSdk();

  @override
  void initState() {
    super.initState();
    _iAdvizeSdk.setLanguage('fr');
    _iAdvizeSdk.setLogLevel(LogLevel.verbose);
    // _iAdvizeSdk.setDefaultFloatingButton(true);
    // _iAdvizeSdk.setFloatingButtonPosition(25, 25);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     // await _flutterIadvizeSdkPlugin.getPlatformVersion();
  //     _flutterIadvizeSdkPlugin.activate(projectId: 8047);
  //   } on PlatformException {
  //     log('errror');
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iAdvize Flutter Plugin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                onPressed: () => activateSDK(),
                label: 'Activate',
              ),
              SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => activateChatTargetingRule(),
                label: 'Activate Chat Targeting Rule',
              ),
              SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => activateVideoTargetingRule(),
                label: 'Activate Video Targeting Rule',
              ),
              SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => isActiveTargetingRuleAvailable(),
                label: 'Is Active Targeting Rule Available',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> activateSDK() async {
    await _iAdvizeSdk
        .activate(
          projectId: projectId,
          userId: userId,
          gdprUrl: grpdUrl,
        )
        .then((bool activated) => activated
            ? log('iAdvize SDK activated')
            : log('iAdvize SDK not activated'));
  }

  void activateChatTargetingRule() {
    _iAdvizeSdk.activateTargetingRule(
        uuid: chatTargetingRule, conversationChannel: ConversationChannel.chat);
  }

  void activateVideoTargetingRule() {
    _iAdvizeSdk.activateTargetingRule(
        uuid: videoTargetingRule,
        conversationChannel: ConversationChannel.video);
  }

  Future<void> isActiveTargetingRuleAvailable() async {
    await _iAdvizeSdk.isActiveTargetingRuleAvailable().then((bool available) =>
        available
            ? log('iAdvize SDK targeting rule available')
            : log('iAdvize SDK targeting rule not available'));
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.label, required this.onPressed});

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(label),
    );
  }
}
