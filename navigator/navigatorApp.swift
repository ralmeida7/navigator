//
//  navigatorApp.swift
//  navigator
//
//  Created by Roberto Almeida on 17/04/22.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct navigatorApp: App {    
    
    
    init() {
        configureAmplify()
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            let models = AmplifyModels()
//            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
//            try Amplify.add(plugin: AWSS3StoragePlugin())
//            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Failed to initialize Amplify", error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
