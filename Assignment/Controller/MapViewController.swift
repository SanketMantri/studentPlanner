//
//  MapViewController.swift
//  Assignment
//
//  Created by Sanket Mantri on 20/10/17.
//  Copyright © 2017 Sanket Mantri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var geoCod: CLGeocoder = CLGeocoder()
    var lat : Double!
    var long : Double!
    var location : String!
    var test : CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("location asdlkjaslkdjlaksjdl \(location)")
        
        geoCod.geocodeAddressString(location) {
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.long = placemark?.location?.coordinate.longitude
            self.test = placemark?.location
            print("TTTEEE Lat: \(self.lat), Lon: \(self.long)")
            print("CLLocation Object in Func:\(self.test)")

            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
        print("CLLocation Object out Func:\(self.test)")

        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Navigation
     @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }
     /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
