//
//  ClusterAnnotationView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 22.06.23.
//

import Foundation
import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20 // Пример радиуса закругления
        return imageView
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imageView)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            // Настройка кластерного представления
            displayPriority = .required
            collisionMode = .circle
            
            canShowCallout = true
            imageView.image = AppImages.mapCultureIcon!
        }
    }
}
