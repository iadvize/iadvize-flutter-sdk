## 2.16.1 > 2.16.2

*Nothing to report*

## 2.16.0 > 2.16.1

*Nothing to report*

## 2.15.5 > 2.16.0

**Smaller Chatbox**

The Chatbox can now be presented in a compact mode, the visitor can resize the chatbox manually by dragging the toolbar.
The chatbox is automatically expanded when the keyboard opens. This compact mode can be enabled by using a flag in the `ChatboxConfiguration`:

```dart
IAdvizeSdk.setChatboxConfiguration(ChatboxConfiguration(
  // ...
  isSmallerChatboxEnabled: true,
  // ...
);
```

## 2.15.4 > 2.15.5

*Nothing to report*

## 2.15.3 > 2.15.4

*Nothing to report*

## 2.15.2 > 2.15.3

**Automatic Push Notifications Handling**

Push notifications are now **automatically enabled** every time a visitor is activated using IAdvizeSDK.activate(projectId:authenticationOption:gdprOption:completion:).

  - Previously, push notifications were only enabled during the first activation. After logout, they were disabled, requiring manual re-enablement on subsequent activations.

  - Now, push notifications will automatically re-enable during every activation, regardless of whether it’s the visitor’s first or a subsequent activation.

You only need to call IAdvizeSdk.enablePushNotifications if you previously disabled them using IAdvizeSdk.disablePushNotifications.

## 2.15.1 > 2.15.2

This versions updates several build system dependencies:

- Android SDK 35
- Kotlin 2.0
- Gradle 8.10
- Android Gradle Plugin 8.6
- iOS 18
- Xcode 16

Please note that the minimum OS requirements have evolved with this version:
- minimum Android supported version is now Android 7 (SDK 24)
- minimum iOS supported version is now 13.4

## 2.15.0 > 2.15.1

*Nothing to report*

## 2.14.3 > 2.15.0

### Debug Info

This releases adds a new `debugInfo` API that returns the status of the SDK at any given moment. This API could be used for debugging
purposes, you can add the JSON string output to your log reporting tool.

```
final debugInfo = await IAdvizeSdk.debugInfo();
```

```
{
  "targeting": {
    "screenId": "67BA3181-EBE2-4F05-B4F3-ECB07A62FA92",
    "activeTargetingRule": {
      "id": "D8821AD6-E0A2-4CB9-BF45-B2D8A3CF4F8D",
      "conversationChannel": "chat"
    },
    "isActiveTargetingRuleAvailable": false,
    "currentLanguage": "en"
  },
  "device": {
    "model": "iPhone",
    "osVersion": "17.5",
    "os": "iOS"
  },
  "ongoingConversation": {
    "conversationChannel": "chat",
    "conversationId": "02012815-4BDA-42EF-87DC-5C6ED317AF7F"
  },
  "chatbox": {
    "useDefaultFloatingButton": true,
    "isChatboxPresented": false
  },
  "activation": {
    "activationStatus": "activated",
    "authenticationMode": "simple",
    "projectId": "7260"
  },
  "connectivity": {
    "wifi": true,
    "isReachable": true,
    "cellular": false
  },
  "visitor": {
    "vuid": "d4a57969c7fc4e2a9380f3931fdcee3a965650eb9c6b4",
    "tokenExpiration": "2025-02-27T08:14:11Z"
  },
  "sdkVersion": "2.15.4"
}
```

### Targeting Listener failure callback

This release also adds a callback to notify the integrator about targeting rule trigger failures. This takes the form of a new subscription:

```
late StreamSubscription _targetingRuleAvailabilityUpdateFailedSubscription;

_targetingRuleAvailabilityUpdateFailedSubscription = IAdvizeSdk
    .onActiveTargetingRuleAvailabilityUpdateFailed
    .listen((Map<String, String> error) {
  log('iAdvize Example : Targeting Rule availability update error: $error');
});
```

This will be called when triggering the targeting rule fails and give the reason of the failure when possible.
Please note that the targeting rule triggering may fail, but for standard reasons (for instance if there is no agent availabale to answer). In those cases this `_targetingRuleAvailabilityUpdateFailedSubscription` would not be called, only the usual `_targetingRuleAvailabilityUpdatedSubscription` would be called with a `false` value for `available`.

> To integrate this update you will have to update your code where you want to use this new callback.

## 2.14.2 > 2.14.3

This release adds a new LogLevel.ALL to force the logging of all possible logs of the SDK. This must be used with caution as latencies may be noticed in the hosting app, so do not use this feature without iAdvize explicit authorization for live debugging.

## 2.14.0 > 2.14.2

*Nothing to report*

## 2.13.10 > 2.14.0

*Nothing to report*

## 2.13.9 > 2.13.10

*Nothing to report*

## 2.13.8 > 2.13.9

This release adds a missing callback to the `logout` API. It now returns a `Future<bool>`:

```
IAdvizeSdk.logout().then((bool success) => success
  ? log('iAdvize Example : SDK logged out')
  : log('iAdvize Example : Error looging out of SDK'));
```

## 2.13.7 > 2.13.8

*Nothing to report*

## 2.13.6 > 2.13.7

*Nothing to report*

## 2.13.5 > 2.13.6

*Nothing to report*

## 2.13.4 > 2.13.5

*Nothing to report*

## 2.13.2 > 2.13.4

In this release the Push Notification APIs has been enhanced so that you can now clear the iAdvize Push Notifications on demand.

In order to do so on Android, the SDK now provides a specific Notification Channel, where all iAdvize push notifications may be placed. That way, the SDK will automatically clear this notification channel when Chatbox is opened, and you can clear it manually by calling one of the SDK APIs.

