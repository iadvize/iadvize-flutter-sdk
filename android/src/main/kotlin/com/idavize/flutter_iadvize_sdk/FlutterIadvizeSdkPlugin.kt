package com.idavize.flutter_iadvize_sdk

import android.app.Application
import android.content.Context
import android.content.res.Resources
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.util.Log
import com.iadvize.conversation.sdk.IAdvizeSDK
import com.iadvize.conversation.sdk.IAdvizeSDK.Callback
import com.iadvize.conversation.sdk.feature.authentication.AuthenticationOption
import com.iadvize.conversation.sdk.feature.chatbox.ChatboxConfiguration
import com.iadvize.conversation.sdk.feature.conversation.ConversationChannel
import com.iadvize.conversation.sdk.feature.conversation.ConversationListener
import com.iadvize.conversation.sdk.feature.conversation.IncomingMessageAvatar
import com.iadvize.conversation.sdk.feature.conversation.OngoingConversation
import com.iadvize.conversation.sdk.feature.defaultfloatingbutton.DefaultFloatingButtonConfiguration
import com.iadvize.conversation.sdk.feature.defaultfloatingbutton.DefaultFloatingButtonMargins
import com.iadvize.conversation.sdk.feature.defaultfloatingbutton.DefaultFloatingButtonOption
import com.iadvize.conversation.sdk.feature.gdpr.GDPREnabledOption
import com.iadvize.conversation.sdk.feature.gdpr.GDPROption
import com.iadvize.conversation.sdk.feature.logger.Logger
import com.iadvize.conversation.sdk.feature.targeting.LanguageOption
import com.iadvize.conversation.sdk.feature.targeting.NavigationOption
import com.iadvize.conversation.sdk.feature.targeting.TargetingListener
import com.iadvize.conversation.sdk.feature.targeting.TargetingRule
import com.iadvize.conversation.sdk.feature.transaction.Transaction
import com.iadvize.conversation.sdk.type.Currency
import com.iadvize.conversation.sdk.type.Language
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayInputStream
import java.net.URI
import java.net.URL
import java.util.*


inline fun <T> tryOrNull(f: () -> T) =
    try {
        f()
    } catch (_: Exception) {
        null
    }


