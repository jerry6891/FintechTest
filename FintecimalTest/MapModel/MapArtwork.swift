//
//  MapArtwork.swift
//  FintecimalTest
//
//  Created by Jerry Lozano on 5/12/21.
//

import UIKit
import MapKit
import Contacts

class MapArtwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? { return locationName }
    
    var mapItem: MKMapItem? { guard let location = locationName else { return nil }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
