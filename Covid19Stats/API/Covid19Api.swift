//
//  Covid19Api.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 9/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//


import Foundation



extension URLRequest {
    mutating func enableJson(){
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

enum Covid19API {
    static let API_KEY = "5cf9dfd5-3449-485e-b5ae-70a60e997864"
    enum ENDPOINT :String{
        case baseUrl = "https://api.covid19api.com"
    
    
      enum LOOKUP {
            
        case fetchByCountry
        
        case getGeoLocation(name:String)
            
             var buildRequest:URLRequest!{
                
                switch self {
                    
                case .getGeoLocation(let name):
                    let urlLink = "http://www.mapquestapi.com/geocoding/v1/address?key=nhts3mDf7z12NjzRRYzCPX6kvQ9WPdzV&location=\(name)"
                    
                    var request = URLRequest(url:URL(string: urlLink)!)
                                       request.httpMethod = "GET"
                                        request.enableJson()
                    
                    return request
                    
                case .fetchByCountry:
                   
                   
                     let urlLink = Covid19API.ENDPOINT.baseUrl.rawValue
                    
                
                     var request = URLRequest(url:URL(string: urlLink+"/summary")!)
                    request.httpMethod = "GET"
                     request.addValue("Bearer \(Covid19API.API_KEY)", forHTTPHeaderField: "Authorization")
                     request.enableJson()
                return request
           

                                   
               
                }
                
             }
         }
    }
   
}
