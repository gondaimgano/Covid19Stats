//
//  CountriesTableViewController.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 16/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit
import CoreData


enum Section {
    case main
}

typealias DataSource = UITableViewDiffableDataSource<Section,CCountry>
typealias SnapShot = NSDiffableDataSourceSnapshot<Section, CCountry>

class CountriesTableViewController:UITableViewController{
  
  
    //MARK:- DECLARE COMPUTED COREDATA FETCH REQUEST
    var fetchPhotoRequest:NSFetchRequest<CCountry>{
        
           let request:NSFetchRequest<CCountry> = CCountry.fetchRequest()
           let sortBy = NSSortDescriptor(key: "dateCreated", ascending: true)
           request.sortDescriptors = [sortBy]
          
           request.fetchLimit = 200
           return request
       }
    
    //MARK: - CACHE IN DATA LIST
    private  var dataList:[CCountry]? = []
    //MARK: - LAZY LOAD DATASOURCE
    private lazy var  dataSource = loadDataSource()
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
       tableView.register(SubtitleCell.self, forCellReuseIdentifier: "country_cell")
        tableView.dataSource = dataSource
   
        
       }
  
    
    
    
    //MARK:- REFRESH COLLECTION LIST
      func refreshSnapshot(){
          
              var snapshot = SnapShot()
              snapshot.appendSections([.main])
              snapshot.appendItems(dataList!)
              dataSource.apply(snapshot, animatingDifferences: true)
        
          
          }
    //MARK: - BUILD DATASOURCE
       func loadDataSource() ->DataSource{
        
        return DataSource(tableView: self.tableView){(tableView, indexPath, country) ->
                UITableViewCell? in
           var cell  = tableView.dequeueReusableCell(withIdentifier: "country_cell", for: indexPath) as? SubtitleCell
            if cell == nil || cell?.detailTextLabel == nil {
                cell = SubtitleCell(style: .subtitle, reuseIdentifier: "country_cell")
            }
          
            if let cell = cell{
                 cell.textLabel?.text = "\(country.country!)"
                cell.detailTextLabel?.text = "Confirmed: \(country.totalConfirmed) Recovery: \(country.newConfirmed) Deaths: \(country.newDeaths)"
                cell.accessoryType = .detailButton
            }
            
           
           
               return cell
               
           }
       }




}



// MARK: - Search results
extension CountriesTableViewController:UISearchResultsUpdating,UISearchControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
     
        let text = searchController.searchBar.value(forKey: "searchField") as! UITextField
           if let number = self.dataList?.count, number == 0{
           self.dataList = try? DataController.shared.viewContext.fetch(fetchPhotoRequest)
           }
        if let searchTerm = text.text, !searchTerm.isEmpty{
               self.dataList =  self.dataList?.filter{i in
           guard let country = i.country else { return false }
           return country.uppercased().contains(searchTerm.uppercased())
           }
            
           refreshSnapshot()
           }
         }
}
