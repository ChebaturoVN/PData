//
//  AppDelegate.swift
//  PData
//
//  Created by VladimirCH on 28.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        var viewModel: MainViewModel = MainViewModelImpl()
        let vc = MainViewController(viewModel: viewModel)
        viewModel.view = vc

        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }

}

