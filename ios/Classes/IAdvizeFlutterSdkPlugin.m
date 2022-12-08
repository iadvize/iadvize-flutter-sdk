#import "IAdvizeFlutterSdkPlugin.h"
#if __has_include(<iadvize_flutter_sdk/iadvize_flutter_sdk-Swift.h>)
#import <iadvize_flutter_sdk/iadvize_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "iadvize_flutter_sdk-Swift.h"
#endif

@implementation IAdvizeFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [IAdvizeSdkSwiftFlutterPlugin registerWithRegistrar:registrar];
}
@end
