//
//  EventAnnotation.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 20.06.23.
//

import MapKit
import CoreData

final class EventAnnotation: NSObject, MKAnnotation, Identifiable {
    public let identifier = "EventAnnotation"
        
    let objectID: NSManagedObjectID
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let type: String
    var img: UIImage? = UIImage(systemName: "heart.fill")
    
    init(event: Event) {
        self.objectID = event.objectID
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(event.latitude),
                                                 longitude: CLLocationDegrees(event.longitude))
        self.title = event.name
        self.subtitle = event.type
        self.type = event.type ?? ""
    }
}

class MapPinView: MKAnnotationView {
    
    public let identifier = "MapPinView"
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
        view.layer.cornerRadius = 16.0
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "bg")
        imageview.layer.cornerRadius = 8.0
        imageview.clipsToBounds = true
        return imageview
    }()
    
    private lazy var bottomCornerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    // MARK: Initialization
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        containerView.addSubview(bottomCornerView)
        bottomCornerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15.0).isActive = true
        bottomCornerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bottomCornerView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bottomCornerView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let angle = (39.0 * CGFloat.pi) / 180
        let transform = CGAffineTransform(rotationAngle: angle)
        bottomCornerView.transform = transform
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0).isActive = true
    }
}
