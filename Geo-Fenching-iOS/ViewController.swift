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
  
    let viewModel = ViewModel()
    
    
    @IBAction func btnCurrentLocationClicked(_ sender: Any) {
        
        let viewRegion = MKCoordinateRegion(center: self.viewModel.currentLocation!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                           self.ibMapView.setRegion(viewRegion, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        viewModel.locationDidRefresh = { [weak self] (loc,error) in
           DispatchQueue.main.async {
            
            let viewRegion = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                              
            self?.ibMapView.setRegion(viewRegion, animated: false)
           }
             
        }
        
        viewModel.startLocationEngine()

        viewModel.fetchStationAnnotation { arrayAnnotations, error in

            self.ibMapView.addAnnotations(arrayAnnotations)

        }
        
        viewModel.getUserAnnotation { userAnnotations, error in
            
            let userAnnotation = userAnnotations[0]
                self.ibMapView.addAnnotation(userAnnotation)

            
        }
        

    }
    
    
        
}

extension ViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    let location = view.annotation as! CustomMapAnnotation
    let launchOptions = [MKLaunchOptionsDirectionsModeKey:
      MKLaunchOptionsDirectionsModeDriving]
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


