import Flutter
import UIKit
import IAdvizeConversationSDK



public class SwiftFlutterIadvizeSdkPlugin: NSObject, FlutterPlugin {
    let TAG = "iAdvize SDK"
    let CHANNEL_METHOD_ACTIVATE = "activate"
    let CHANNEL_METHOD_LOG_LEVEL = "setLogLevel"
    let CHANNEL_METHOD_LANGUAGE = "setLanguage"
    let CHANNEL_METHOD_ACTIVATE_TARGETING_RULE = "activateTargetingRule"
    let CHANNEL_METHOD_iS_ACTIVE_TARGETING_RULE_AVAILABLE = "isActiveTargetingRuleAvailable"
    let CHANNEL_METHOD_SET_TARGETING_RULE_AVAILABILITY_LISTENER = "setOnActiveTargetingRuleAvailabilityListener"
    let CHANNEL_METHOD_SET_CONVERSATION_LISTENER = "setConversationListener"
    let CHANNEL_METHOD_ONGOING_CONVERSATION_ID = "ongoingConversationId"
    let CHANNEL_METHOD_ONGOING_CONVERSATION_CHANNEL = "ongoingConversationChannel"
    let CHANNEL_METHOD_REGISTER_PUSH_TOKEN = "registerPushToken"
    let CHANNEL_METHOD_ENABLE_PUSH_NOTIFICATIONS = "enablePushNotifications"
    let CHANNEL_METHOD_DISABLE_PUSH_NOTIFICATIONS = "disablePushNotifications"
    
