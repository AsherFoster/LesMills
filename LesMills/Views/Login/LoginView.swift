//
//  LoginView.swift
//  LesMills
//
//  Created by Asher Foster on 12/10/23.
//

import SwiftUI

struct LoginView: View {
    
    
    var body: some View {
        NavigationStack {
            VStack() {
                Spacer()
                LoginForm()
                    .background(.regularMaterial)
            }
            .background(
                Image("TackyWorkoutPerson")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    LoginView()
}
