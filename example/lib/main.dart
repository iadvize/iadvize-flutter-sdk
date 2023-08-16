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
  // Notifications
  final String _pushToken = 'Replace with the device token (FCM setup)';
  final ApplicationMode applicationMode = ApplicationMode.dev;

  // Authentication
  final int projectId = -1; // TODO Replace with your project id
  final AuthenticationOption anonAuth = AuthenticationOption.anonymous();
  final AuthenticationOption simpleAuth =
      AuthenticationOption.simple(userId: 'user id');
  final AuthenticationOption securedAuth =
      AuthenticationOption.secured(onJweRequested: () {
    return Future.value('JWE token retrieved via your third party secure auth');
  });

  // GDPR
  final GDPROption gdprDisabled = GDPROption.disabled();
  final GDPROption gdprURL =
      GDPROption.url(url: "http://replace.with.your.gdpr.url/");
  final GDPROption gdprListener = GDPROption.listener(onMoreInfoClicked: () {
    log('iAdvize Example : GDPR More Info button clicked');
    // Implement your own logic here
  });

  // Targeting / Engagement
  final TargetingRule chatTargetingRule = TargetingRule(
      uuid: 'Replace with a chat channel targeting rule id',
      channel: ConversationChannel.chat);

  final TargetingRule videoTargetingRule = TargetingRule(
      uuid: 'Replace with a video channel targeting rule id',
      channel: ConversationChannel.video);

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
                onPressed: () => _logout(),
                label: 'Logout',
              ),
              const SizedBox(height: 2 * spaceBetweenButton),
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
              const SizedBox(height: 2 * spaceBetweenButton),
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
              const SizedBox(height: 2 * spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _setChatboxConfiguration(),
                label: 'Set ChatboxConfiguration',
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
              const SizedBox(height: 2 * spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _registerTransaction(),
                label: 'Register Transaction',
              ),
              const SizedBox(height: spaceBetweenButton),
              CustomTextButton(
                onPressed: () => _registerCustomData(),
                label: 'Register Custom Data',
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
      authenticationOption: simpleAuth,
      gdprOption: gdprListener,
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
      iosFontName: 'Baskerville',
      iosFontSize: 16,
      androidFontPath: 'fonts/baskerville_regular.ttf',

      incomingMessageBackgroundColor: const Color(0xFFEEEFF0),
      incomingMessageTextColor: const Color(0xFF34393F),
      outgoingMessageBackgroundColor: const Color(0xFF320087),
      outgoingMessageTextColor: const Color(0xFFEEEFF0),
      accentColor: const Color(0xFFFFBF32),

      navigationBarBackgroundColor: const Color(0xFFFFBF32),
      navigationBarMainColor: const Color(0xFF320087),
      navigationBarTitle: 'Toolbar custom title',

      // If both incomingMessageAvatarImage & incomingMessageAvatarURL are set,
      // incomingMessageAvatarURL takes precedence
      incomingMessageAvatarImage: const AssetImage('assets/images/agent.png'),
      //incomingMessageAvatarURL: 'https://picsum.photos/200/200',

      automaticMessage: 'Hello! What can we do for you today?',
      gdprMessage: 'Custom GDPR explanation message...',
    ));
  }

  void _registerTransaction() {
    IAdvizeSdk.registerTransaction(Transaction(
        transactionId: 'transactionId', currency: 'EUR', amount: 25));
  }

  void _registerCustomData() {
    List<CustomData> customData = <CustomData>[
      CustomData.fromString("Test", "Test"),
      CustomData.fromBoolean("Test2", false),
      CustomData.fromDouble("Test3", 2.0),
      CustomData.fromInt("Test4", 3)
    ];
    IAdvizeSdk.registerCustomData(customData).then((bool success) =>
        log('iAdvize Example : custom data registered: $success'));
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
