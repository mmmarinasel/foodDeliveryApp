import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBAction func backHandleButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }
}
