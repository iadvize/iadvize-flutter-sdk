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
