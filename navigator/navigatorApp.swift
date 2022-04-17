//
//  navigatorApp.swift
//  navigator
//
//  Created by Roberto Almeida on 17/04/22.
//

import SwiftUI

@main
struct navigatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
