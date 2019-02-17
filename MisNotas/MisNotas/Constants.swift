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
}
