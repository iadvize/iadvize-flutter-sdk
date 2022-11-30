package com.idavize.flutter_iadvize_sdk

import android.os.Handler
import io.flutter.plugin.common.EventChannel
import java.util.*

class OnReceiveMessageStreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null

    fun onMessage(message: String) {
        sink?.success(message)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}