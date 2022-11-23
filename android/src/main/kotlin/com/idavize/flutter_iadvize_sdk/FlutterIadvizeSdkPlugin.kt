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

const val TAG: String = "iAdvize SDK"


inline fun <T> tryOrNull(f: () -> T) =
    try {
        f()
    } catch (_: Exception) {
        null
    }


/** FlutterIadvizeSdkPlugin */
class FlutterIadvizeSdkPlugin : FlutterPlugin, MethodCallHandler {
    private var chanelMethodName = "flutter_iadvize_sdk"
    private var channelMethodActivate = "activate"
    private var channelMethodSetLogLevel = "setLogLevel"
    private var channelMethodSetLanguage = "setLanguage"
    private var channelMethodActivateTargetingRule = "activateTargetingRule"
    private var channelMethodIsActiveTargetingRuleAvailable = "isActiveTargetingRuleAvailable"
    private var channelMethodSetConversationListener = "setConversationListener"
    private var channelMethodSetTargetingRuleAvailabilityListener = "setOnActiveTargetingRuleAvailabilityListener"
    private var channelMethodOngoingConversationId = "ongoingConversationId"
    private var channelMethodOngoingConversationChannel = "ongoingConversationChannel"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
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
        Log.d("$TAG", "initiate called")
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
                    result.success(false)
                }
            }
        )
    }

    private fun setLogLevel(logLevel: Int) {
        Log.d(TAG, "setLogLevel to ${logLevel.toString()}")
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
        Log.d(TAG, "setLanguage to $language")
        var lang = tryOrNull { Language.valueOf(language) } ?: Language.en
        IAdvizeSDK.targetingController.language = LanguageOption.Custom(lang)
    }

    private fun activateTargetingRule(uuid: String, channel: String) {
        var value = UUID.fromString(uuid)
        Log.d(TAG, "activate targeting rule ${value.toString()}")

        IAdvizeSDK.targetingController.activateTargetingRule(
            TargetingRule(
                value,
                conversationChannelFrom(channel)
            )
        )
    }

    private fun conversationChannelFrom(value: String): ConversationChannel = when (value) {
        "chat" -> ConversationChannel.CHAT
        "video" -> ConversationChannel.VIDEO
        else -> ConversationChannel.CHAT
    }

    private fun conversationChannelToString(value: ConversationChannel): String = when (value) {
        ConversationChannel.CHAT -> "chat"
        ConversationChannel.VIDEO -> "video"
        else -> "chat"
    }

    private fun isActiveTargetingRuleAvailable(): Boolean {
        return IAdvizeSDK.targetingController.isActiveTargetingRuleAvailable()
    }

    private fun setOnActiveTargetingRuleAvailabilityListener() {
        Log.d(TAG, "setConversationListener")
        IAdvizeSDK.targetingController.listeners.add(object : TargetingListener {
            override fun onActiveTargetingRuleAvailabilityUpdated(isActiveTargetingRuleAvailable: Boolean) {
                Log.d(TAG, "onActiveTargetingRuleAvailabilityUpdated $isActiveTargetingRuleAvailable")
                onActiveTargetingRuleAvailabilityUpdatedStreamHandler.onUpdated(isActiveTargetingRuleAvailable)
            }
        })
    }

    private fun ongoingConversationId(): String? {
        Log.d(TAG, "ongoingConversationId called")
        return IAdvizeSDK.conversationController.ongoingConversation()?.conversationId
    }

    private fun ongoingConversationChannel(): String? {
        Log.d(TAG, "ongoingConversationChannel called")
        val channel = (IAdvizeSDK.conversationController.ongoingConversation()?.conversationChannel)
        return if(channel != null) conversationChannelToString(channel) else null
        
    }

    private fun setConversationListener() {
        Log.d(TAG, "setConversationListener")
        IAdvizeSDK.conversationController.listeners.add(object : ConversationListener {
            override fun onOngoingConversationUpdated(ongoingConversation: OngoingConversation?) {
                Log.d(TAG, "onOngoingConversationUpdated ${ongoingConversation != null}")
                onOngoingConversationUpdatedStreamHandler.onUpdated(ongoingConversation != null)
            }

            override fun onNewMessageReceived(message: String) {
                Log.d(TAG, "onNewMessageReceived $message")
                onReceiveMessageStreamHandler.onMessage(message)
            }

            override fun handleClickedUrl(uri: Uri): Boolean {
                Log.d(TAG, "handleClickedUrl $uri")
                handleClickUrlStreamHandler.onUrlClicked(uri.toString())
                return true
            }
        })
    }

   

}
