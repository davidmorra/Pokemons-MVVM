//
//  AppDelegate.swift
//  Garage
//
//  Created by Davit on 15.05.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: Coordinator?
    let appDiContainer: AppDiContainer = {
        return AppDiContainer()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(appDIContainer: appDiContainer, navigationController: navigationController)
        
        window?.rootViewController = navigationController
        
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }

}
