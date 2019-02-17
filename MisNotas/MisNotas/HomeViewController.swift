//
//  HomeViewController.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var imgPhotoUser: UIImageView!
	@IBOutlet weak var lblNameUser: UILabel!
	@IBOutlet weak var lblEmailUser: UILabel!
	@IBOutlet weak var txtNote: UITextField!
	@IBOutlet weak var viewOptions: UIView!
	@IBOutlet weak var viewAds: UIView!
	@IBOutlet weak var tblViewNotes: UITableView!
	@IBOutlet weak var viewSendNote: UIView!
	
	
	
	var sbNameUser:String = "";
	var sbEmailUser:String = "";

    override func viewDidLoad() {
        super.viewDidLoad()
		self.txtNote.delegate = self;
		
		//Se añade evento de tap al view para ocultar el teclado cuando se presione por fuera de txtNote
		let tapView:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyborad));
		self.view.addGestureRecognizer(tapView);
		//Observadores de eventos de teclado
		NotificationCenter.default.addObserver(self, selector: #selector(keyborardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
		NotificationCenter.default.addObserver(self, selector: #selector(keyborardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
		NotificationCenter.default.addObserver(self, selector: #selector(keyborardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.lblNameUser.text = self.sbNameUser;
		self.lblEmailUser.text = self.sbEmailUser;
	}
	
	deinit {
		//Se remueven observadores de eventos de teclado
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
	}
	
	@objc func dismissKeyborad(){
		self.view.endEditing(true);
	}
	
	//Llamar cuando se envíe la nota
	func hideKeyboard(){
		self.txtNote.becomeFirstResponder();
	}
	
	@objc func keyborardWillChange(notification: Notification){
		print("keyborardWillChange >> \(notification.name) ");
		if UIResponder.keyboardWillShowNotification == notification.name {
			print("keyboardWillShowNotification  >> \(notification.name) ");
			if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
				print("\(keyboardFrame.cgRectValue.height)");
				self.view.frame.origin.y = (-1 * keyboardFrame.cgRectValue.height);
			}
		}
		
		if UIResponder.keyboardWillHideNotification == notification.name {
			print("keyboardWillHideNotification  >> \(notification.name) ");
			self.view.frame.origin.y = 0;
		}
		
		if UIResponder.keyboardWillChangeFrameNotification == notification.name {
			print("keyboardWillChangeFrameNotification  >> \(notification.name) ");
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		<#code#>
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		<#code#>
	}
	
	@IBAction func onBtnSendNote(_ sender: Any) {
	}
	
	@IBAction func onBtnCamera(_ sender: Any) {
	}
	
	@IBAction func onBtnCrash(_ sender: Any) {
	}
	
	@IBAction func onBtnRefresh(_ sender: Any) {
	}
	
	@IBAction func onBtnShare(_ sender: Any) {
	}
	
	@IBAction func onBtnLogOut(_ sender: Any) {
		let firebaseAuth = Auth.auth()
		do {
			GIDSignIn.sharedInstance()?.signOut();
			FBSDKLoginManager().logOut();
			try firebaseAuth.signOut()
			self.dismiss(animated: true, completion: nil);
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
	}


}
