//
//  Covid19MapViewController.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 7/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class Covid19Annotation: MKPointAnnotation {
    
    var country:CCountry? = nil
    
}


class Covid19MapViewController: UIViewController {
    
    @IBOutlet weak var countryMap: MKMapView!
    
    @IBOutlet weak var countrySearchBar: UISearchBar!
    var searchController:UISearchController{
        let countries = CountriesTableViewController()
        let search = UISearchController(searchResultsController: countries)
        search.delegate = countries as UISearchControllerDelegate
        search.searchResultsUpdater = countries as UISearchResultsUpdating
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search by Country"
        return search
    }
    var fetchCountryRequest:NSFetchRequest<CCountry>{
        
           let request:NSFetchRequest<CCountry> = CCountry.fetchRequest()
           let sortBy = NSSortDescriptor(key: "dateCreated", ascending: false)
           request.sortDescriptors = [sortBy]
          // request.fetchLimit = 200
           return request
       }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryMap.delegate = self
        //countrySearchBar.delegate = self
        countryMap.register(Covid19Annotation.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(Covid19Annotation.self))
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Covid 19 Map Update"
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .refresh, target: self, action: #selector(pressRefresh))
        // Do any additional setup after loading the view.
    }
    
    @objc  func pressRefresh(_ sender: Any?) {
        loadData()
    }
    func initialize() {
          if let listToMap =  try? DataController.shared.viewContext.fetch(self.fetchCountryRequest){
                        listToMap.forEach{item in
                            self.countryMap.addAnnotation(self.generateAnnotation(pin: item))
                        }
                    }
          else{
          loadData()
          }
      }
    override func viewDidAppear(_ animated: Bool) {
     initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stats = segue.destination as? CountryStatViewController{
        if let annotation = sender as? Covid19Annotation{
            stats.covid19Annotation = annotation
        }
        }
    }
    
    }

    

extension Covid19MapViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          let reuseId = "pin"
                var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
               
        if let ann = annotation as? Covid19Annotation, let countryDetail = ann.country{
            
                if pinView == nil {
                                  pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                                  pinView!.canShowCallout = true
                    let vfactor = Double.init(countryDetail.totalRecovered)/Double.init(countryDetail.totalConfirmed)*1.0
                  //  print(countryDetail.country!, vfactor)
                    if vfactor > 0.4 {
                        
                                  pinView!.pinTintColor = .blue
                    }
                    else{
                        pinView!.pinTintColor = .red
                    }
                                  pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                              } else {
                                  pinView!.annotation = annotation
                              
                
            }
        }
              
           
           return pinView
      }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      //  view.annotation?.title
        if let annotation = view.annotation as? Covid19Annotation {
        performSegue(withIdentifier: "showCountry", sender: annotation)
            
        }
        
    }
    
}


extension Covid19MapViewController{
    
    func generateAnnotation(pin:CCountry)->Covid19Annotation{
        
       let annotation = Covid19Annotation()
        annotation.country = pin
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        annotation.title = "\(pin.country!)"
        
        annotation.subtitle = "Confirmed : \(pin.totalConfirmed) Recovered: \(pin.totalRecovered)"
      
        return annotation
    }
    
    func loadData(){
    Covid19Service.fetchByCountry{
        response,
        error in
       
        if let response = response {
            
            if let listToDelete =  try? DataController.shared.viewContext.fetch(self.fetchCountryRequest){
                self.countryMap.removeAnnotations(self.countryMap.annotations)
                               listToDelete.forEach{item in
                                DataController.shared.viewContext.delete(item)
                               }
                try? DataController.shared.viewContext.save()
                
                           }
            
            response.countries.forEach{f in
                if let target =  decodedCountries.refCountryCodes.filter({t in
                    t.country.lowercased().contains(f.country.lowercased())
                }).first {
                let dcountry = CCountry(context: DataController.shared.viewContext)
                dcountry.latitude = target.latitude
                dcountry.longitude = target.longitude
                dcountry.country = f.country
                dcountry.countryCode = f.countryCode
                dcountry.dateCreated = Date()
                dcountry.newConfirmed = Int32(f.newConfirmed)
                dcountry.newDeaths = Int32(f.newDeaths)
                dcountry.newRecovered = Int32(f.newRecovered)
                dcountry.totalConfirmed = Int32(f.totalConfirmed)
                dcountry.totalRecovered = Int32(f.totalRecovered)
                dcountry.slug = f.slug
                dcountry.id = f.id
                   
                    
                    //print(target)
                    

                }
           
            }
            
            try? DataController.shared.viewContext.save()
            
            if let listToMap =  try? DataController.shared.viewContext.fetch(self.fetchCountryRequest){
                
                listToMap.forEach{item in
                    self.countryMap.addAnnotation(self.generateAnnotation(pin: item))
                }
            }
            
            }
        if let error = error as? HTTPError {
            let alert = UIAlertController(title: "Error ", message:error.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
        }
        }
    }
}


extension Covid19MapViewController{
    
    
}
    
    
