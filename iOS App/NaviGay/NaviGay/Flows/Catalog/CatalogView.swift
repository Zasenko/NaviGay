//
//  CatalogView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 04.05.23.
//

import SwiftUI

struct CatalogView: View {
    
    //MARK: - Proreties
    
    @StateObject var viewModel: CatalogViewModel
    @State private var searchText = ""
    
    //MARK: - Body
    
    var body: some View {
        NavigationStack {
            switch viewModel.loadState {
            case .normal, .success:
                listWithCountries
            case .loading:
                ProgressView()
            case .failure:
                // TODO - сделать окошко с ошибкой и повторить
                // сейчас ошибка вообще не отображается
                Text("что-то пошло не так")
            }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder private var listWithCountries: some View {
        List {
            Section {
                ForEach($viewModel.activeCountries) { country in
                    NavigationLink {
                        viewModel.cteateCountryView(country: country.wrappedValue)
                            .ignoresSafeArea(.container, edges: .top)
                    } label: {
                        CountryCell(country: country)
                    }
                }
                .listRowBackground(AppColors.background)
            }
        }
        //УБРАТЬ!!!!!
        .searchable(text: $searchText, prompt: "Look for something")
        //----------------
        .listStyle(.plain)
        .toolbarBackground(AppColors.background, for: .navigationBar)
    }
}

//struct CatalogView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatalogView()
//    }
//}
