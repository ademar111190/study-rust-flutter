import Flutter
import UIKit

public class SwiftStudyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "study", binaryMessenger: registrar.messenger())
    let instance = SwiftStudyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func dummyMethodToEnforceBundling() {
    let dummy = dummy_method_to_enforce_bundling();
    print(dummy)
  }
}
