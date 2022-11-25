import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backHandleButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    fileprivate let lm = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        lm.requestAccess { [weak self] isSuccess in
            if isSuccess {
                self?.lm.getLocation { [weak self] loc in
                    guard let location = loc else { return }
                    self?.zoomArea(location)
                }
            }
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(setDeliverMarker))
        gestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func zoomArea(_ location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func setDeliverMarker(gestureRecognizer: UITapGestureRecognizer) {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        let location = gestureRecognizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.title = "Deliver here"
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
}
