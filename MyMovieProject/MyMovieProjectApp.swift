//
//  MyMovieProjectApp.swift
//  MyMovieProject
//
//  Created by Caio Marques on 27/11/24.
//

import SwiftUI

@main
struct MyMovieProjectApp: App {
    @AppStorage("alreadyLog") var alreadyLog : Bool = false
    
    var body: some Scene {
        WindowGroup {
            if alreadyLog {
                HomeView()
            } else {
                OnboardingView()
            }
        }
    }
}
