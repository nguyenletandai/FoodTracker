//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by daicudu on 12/8/18.
//  Copyright © 2018 daicudu. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController, UISearchBarDelegate {
//
    
    //MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    var meals = [Meal]()
//    var searchControl: UISearchController?
    var searchData = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals() {
            meals += savedMeals
            meals += [Meal(name: "xxx", photo: UIImage(named: "meal1"), rating: 4)!]
        }
        else {
            // Load the sample data.
            loadSampleMeals()
        }
        
        searchData = meals
//        searchControl = UISearchController(searchResultsController: nil)
//        searchControl?.searchResultsUpdater = self
//        searchControl?.dimsBackgroundDuringPresentation = false
//        navigationItem.searchController = searchControl
//        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeue is not an instance of MealTableCell.")
        }
        let meal = searchData[indexPath.row]
        
        cell.namelabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        return cell
    }
    

    // cai ham nay co san
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    // ham nay cung la ham co san
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = meals.index(of: searchData[indexPath.row]) {
                
            // Delete the row from the data source
                meals.remove(at: index)
            searchData.remove(at: indexPath.row)
            }
            
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
//    func updateSearchResults (for searchController: UISearchController) {
//        if let searchText = searchControl?.searchBar.text , !searchText.isEmpty {
//            searchData = meals.filter { (item: Meal) -> Bool in
//                return (item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
//            }
//        }else {
//            searchData = meals
//        }
//         tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText.isEmpty)
        guard !searchText.isEmpty else {
            searchData = meals
            tableView.reloadData()
            return
        }
        searchData = meals.filter { (item: Meal) -> Bool in
            return (item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        tableView.reloadData()
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetaiViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being display by the table")
            }
            
            let selectedMeal = searchData[indexPath.row]
            mealDetaiViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Private methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "caprese Salad", photo: photo1, rating: 4) else {
            fatalError("unable to instatiate meal1")
        }
        guard let meal2 = Meal(name: "chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("unable to instatiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with mealballs", photo: photo3, rating: 3) else {
            fatalError("unable to instatiate meal3")
        }
        meals += [meal1, meal2, meal3]
        
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if let index = meals.index(of: searchData[selectedIndexPath.row]) {
                    meals[index] = meal
                    searchData[selectedIndexPath.row] = meal
                }

                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: searchData.count, section: 0)
                
                searchData.append(meal)
                meals = searchData
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveMeals()
        }

    }
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
}
