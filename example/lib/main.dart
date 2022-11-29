import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
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

  // Var for Custom button
  bool _showCustomButton = false;
  bool _newMessage = false;
  bool _useCustomButton = false;

  bool _hasOngoingConversation = false;

  static const double spaceBetweenButton = 20;

  late StreamSubscription _messageSubscription;
  late StreamSubscription _hasOngoingSubscription;
  late StreamSubscription _clickedUrlSubscription;
  late StreamSubscription _targetingRuleAvailabilityUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    IadvizeSdk.setLanguage('fr');
    IadvizeSdk.setLogLevel(LogLevel.verbose);
    IadvizeSdk.setOnActiveTargetingRuleAvailabilityListener();
    _targetingRuleAvailabilityUpdatedSubscription = IadvizeSdk
        .onActiveTargetingRuleAvailabilityUpdated
        .listen((bool available) {
      log('iAdvize Example : Targeting Rule available: $available');
      _updateCustomChatButtonVisibility();
    });

    IadvizeSdk.setConversationListener(manageUrlClick: true);
    _messageSubscription =
        IadvizeSdk.onReceiveNewMessage.listen((String message) {
      log('iAdvize Example : New message: $message');
      setState(() {
        _newMessage = true;
      });
    });
    _hasOngoingSubscription =
        IadvizeSdk.onOngoingConversationUpdated.listen((bool ongoing) {
      log('iAdvize Example : Ongoing: $ongoing');
      _hasOngoingConversation = ongoing;
      _updateCustomChatButtonVisibility();
    });
    _clickedUrlSubscription =
        IadvizeSdk.onHandleClickedUrl.listen((String url) {
      log('iAdvize Example : Click on url: $url');
    });
    IadvizeSdk.setDefaultFloatingButton(true);
    IadvizeSdk.setFloatingButtonPosition(leftMargin: 20, bottomMargin: 20);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iAdvize Flutter Plugin Example'),
        ),
        floatingActionButton: _showCustomButton && _useCustomButton
            ? FloatingActionButton(
                backgroundColor: _newMessage ? Colors.red : Colors.blue,
                child: const Icon(Icons.chat),
                onPressed: () {
                  _presentChatbox();
                  setState(() {
                    _newMessage = false;
                  });
                },
              )
            : null,
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
                onPressed: () => _registerUserNavigation(),
                label: 'Register User Navigation',
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
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _registertransaction(),
                label: 'Register Transaction',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _logout(),
                label: 'Logout',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () {
                  setState(() {
                    _useCustomButton = true;
                  });
                  IadvizeSdk.setDefaultFloatingButton(false);
                },
                label: 'Show Custom Button example',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () {
                  setState(() {
                    _useCustomButton = false;
                  });
                  IadvizeSdk.setDefaultFloatingButton(true);
                },
                label: 'Hide Custom Button example',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _activateSDK() {
    IadvizeSdk.activate(
      projectId: projectId,
      userId: userId,
      gdprUrl: grpdUrl,
    ).then((bool activated) => activated
        ? log('iAdvize Example : SDK activated')
        : log('iAdvize Example : SDK not activated'));
  }

  void _activateChatTargetingRule() =>
      IadvizeSdk.activateTargetingRule(chatTargetingRule);

  void _activateVideoTargetingRule() =>
      IadvizeSdk.activateTargetingRule(videoTargetingRule);

  void _isActiveTargetingRuleAvailable() {
    IadvizeSdk.isActiveTargetingRuleAvailable().then((bool available) =>
        available
            ? log('iAdvize Example : SDK targeting rule available')
            : log('iAdvize Example : targeting rule not available'));
  }

  void _registerUserNavigation() {
    IadvizeSdk.registerUserNavigation(
        navigationOption: NavigationOption.optionNew,
        newTargetingRule: videoTargetingRule);
  }

  void _ongoingConversationId() {
    IadvizeSdk.ongoingConversationId()
        .then((String? id) => log('iAdvize Example : conversationId $id'));
  }

  void _ongoingConversationChannel() {
    IadvizeSdk.ongoingConversationChannel().then((ConversationChannel?
            channel) =>
        log('iAdvize Example : conversation channel ${channel?.toValueString()}'));
  }

  void _registerPushToken() => IadvizeSdk.registerPushToken(
      pushToken: _pushToken, mode: applicationMode);

  void _enablePushNotifications() =>
      IadvizeSdk.enablePushNotifications().then((bool success) =>
          log('iAdvize Example : push notifications enabled $success'));

  void _disablePushNotifications() =>
      IadvizeSdk.disablePushNotifications().then((bool success) =>
          log('iAdvize Example : push notifications disabled $success'));

  void _setChatboxConfiguration() {
    IadvizeSdk.setChatboxConfiguration(ChatboxConfiguration(
      mainColor: Colors.red,
      navigationBarBackgroundColor: Colors.black,
      navigationBarTitle: 'Test',
      navigationBarMainColor: Colors.yellow,
      iosFontName: 'Fruit Days',
      iosFontSize: 25,
      androidFontPath: 'fonts/Test-Font.ttf',
      automaticMessage: 'Hello! Please ask your question :)',
      gdprMessage: 'Your own GDPR message.',
      incomingMessageAvatarImage: const AssetImage('assets/test.jpeg'),
      incomingMessageAvatarURL: 'https://picsum.photos/200/200',
    ));
  }

  void _registertransaction() {
    IadvizeSdk.registerTransaction(Transaction(
        transactionId: 'transactionId', currency: 'EUR', amount: 25));
  }

  void _logout() {
    IadvizeSdk.logout();
  }

  void _presentChatbox() {
    IadvizeSdk.presentChatbox();
  }

  Future<void> _updateCustomChatButtonVisibility() async {
    final bool sdkActivated = await IadvizeSdk.isSDKActivated();
    final bool ruleAvailable =
        await IadvizeSdk.isActiveTargetingRuleAvailable();

    setState(() {
      _showCustomButton =
          sdkActivated && (_hasOngoingConversation || ruleAvailable);
    });
    log('$_showCustomButton : $sdkActivated && ($_hasOngoingConversation || $ruleAvailable)');
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
