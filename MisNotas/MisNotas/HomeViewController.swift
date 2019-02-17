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
import FirebaseDatabase

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var imgPhotoUser: UIImageView!
	@IBOutlet weak var lblNameUser: UILabel!
	@IBOutlet weak var lblEmailUser: UILabel!
	@IBOutlet weak var txtNote: UITextField!
	@IBOutlet weak var viewOptions: UIView!
	@IBOutlet weak var viewAds: UIView!
	@IBOutlet weak var tblViewNotes: UITableView!
	@IBOutlet weak var viewSendNote: UIView!
	
	
	//Variables de usuario logueado
	var sbNameUser:String = "";
	var sbEmailUser:String = "";
	var sbPhotoUser:String = "AppIcon";
	
	//Variables de Database Firebase
	var refDatabase:DatabaseReference!;
	var notes: [DataSnapshot]! = [];
	fileprivate var _refDatabaseHandle: DatabaseHandle!;
	
	
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
		
		self.tblViewNotes.delegate = self;
		self.tblViewNotes.dataSource = self;
		//Configuracion de la base de datos
		self.configureDatabase();
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.imgPhotoUser.image = UIImage(named: self.sbPhotoUser);
		self.lblNameUser.text = self.sbNameUser;
		self.lblEmailUser.text = self.sbEmailUser;
	}
	
	func configureDatabase(){
		self.refDatabase = Database.database().reference();
		self._refDatabaseHandle = self.refDatabase.child(Constants.ChildsDatabase.notes).observe(.value, with: { (snapshot) in
			self.notes = [DataSnapshot]();
			for child in snapshot.children {
				self.notes.append(child as! DataSnapshot);
			}
			self.tblViewNotes.reloadData();
		});
	}
	
	deinit {
		//Se remueven observadores de eventos de teclado
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
		//Se remueve el observador de evento de la base de datos realtime
		if let refHandle = self._refDatabaseHandle {
			//Remueve todos los observadorores de la base de datos
			//self.refDatabase.removeAllObservers();
			//Remueve el obervador especifico del nodo notes de la base de datos
			self.refDatabase.child(Constants.ChildsDatabase.notes).removeObserver(withHandle: refHandle);
		}
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
		return self.notes.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tblViewNotes.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell;
		
		let noteSnapshot: DataSnapshot! = self.notes[indexPath.row];
		guard let message = noteSnapshot.value as? [String:String] else { return cell; }
		
		let name = message[Constants.NoteFields.name] ?? "";
		let text = message[Constants.NoteFields.text] ?? "";
		
		cell.setData(dataImg: nil, textCell: ( name + ": " + text ));
		
		return cell;
	}
	
	func sendNote(data: [String: String]) {
		var mdata = data
		mdata[Constants.NoteFields.name] = Auth.auth().currentUser?.displayName
		if let photoURL = Auth.auth().currentUser?.photoURL {
			mdata[Constants.NoteFields.photoURL] = photoURL.absoluteString
		}
		//Se envian datos a la base de datos de Firebase
		self.refDatabase.child(Constants.ChildsDatabase.notes).childByAutoId().setValue(mdata);
	}
	
	@IBAction func onBtnSendNote(_ sender: Any) {
		if let text = self.txtNote.text, !text.isEmpty{
			let data = [Constants.NoteFields.text: text]
			self.sendNote(data: data);
			self.txtNote.text = "";
			self.dismissKeyborad();
		}
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
