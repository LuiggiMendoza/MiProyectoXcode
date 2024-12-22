//
//  UbicacionViewController.swift
//  LibRaulito
//
//  Created by DAMII on 5/12/24.
//

import UIKit
import MapKit
import CoreLocation

class UbicacionViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapaMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Establecer una ubicación inicial
                let initialLocation = CLLocation(latitude: -8.078899848565204, longitude: -79.05573445426016) // San Francisco, CA
                centerMapOnLocation(location: initialLocation)
        
        let annotation = MKPointAnnotation()
            annotation.coordinate = initialLocation.coordinate
            annotation.title = "Libreria Raulito"
            annotation.subtitle = "La Esperanza"
            mapaMapView.addAnnotation(annotation)
    }
    
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000) {
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            mapaMapView.setRegion(coordinateRegion, animated: true)
        }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
