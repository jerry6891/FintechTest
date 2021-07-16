//
//  MapDetail.swift
//  FintecimalTest
//
//  Created by Jerry Lozano on 5/11/21.
//

import UIKit
import MapKit

class MapDetail: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapScreen: MKMapView!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    
    var getLatitude = Double()
    var getLongitude = Double()
    var getStreetName = String()
    var getSuburbPlace = String()
    
    private let locationManager = CLLocationManager()
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: getLatitude, longitude: getLongitude)
        mapScreen.centerToLocation(initialLocation)
        
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius,
          longitudinalMeters: regionRadius)
        mapScreen.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region),animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapScreen.setCameraZoomRange(zoomRange, animated: true)
        
        let artwork = MapArtwork(
          title: getStreetName,
          locationName: getSuburbPlace,
          coordinate: CLLocationCoordinate2D(latitude: getLatitude, longitude: getLongitude))
        mapScreen.addAnnotation(artwork)
        mapScreen.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.systemIndigo
        return renderer
    }
    
    func getDirections(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
       let source = MKMapItem(placemark: MKPlacemark(coordinate: loc1))
       source.name = "Your Location"
       let destination = MKMapItem(placemark: MKPlacemark(coordinate: loc2))
        destination.name = "Destination"
       MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func tappedNavigationButton(_ sender: Any) {
        let coordinateOne = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 25.631548261759725)!, longitude: CLLocationDegrees(exactly: -100.34630597294719)!)
        let coordinateTwo = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: getLatitude)!, longitude: CLLocationDegrees(exactly: getLongitude)!)
        self.getDirections(loc1: coordinateOne, loc2: coordinateTwo)
    }
    
    @IBAction func tappedVisitButton(_ sender: Any) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(getStreetName) {
            userDefaults.set(encoded, forKey: "Location Saved!")
            print("Saved Data: \(getStreetName) | \(encoded)")
            
            let alert = UIAlertController(title: getStreetName, message: "Location Saved", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Checked", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension MapDetail: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? MapArtwork else {
      return nil
    }
    
    let identifier = "artwork"
    var view: MKMarkerAnnotationView
    
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
        
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      guard let artwork = view.annotation as? MapArtwork else {
        return
      }

      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
