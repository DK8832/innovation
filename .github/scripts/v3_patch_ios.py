from pathlib import Path

p = Path('앱/ios/Runner/AppDelegate.swift')
p.write_text('''import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
''', encoding='utf-8')
print('Flutter 3.35 compatible iOS AppDelegate applied')
