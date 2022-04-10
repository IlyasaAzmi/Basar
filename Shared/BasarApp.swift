//
//  BasarApp.swift
//  Shared
//
//  Created by CAKAP on 09/04/22.
//

import SwiftUI
import Firebase

@main
struct BasarApp: App {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    
    init() {
        FirebaseApp.configure()
        
        // Anonymous authentication with Firebase
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("FAILED: Anonymous Authenctication with Firebase")
                return
            }
            
            let uid = user.uid
            print("Firebase: Anonymous user authentication with uid: \(uid).")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
        }
    }
}
