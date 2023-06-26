//
//  UserView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

struct UserView: View {
    
    let vm: UserViewModel
    @Binding var isUserLogin: Bool
    
    var body: some View {
        if isUserLogin {
            Button {
                vm.logOutButtonTapped()
                isUserLogin = false
            } label: {
                Text("Log Out")
            }

        } else {
            Color.red
        }
    }
}

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView(vm: UserViewModel(isUserLogin: .constant(false)))
//    }
//}