    var onReceiveMessageStreamHandler: OnReceiveMessageStreamHandler?
    var handleClickUrlStreamHandler: HandleClickUrlStreamHandler?
    var onOngoingConversationUpdatedStreamHandler: OnUpdatedStreamHandler?
    var onActiveTargetingRuleAvailabilityUpdatedStreamHandler: OnUpdatedStreamHandler?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_iadvize_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterIadvizeSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        instance.onReceiveMessageStreamHandler = OnReceiveMessageStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/onReceiveMessage", binaryMessenger: registrar.messenger()).setStreamHandler(instance.onReceiveMessageStreamHandler)
        instance.handleClickUrlStreamHandler = HandleClickUrlStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/handleClickUrl", binaryMessenger: registrar.messenger()).setStreamHandler(instance.handleClickUrlStreamHandler)
        instance.onOngoingConversationUpdatedStreamHandler = OnUpdatedStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/onOngoingConversationUpdated", binaryMessenger: registrar.messenger()).setStreamHandler(instance.onOngoingConversationUpdatedStreamHandler)
        instance.onActiveTargetingRuleAvailabilityUpdatedStreamHandler = OnUpdatedStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/onActiveTargetingRuleAvailabilityUpdated", binaryMessenger: registrar.messenger()).setStreamHandler(instance.onActiveTargetingRuleAvailabilityUpdatedStreamHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args: [String: Any] = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "BAD_ARGS",
                                     message: "\(TAG): could not recognize flutter arguments in method: (\(self.CHANNEL_METHOD_ACTIVATE))",
                                     details: nil))
            return
        }
        switch call.method {
            
        case self.CHANNEL_METHOD_ACTIVATE:
            let projectId : Int = args["projectId"] as! Int
            let userId = args["userId"] as? String ?? nil
            let gdprUrl = args["gdprUrl"] as? String ?? nil
            activate(projectId: projectId, userId: userId, gdprUrl: gdprUrl, result: result)
        case self.CHANNEL_METHOD_LOG_LEVEL:
            let logLevel = args["logLevel"] as! Int
            setLogLevel(value: logLevel)
        case self.CHANNEL_METHOD_LANGUAGE:
            let language = args["language"] as! String
            setLanguage(language: language)
        case self.CHANNEL_METHOD_ACTIVATE_TARGETING_RULE:
            let uuid = args["uuid"] as! String
            let channel = args["channel"] as! String
            activateTargetingRule(uuid: uuid, channel: channel)
        case self.CHANNEL_METHOD_iS_ACTIVE_TARGETING_RULE_AVAILABLE:
            result(isActiveTargetingRuleAvailable())
        case self.CHANNEL_METHOD_SET_TARGETING_RULE_AVAILABILITY_LISTENER:
            setOnActiveTargetingRuleAvailabilityListener()
        case self.CHANNEL_METHOD_SET_CONVERSATION_LISTENER:
            setConversationListener()
        case self.CHANNEL_METHOD_ONGOING_CONVERSATION_ID:
            result(ongoingConversationId())
        case self.CHANNEL_METHOD_ONGOING_CONVERSATION_CHANNEL:
            result(ongoingConversationChannel())
        case self.CHANNEL_METHOD_REGISTER_PUSH_TOKEN:
            let pushToken = args["pushToken"] as! String
            let mode = args["mode"] as! String
           registerPushToken(pushToken: pushToken, mode: mode)
        case self.CHANNEL_METHOD_ENABLE_PUSH_NOTIFICATIONS:
           enablePushNotifications(result: result)
        case self.CHANNEL_METHOD_DISABLE_PUSH_NOTIFICATIONS:
           disablePushNotifications(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func activate(projectId: Int,
                          userId: String?,
                          gdprUrl: String?, result: @escaping FlutterResult) -> Void {
        let rgpdOption: IAdvizeConversationSDK.GDPROption = gdprUrl != nil && URL(string: gdprUrl!) != nil ? .enabled(option: .legalInformation(url: URL(string: gdprUrl!)!)) : .disabled
        
        let authenticationOption: IAdvizeConversationSDK.AuthenticationOption = {
            guard userId != nil && userId!.isEmpty == false else {
                return .anonymous
            }
            return .simple(userId: userId!)
        }()
        
        IAdvizeSDK.shared.activate(projectId: projectId,
                                   authenticationOption: authenticationOption,
                                   gdprOption: rgpdOption){ success in
            
           result(success)
        }
    }
    
    private func setLogLevel(value: Int) -> Void {
        IAdvizeSDK.shared.logLevel = IAdvizeConversationSDK.Logger.LogLevel.fromInt(value)
    }
    
    private func setLanguage(language: String) -> Void {
        IAdvizeSDK.shared.targetingController.language = .custom(value: Language(rawValue: language.lowercased()) ?? .fr)
    }
    
    private func activateTargetingRule(uuid: String, channel: String) -> Void {
        
        guard let uuid = UUID(uuidString: uuid) else {
            print("Unable to activate targeting rule: targeting rule id not valid")
            return
        }
        let channel = ConversationChannel.fromString(channel)
        let targetingRule = TargetingRule(id: uuid, conversationChannel: channel)
        IAdvizeSDK.shared.targetingController.activateTargetingRule(targetingRule: targetingRule)
        
    }
    
    private func isActiveTargetingRuleAvailable() -> Bool {
       return IAdvizeSDK.shared.targetingController.isActiveTargetingRuleAvailable
    }

    private func setOnActiveTargetingRuleAvailabilityListener() {
        IAdvizeSDK.shared.targetingController.delegate = self  
    }

    private func setConversationListener() {
        IAdvizeSDK.shared.conversationController.delegate = self   
    }

    private func ongoingConversationId() -> String? {
        return IAdvizeSDK.shared.conversationController.ongoingConversation()?.conversationId.uuidString
    }

    private func ongoingConversationChannel() -> String? {
        return IAdvizeSDK.shared.conversationController.ongoingConversation()?.conversationChannel.rawValue
    }

    private func registerPushToken(pushToken: String, mode: String) -> Void {
        let applicationMode = ApplicationMode.fromString(mode)
        IAdvizeSDK.shared.notificationController.registerPushToken(pushToken, applicationMode: applicationMode)
    }

    private func enablePushNotifications(result: @escaping FlutterResult) -> Void {
        IAdvizeSDK.shared.notificationController.enablePushNotifications { success in
            result(success)
        }
    }
    
    
    private func disablePushNotifications(result: @escaping FlutterResult) -> Void {
        IAdvizeSDK.shared.notificationController.disablePushNotifications { success in
            result(success)
        }
    }
}

extension SwiftFlutterIadvizeSdkPlugin: TargetingControllerDelegate {
    public func activeTargetingRuleAvailabilityDidUpdate(isActiveTargetingRuleAvailable: Bool) {
        self.onActiveTargetingRuleAvailabilityUpdatedStreamHandler?.onUpdated(value: isActiveTargetingRuleAvailable)
    }
}

extension SwiftFlutterIadvizeSdkPlugin: ConversationControllerDelegate {
    public func ongoingConversationUpdated(ongoingConversation: IAdvizeConversationSDK.OngoingConversation?) {
        self.onOngoingConversationUpdatedStreamHandler?.onUpdated(value: ongoingConversation != nil)
    }
    public func didReceiveNewMessage(content: String) {
        self.onReceiveMessageStreamHandler?.onMessage(message: content)
    }
    public func conversationController(_ controller: ConversationController, shouldOpen url: URL) -> Bool {
        self.handleClickUrlStreamHandler?.onUrlClicked(url: url.absoluteString)
        return true;
    }
}

extension ConversationChannel {
    static func fromString(_ channel: String) -> ConversationChannel {
        switch channel.uppercased() {
        case "VIDEO":
            return .video
        case "CHAT":
            return .chat
        default:
            return .chat
        }
    }
}

extension ApplicationMode {
    static func fromString(_ mode: String) -> ApplicationMode {
        switch mode.lowercased() {
        case "dev":
            return .dev
        case "prod":
            return .prod
        default:
            return .dev
        }
    }
}

extension IAdvizeConversationSDK.Logger.LogLevel {
    static func fromInt(_ value: Int) -> IAdvizeConversationSDK.Logger.LogLevel {
        switch value {
        case 0: return .verbose
        case 1: return .info
        case 2: return .warning
        case 3: return .error
        case 4: return .success
        default: return .verbose
        }
    }
}