/** FlutterIadvizeSdkPlugin */
class FlutterIadvizeSdkPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val chanelMethodName = "flutter_iadvize_sdk"
        private const val channelMethodActivate = "activate"
        private const val channelMethodSetLogLevel = "setLogLevel"
        private const val channelMethodSetLanguage = "setLanguage"
        private const val channelMethodActivateTargetingRule = "activateTargetingRule"
        private const val channelMethodIsActiveTargetingRuleAvailable =
            "isActiveTargetingRuleAvailable"
        private const val channelMethodSetConversationListener = "setConversationListener"
        private const val channelMethodSetTargetingRuleAvailabilityListener =
            "setOnActiveTargetingRuleAvailabilityListener"
        private const val channelMethodRegisterUserNavigation =
            "registerUserNavigation"
        private const val channelMethodOngoingConversationId = "ongoingConversationId"
        private const val channelMethodOngoingConversationChannel = "ongoingConversationChannel"
        private const val channelMethodRegisterPushToken = "registerPushToken"
        private const val channelMethodEnablePushNotifications = "enablePushNotifications"
        private const val channelMethodDisablePushNotifications = "disablePushNotifications"
        private const val channelMethodSetDefaultFloatingButton = "setDefaultFloatingButton"
        private const val channelMethodSetDefaultFloatingButtonPosition =
            "setFloatingButtonPosition"
        private const val channelMethodSetChatboxConfiguration = "setChatboxConfiguration"
        private const val channelMethodRegisterTransaction = "registerTransaction"
        private const val channelMethodLogout = "logout"
        private const val TAG: String = "iAdvize SDK"
    }


    private lateinit var channel: MethodChannel
    private lateinit var onReceiveMessageStreamHandler: OnReceiveMessageStreamHandler
    private lateinit var handleClickUrlStreamHandler: HandleClickUrlStreamHandler
    private lateinit var onOngoingConversationUpdatedStreamHandler: OnUpdatedStreamHandler
    private lateinit var onActiveTargetingRuleAvailabilityUpdatedStreamHandler: OnUpdatedStreamHandler

    private var defaultFloatingButtonConfiguration = DefaultFloatingButtonConfiguration()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(
            flutterPluginBinding.applicationContext
        )
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, chanelMethodName)
        channel.setMethodCallHandler(this)

        onReceiveMessageStreamHandler = OnReceiveMessageStreamHandler()
        EventChannel(
            flutterPluginBinding.binaryMessenger,
            "$chanelMethodName/onReceiveMessage"
        ).setStreamHandler(onReceiveMessageStreamHandler)
        handleClickUrlStreamHandler = HandleClickUrlStreamHandler()
        EventChannel(
            flutterPluginBinding.binaryMessenger,
            "$chanelMethodName/handleClickUrl"
        ).setStreamHandler(handleClickUrlStreamHandler)
        onOngoingConversationUpdatedStreamHandler = OnUpdatedStreamHandler()
        EventChannel(
            flutterPluginBinding.binaryMessenger,
            "$chanelMethodName/onOngoingConversationUpdated"
        ).setStreamHandler(onOngoingConversationUpdatedStreamHandler)
        onActiveTargetingRuleAvailabilityUpdatedStreamHandler = OnUpdatedStreamHandler()
        EventChannel(
            flutterPluginBinding.binaryMessenger,
            "$chanelMethodName/onActiveTargetingRuleAvailabilityUpdated"
        ).setStreamHandler(onActiveTargetingRuleAvailabilityUpdatedStreamHandler)
    }

    private fun onAttachedToEngine(applicationContext: Context) {
        IAdvizeSDK.initiate((applicationContext as Application))
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            channelMethodActivate -> {
                val projectId = call.argument<Int>("projectId") as Int
                val userId = call.argument<String?>("userId")
                val gdprUrl = call.argument<String?>("gdprUrl")
                activate(projectId, userId, gdprUrl, result)
            }
            channelMethodSetLogLevel -> {
                val logLevel = call.argument<Int>("logLevel") as Int
                setLogLevel(logLevel)
            }
            channelMethodSetLanguage -> {
                val language = call.argument<String>("language") as String
                setLanguage(language)
            }
            channelMethodActivateTargetingRule -> {
                val uuid = call.argument<String>("uuid") as String
                val channel = call.argument<String>("channel") as String
                activateTargetingRule(uuid, channel)
            }
            channelMethodIsActiveTargetingRuleAvailable -> {
                result.success(isActiveTargetingRuleAvailable())
            }
            channelMethodSetConversationListener -> {
                setConversationListener()
            }
            channelMethodSetTargetingRuleAvailabilityListener -> {
                setOnActiveTargetingRuleAvailabilityListener()
            }
            channelMethodRegisterUserNavigation -> {
                val uuid = call.argument<String?>("uuid")
                val channel = call.argument<String?>("channel")
                val option = call.argument<String>("navigationOption") as String
                registerUserNavigation(option, uuid, channel)
            }
            channelMethodOngoingConversationId -> {
                result.success(ongoingConversationId())
            }
            channelMethodOngoingConversationChannel -> {
                result.success(ongoingConversationChannel())
            }
            channelMethodRegisterPushToken -> {
                val pushToken = call.argument<String>("pushToken") as String
                val mode = call.argument<String>("mode") as String
                registerPushToken(pushToken, mode)
            }
            channelMethodEnablePushNotifications -> {
                enablePushNotifications(result)
            }
            channelMethodDisablePushNotifications -> {
                disablePushNotifications(result)
            }
            channelMethodSetDefaultFloatingButton -> {
                val active = call.argument<Boolean>("active") as Boolean
                setDefaultFloatingButton(active)
            }
            channelMethodSetDefaultFloatingButtonPosition -> {
                val leftMargin = call.argument<Int>("leftMargin") as Int
                val bottomMargin = call.argument<Int>("bottomMargin") as Int
                setFloatingButtonPosition(leftMargin, bottomMargin)
            }
            channelMethodSetChatboxConfiguration -> {
                val mainColor = call.argument<String?>("mainColor")
                val navigationBarBackgroundColor =
                    call.argument<String?>("navigationBarBackgroundColor")
                val navigationBarMainColor =
                    call.argument<String?>("navigationBarMainColor")
                val navigationBarTitle = call.argument<String?>("navigationBarTitle")
                val fontPath = call.argument<String?>("fontPath")
                val automaticMessage = call.argument<String?>("automaticMessage")
                val gdprMessage = call.argument<String?>("gdprMessage")
                val incomingMessageAvatarImage =
                    call.argument<ByteArray?>("incomingMessageAvatarImage")
                val incomingMessageAvatarURL =
                    call.argument<String?>("incomingMessageAvatarURL")

                setChatboxConfiguration(
                    mainColor,
                    navigationBarBackgroundColor,
                    navigationBarMainColor,
                    navigationBarTitle,
                    fontPath,
                    automaticMessage,
                    gdprMessage,
                    incomingMessageAvatarImage,
                    incomingMessageAvatarURL
                )
            }
            channelMethodRegisterTransaction -> {
                val transactionId = call.argument<String>("transactionId") as String
                val amount = call.argument<Double>("amount") as Double
                val currency = call.argument<String>("currency") as String
                val success = registerTransaction(transactionId, amount, currency)
                if (!success) result.error("BAD_ARGS", "Invalid currency", "")
            }
            channelMethodLogout -> logout()
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun activate(
        projectId: Int,
        userId: String?,
        gdprUrl: String?,
        result: Result
    ) {
        val authOption =
            if (userId.isNullOrBlank()) AuthenticationOption.Anonymous
            else AuthenticationOption.Simple(userId)
        val legalUrl =
            if (gdprUrl.isNullOrBlank()) null
            else tryOrNull { URI(gdprUrl) }
        val gdprOption = legalUrl?.let { GDPROption.Enabled(GDPREnabledOption.LegalUrl(it)) }
            ?: GDPROption.Disabled
        IAdvizeSDK.activate(
            projectId,
            authOption,
            gdprOption,
            object : Callback {
                override fun onSuccess() {
                    result.success(true)
                }

                override fun onFailure(t: Throwable) {
                    result.error("EX_FAILED", t.toString(), "")
                }
            }
        )
    }

    private fun setLogLevel(logLevel: Int) {
        IAdvizeSDK.logLevel = logLevelFrom(logLevel)
    }

    private fun logLevelFrom(value: Int): Logger.Level {
        return when (value) {
            0 -> Logger.Level.VERBOSE
            1 -> Logger.Level.INFO
            2 -> Logger.Level.WARNING
            3 -> Logger.Level.ERROR
            else -> Logger.Level.WARNING
        }
    }

    private fun setLanguage(language: String) {
        val lang = tryOrNull { Language.valueOf(language) } ?: Language.en
        IAdvizeSDK.targetingController.language = LanguageOption.Custom(lang)
    }

    private fun activateTargetingRule(uuid: String, channel: String) {
        val value = UUID.fromString(uuid)

        IAdvizeSDK.targetingController.activateTargetingRule(
            TargetingRule(
                value,
                channel.toConversationChannel()
            )
        )
    }

    private fun String.toConversationChannel(): ConversationChannel = when (this) {
        "chat" -> ConversationChannel.CHAT
        "video" -> ConversationChannel.VIDEO
        else -> ConversationChannel.CHAT
    }

    private fun ConversationChannel.toChannelString(): String = when (this) {
        ConversationChannel.CHAT -> "chat"
        ConversationChannel.VIDEO -> "video"
        else -> "chat"
    }

    private fun isActiveTargetingRuleAvailable(): Boolean {
        return IAdvizeSDK.targetingController.isActiveTargetingRuleAvailable()
    }

    private fun setOnActiveTargetingRuleAvailabilityListener() {
        IAdvizeSDK.targetingController.listeners.add(object : TargetingListener {
            override fun onActiveTargetingRuleAvailabilityUpdated(isActiveTargetingRuleAvailable: Boolean) {

                onActiveTargetingRuleAvailabilityUpdatedStreamHandler.onUpdated(
                    isActiveTargetingRuleAvailable
                )
            }
        })
    }

    private fun registerUserNavigation(navigationOption: String, uuid: String?, channel: String?) {
        IAdvizeSDK.targetingController.registerUserNavigation(navigationOption.toNavigationOption(uuid, channel))
    }

    private fun String.toNavigationOption(
        uuid: String?,
        channel: String?
    ): NavigationOption = when (this) {
        "clear" -> NavigationOption.ClearActiveRule
        "keep" -> NavigationOption.KeepActiveRule
        "new" -> NavigationOption.ActivateNewRule(
            TargetingRule(
                UUID.fromString(uuid),
                channel!!.toConversationChannel(),
            )
        )
        else -> NavigationOption.ClearActiveRule
    }

    private fun ongoingConversationId(): String? {
        return IAdvizeSDK.conversationController.ongoingConversation()?.conversationId
    }

    private fun ongoingConversationChannel(): String? {
        val channel = (IAdvizeSDK.conversationController.ongoingConversation()?.conversationChannel)
        return channel?.toChannelString()

    }

    private fun setConversationListener() {
        IAdvizeSDK.conversationController.listeners.add(object : ConversationListener {
            override fun onOngoingConversationUpdated(ongoingConversation: OngoingConversation?) {
                onOngoingConversationUpdatedStreamHandler.onUpdated(ongoingConversation != null)
            }

            override fun onNewMessageReceived(content: String) {
                onReceiveMessageStreamHandler.onMessage(content)
            }

            override fun handleClickedUrl(uri: Uri): Boolean {
                handleClickUrlStreamHandler.onUrlClicked(uri.toString())
                return true
            }
        })
    }

    private fun registerPushToken(pushToken: String, mode: String) {
        IAdvizeSDK.notificationController.registerPushToken(pushToken)
    }

    private fun enablePushNotifications(result: Result) {
        IAdvizeSDK.notificationController.enablePushNotifications(object : Callback {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onFailure(t: Throwable) {
                result.error("EX_FAILED", t.toString(), "")
            }
        })
    }

    private fun disablePushNotifications(result: Result) {
        IAdvizeSDK.notificationController.disablePushNotifications(object : Callback {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onFailure(t: Throwable) {
                result.error("EX_FAILED", t.toString(), "")
            }
        })
    }

    private fun setDefaultFloatingButton(active: Boolean) {
        IAdvizeSDK.defaultFloatingButtonController.setupDefaultFloatingButton(
            if (active)
                DefaultFloatingButtonOption.Enabled(defaultFloatingButtonConfiguration)
            else DefaultFloatingButtonOption.Disabled
        )
    }

    private fun setFloatingButtonPosition(leftMargin: Int, bottomMargin: Int) {
        val bgTint = defaultFloatingButtonConfiguration.backgroundTint
        defaultFloatingButtonConfiguration = DefaultFloatingButtonConfiguration(
            margins = DefaultFloatingButtonMargins(
                start = leftMargin,
                bottom = bottomMargin
            ),
            backgroundTint = bgTint,
        )
        setDefaultFloatingButton(true)
    }

    private fun setChatboxConfiguration(
        mainColor: String?,
        navigationBarBackgroundColor: String?,
        navigationBarMainColor: String?,
        navigationBarTitle: String?,
        fontPath: String?,
        automaticMessage: String?,
        gdprMessage: String?,
        incomingMessageAvatarImage: ByteArray?,
        incomingMessageAvatarURL: String?
    ) {
        val configuration = ChatboxConfiguration()
        if (mainColor != null) {
            (Color.parseColor(mainColor) as? Int)?.let { color ->
                configuration.mainColor = color
                //set floating button color
                val margins = defaultFloatingButtonConfiguration.margins
                defaultFloatingButtonConfiguration = DefaultFloatingButtonConfiguration(
                    margins = margins,
                    backgroundTint = color,
                )
                setDefaultFloatingButton(true)
            }
        }
        if (navigationBarBackgroundColor != null) {
            (Color.parseColor(navigationBarBackgroundColor) as? Int)?.let { color ->
                configuration.toolbarBackgroundColor = color
            }
        }
        if (navigationBarMainColor != null) {
            (Color.parseColor(navigationBarMainColor) as? Int)?.let { color ->
                configuration.toolbarMainColor = color
            }
        }
        if (navigationBarTitle != null) {
            configuration.toolbarTitle = navigationBarTitle
        }
        if (fontPath != null) {
            configuration.fontPath = fontPath
        }
        if (automaticMessage != null) {
            configuration.automaticMessage = automaticMessage
        }
        if (gdprMessage != null) {
            configuration.gdprMessage = gdprMessage
        }
        if (incomingMessageAvatarImage != null) {
            val arrayInputStream = ByteArrayInputStream(incomingMessageAvatarImage)
            val bitmap = BitmapFactory.decodeStream(arrayInputStream)
            val bd = BitmapDrawable(Resources.getSystem(), bitmap)
            val d = bd.current
            configuration.incomingMessageAvatar = IncomingMessageAvatar.Image(d)
        }
        if (incomingMessageAvatarURL != null) {
            val url = URL(incomingMessageAvatarURL)
            configuration.incomingMessageAvatar = IncomingMessageAvatar.Url(url)
        }
        IAdvizeSDK.chatboxController.setupChatbox(configuration)

    }

    private fun registerTransaction(
        transactionId: String,
        amount: Double,
        currencyName: String
    ): Boolean {
        val currency = tryOrNull { Currency.valueOf(currencyName ?: "") } ?: return false
        Log.d(TAG, currencyName ?: "")
        Log.d(TAG, currency.toString())
        IAdvizeSDK.transactionController.register(
            Transaction(
                transactionId ?: "",
                Date(),
                amount ?: 0.0,
                currency
            )
        )
        return true

    }

    private fun logout() {
        IAdvizeSDK.logout()
    }

}
