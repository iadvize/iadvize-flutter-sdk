import Foundation
import Flutter

class OnUpdatedStreamHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    @objc func onUpdated(value: Bool) {
        guard let sink = sink else { return }
        sink(value)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}