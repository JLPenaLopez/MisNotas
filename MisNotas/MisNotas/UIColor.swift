//
//  UIColor.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/17/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	convenience init(hex: String) {
		let scanner = Scanner(string: hex)
		scanner.scanLocation = 0
		
		var rgbValue: UInt64 = 0
		
		scanner.scanHexInt64(&rgbValue)
		
		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff
		
		self.init(
			red: CGFloat(CFloat(r) / 0xff),
			green: CGFloat(CFloat(g) / 0xff),
			blue: CGFloat(Float(b) / 0xff), alpha: 1
		)
	}
}
