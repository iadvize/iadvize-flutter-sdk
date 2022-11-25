import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iadvize_sdk/entities/chatbox_configuration.dart';
import 'package:flutter_iadvize_sdk/enums/conversation_channel.dart';
import 'package:flutter_iadvize_sdk/enums/log_level.dart';
import 'package:flutter_iadvize_sdk/iadvize_sdk.dart';
import 'package:flutter_iadvize_sdk_example/keys.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _pushToken = 'device_push_token';

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
    _iAdvizeSdk.setDefaultFloatingButton(true);
    _iAdvizeSdk.setFloatingButtonPosition(leftMargin: 20, bottomMargin: 20);
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
                onPressed: () async => await _activateSDK(),
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
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _setChatboxConfiguration(),
                label: 'Set ChatboxConfiguration',
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
          projectId: projectId,
          userId: userId,
          gdprUrl: grpdUrl,
        )
        .then((bool activated) => activated
            ? log('iAdvize Example : SDK activated')
            : log('iAdvize Example : SDK not activated'));
  }

  void _activateChatTargetingRule() => _iAdvizeSdk.activateTargetingRule(
      uuid: chatTargetingRule, conversationChannel: ConversationChannel.chat);

  void _activateVideoTargetingRule() => _iAdvizeSdk.activateTargetingRule(
      uuid: videoTargetingRule, conversationChannel: ConversationChannel.video);

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
      pushToken: _pushToken, mode: applicationMode);

  void _enablePushNotifications() =>
      _iAdvizeSdk.enablePushNotifications().then((bool enabled) =>
          log('iAdvize Example : push notifications enabled $enabled'));

  void _disablePushNotifications() =>
      _iAdvizeSdk.disablePushNotifications().then((bool disabled) =>
          log('iAdvize Example : push notifications disabled $disabled'));

  Future<void> _setChatboxConfiguration() async {
    _iAdvizeSdk.setChatboxConfiguration(ChatboxConfiguration(
      mainColor: Colors.red,
      navigationBarBackgroundColor: Colors.black,
      navigationBarTitle: 'Test',
      navigationBarMainColor: Colors.yellow,
      fontName: 'test_font',
      fontSize: 25,
      fontPath: 'fonts/Test-Font.ttf',
      automaticMessage: 'Hello! Please ask your question :)',
      gdprMessage: 'Your own GDPR message.',
      incomingMessageAvatarImage: const AssetImage('assets/test.jpeg'),
      incomingMessageAvatarURL: 'https://picsum.photos/200/200',
    ));
  }

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
