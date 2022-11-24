package com.idavize.flutter_iadvize_sdk

import androidx.annotation.NonNull

import android.app.Application;
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.iadvize.conversation.sdk.IAdvizeSDK
import com.iadvize.conversation.sdk.IAdvizeSDK.Callback
import com.iadvize.conversation.sdk.feature.authentication.AuthenticationOption
import com.iadvize.conversation.sdk.feature.conversation.ConversationListener
import com.iadvize.conversation.sdk.feature.conversation.OngoingConversation
import com.iadvize.conversation.sdk.feature.gdpr.GDPREnabledOption
import com.iadvize.conversation.sdk.feature.gdpr.GDPROption
import com.iadvize.conversation.sdk.feature.logger.Logger
import com.iadvize.conversation.sdk.feature.targeting.LanguageOption
import com.iadvize.conversation.sdk.feature.targeting.TargetingListener
import com.iadvize.conversation.sdk.type.Language
import com.iadvize.conversation.sdk.feature.conversation.ConversationChannel
import com.iadvize.conversation.sdk.feature.targeting.TargetingRule
import android.net.Uri
import java.net.URL
import java.net.URI
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
    private const val channelMethodIsActiveTargetingRuleAvailable = "isActiveTargetingRuleAvailable"
    private const val channelMethodSetConversationListener = "setConversationListener"
    private const val channelMethodSetTargetingRuleAvailabilityListener = "setOnActiveTargetingRuleAvailabilityListener"
    private const val channelMethodOngoingConversationId = "ongoingConversationId"
    private const val channelMethodOngoingConversationChannel = "ongoingConversationChannel"
    private const val channelMethodRegisterPushToken = "registerPushToken"
    private const val channelMethodEnablePushNotifications = "enablePushNotifications"
    private const val channelMethodDisablePushNotifications = "disablePushNotifications"
    private const val TAG: String = "iAdvize SDK"
    }
    

    private lateinit var channel: MethodChannel
    private lateinit var onReceiveMessageStreamHandler: OnReceiveMessageStreamHandler
    private lateinit var handleClickUrlStreamHandler: HandleClickUrlStreamHandler
    private lateinit var onOngoingConversationUpdatedStreamHandler: OnUpdatedStreamHandler
    private lateinit var onActiveTargetingRuleAvailabilityUpdatedStreamHandler: OnUpdatedStreamHandler

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(
            flutterPluginBinding.getApplicationContext()
        )
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, chanelMethodName)
        channel.setMethodCallHandler(this)
        
        onReceiveMessageStreamHandler = OnReceiveMessageStreamHandler()
        EventChannel(flutterPluginBinding.binaryMessenger, "$chanelMethodName/onReceiveMessage").setStreamHandler(onReceiveMessageStreamHandler)
        handleClickUrlStreamHandler = HandleClickUrlStreamHandler()
        EventChannel(flutterPluginBinding.binaryMessenger, "$chanelMethodName/handleClickUrl").setStreamHandler(handleClickUrlStreamHandler)
        onOngoingConversationUpdatedStreamHandler = OnUpdatedStreamHandler()
        EventChannel(flutterPluginBinding.binaryMessenger, "$chanelMethodName/onOngoingConversationUpdated").setStreamHandler(onOngoingConversationUpdatedStreamHandler)
        onActiveTargetingRuleAvailabilityUpdatedStreamHandler = OnUpdatedStreamHandler()
        EventChannel(flutterPluginBinding.binaryMessenger, "$chanelMethodName/onActiveTargetingRuleAvailabilityUpdated").setStreamHandler(onActiveTargetingRuleAvailabilityUpdatedStreamHandler)
    }

    private fun onAttachedToEngine(applicationContext: Context) {
        IAdvizeSDK.initiate((applicationContext as Application))
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
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
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun activate(
        @NonNull projectId: Int,
        userId: String?,
        gdprUrl: String?,
        @NonNull result: Result
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
                    result.error(TAG, t.toString(), "")
                }
            }
        )
    }

    private fun setLogLevel(logLevel: Int) {
        IAdvizeSDK.logLevel = logLevelFrom(logLevel)
    }

    private fun logLevelFrom(value: Int): Logger.Level {
        when (value) {
            0 -> return Logger.Level.VERBOSE
            1 -> return Logger.Level.INFO
            2 -> return Logger.Level.WARNING
            3 -> return Logger.Level.ERROR
            else -> return Logger.Level.WARNING
        }
    }

    private fun setLanguage(language: String) {
        var lang = tryOrNull { Language.valueOf(language) } ?: Language.en
        IAdvizeSDK.targetingController.language = LanguageOption.Custom(lang)
    }

    private fun activateTargetingRule(uuid: String, channel: String) {
        var value = UUID.fromString(uuid)

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
                
                onActiveTargetingRuleAvailabilityUpdatedStreamHandler.onUpdated(isActiveTargetingRuleAvailable)
            }
        })
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

            override fun onNewMessageReceived(message: String) {
                onReceiveMessageStreamHandler.onMessage(message)
            }

            override fun handleClickedUrl(uri: Uri): Boolean {
                handleClickUrlStreamHandler.onUrlClicked(uri.toString())
                return true
            }
        })
    }

    private fun registerPushToken(pushToken: String, mode: String) {
            Log.d(TAG, "set pushToken " + pushToken)
            IAdvizeSDK.notificationController.registerPushToken(pushToken)
    }

    private fun enablePushNotifications(@NonNull result: Result) {
            IAdvizeSDK.notificationController.enablePushNotifications(object : Callback {
                override fun onSuccess() {
                   result.success(true)
                }

                override fun onFailure(t: Throwable) {
                    result.error(TAG, t.toString(), "")
                }
            })
    }

    private fun disablePushNotifications(@NonNull result: Result) {
        IAdvizeSDK.notificationController.disablePushNotifications(object : Callback {
            override fun onSuccess() {
               result.success(true)
            }

            override fun onFailure(t: Throwable) {
                result.error(TAG, t.toString(), "")
            }
        })
}

}
