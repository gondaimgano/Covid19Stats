//
//  Covid19Service.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 9/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation

class Covid19Service{
    class func fetchByCountry( _ completionHandler:@escaping (CovidSummaryResponse?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: .fetchByCountry){
            result in
            switch result{
            case .success(let data):
            
                let response = try? JSONDecoder().decode(CovidSummaryResponse.self, from: data)
              // print(response)
                DispatchQueue.main.async {
                  completionHandler(response,nil)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                              completionHandler(nil,error)
                            }
            }
        }
        
        task.resume()
        
    }
}
