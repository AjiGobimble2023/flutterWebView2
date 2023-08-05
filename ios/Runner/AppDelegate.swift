import UIKit
import Flutter
import FlutterPluginRegistrant // tambahkan baris ini

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // tambahkan kode berikut
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    SwiftFlutterInappwebviewPlugin.register(with: self.registrar(forPlugin: "com.pichillilorenzo/flutter_inappwebview")!)
    // akhir kode yang ditambahkan
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}