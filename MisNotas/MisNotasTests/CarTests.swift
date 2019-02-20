//
//  CarTests.swift
//  MisNotasTests
//
//  Created by Jorge Luis Peña López on 2/19/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import XCTest

class CarTests: XCTestCase {

	var mazda:Car!;
	var mercedesBenz:Car!;
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		super.setUp();
		mazda = Car(type: .Economy, transmissionMode: .Drive);
		mercedesBenz = Car(type: .Sport, transmissionMode: .Drive);
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown();
		mazda = nil;
		mercedesBenz = nil;
    }

    func testDistanceCars() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		//Dado que
		let minutes = 120;
		//Cuando se inician los carros
		mazda.start(minutes: minutes);
		mercedesBenz.start(minutes: minutes);
		//Entonces se valida si el mercedez ha recorrido más distancia que el mazda
		XCTAssertTrue(mercedesBenz.distance > mazda.distance);
		//Entonces se valida si el mercedez y el mazda van a diferente velocidad
		XCTAssertNotEqual(mercedesBenz.speed, mazda.speed, "mercedesBenz.speed >> \(mercedesBenz.speed)km/h y mazda.speed >> \(mazda.speed)km/h");
		//Entonces se valida si el mercedez y el mazda son de diferente tipo
		XCTAssertNotEqual(mercedesBenz.type, mazda.type, "mercedesBenz.type >> \(mercedesBenz.type) y mazda.type >> \(mazda.type)");
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	func tes(){
		
	}
	
}