First of all you need to create this notification channel:

```
IAdvizeSdk.createNotificationChannel();
```
This call does nothing when called on an iOS platform.

Then, when receiving a push notification, in order to display it via your usual notification library, you need to specify the notificaiton channel id retrieved via:
```
final String notifChannelId = await IAdvizeSdk.notificationChannelId();
```
Here as well this API does nothing on iOS (it returns an empty string).

In order to know how to specify the notification channel id when displaying the push notification, please refer to the documentation of your notification library.

On iOS the notification channel concept does not exist so nothing has to be done here for configuration.

Once this is done, the push notification coming from iAdvize will be cleared automatically when the visitor opens the Chatbox. 
If you want to clear them manually at any other time you can call this API:

```
IAdvizeSDK.clearIAdvizePushNotifications()
```


## 2.13.1 > 2.13.2

*Nothing to report*

## 2.13.0 > 2.13.1

*Nothing to report*

## 2.12.0 > 2.13.0

Chatbox APIs were added in order for the integrator to know when the Chatbox is opened & closed.
```
IAdvizeSdk.setChatboxListener();
StreamSubscription _chatboxOpenedSubscription = IAdvizeSdk.onChatboxOpened
    .listen((event) => log('iAdvize Example : Chatbox opened'));
StreamSubscription _chatboxClosedSubscription = IAdvizeSdk.onChatboxClosed
    .listen((event) => log('iAdvize Example : Chatbox closed'));
```

## 2.11.2 > 2.12.0

This release deprecates the ChatboxConfiguration.mainColor setting and adds new ways to customize the look and feel of the messages, both the ones from the visitor and the ones from the agent. Please review the new parameters to customize them to your liking.

This release adds a new LogLevel.NONE to disable all console logs and all logging capture. Please note that this disables iAdvize functional logs aggregation as well so debugging issues will be made harder if this mode is chosen.

## 2.11.1 > 2.11.2

*Nothing to report*

## 2.11.0 > 2.11.1

*Nothing to report*

## 2.10.4 > 2.11.0

From this release and onward, the possibility to upload files in the conversation is based on the option
available in the Admin Chatbox Builder. To enable/disable it go to your iAdvize Administration Panel then :
> Engagement > Notifications & Chatbox > Chatbox (Customize) > Composition box (tab) > Allow the visitor to upload images and pdf

## 2.10.3 > 2.10.4

*Nothing to report*

## 2.10.2 > 2.10.3

The minimum required Dart SDK version was bumped to `>=2.19.0 <3.0.0` so ensure you are using a valid Dart SDK version.

## 2.10.1 > 2.10.2

*Nothing to report*

## 2.10.0 > 2.10.1

*Nothing to report*

## 2.9.4 > 2.10.0

*Nothing to report*

## 2.9.3 > 2.9.4

*Nothing to report*

## 2.9.2 > 2.9.3

*Nothing to report*

## 2.9.1 > 2.9.2

*Nothing to report*

## 2.9.0 > 2.9.1

The Kotlin version used in the SDK was updated from `1.7.20` to `1.8.10`. You will need to update your
Kotlin version accordingly in order for your project to compile.

## 2.8.0 > 2.9.0

#### GDPROption Listener

You can configure how the SDK behaves when the user taps on the `More information` button by either:

- providing an URL pointing to your GPDR policy, it will be opened on user click
- providing a listener/delegate, it will be called on user click and you can then implement your own custom behavior

> *⚠️ If your visitors have already consented to GDPR inside your application, you can activate the iAdvize SDK without the GDPR process. However, be careful to explicitly mention the iAdvize Chat part in your GDPR consent details.*

<pre class="prettyprint">
// Disabled
val gdprOption = GDPROption.disabled()

// URL
val gdprOption = GDPROption.url(url: "http://my.gdpr.rules.com")

// Listener
void _onGDPRMoreInfoClicked() {
  log('iAdvize Example : GDPR More Info button clicked');
}
val gdprOption = GDPROption.listener(onMoreInfoClicked: _onGDPRMoreInfoClicked)
</pre>

#### Add notification API (isIAdvizePushNotification)

As the SDK notifications are caught in the same place than your app other notifications, you first have to distinguish if the received notification comes from iAdvize or not. This can be done using:

<pre class="prettyprint">
void handleNotification(RemoteMessage message) {
  log('handling notification $message');
  IAdvizeSdk.isIAdvizePushNotification(message.data).then(
    (bool isAdvizeNotification) =>
      log('Notification from iAdvize ? $isAdvizeNotification'));
}
</pre>

#### Add Custom Data API (registerCustomData) to save visitor custom data

The iAdvize Messenger SDK allows you to save data related to the visitor conversation:

<pre class="prettyprint">
List<CustomData> customData = <CustomData>[
  CustomData.fromString("Test", "Test"),
  CustomData.fromBoolean("Test2", false),
  CustomData.fromDouble("Test3", 2.0),
  CustomData.fromInt("Test4", 3)
];
IAdvizeSdk.registerCustomData(customData).then((bool success) =>
    log('iAdvize Example : custom data registered: $success'));
</pre>

> *⚠️ As those data are related to the conversation they cannot be sent if there is no ongoing conversation. Custom data registered before the start of a conversation are stored and the SDK automatically tries to send them when the conversation starts.*

The visitor data you registered are displayed in the iAdvize Operator Desk in the conversation sidebar, in a tab labelled  `Custom data`.

## 2.8.2 > 2.8.3

*Nothing to report*

### Integration documentation

Please refer to our up-to-date public integration documentation if needed, it contains code snippets
for each feature of the SDK:
https://developers.iadvize.com/documentation/mobile-sdk
