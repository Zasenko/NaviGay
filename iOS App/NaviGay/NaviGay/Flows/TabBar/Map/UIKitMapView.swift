//
//  UIKitMapView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 16.06.23.
//

import SwiftUI
import MapKit

struct UIKitMapView: UIViewRepresentable {
    
    @ObservedObject var mapViewModel: MapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        return mapViewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        mapViewModel.updateAnnotations()
    }
}
