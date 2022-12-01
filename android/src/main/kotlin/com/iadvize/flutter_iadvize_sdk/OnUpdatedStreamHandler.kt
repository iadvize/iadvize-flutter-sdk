package com.iadvize.flutter_iadvize_sdk

import android.os.Handler
import io.flutter.plugin.common.EventChannel
import java.util.*

class OnUpdatedStreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null

    fun onUpdated(value: Boolean) {
        sink?.success(value)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}