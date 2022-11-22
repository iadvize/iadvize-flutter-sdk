import Flutter
import UIKit
import IAdvizeConversationSDK

let TAG = "iAdvize SDK"

public class SwiftFlutterIadvizeSdkPlugin: NSObject, FlutterPlugin {
    let CHANNEL_METHOD_ACTIVATE = "activate"
    let CHANNEL_METHOD_LOG_LEVEL = "setLogLevel"
    let CHANNEL_METHOD_LANGUAGE = "setLanguage"
    let CHANNEL_METHOD_ACTIVATE_TARGETING_RULE = "activateTargetingRule"
    let CHANNEL_METHOD_iS_ACTIVE_TARGETING_RULE_AVAILABLE = "isActiveTargetingRuleAvailable"
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_iadvize_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterIadvizeSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
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
            isActiveTargetingRuleAvailable(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func activate(projectId: Int,
                          userId: String?,
                          gdprUrl: String?, result: @escaping FlutterResult) {
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
        print("\(TAG) - setLogLevel called with \(value)")
        IAdvizeSDK.shared.logLevel = logLevelFrom(value: value)
    }
    
    private func logLevelFrom(value: Int) -> IAdvizeConversationSDK.Logger.LogLevel{
        switch value {
        case 0: return .verbose
        case 1: return .info
        case 2: return .warning
        case 3: return .error
        case 4: return .success
        default: return .verbose
        }
    }
    
    private func setLanguage(language: String) -> Void {
        print("\(TAG) - setLanguage called with \(language)")
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

    private func isActiveTargetingRuleAvailable(result: @escaping FlutterResult) -> Void {
        print("iAdvize iOS SDK - isActiveTargetingRuleAvailable called")
        result(IAdvizeSDK.shared.targetingController.isActiveTargetingRuleAvailable)
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
