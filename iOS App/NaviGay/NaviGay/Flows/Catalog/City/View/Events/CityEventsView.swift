//
//  CityEventsView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 24.05.23.
//

import SwiftUI

struct CityEventsView: View {
    
    //MARK: - Proreties
    
    @State private var events: [Event]
    let size: CGSize
    
    init(events: [Event], size: CGSize) {
        self.events = events
        self.size = size
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(events) { event in
                        CityEventView(viewModel: CityEventViewModel(event: event), size: size)
                    }
                }
            }
            .frame(width: size.width)
            .frame(height: 500)
        }
        //TODO
    }
}

//struct CityEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CityEventsView()
//    }
//}
