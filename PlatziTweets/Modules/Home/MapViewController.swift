//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 14/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - IBOulets
    @IBOutlet weak var mapContainer: UIView!
    
    
     var posts = [Post]()
    
    private var map: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // always use this life of cycle when the UI is done with code
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMap()
    }
    
    
    private func setupMap(){
        map = MKMapView(frame: mapContainer.bounds)
        
        mapContainer.addSubview(map ?? UIView())
        
        setupMakers()
    }
    
    private func setupMakers(){
        posts.forEach { item in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            
            marker.title = item.text
            marker.subtitle = item.author.names
            
            map?.addAnnotation(marker)
        }
        
        guard let lastPost = posts.last else {
            return
        }
        
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude, longitude: lastPost.location.longitude)
        
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
    }

}
