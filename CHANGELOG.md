# 2.13.8 (Cantal)

### Release date 2024/05/14

**Bug fixes**

- Fix line feed escaping breaking markdown syntax in bot messages
- (Android) Fix text selection breaking markdown link handling

# 2.13.7 (Cantal)

### Release date 2024/04/11

**Bug fixes**

- (Android) Fix secured preferences initialization issue in case of modified decryption key

# 2.13.6 (Cantal)

### Release date 2024/04/09

**Features**

- (Android) Add copy-paste selection in messages

**Bug fixes**

- (Android) Fix secured preferences initialization issue with Android auto-backup strategy

# 2.13.5 (Cantal)

### Release date 2024/03/21

**Features**

- (Android) Rework the initiate API, adding a callback + implementing retry behavior

**Bug fixes**

- Fix markdown links not triggering the SDK click handler
- (Android) Fix a crash occuring when visitor spam messages
- (Android) Add some missing obfuscation instructions
- (iOS) Fix deadlock state in case of first XMPP connection error

# 2.13.4 (Cantal)

### Release date 2024/01/18

**Features**

- Clear iAdvize Push Notifications on chatbox opening
- Add an API for clearing iAdvize Push Notifications on demand

**Bug fixes**

- (iOS) Fix a UI thread crash when displaying error view

# 2.13.2 (Cantal)

### Release date 2023/12/21

**Features**

- Support simple Markdown syntax inside QuickReply messages
- Add some translations for GDPR messages (cs, da, pl, sk, sv)

**Bug fixes**

- (Android) Fix a display issue on ProductOffer messages when no offer pric is set
- (iOS) Fix GDPR mode not updating after multiple activations

**Dependencies**

- (Android) Removed deprecated `play-services-safetynet` dependency in favor of `play-services-basement`

# 2.13.1 (Cantal)

### Release date 2023/11/29

**Features**

- (iOS) Support multiline in QuickReply choices

**Bug fixes**

- (Android) Fix potential stuck state during GDPR process
- (Android) Fix conversation not being started properly if network disconnects during MUC/SUB subscription
- (Android) Remove OnBackPressedHandler which was causing issues in back button handling
- (iOS) Add missing completion call on secured auth activation failure callback
- (iOS) Fix conversation closing regression caused by the token refresh strategy

**Dependencies**

- Kotlin `1.9.20`
- Gradle `8.3`
- Android Gradle Plugin `8.1.2`
- Android SDK Target `34`
- Android SDK Build Tools `34.0.0`

# 2.13.0 (Cantal)

### Release date 2023/10/25

**Features**

- Add automatic auth token refresh management
- Remove preview image when it is empty (previously used a placeholder)
- Add `onChatboxOpened` & `onChatboxClosed` API

**Bug fixes**

- Fix web & markdown links display
- (iOS) Fix QuickReplies hit detection when no avatar is set
- (iOS) Review of Chatbox APIs computation on main UI thread

**Dependencies**

- (iOS) Xcode target `14.2` -> `15.0`
- (Android) Gradle Plugin `8.1.0` -> `8.1.1`

# 2.12.0 (Beaufort)

### Release date 2023/08/16

**Features**

- Allow a more sophisticated message color customization
- Add a LogLevel mode to remove all logs

**Bug fixes**

- Fix conversation management after various network connection issues (phone sleep / app in background)
- (iOS) Fix secured auth token concurrency spam

**Dependencies**

- (iOS) Updated min supported iOS platform from `12.0` to `13.0`
- (Android) Gradle Plugin `7.4.1` -> `8.1.0`
- (Android) Build Tools `33.0.1` -> `33.0.2`
- (Android) Kotlin `1.8.10` -> `1.8.21`

# 2.11.2 (Angelot)

### Release date 2023/05/31

**Bug fixes**

- (iOS) Fix video conversation flow wrongly changing the conversation channel
- Fix font update on several message types

# 2.11.1 (Angelot)

### Release date 2023/05/29

**Bug fixes**

- (Android) Fix compilation issue on build

# 2.11.0 (Angelot)

### Release date 2023/05/25

**Features**

- Disable file attachment buttons when it is disabled in Admin chatbox template

**Bug fixes**

- (iOS) Fix camera still opening after manual permission removal
- (iOS) Fix targeting listener not being triggered when there is an ongoing conversation
- (iOS) Fix ongoing conversation being returned as true after closing a video conversation
- (Android) Fix message alignment

# 2.10.4

### Release date 2023/04/17

**Bug fixes**

- (Android) Fix default floating button showing when disabled

# 2.10.3

### Release date 2023/04/06

**Dependencies**

- Set minimum required Dart SDK version to `2.19.0`

# 2.10.2

### Release date 2023/04/05

**Bug fixes**

- Fix chatbox configuration API

# 2.10.1

### Release date 2023/03/30

**Bug fixes**

- (Android) Fix message alignment

# 2.10.0

### Release date 2023/03/29

**Features**

- Disable satisfaction survey after failed bot transfer if parametrized in the admin
- Handle the Estimated Waiting Time messages

**Bug fixes**

- (Android) Fix pre-conversation custom data not being sent on conversation start
- (Android) Fix targeting process not being fully restarted after conversation end

# 2.9.4

### Release date 2023/03/07

**Bug fixes**

- (Android) Fix Android build issues

# 2.9.3

### Release date 2023/03/01

**Bug fixes**

- (Android) Fix Android build issues

# 2.9.2

### Release date 2023/02/15

**Features**

- (iOS) Embed XMPPFramwork inside XCFramework artifact (Twilio is now the only external SDK dependency)

**Bug fixes**

- (iOS) Fix bug in framework generation causing upload issues for integrating app

# 2.9.1

### Release date 2023/02/09

**Bug fixes**

- (iOS) Fix bot conversation starting without user GDPR consent
- (Android) Fix file picker permissions on Android 13

# 2.9.0

### Release date 2022/12/30

**Features**

- Add the Listener GDPROption to implement a custom behavior on user "More info" click
- Add notification API (isIAdvizePushNotification)
- Add Custom Data API (registerCustomData) to save visitor custom data

See UPGRADING.md or the [official documentation](https://developers.iadvize.com/documentation/mobile-sdk) for deeper explanations on those features.

**Bug fixes**

- Fix NPS values to 0-10 (was 1-10)

# 2.8.0

### Release date 2022/12/09

Initial release
