import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window.secureApp()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


extension UIWindow{
  func secureApp(){
    let field=UITextField(
      field.isSecureTextEntry=true
      self.addSubView(field)
      field.centerYAnchor.constraint(equalTo:self.centerYAnchor.isActive=true)
      field.centerXAnchor.constraint(equalTo:self.centerXAnchor.isActive=true)
      self.layer.superLayer?.addSublayer(field.layer)
      field.layer.sublayers?.first?.addSublayer(self.layer)
    )
  }
} 