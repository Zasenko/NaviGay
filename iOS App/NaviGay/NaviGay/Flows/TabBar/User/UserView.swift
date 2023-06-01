//
//  UserView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

struct UserView: View {
    
    let vm: UserViewModel
    
    var body: some View {
        if vm.isUserLogin {
            Color.green
        } else {
            Color.red
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(vm: UserViewModel(isUserLogin: .constant(false)))
    }
}
