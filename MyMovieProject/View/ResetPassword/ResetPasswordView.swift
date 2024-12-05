//
//  ResetPasswordView.swift
//  MyMovieProject
//
//  Created by Caio Marques on 29/11/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var vm = ResetPasswordViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Write down your email:")
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                vm.resetPassword()
            } label: {
                Text("Reset password")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Reset Password")
        .fullScreenCover(isPresented: $vm.goSuccessfullyResetView) {
            SuccessfullyResetView()
        }
    }
}

#Preview {
    NavigationView{
        ResetPasswordView()
    }
}
