//
//  EmeraldJewelsApp.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 08/10/24.
//

import SwiftUI
import Firebase

@main
struct EmeraldJewelsApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                EJHomeView()
            } else {
                EJSignIn()
            }
        }
    }
}
