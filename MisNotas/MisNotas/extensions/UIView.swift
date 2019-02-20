//
//  UIView.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/17/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor? {
		get {
			return UIColor(cgColor: layer.borderColor!)
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	
}
