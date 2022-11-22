package com.idavize.flutter_iadvize_sdk

import androidx.annotation.NonNull

import android.app.Application;
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.iadvize.conversation.sdk.IAdvizeSDK
import com.iadvize.conversation.sdk.IAdvizeSDK.Callback
import com.iadvize.conversation.sdk.feature.authentication.AuthenticationOption
import com.iadvize.conversation.sdk.feature.gdpr.GDPREnabledOption
import com.iadvize.conversation.sdk.feature.gdpr.GDPROption
import com.iadvize.conversation.sdk.feature.logger.Logger
import com.iadvize.conversation.sdk.feature.targeting.LanguageOption
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
    private var channelMethodActivate = "activate"
    private var channelMethodSetLogLevel = "setLogLevel"
    private var channelMethodSetLanguage = "setLanguage"
    private var channelMethodActivateTargetingRule = "activateTargetingRule"
    private var channelMethodIsActiveTargetingRuleAvailable = "isActiveTargetingRuleAvailable"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(
            flutterPluginBinding.getApplicationContext()
        )
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_iadvize_sdk")
        channel.setMethodCallHandler(this)

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
              isActiveTargetingRuleAvailable(result)
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

    private fun isActiveTargetingRuleAvailable(@NonNull result: Result) {
      result.success(IAdvizeSDK.targetingController.isActiveTargetingRuleAvailable())
    }
    
}
