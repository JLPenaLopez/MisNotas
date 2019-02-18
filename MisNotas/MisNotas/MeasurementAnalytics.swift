//
//  MeasurementAnalytics.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/17/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import Foundation
import Firebase

class MeasurementAnalytics: NSObject {
	static func sendLoginEvent(params:Dictionary<String,Any>? = nil) {
		Analytics.logEvent(AnalyticsEventLogin, parameters: params);
	}
	
	static func sendLogoutEvent(params:Dictionary<String,Any>? = nil) {
		Analytics.logEvent("logout", parameters: params);
	}
	
	static func sendNoteEvent(params:Dictionary<String,Any>? = nil) {
		Analytics.logEvent("note", parameters: params);
	}
	
	static func openCamera(params:Dictionary<String,Any>? = nil) {
		Analytics.logEvent("open_camera", parameters: params);
	}
	
	static func shareApp(params:Dictionary<String,Any>? = nil) {
		Analytics.logEvent("share_app", parameters: params);
	}
}
