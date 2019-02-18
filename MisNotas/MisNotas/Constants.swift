//
//  Constants.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import Foundation

struct Constants {
	struct Segues {
		static let SignInToHome = "SignInToHome";
	}
	
	static let permissionsFacebook = ["public_profile", "email", "user_gender"];
	
	struct NoteFields {
		static let name = "name"
		static let text = "text"
		static let photoURL = "photoUrl"
		static let imageURL = "imageUrl"
	}
	
	struct ChildsDatabase {
		static let notes = "notes";
	}
	
	struct RemoteConfig {
		struct keys {
			static let maxLengthNote = "max_length_note";
			static let colorAppBackground = "color_app_background";
			static let isHiddenViewOptions = "is_hidden_view_options";
		}
		
		struct defaultValues {
			static let maxLength:NSNumber = 10;
			static let colorAppBackgroundDefault:String = "3498DB";
			static let isHiddenViewOptions:Bool = false;
		}
	}
	
	struct AdMob {
		//Se utiliza solo para efectos de pruebas https://developers.google.com/admob/ios/banner?authuser=0
		static let adUnitID = "ca-app-pub-3940256099942544/2934735716";
	}
}
