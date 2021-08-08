//
//  ViewController.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit
import Combine
import PromiseKit

class ViewController: UIViewController {

    @IBOutlet weak var ibMapView: MKMapView!
    @IBOutlet weak var ibDisplayView: UIView!
    @IBOutlet weak var btnGoto: UIButton!
    
    let viewModel = ViewModel()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAlert: UILabel!
    

    @IBAction func btnCurrentLocationClicked(_ sender: Any) {
        
        
        firstly {
            self.viewModel.fetchCurrentLocation()

        }.done { _ in
            self.viewModel.getNearestStation()
        }

      
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
    private var cancellables: Set<AnyCancellable> = []

    func setupData()
    {

        self.viewModel.updateUI = {
            
            self.btnGoto.setTitle(self.viewModel.enablePump ? "PUMP NOW!":"GOTO STATION!", for: .normal)

        }

        
        //Demo of obersable binding
        self.viewModel.$nearestStation.sink { model in
            
            
            let distance = (model?.distance ?? 0)/1000
            self.lblTitle.text = String(format: "NEAREST STATION %.2f KM", distance)
                
            self.lblDesc.text = model?.name
            
            if let nearestStation = model, let user = self.viewModel.userInfoObject
            {
                let value  = self.viewModel.validateInRangeAndConnectWifi(station: nearestStation, user: user as! UserObjectModel)
                let proximityRange = value.0 ? "In":"NOT In"
                let wifiRange = value.1 ? "connected" : "NOT connected"
                let combineText = "You are \(proximityRange) Station Proximity & \(wifiRange) to Wifi"
                self.lblAlert.text = combineText
                
            }
            else{
                self.lblTitle.text = "NEAREST STATION - M"
                self.lblDesc.text = "------"
                self.lblAlert.text = "PROXIMITY ....."
            }
                              
                 
        }.store(in: &cancellables)
            
           
       
    }
    func refreshUserAnnotation()
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
                self.refreshUserAnnotation()
            }
           
            let viewRegion = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                              
            self.ibMapView.setRegion(viewRegion, animated: false)
           }
        }
        
        
        firstly {
            self.viewModel.startLocationService()

        }.then { _ in
            self.viewModel.retreivePageData()
        }.then { _ in
            self.viewModel.fetchStationAnnotation()
        }.then { tempArray in
            self.addStationAnnotations(array: tempArray)
        }.done { _ in
            self.viewModel.getNearestStation()
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
    func addStationAnnotations(array:[StationCMAnnotation]) -> Promise<Any?>
    {
        let promise = Promise<Any?>
        {seal in
            
            self.ibMapView.addAnnotations(array)
            seal.fulfill(nil)

        }
        
        return promise
        
    }
    

}


