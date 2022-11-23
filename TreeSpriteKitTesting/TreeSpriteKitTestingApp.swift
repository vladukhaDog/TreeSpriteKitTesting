//
//  TreeSpriteKitTestingApp.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import SwiftUI

@main
struct TreeSpriteKitTestingApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "tree.circle")
                        Text("Tree")
                    }
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                MyTreesView()
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("My Trees")
                    }
            }
        }
    }
}
