//
//  ViewBuilderManager.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 01.06.23.
//

import SwiftUI

protocol ViewBuilderManagerProtocol {
    func buildEntryView() -> EntryView
    func buildLoginView(entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>) -> LoginView
    func buildSignUpView(entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>, isSignUpViewOpen: Binding<Bool>) -> SignUpView
    func buildTabBarView(isUserLogin: Binding<Bool>) -> TabBarView
}

final class ViewBuilderManager: ObservableObject {
    
    //MARK: - Private Properties
    
    private let dataManager: CoreDataManagerProtocol
    
    private lazy var userDataManager = UserDataManager(manager: dataManager)
    private lazy var catalogDataManager = CatalogDataManager(manager: dataManager)
    private lazy var placeDataManager = PlaceDataManager(manager: dataManager)
    
    private lazy var catalogNetworkManager = CatalogNetworkManager()
    private lazy var placeNetworkManager = PlaceNetworkManager()
    
    //MARK: - Inits
    
    init() {
        self.dataManager = CoreDataManager()
    }
}

extension ViewBuilderManager: ViewBuilderManagerProtocol {
    
    //MARK: - Functions
    
    func buildEntryView() -> EntryView {
        let viewModel = EntryViewModel(userDataManager: self.userDataManager)
        return EntryView(viewModel: viewModel)
    }
    
    func buildLoginView(entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>) -> LoginView {
        let viewModel = LoginViewModel(entryRouter: entryRouter, isUserLogin: isUserLogin, userDataManager: self.userDataManager)
        return LoginView(viewModel: viewModel)
    }
    
    func buildSignUpView(entryRouter: Binding<EntryViewRouter>, isUserLogin: Binding<Bool>, isSignUpViewOpen: Binding<Bool>) -> SignUpView {
        let viewModel = SignUpViewModel(networkManager: AuthNetworkManager(), authManager: AuthManager(), userDataManager: self.userDataManager, entryRouter: entryRouter, isUserLogin: isUserLogin, isSignUpViewOpen: isSignUpViewOpen)
        return SignUpView(viewModel: viewModel)
    }
    
    func buildTabBarView(isUserLogin: Binding<Bool>) -> TabBarView {
        let viewModel = TabBarViewModel(isUserLogin: isUserLogin, dataManager: self.dataManager)
        return TabBarView(viewModel: viewModel)
    }
    
    func buildCatalogView(safeArea: EdgeInsets, size: CGSize) -> CatalogView {
        let viewModel = CatalogViewModel(networkManager: catalogNetworkManager, dataManager: catalogDataManager, safeArea: safeArea, size: size)
        return CatalogView(viewModel: viewModel)
    }
    
    func buildCountryView(country: Country, safeArea: EdgeInsets, size: CGSize) -> CountryView {
        let viewModel = CountryViewModel(country: country, networkManager: catalogNetworkManager, dataManager: catalogDataManager)
        return CountryView(viewModel: viewModel, safeArea: safeArea, size: size)
    }
    
    func buildCityView(city: City, safeArea: EdgeInsets, size: CGSize) -> CityView {
        let viewModel = CityViewModel(city: city, networkManager: catalogNetworkManager, dataManager: catalogDataManager)
        return CityView(viewModel: viewModel, safeArea: safeArea, size: size)
    }
    
    func buildPlaceView(place: Place, safeArea: EdgeInsets, size: CGSize) -> PlaceView {
        let viewModel = PlaceViewModel(place: place, networkManager: placeNetworkManager, dataManager: placeDataManager)
        return PlaceView(viewModel: viewModel, safeArea: safeArea, size: size)
    }
}
