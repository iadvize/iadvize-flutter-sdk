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
    let CHANNEL_METHOD_REGISTER_USER_NAVIGATION = "registerUserNavigation"
    let CHANNEL_METHOD_ONGOING_CONVERSATION_ID = "ongoingConversationId"
    let CHANNEL_METHOD_ONGOING_CONVERSATION_CHANNEL = "ongoingConversationChannel"
    let CHANNEL_METHOD_REGISTER_PUSH_TOKEN = "registerPushToken"
    let CHANNEL_METHOD_ENABLE_PUSH_NOTIFICATIONS = "enablePushNotifications"
    let CHANNEL_METHOD_DISABLE_PUSH_NOTIFICATIONS = "disablePushNotifications"
    let CHANNEL_METHOD_SET_DEFAULT_BUTTON = "setDefaultFloatingButton"
    let CHANNEL_METHOD_SET_BUTTON_POSITION = "setFloatingButtonPosition"
    let CHANNEL_METHOD_SET_CHATBOX_CONFIG = "setChatboxConfiguration"
    let CHANNEL_METHOD_REGISTER_TRANSACTION = "registerTransaction"
    let CHANNEL_METHOD_LOGOUT = "logout"
    let CHANNEL_METHOD_PRESENT_CHATBOX = "presentChatbox"
    let CHANNEL_METHOD_DISMISS_CHATBOX = "dismissChatbox"
    let CHANNEL_METHOD_IS_SDK_ACTIVATED = "isSDKActivated"
    let CHANNEL_METHOD_IS_CHATBOX_PRESENTED = "isChatboxPresented"
    
    var methodChannel: FlutterMethodChannel?
    var onReceiveMessageStreamHandler: OnReceiveMessageStreamHandler?
    var handleClickUrlStreamHandler: HandleClickUrlStreamHandler?
    var onOngoingConversationUpdatedStreamHandler: OnUpdatedStreamHandler?
    var onActiveTargetingRuleAvailabilityUpdatedStreamHandler: OnUpdatedStreamHandler?
    
    var flutterWillManageUrlClick = false
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterIadvizeSdkPlugin()
        
        instance.methodChannel = FlutterMethodChannel(name: "flutter_iadvize_sdk", binaryMessenger: registrar.messenger())
        let channel = instance.methodChannel!
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.onReceiveMessageStreamHandler = OnReceiveMessageStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/onReceiveMessage", binaryMessenger: registrar.messenger()).setStreamHandler(instance.onReceiveMessageStreamHandler)
        instance.handleClickUrlStreamHandler = HandleClickUrlStreamHandler()
        FlutterEventChannel(name: "flutter_iadvize_sdk/onHandleClickUrl", binaryMessenger: registrar.messenger()).setStreamHandler(instance.handleClickUrlStreamHandler)
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
            let gdprUrl = args["gdprUrl"] as? String ?? nil
            let authenticationOptionType : String = args["type"] as! String
            switch authenticationOptionType {
            case "anonymous":
                print("anonymous")
                let authOption: IAdvizeConversationSDK.AuthenticationOption = .anonymous
                activate(projectId: projectId, authOption: authOption, gdprUrl: gdprUrl, result: result)
            case "simple":
                let userId = args["userId"] as! String
                print("simple " + userId)
                let authOption: IAdvizeConversationSDK.AuthenticationOption = .simple(userId: userId)
                activate(projectId: projectId, authOption: authOption, gdprUrl: gdprUrl, result: result)
            case "secured":
                print("secured")
                let authOption: IAdvizeConversationSDK.AuthenticationOption = .secured(jweProvider: self)
                activate(projectId: projectId, authOption: authOption, gdprUrl: gdprUrl, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
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
        case self.CHANNEL_METHOD_REGISTER_USER_NAVIGATION:
            let uuid = args["uuid"] as! String?
            let channel = args["channel"] as! String?
            let option = args["navigationOption"] as! String
            registerUserNavigation(navigationOption: option, uuid: uuid, channel: channel)
        case self.CHANNEL_METHOD_SET_CONVERSATION_LISTENER:
            self.flutterWillManageUrlClick = args["manageUrlClick"] as! Bool
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
        case self.CHANNEL_METHOD_SET_DEFAULT_BUTTON:
            let active = args["active"] as! Bool
            setDefaultFloatingButton(active: active)
        case self.CHANNEL_METHOD_SET_BUTTON_POSITION:
            let leftMargin = args["leftMargin"] as! Int
            let bottomMargin = args["bottomMargin"] as! Int
            setFloatingButtonPosition(leftMargin: leftMargin, bottomMargin: bottomMargin)
        case self.CHANNEL_METHOD_SET_CHATBOX_CONFIG:
            let mainColor = args["mainColor"] as! String?
            let navigationBarBackgroundColor = args["navigationBarBackgroundColor"] as! String?
            let navigationBarMainColor = args["navigationBarMainColor"] as! String?
            let navigationBarTitle = args["navigationBarTitle"] as! String?
            let fontName = args["fontName"] as! String?
            let fontSize = args["fontSize"] as! Int?
            let automaticMessage = args["automaticMessage"] as! String?
            let gdprMessage = args["gdprMessage"] as! String?
            
            var incomingMessageAvatarImage: [UInt8]?
            let incomingMessageAvatarImageFlutter = args["incomingMessageAvatarImage"] as! FlutterStandardTypedData?
            if incomingMessageAvatarImageFlutter != nil {incomingMessageAvatarImage = [UInt8](incomingMessageAvatarImageFlutter!.data)}
            let incomingMessageAvatarURL = args["incomingMessageAvatarURL"] as! String?
            
            setChatboxConfiguration(
                mainColor:mainColor,
                navigationBarBackgroundColor:navigationBarBackgroundColor,
                navigationBarMainColor:navigationBarMainColor,
                navigationBarTitle:navigationBarTitle,
                fontName:fontName,
                fontSize:fontSize,
                automaticMessage:automaticMessage,
                gdprMessage:gdprMessage,
                incomingMessageAvatarImage:incomingMessageAvatarImage,
                incomingMessageAvatarURL:incomingMessageAvatarURL
            )
        case self.CHANNEL_METHOD_REGISTER_TRANSACTION:
            let transactionId = args["transactionId"] as! String
            let amount = args["amount"] as! Double
            let currency = args["currency"] as! String
            let success = registerTransaction(transactionId: transactionId, amount: amount, currencyName: currency)
            if(!success) {
                result(FlutterError.init(code: "BAD_ARGS",
                                         message: "\(TAG): Invalid currency",
                                         details: nil))
            }
        case self.CHANNEL_METHOD_LOGOUT: logout()
        case self.CHANNEL_METHOD_PRESENT_CHATBOX: presentChatbox()
        case self.CHANNEL_METHOD_DISMISS_CHATBOX: dismissChatbox()
        case self.CHANNEL_METHOD_IS_CHATBOX_PRESENTED:
            let presented = isChatboxPresented()
            result(presented)
        case self.CHANNEL_METHOD_IS_SDK_ACTIVATED:
            let activated = isSDKActivated()
            result(activated)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func activate(projectId: Int,
                          authOption: AuthenticationOption,
                          gdprUrl: String?, result: @escaping FlutterResult) -> Void {
        let rgpdOption: IAdvizeConversationSDK.GDPROption = gdprUrl != nil && URL(string: gdprUrl!) != nil ? .enabled(option: .legalInformation(url: URL(string: gdprUrl!)!)) : .disabled
        
        IAdvizeSDK.shared.activate(projectId: projectId,
                                   authenticationOption: authOption,
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
    
    private func registerUserNavigation(navigationOption: String, uuid: String?, channel: String?) -> Void {
        let navOption = NavigationOption.fromString(navigationOption, uuid: uuid, channel: channel)
        IAdvizeSDK.shared.targetingController.registerUserNavigation(navigationOption: navOption)
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
    
    private func setDefaultFloatingButton(active: Bool) -> Void {
        IAdvizeSDK.shared.chatboxController.useDefaultFloatingButton = active
    }
    
    private func setFloatingButtonPosition(leftMargin: Int, bottomMargin: Int) -> Void {
        IAdvizeSDK.shared.chatboxController.setFloatingButtonPosition(leftMargin: Double(leftMargin), bottomMargin: Double(bottomMargin))
    }
    
    private func setChatboxConfiguration(mainColor:String?,
                                         navigationBarBackgroundColor:String?,
                                         navigationBarMainColor:String?,
                                         navigationBarTitle:String?,
                                         fontName:String?,
                                         fontSize:Int?,
                                         automaticMessage:String?,
                                         gdprMessage:String?,
                                         incomingMessageAvatarImage:[UInt8]?,
                                         incomingMessageAvatarURL:String?) -> Void {
        var configuration = ChatboxConfiguration()
        if mainColor != nil, let color = UIColor(hexString: mainColor!) {
            configuration.mainColor = color
        }
        if navigationBarBackgroundColor != nil, let color = UIColor(hexString: navigationBarBackgroundColor!) {
            configuration.navigationBarBackgroundColor = color
        }
        if navigationBarMainColor != nil, let color = UIColor(hexString: navigationBarMainColor!) {
            configuration.navigationBarMainColor = color
        }
        if navigationBarTitle != nil {
            configuration.navigationBarTitle = navigationBarTitle
        }
        if fontName != nil && fontSize != nil {
            configuration.font = UIFont(name: fontName!, size: CGFloat(fontSize!))
        }
        if automaticMessage != nil {
            configuration.automaticMessage = automaticMessage
        }
        if gdprMessage != nil {
            configuration.gdprMessage = gdprMessage
        }
        if incomingMessageAvatarImage != nil {
            let data = Data(bytes: incomingMessageAvatarImage!, count: incomingMessageAvatarImage!.count)
            if let image = UIImage(data: data){
                configuration.incomingMessageAvatar = .image(image: image)
            }
        }
        if incomingMessageAvatarURL != nil,
           let url = URL(string: incomingMessageAvatarURL!) {
            configuration.incomingMessageAvatar = .url(url: url)
        }
        
        IAdvizeSDK.shared.chatboxController.setupChatbox(configuration: configuration)
    }
    
    private func registerTransaction(transactionId: String, amount: Double, currencyName: String) -> Bool {
        guard let currency = Currency(rawValue: currencyName) else{
            print("error")
            return false
        }
        if(currency == Currency.__unknown(currencyName)) {
            return false
        }
        let transaction = Transaction(externalTransactionId: transactionId, date: Date(), amount: amount, currency: currency)
        IAdvizeSDK.shared.transactionController.registerTransaction(transaction)
        return true
    }
    
    private func logout() -> Void {
        IAdvizeSDK.shared.logout()
    }
    
    private func presentChatbox() -> Void {
        IAdvizeSDK.shared.chatboxController.presentChatbox(
            animated: true,
            presentingViewController: UIApplication.shared.keyWindow?.rootViewController) {
                
            }
        
    }
    
    private func dismissChatbox() -> Void {
        IAdvizeSDK.shared.chatboxController.dismissChatbox()
        
    }
    
    private func isSDKActivated() -> Bool {
        return IAdvizeSDK.shared.activationStatus == .activated
    }
    
    private func isChatboxPresented() -> Bool {
        return IAdvizeSDK.shared.chatboxController.isChatboxPresented()
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
        return !self.flutterWillManageUrlClick;
    }
}

extension ConversationChannel {
    static func fromString(_ channel: String) -> ConversationChannel {
        switch channel.lowercased() {
        case "video":
            return .video
        case "chat":
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

extension NavigationOption {
    static func fromString(_ navigationOption: String, uuid: String?, channel: String?) -> NavigationOption {
        switch navigationOption.lowercased() {
        case "clear":
            return .clearActiveRule
        case "keep":
            return .keepActiveRule
        case "new":
            guard let uuid = UUID(uuidString: uuid!) else {
                print("Unable to activate targeting rule: targeting rule id not valid")
                return .clearActiveRule
            }
            let channel = ConversationChannel.fromString(channel!)
            let targetingRule = TargetingRule(id: uuid, conversationChannel: channel)
            return .activateNewRule(targetingRule: targetingRule)
        default:
            return .clearActiveRule
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

extension SwiftFlutterIadvizeSdkPlugin: JWEProvider {
    public func willRequestJWE(completion: @escaping (Result<IAdvizeConversationSDK.JWE, Error>) -> Void) {
        DispatchQueue.main.async {
            self.methodChannel?.invokeMethod("get_jwe", arguments: nil, result: {(r:Any?) -> () in
                if r is String? { let jwe = r as! String
                    completion(.success(IAdvizeConversationSDK.JWE(value: jwe)))
                }
            })
        }
    }
}
