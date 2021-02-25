//
//  CountryStatViewController.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 24/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit
import MapKit
class CountryStatViewController: UIViewController {
    
    @IBOutlet weak var mapDetail: MKMapView!
    @IBOutlet weak var totalConfirmedValue: UILabel!
    @IBOutlet weak var totalRecoveredValue: UILabel!
    @IBOutlet weak var newDeathsValue: UILabel!
    var covid19Annotation:Covid19Annotation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
           setTitle()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
            setTitle()
        let camera = MKMapCamera(lookingAtCenter: covid19Annotation!.coordinate, fromDistance: self.mapDetail.camera.centerCoordinateDistance, pitch: self.mapDetail.camera.pitch, heading: self.mapDetail.camera.heading)
                               self.mapDetail.setCamera(camera, animated: true)
          mapDetail.addAnnotation(covid19Annotation!)
        if let  country = covid19Annotation?.country{
       
        totalConfirmedValue.text = "\(country.totalConfirmed)"
        totalRecoveredValue.text = "\(country.totalRecovered)"
        newDeathsValue.text = "\(country.newDeaths)"
        
        }
       }
    
    func setTitle(){
      
        if let covid = covid19Annotation , let country = covid.country{
         self.title = "\(country.country!)"
               }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
