import Foundation
import Flutter

class HandleClickUrlStreamHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    @objc func onUrlClicked(url: String) {
        guard let sink = sink else { return }
        sink(url)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}