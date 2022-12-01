import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iadvize_flutter_sdk/iadvize_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TODO: replace by your own values
  final String _pushToken = 'device_push_token';
  final int projectId = 3585;
  final String? grpdUrl = null;
  final ApplicationMode applicationMode = ApplicationMode.dev;
  final TargetingRule chatTargetingRule =
      TargetingRule(uuid: 'a41611fe-c453-4df5-b6ef-3438527933b4', channel: ConversationChannel.chat);
  final TargetingRule videoTargetingRule =
      TargetingRule(uuid: '6e9a8e26-65d7-4d68-a699-00c5fe8740b8', channel: ConversationChannel.video);
  final AuthenticationOption authOptionAnonymous =
      AuthenticationOption.anonymous();
  final AuthenticationOption authOptionSimple =
      AuthenticationOption.simple(userId: 'abcdef');
  final AuthenticationOption authOptionSecured =
      AuthenticationOption.secured(onJweRequested: () {
    return Future.value('your_jwe_token');
  });

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
    IAdvizeSdk.setLanguage('fr');
    IAdvizeSdk.setLogLevel(LogLevel.verbose);
    IAdvizeSdk.setOnActiveTargetingRuleAvailabilityListener();
    _targetingRuleAvailabilityUpdatedSubscription = IAdvizeSdk
        .onActiveTargetingRuleAvailabilityUpdated
        .listen((bool available) {
      log('iAdvize Example : Targeting Rule available: $available');
      _updateCustomChatButtonVisibility();
    });

    IAdvizeSdk.setConversationListener(manageUrlClick: true);
    _messageSubscription =
        IAdvizeSdk.onReceiveNewMessage.listen((String message) {
      log('iAdvize Example : New message: $message');
      setState(() {
        _newMessage = true;
      });
    });
    _hasOngoingSubscription =
        IAdvizeSdk.onOngoingConversationUpdated.listen((bool ongoing) {
      log('iAdvize Example : Ongoing: $ongoing');
      _hasOngoingConversation = ongoing;
      _updateCustomChatButtonVisibility();
    });
    _clickedUrlSubscription =
        IAdvizeSdk.onHandleClickedUrl.listen((String url) {
      log('iAdvize Example : Click on url: $url');
    });
    IAdvizeSdk.setDefaultFloatingButton(true);
    IAdvizeSdk.setFloatingButtonPosition(leftMargin: 20, bottomMargin: 20);
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
                  IAdvizeSdk.setDefaultFloatingButton(false);
                },
                label: 'Show Custom Button example',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () {
                  setState(() {
                    _useCustomButton = false;
                    _newMessage = false;
                  });
                  IAdvizeSdk.setDefaultFloatingButton(true);
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
    IAdvizeSdk.activate(
      projectId: projectId,
      authenticationOption: authOptionAnonymous,
      gdprUrl: grpdUrl,
    ).then((bool activated) => activated
        ? log('iAdvize Example : SDK activated')
        : log('iAdvize Example : SDK not activated'));
  }

  void _activateChatTargetingRule() =>
      IAdvizeSdk.activateTargetingRule(chatTargetingRule);

  void _activateVideoTargetingRule() =>
      IAdvizeSdk.activateTargetingRule(videoTargetingRule);

  void _isActiveTargetingRuleAvailable() {
    IAdvizeSdk.isActiveTargetingRuleAvailable().then((bool available) =>
        available
            ? log('iAdvize Example : SDK targeting rule available')
            : log('iAdvize Example : targeting rule not available'));
  }

  void _registerUserNavigation() {
    IAdvizeSdk.registerUserNavigation(
      navigationOption: NavigationOption.optionNew,
      newTargetingRule: videoTargetingRule,
    );
  }

  void _ongoingConversationId() {
    IAdvizeSdk.ongoingConversationId()
        .then((String? id) => log('iAdvize Example : conversationId $id'));
  }

  void _ongoingConversationChannel() {
    IAdvizeSdk.ongoingConversationChannel().then((ConversationChannel?
            channel) =>
        log('iAdvize Example : conversation channel ${channel?.toValueString()}'));
  }

  void _registerPushToken() => IAdvizeSdk.registerPushToken(
      pushToken: _pushToken, mode: applicationMode);

  void _enablePushNotifications() =>
      IAdvizeSdk.enablePushNotifications().then((bool success) =>
          log('iAdvize Example : push notifications enabled $success'));

  void _disablePushNotifications() =>
      IAdvizeSdk.disablePushNotifications().then((bool success) =>
          log('iAdvize Example : push notifications disabled $success'));

  void _setChatboxConfiguration() {
    IAdvizeSdk.setChatboxConfiguration(ChatboxConfiguration(
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
    IAdvizeSdk.registerTransaction(Transaction(
        transactionId: 'transactionId', currency: 'EUR', amount: 25));
  }

  void _logout() {
    IAdvizeSdk.logout();
  }

  void _presentChatbox() {
    IAdvizeSdk.presentChatbox();
  }

  Future<void> _updateCustomChatButtonVisibility() async {
    final bool sdkActivated = await IAdvizeSdk.isSDKActivated();
    final bool ruleAvailable =
        await IAdvizeSdk.isActiveTargetingRuleAvailable();

    setState(() {
      _showCustomButton =
          sdkActivated && (_hasOngoingConversation || ruleAvailable);
    });
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
