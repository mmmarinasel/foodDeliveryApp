import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared  = LocationManager()
    
    typealias AccessRequestBlock = (Bool) -> Void
    typealias LocationRequestBlock  = (CLLocationCoordinate2D?) -> Void
    
    var isEnabled: Bool { return CLLocationManager.isEnabled }
    var canRequestAccess: Bool { return CLLocationManager.canRequestService }
    
    private var accessRequestCompletion: AccessRequestBlock?
    private var locationRequestCompletion: LocationRequestBlock?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAccess(completion: AccessRequestBlock?) {
        self.accessRequestCompletion = completion
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: LocationRequestBlock?) {
        self.locationRequestCompletion = completion
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.accessRequestCompletion?(isEnabled)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.locationRequestCompletion?(location)
        self.locationRequestCompletion = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        self.locationRequestCompletion?(nil)
        self.locationRequestCompletion = nil
    }
}

extension CLLocationManager {
    static var canRequestService: Bool {
        let manager = CLLocationManager()
        return manager.authorizationStatus != .restricted && manager.authorizationStatus != .denied
    }
    
    static var isEnabled: Bool {
        let manager = CLLocationManager()
        return manager.authorizationStatus != .authorizedAlways || manager.authorizationStatus != .authorizedWhenInUse
    }
}
