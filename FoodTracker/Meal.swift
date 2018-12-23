//
//  Meal.swift
//  FoodTracker
//
//  Created by daicudu on 12/7/18.
//  Copyright © 2018 daicudu. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    //MARK: properties
    
    //MARK: Acrchiving Paths
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("meals")
    
    //MARK: types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // the name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // the rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        //Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
    
}
