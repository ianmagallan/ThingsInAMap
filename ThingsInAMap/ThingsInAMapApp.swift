//
//  ThingsInAMapApp.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 29.12.22.
//

import SwiftUI

@main
struct ThingsInAMapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
