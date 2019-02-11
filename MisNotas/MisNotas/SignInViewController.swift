//
//  ViewController.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
	
	@IBOutlet weak var btnSignInGoogle: GIDSignInButton!
	var handle: AuthStateDidChangeListenerHandle?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//Auth.auth().languageCode = "es";
		GIDSignIn.sharedInstance()?.uiDelegate = self;
		GIDSignIn.sharedInstance()?.signInSilently();
		self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
			if user != nil {
				let displayName = user?.displayName;
				let uid = user?.uid;
				let email = user?.email;
				let photoURL = user?.photoURL;
				print("displayName \(displayName ?? "")");
				print("uid \(uid ?? "")");
				print("email \(email ?? "")");
				print("photoURL \(String(describing: photoURL))");
				print("photoURL \(String(describing: photoURL?.absoluteString))");
				self.performSegue(withIdentifier: Constants.Segues.SignInToHome, sender: nil);
			}
		}
	}
	
	//override func viewDidDisappear(_ animated: Bool) {
	deinit {
		if let handle = self.handle {
			Auth.auth().removeStateDidChangeListener(handle);
		}
	}


}

