import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iadvize_sdk/enums/application_mode.dart';
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
  final int _projectId = 8047;
  final String _chatTargetingRule = '3ad856a4-f151-486d-8879-f9924d81a596';
  final String _videoTargetingRule = 'e891e20c-fad9-4b53-ada3-f5fd956d5b57';
  final String? _userId = null;
  final String? _grpdUrl = null;
  final String _pushToken = 'device_push_token';
  final ApplicationMode _applicationMode = ApplicationMode.dev;

  static const double spaceBetweenButton = 20;

  final _iAdvizeSdk = IavizeSdk();

  late StreamSubscription _messageSubscription;
  late StreamSubscription _hasOngoingSubscription;
  late StreamSubscription _clickedUrlSubscription;
  late StreamSubscription _targetingRuleAvailabilityUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    _iAdvizeSdk.setLanguage('fr');
    _iAdvizeSdk.setLogLevel(LogLevel.verbose);
    _iAdvizeSdk.setOnActiveTargetingRuleAvailabilityListener();
    _targetingRuleAvailabilityUpdatedSubscription = _iAdvizeSdk
        .onActiveTargetingRuleAvailabilityUpdated
        .listen((bool available) {
      log('iAdvize Example : Targeting Rule available: $available');
    });
    _iAdvizeSdk.setConversationListener();
    _messageSubscription =
        _iAdvizeSdk.onReceiveNewMessage.listen((String message) {
      log('iAdvize Example : New message: $message');
    });
    _hasOngoingSubscription =
        _iAdvizeSdk.hasOngoingConversation.listen((bool ongoing) {
      log('iAdvize Example : Ongoing: $ongoing');
    });
    _clickedUrlSubscription = _iAdvizeSdk.handleClickedUrl.listen((String url) {
      log('iAdvize Example : Click on url: $url');
    });
    // _iAdvizeSdk.setDefaultFloatingButton(true);
    // _iAdvizeSdk.setFloatingButtonPosition(25, 25);
    // _iAdvizeSdk.onConversationListener(
    //     onReceiveNewMessage: (message) => log('test $message'));
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
                onPressed: () => _activateSDK(),
                label: 'Activate',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _activateChatTargetingRule(),
                label: 'Activate Chat Targeting Rule',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _activateVideoTargetingRule(),
                label: 'Activate Video Targeting Rule',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _isActiveTargetingRuleAvailable(),
                label: 'Is Active Targeting Rule Available',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _ongoingConversationId(),
                label: 'Print Conversation Id',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _ongoingConversationChannel(),
                label: 'Print Conversation Channel',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _registerPushToken(),
                label: 'Register Push Token',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _enablePushNotifications(),
                label: 'Enable Push Notifications',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _disablePushNotifications(),
                label: 'Disnable Push Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _activateSDK() async {
    await _iAdvizeSdk
        .activate(
          projectId: _projectId,
          userId: _userId,
          gdprUrl: _grpdUrl,
        )
        .then((bool activated) => activated
            ? log('iAdvize Example : SDK activated')
            : log('iAdvize Example : SDK not activated'));
  }

  void _activateChatTargetingRule() => _iAdvizeSdk.activateTargetingRule(
      uuid: _chatTargetingRule, conversationChannel: ConversationChannel.chat);

  void _activateVideoTargetingRule() => _iAdvizeSdk.activateTargetingRule(
      uuid: _videoTargetingRule,
      conversationChannel: ConversationChannel.video);

  Future<void> _isActiveTargetingRuleAvailable() async {
    await _iAdvizeSdk.isActiveTargetingRuleAvailable().then((bool available) =>
        available
            ? log('iAdvize Example : SDK targeting rule available')
            : log('iAdvize Example : targeting rule not available'));
  }

  Future<void> _ongoingConversationId() async {
    await _iAdvizeSdk
        .ongoingConversationId()
        .then((String? id) => log('iAdvize Example : conversationId $id'));
  }

  Future<void> _ongoingConversationChannel() async {
    await _iAdvizeSdk.ongoingConversationChannel().then((ConversationChannel?
            channel) =>
        log('iAdvize Example : conversation channel ${channel?.toValueString()}'));
  }

  void _registerPushToken() => _iAdvizeSdk.registerPushToken(
      pushToken: _pushToken, mode: _applicationMode);

  void _enablePushNotifications() =>
      _iAdvizeSdk.enablePushNotifications().then((bool enabled) =>
          log('iAdvize Example : push notifications enabled $enabled'));

  void _disablePushNotifications() =>
      _iAdvizeSdk.disablePushNotifications().then((bool disabled) =>
          log('iAdvize Example : push notifications disabled $disabled'));

  @override
  void dispose() {
    _messageSubscription.cancel();
    _hasOngoingSubscription.cancel();
    _clickedUrlSubscription.cancel();
    _targetingRuleAvailabilityUpdatedSubscription.cancel();
    super.dispose();
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
