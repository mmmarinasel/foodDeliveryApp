import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressView: AddressView!
    @IBAction func backHandleButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    fileprivate let lm = LocationManager.shared
    
    var delegate: CartViewDelegate?
    
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
        setUpAddressView(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
    }
    
    func setUpAddressView(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.addressView.isHidden = false
        self.addressView.layer.cornerRadius = 12
        getAddressFromLatLon(latitude: latitude, longitude: longitude) { [weak self] address in
            self?.addressView.addressLabel.text = address
        }
        self.addressView.confirmButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
    }
    
    @objc func handleTap(sender: UIButton!) {
        self.delegate?.updateAddress(address: self.addressView.addressLabel.text)
//        CartViewController.address = self.addressView.addressLabel.text
        self.dismiss(animated: true)
    }
    
    func getAddressFromLatLon(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String) -> Void) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            if error != nil {
                print("reverse geodcode fail")
            }
            let pm = (placemarks ?? [CLPlacemark]()) as [CLPlacemark]
            
            if !pm.isEmpty {
                let pm = placemarks?[0]
                var addressString: String = ""
                if pm?.subLocality != nil {
                    addressString += (pm?.subLocality ?? "") + ", "
                }
                if pm?.thoroughfare != nil {
                    addressString += (pm?.thoroughfare ?? "") + ", "
                }
                if pm?.locality != nil {
                    addressString += (pm?.locality ?? "") + ", "
                }
                if pm?.country != nil {
                    addressString += (pm?.country ?? "")
                }
                completion(addressString)
            }
        }
    }
}
