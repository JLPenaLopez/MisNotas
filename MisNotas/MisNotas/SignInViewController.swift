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
import FBSDKLoginKit

class SignInViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
	
	@IBOutlet weak var btnSignInGoogle: GIDSignInButton!
	@IBOutlet weak var btnSingInFacebook: FBSDKLoginButton!
	var handle: AuthStateDidChangeListenerHandle?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//Auth.auth().languageCode = "es";
		//Google Login
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
		
		//Facebook Login
		btnSingInFacebook.delegate = self;
		btnSingInFacebook.readPermissions = Constants.permissionsFacebook;
	}
	
	//override func viewDidDisappear(_ animated: Bool) {
	deinit {
		if let handle = self.handle {
			Auth.auth().removeStateDidChangeListener(handle);
		}
	}

	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
		if let error = error {
			print(error.localizedDescription)
			return;
		}
		
		if result.isCancelled{
			print("Usuario canceló Login")
			return;
		}
		//Usuario inicio sesión con Facebook
		//Se obtiene la credencial del proveedor de Facebook en Firebase a partir del token del login con Facebook
		let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString);
		Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
			if let error = error {
				print("Error signInAndRetrieveData FacebookAuthProvider \(error)");
				return;
			}
			// Usuario inició sesión en Facebook y en Firebase
			print(authResult ?? "");
		}
		
		//Se obtiene la información de perfil del usuario
		FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, email, first_name, last_name, picture"]).start {
			(connection, result, error) in
			if error != nil {
				//Error obteniendo los datos de perfil del usuario
				print("Error FBSDKGraphRequest \(error!)");
			} else if let userData = result as? NSDictionary {
				let email = userData["email"];
				print("email \(email ?? "")");
			}
		}
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		//Usuario cierra sesión con FacebookButton
	}
	
}

