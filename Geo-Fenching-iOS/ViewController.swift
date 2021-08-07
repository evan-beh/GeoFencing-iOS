//
//  ViewController.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var ibMapView: MKMapView!
    @IBOutlet weak var ibDisplayView: UIView!
    @IBOutlet weak var btnGoto: UIButton!
    
    let viewModel = ViewModel()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAlert: UILabel!
    
    
    @IBAction func btnCurrentLocationClicked(_ sender: Any) {
        
        
        self.viewModel.fetchCurrentLocation()

      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ibDisplayView.setRoundBorder()
        
        self.ibDisplayView.setShadow()
     
        self.btnGoto.layer.cornerRadius = 5.0

        setupMap()
        
        setupViewModel()
        
        setupData()

    }
    
    func setupData()
    {
        self.lblTitle.text = "NEAREST STATION 100 M"
        self.lblDesc.text = "PETRONAS TTDI"
        self.lblAlert.text = "You are on in the proximity but"
        
    }
    func refreshUserLocation()
    {
        let region = CLCircularRegion(center: (self.viewModel.userAnnotation!.object?.coordinate)!, radius: self.viewModel.constRadius, identifier: "geofence")
        self.ibMapView.removeOverlays(self.ibMapView.overlays)
        let circle = MKCircle(center: (self.viewModel.userAnnotation!.object?.coordinate)!, radius: region.radius)
        self.ibMapView.addOverlay(circle)
        
        self.ibMapView.addAnnotation(self.viewModel.userAnnotation!)
    }
    
    func setupViewModel()
    {
        self.viewModel.locationDidRefresh = {(loc,error) in
           DispatchQueue.main.async {
            
            if let  currentAnnotation = self.viewModel.userAnnotation
            {
                self.ibMapView.removeAnnotation(currentAnnotation)

            }
            self.viewModel.getUserAnnotation { userAnnotation, error in
              
                self.refreshUserLocation()
                
            }
           
            let viewRegion = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                              
            self.ibMapView.setRegion(viewRegion, animated: false)
           }
        }
        
        viewModel.startLocationEngine()

        viewModel.fetchStationAnnotation { arrayAnnotations, error in

            self.ibMapView.addAnnotations(arrayAnnotations)

        }
        
      
    }
    
    
        
}

extension ViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    let location = view.annotation as! CustomMapAnnotation
    let launchOptions = [MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeDefault]
    location.mapItem().openInMaps(launchOptions: launchOptions)
  }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}

        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.strokeColor = .blue
        circleRenderer.fillColor = .blue
        circleRenderer.alpha = 0.2
        return circleRenderer
    }
  
}

extension ViewController {
    
    func setupMap()
       {
           self.ibMapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
           ibMapView.delegate = self
               

       }
       
   

}


