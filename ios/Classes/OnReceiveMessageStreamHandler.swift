import Foundation
import Flutter

class OnReceiveMessageStreamHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    @objc func onMessage(message: String) {
        guard let sink = sink else { return }
        sink(message)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}