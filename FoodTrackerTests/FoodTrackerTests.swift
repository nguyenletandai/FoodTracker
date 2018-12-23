//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by daicudu on 12/5/18.
//  Copyright © 2018 daicudu. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    //MARK: Meal class tests
    // Comfirm that the meal initialization returns a meal object when passed valid parameters.
    func testMealInitializationSucceed() {
        //zero rating
        let zeroRatingMeal = Meal.init(name: "zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Hightlight positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    // comfirm that the meal initialization return nil when passed a negative rating or an empty name.
    func testMealInitilizationFails() {
        // negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
        // Rating exceeds maximun
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }

}
