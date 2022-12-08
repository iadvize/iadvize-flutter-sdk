package com.iadvize.iadvize_flutter_sdk

import android.os.Handler
import io.flutter.plugin.common.EventChannel
import java.util.*

class HandleClickUrlStreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null

    fun onUrlClicked(value: String) {
        sink?.success(value)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}