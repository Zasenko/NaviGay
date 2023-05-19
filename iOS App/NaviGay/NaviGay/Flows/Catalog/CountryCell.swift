//
//  CountryCell.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import SwiftUI

struct CountryCell: View {
    
    //MARK: - Properties
    
    @Binding var country: Country
    
    //MARK: - Body
    
    var body: some View {
        HStack(alignment: .top) {
            Text(country.flag ?? "🏳️‍🌈")
                .font(.title)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(country.name ?? "")
                    .font(.title)
                    .padding(.bottom, 4)
                Text(country.smallDescriprion ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.bottom)
    }
}


//"struct CountryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CountryCell()
//    }
//}"
