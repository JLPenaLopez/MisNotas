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
	var sbGenderUser:String?;
	
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
				print("gender \(self.sbGenderUser ?? "")");
				let user:[String:String] = ["nameUser":displayName ?? "","emailUser":email ?? "","photoUser":photoURL?.absoluteString ?? ""];
				MeasurementAnalytics.sendLoginEvent(params: ["email_user":email ?? ""]);
				self.performSegue(withIdentifier: Constants.Segues.SignInToHome, sender: user);
				
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
		
		//Se obtiene la información de perfil del usuario
		FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, email, first_name, last_name, picture, gender"]).start {
			(connection, result, error) in
			if error != nil {
				//Error obteniendo los datos de perfil del usuario
				print("Error FBSDKGraphRequest \(error!)");
			} else if let userData = result as? NSDictionary {
				let email = userData["email"];
				print("email \(email ?? "")");
				self.sbGenderUser = userData["gender"] as? String;
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
					print("authResult?.user >> \(String(describing: authResult?.user))");
					print("authResult?.user.email >> \(String(describing: authResult?.user.email))");
				}
			}
		}
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		//Usuario cierra sesión con FacebookButton
		print("Usuario cierra sesión en Facebook con FacebookButton");
	}
	
	
	// MARK: - Navigation
	//In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if segue.identifier == Constants.Segues.SignInToHome {
			let vc = segue.destination as? HomeViewController;
			if let dictUser = sender as? Dictionary<String,String> {
				vc?.sbPhotoUser = dictUser["photoUser"] ?? "";
				vc?.sbNameUser = dictUser["nameUser"] ?? "";
				vc?.sbEmailUser = dictUser["emailUser"] ?? "";
			}
		}
	}
}

