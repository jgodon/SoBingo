//
//  AppDelegate.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import NeoCoordinator
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var appCoordinator: Coordinator!
  let builder = MainBuilder()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    
    window = UIWindow()
    let navigationController = UINavigationController()
    window?.rootViewController = navigationController
    appCoordinator = AppCoordinator(navigationController: navigationController, parentCoordinator: nil, context: Context(value: (builder)))
    try! appCoordinator.start(withCallback: nil)
    window?.makeKeyAndVisible()
    
    return true
  }
}
