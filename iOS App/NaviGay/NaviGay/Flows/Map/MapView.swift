//
//  MapView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 18.05.23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct PlaceT: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let description: String
}
