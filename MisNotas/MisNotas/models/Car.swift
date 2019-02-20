//
//  Car.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/19/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import Foundation

class Car {
	
	var distance = 0;
	var type: CarType;
	var transmissionMode: CarTransmissionMode;
	var speed = 0;
	
	init(type:CarType, transmissionMode:CarTransmissionMode){
		self.type = type;
		self.transmissionMode = transmissionMode;
	}
	
	func start(minutes: Int) {
		
		//var speed = 0;
		
		if self.type == .Economy && self.transmissionMode == .Drive {
			self.speed = 35;
		}
		
		if self.type == .OffRoad && self.transmissionMode == .Drive {
			self.speed = 50;
		}
		
		if self.type == .Sport && self.transmissionMode == .Drive {
			self.speed = 70;
		}
		
		self.distance = self.speed * (minutes / 60);
		
	}
	
}

enum CarType {
	case Economy
	case OffRoad
	case Sport
}

enum CarTransmissionMode {
	case Park
	case Reverse
	case Neutral
	case Drive
}
