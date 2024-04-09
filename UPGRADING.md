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
