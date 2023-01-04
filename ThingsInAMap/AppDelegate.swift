//
//  AppDelegate.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import Foundation
import GoogleMaps
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
        return true
    }
}
