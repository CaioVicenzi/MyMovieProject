//
//  SuccessfullyResetView.swift
//  MyMovieProject
//
//  Created by Caio Marques on 30/11/24.
//

import SwiftUI

struct SuccessfullyResetView: View {
    @State var goLogin : Bool = false
    
    var body: some View {
        VStack {
            Text("Email successfully sent.")
            Text("Check your email.")
            Button("OK") {
                goLogin = true
            }
        }
        .fullScreenCover(isPresented: $goLogin) {
            LoginView()
        }
        
    }
}

#Preview {
    SuccessfullyResetView()
}
