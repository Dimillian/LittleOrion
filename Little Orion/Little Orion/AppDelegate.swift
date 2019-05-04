//
//  AppDelegate.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit
import ReSwift

let store = Store<AppState>(reducer: AppReducer,
                         state: nil,
                         middleware: [logMiddleware])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }



}

