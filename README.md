# iAdvize Conversation SDK - Flutter plugin

Take your app to the next step and provide a unique conversational experience to your users!

Embed the iAdvize Conversation SDK in your app and connect your visitors with your professional operators or ibbü experts through a fully customised chat experience. Visitors can ask a question and will receive answers directly on their devices with push notifications, in or outside your app.

You will find an example of integration in the ` example/` folder of this repository that you can run using 
```
cd example
flutter run lib/main.dart
```

## Requirements

The iAdvize Flutter SDK uses the iAdvize native iOS & Android SDKs.

### For Android

| Android Version  | Kotlin Version |
|------------------|----------------|
| API 21 or higher | 1.7.20         |

### For iOS

| iOS            | Xcode |
|----------------|-------|
| 12.0 or higher | 13.X  |

## Documentation

The iOS API reference is available [here](https://iadvize.github.io/iadvize-ios-sdk/).

The Android API reference is available [here](https://iadvize.github.io/iadvize-android-sdk/).

## Setup

### App creation

1. Ask your iAdvize Admin to create a **Mobile App** on the administration website. _If you want to enable the iAdvize SDK push notifications for your user you have to provide your APNS push certificate when you create your app on the administration website._

2. Ask your iAdvize Admin to create a new **Web & Mobile App** targeting campaign on the administration website and to give you the following information:
   - **projectId**: id of your project
   - **targetingRuleId(s)**: one or multiple rules which you will be able to activate in code during the user navigation (see [Targeting](#Targeting)).

## Installation

### Get the SDK

Run this command `flutter pub add iadvize_flutter_sdk`

### For iOS

For iOS app make sure to go to `ios` folder and install Cocoapods dependencies:

```ruby
cd ios && pod install
```

The SDK is distributed as an XCFramework, therefore **you are required to use CocoaPods 1.9.0 or newer**.

Add the following to the bottom of your Podfile:

```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
```

> This post_install hook is required because the iAdvize SDK supports [module stability](https://swift.org/blog/abi-stability-and-more/). Therefore, all its dependencies must be built using the "Build Libraries for Distribution" option.

The SDK supports video conversations. Thus it will request camera and microphone access before entering a video call. To avoid the app to crash, you have to setup two keys in your app Info.plist

```ruby
NSMicrophoneUsageDescription
NSCameraUsageDescription
```

## Usage

### Import

You need to import the SDK.

```dart
import 'package:iadvize_flutter_sdk/iadvize_sdk.dart';
```

### Activation

To activate the SDK you must use the **activate** function. You also have access to a asynchronous callback in order to know if the SDK has been successfully activated (and to retry later if the activation fails):

```dart
IAdvizeSdk.activate(
    projectId: 'projectId',
    authenticationOption: AuthenticationOption.anonymous() OR
                          AuthenticationOption.simple(userId: 'your_user_id') OR
                          AuthenticationOption.secured(onJweRequested: () {
                              return Future.value('your_jwe_token');
                          },
    gdprUrl: grpdUrl,
    ).then((bool activated) => activated
        ? log('iAdvize Example : SDK activated')
        : log('iAdvize Example : SDK not activated'));
```

Once the iAdvize Conversation SDK is successfully activated, you should see a success message in the console:

```
✅ iAdvize conversation activated, the version is x.x.x.
```

Do not forget to [logout](#Logout) when the user is no longer connected in your app.

##### GDPR

By default, when you activate the SDK, the GDPR will be disabled.

To enable it, you can pass a GDPR option while activating the SDK. This GDPROption dictates how the SDK behaves when the user taps on the “More information” button:

1. `gdprURL`: will open the given URL containing GDPR information

The GDPR process is now activated for your users and a default message will be provided to collect the user consent. Please check the [Customization](#Customization) section below if you want to customise this message.

You can empty value in the `gdprURL` parameter to disable GDPR.

#### Logging

By default, the SDK will **only log Warnings and Errors**. You can make it more verbose and choose between multiple levels of log for a better integration experience:

```dart
IAdvizeSdk.setLogLevel(LogLevel.verbose);
```

Possible values are :

```dart
enum LogLevel {
  verbose,
  info,
  warning,
  error,
  success,
}
```

### Targeting

#### Targeting Language

By default, the SDK will use the device language for **targeting a conversation**. With this variable you can specify the language you want to use for targetting:

```js
IAdvizeSdk.setLanguage('fr');
```

The parameter passed to the function is a `string` parameter.

> :warning: This `language` property is NOT intended to change the language displayed in the SDK.

#### Activate a targeting rule

For the iAdvize SDK to work, you have to setup an active targeting rule. To do so, you can call the following method:

```dart
 IAdvizeSdk.activateTargetingRule(TargetingRule(uuid: 'targeting-rule-uuid', channel: ConversationChannel.chat));
// OR
 IAdvizeSdk.activateTargetingRule(TargetingRule(uuid: 'targeting-rule-uuid', channel: ConversationChannel.video));
```

#### Targeting rule availability

The targeting rule availability check will be triggered when you update the active targeting rule (see [Activate a targeting rule](#rule))

You can check the active rule availability by accessing:

```dart
IAdvizeSdk.isActiveTargetingRuleAvailable().then((bool available) =>
    available
        ? log('iAdvize Example : SDK targeting rule available')
        : log('iAdvize Example : targeting rule not available'))
```

Or if you want to be informed of rule availability updates, you can add a delegate:

```dart
IAdvizeSdk.setOnActiveTargetingRuleAvailabilityListener();
```

And retrieve update by doing:

```dart
IadvizeSdk
    .onActiveTargetingRuleAvailabilityUpdated
    .listen((bool available) {
    log('iAdvize Example : Targeting Rule available: $available');
});
```

#### Follow user navigation

To allow iAdvize statistics to be processed you need to inform the SDK when the user navigates through the screens your app, you will have to call `registerUserNavigation` and pass a navigation option which allows you to clear, keep or activate a new targeting rule.

```dart
IAdvizeSdk.registerUserNavigation(
    navigationOption: NavigationOption.optionKeep);
// OR
IAdvizeSdk.registerUserNavigation(
    navigationOption: NavigationOption.optionClear);
// OR
IAdvizeSdk.registerUserNavigation(
    navigationOption: NavigationOption.optionNew,
    newTargetingRule: TargetingRule(uuid: 'targeting-rule-uuid', channel: ConversationChannel.chat))
```

### Conversation

#### Ongoing conversation

To know and to observe the evolution of the conversation state, you will have access to a variable:

```dart
IAdvizeSdk.ongoingConversationId()
    .then((String? id) => log('iAdvize Example : conversationId $id'));
```

you will be able to figure out the channel of the current conversation by calling:

```dart
IAdvizeSdk.ongoingConversationChannel().then((ConversationChannel? channel) =>
    log('iAdvize Example : conversation channel ${channel?.toValueString()}'));
```

You can also add a delegate to be informed in real time about conversation events:

```dart
IAdvizeSdk.setConversationListener(manageUrlClick: true);
```

After the set of listener, you can catch update by doing:

```dart
IAdvizeSdk.onOngoingConversationUpdated.listen((bool ongoing) {
    log('iAdvize Example : Ongoing: $ongoing');
});

IAdvizeSdk.onReceiveNewMessage.listen((String message) {
    log('iAdvize Example : New message: $message');
});

IAdvizeSdk.onHandleClickedUrl.listen((String url) {
    log('iAdvize Example : Click on url: $url');
});
```

### Push notifications

Before starting this part you will need to ensure that the push notifications are setup in your iAdvize project. The process is described above in [the SDK Knowledge Base.](https://help.iadvize.com/hc/en-gb/articles/360019839480)

#### Configuration

To receive push notification when a message is sent to the visitor, you must register the current **push token** of the device:

```dart
IAdvizeSdk.registerPushToken(pushToken: 'your_push_token', mode: ApplicationMode.dev);
```

Possible values of `ApplicationMode` are (useful for iOS only) :

```dart
enum ApplicationMode {
  dev,
  prod,
}
```

You can register your push token at any time.

By default, push notifications are activated if you have setup the push notifications information for your app on the iAdvize administration website. You can manually enable/disable them at any time using:

```dart
IAdvizeSdk.enablePushNotifications().then((bool success) =>
    log('iAdvize Example : push notifications enabled $success'));

IAdvizeSdk.disablePushNotifications().then((bool success) =>
    log('iAdvize Example : push notifications disabled $success'));
```

### Chatbox

The Chatbox is where the conversation takes place. The visitor can open the Chatbox by touching the Chat button.

You can control the appearance and behavior of the Chatbox and Chat button.

#### Chat button

When the active targeting rule is available, a chat button is displayed to invite the user to chat.

You can decide to let the SDK manage the chat button visibility or control it yourself using the following flag:

```dart
IAdvizeSdk.setDefaultFloatingButton(true);
```

##### Default chat button

If `setDefaultFloatingButton == true` the SDK will use the iAdvize default chat button, manage its visibility, and open the chatbox when user presses it.

The default chat button is anchored to the bottom-left of your screen, you can change its position using:

```dart
IAdvizeSdk.setFloatingButtonPosition(leftMargin: 20, bottomMargin: 20);
```

##### Custom chat Button

You can display your own button by hidding default button.

```dart
IAdvizeSdk.setDefaultFloatingButton(false);
```

Then the visibility of your button must depend on:

```dart
bool _showCustomButton = false;
bool _hasOngoingConversation = false;

IAdvizeSdk.onOngoingConversationUpdated.listen((bool ongoing) {
    log('iAdvize Example : Ongoing: $ongoing');
    _hasOngoingConversation = ongoing;
    _updateCustomChatButtonVisibility();
});

IAdvizeSdk.onActiveTargetingRuleAvailabilityUpdated
    .listen((bool available) {
        log('iAdvize Example : Targeting Rule available: $available');
        _updateCustomChatButtonVisibility();
    });

Future<void> _updateCustomChatButtonVisibility() async {
    final bool sdkActivated = await IAdvizeSdk.isSDKActivated();
    final bool ruleAvailable =
        await IAdvizeSdk.isActiveTargetingRuleAvailable();

    setState(() {
        _showCustomButton =
            sdkActivated && (_hasOngoingConversation || ruleAvailable);
    });
}
```

#### Chatbox Customization

You can customize the chatbox UI by calling the following method:

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration()
IAdvizeSdk.setChatboxConfiguration(customChatboxConfig);
```

A simple snippet to only change one value:

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    mainColor: Colors.red,
);
IAdvizeSdk.setChatboxConfiguration(customChatboxConfig);
```

The `ChatboxConfiguration` allow you to customize the following attributes:

##### Main color

You can setup a main color on the SDK which will be applied to the color of:

- the default Chat button (if you use it)
- the send button in the Conversation View
- the blinking text cursor in the “new message” input in the Conversation View
- the background color of the message bubbles (only for sent messages)

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    mainColor: Colors.red,
);
```

##### Navigation bar

You can configure the Toolbar of the Chatbox and modify:

- the background color
- the main color
- the title

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    navigationBarBackgroundColor: Colors.black,
    navigationBarTitle: 'Test',
    navigationBarMainColor: Colors.yellow,
);
```

##### Font

You can update the font used in the UI of the IAdvize Conversation SDK. You just have to call this method to setup your own font:

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    iosFontName: 'FontName', //iOs only
    iosFontSize: 11, //iOs only
    androidFontPath: 'fonts/Test-Font.ttf', //Android only
);
```

##### Automatic message

A first automatic message can be setup to be displayed as an operator message in the Chatbox. By default, no message will be displayed. This message will also be used and displayed when the user accepts the GDPR. You can set an automatic message through:

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    automaticMessage: 'Hello! Please ask your question',
);
```

##### GDPR message

If you want to activate the GDPR consent collect feature through the iAdvize Conversation SDK.

Once the GDPR is activated, you can easily customise the GDPR message you want to display to your users to collect their consent:

```dart
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
    gdprMessage: 'Your own GDPR message.',
);
```

##### Brand avatar

You can update the brand avatar displayed for the incoming messages. You can specify an URL or an AssetImage. Gifs are not supported.

```dart
// Update the incoming message avatar with an AssetImage.
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
  incomingMessageAvatarImage: const AssetImage('assets/test.jpeg'),
);

// Update the incoming message avatar with an `url` string.
final ChatboxConfiguration customChatboxConfig = ChatboxConfiguration(
  incomingMessageAvatarURL: 'url',
);
```

##### Opening/Hidding the Chatbox

```dart
IAdvizeSdk.presentChatbox();
//OR
IAdvizeSdk.dismissChatbox();
```

### Transaction

You can register a transaction within your application:

```dart
final Transaction transaction = Transaction(
    transactionId: 'transactionId', currency: 'EUR', amount: 25);
IAdvizeSdk.registerTransaction(transaction);
```

### Logout

When the user is logged out in your app, you need to log out in the iAdvize SDK as well to ensure the privacy of the user data and conversations.

```dart
IAdvizeSdk.logout();
```

This will clear all the locally stored visitor data.

## And you’re done! 💪

Well done! You’re now ready to take your app to the next step and provide a unique conversational experience to your users! 🚀
