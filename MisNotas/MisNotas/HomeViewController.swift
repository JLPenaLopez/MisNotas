//
//  HomeViewController.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit
import Photos

import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseRemoteConfig
import GoogleMobileAds
import Crashlytics

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InviteDelegate {
	
	@IBOutlet weak var imgPhotoUser: UIImageView!
	@IBOutlet weak var lblNameUser: UILabel!
	@IBOutlet weak var lblEmailUser: UILabel!
	@IBOutlet weak var txtNote: UITextField!
	@IBOutlet weak var viewOptions: UIView!
	@IBOutlet weak var viewAds: GADBannerView!
	@IBOutlet weak var tblViewNotes: UITableView!
	@IBOutlet weak var viewSendNote: UIView!
	@IBOutlet weak var viewHeader: UIView!
	
	//Variables de usuario logueado
	var sbNameUser:String = "";
	var sbEmailUser:String = "";
	var sbPhotoUser:String = "AppIcon";
	
	//Variables de Firebase RealTime Database
	var refDatabase:DatabaseReference!;
	var notes: [DataSnapshot]! = [];
	fileprivate var _refDatabaseHandle: DatabaseHandle!;
	
	//Variables de Firebase Storage
	var refStorage: StorageReference!
	
	//Variables de RemoteConfig
	var remoteConfig: RemoteConfig!;
	var maxLength:NSNumber = Constants.RemoteConfig.defaultValues.maxLength;
	var colorAppBackground:String = Constants.RemoteConfig.defaultValues.colorAppBackgroundDefault;
	var isHiddenViewOptions:Bool = Constants.RemoteConfig.defaultValues.isHiddenViewOptions;
	
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
		//Configuracion de Firebase RealTime Database
		self.configureDatabase();
		//Configuracion de Firebase Storage
		self.configureStorage();
		//Configuración de RemoteConfig
		self.configureRemoteConfig();
		self.fetchRemoteConfig();
		//Configuración de AdMob, carga de ads en banner
		self.loadAd();
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		
		
		if let url = URL(string: self.sbPhotoUser), UIApplication.shared.canOpenURL(url) {
			do {
				let data = try Data(contentsOf: url);
				self.imgPhotoUser.image = UIImage(data: data);
			} catch let error as NSError {
				print ("Error obteniendo data de photoURL: \(error.localizedDescription)");
				self.imgPhotoUser.image = UIImage(named: "AppIcon");
			}
			
		}else{
			self.imgPhotoUser.image = UIImage(named: "AppIcon");
		}
		
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
	
	func configureStorage() {
		self.refStorage = Storage.storage().reference()
	}
	
	func configureRemoteConfig(){
		self.remoteConfig = RemoteConfig.remoteConfig();
		//Por defecto RemoteConfig se limita a maximo 5 solicitudes por hora, por lo tanto
		//Se habilita el modo desarrollador para permitir que se realicen mas solicitudes por hora
		let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
		remoteConfig.configSettings = remoteConfigSettings
	}
	
	func fetchRemoteConfig(){
		var expirationDuration: TimeInterval = 3600
		//Si esta en modo desarrollador se establece en 0 para que en cada fetch se obtengan los datos desde Firebase
		if self.remoteConfig.configSettings.isDeveloperModeEnabled {
			expirationDuration = 0
		}
		self.remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
			if status == .success {
				print("Config Remote obtenidos");
				self.remoteConfig.activateFetched()
				let maxLenghtNote = self.remoteConfig[Constants.RemoteConfig.keys.maxLengthNote];
				let colorAppBackground = self.remoteConfig[Constants.RemoteConfig.keys.colorAppBackground];
				let isHiddenViewOptions = self.remoteConfig[Constants.RemoteConfig.keys.isHiddenViewOptions];
				self.maxLength = maxLenghtNote.numberValue!;
				self.colorAppBackground = colorAppBackground.stringValue!;
				self.isHiddenViewOptions = isHiddenViewOptions.boolValue;
				self.configureView();
			} else {
				if let error = error {
					print("Error obteniendo RemoteConfig \(error.localizedDescription)");
				}
			}
		}
	}
	
	func configureView(){
		self.viewHeader.backgroundColor = UIColor(hex: self.colorAppBackground);
		self.viewOptions.isHidden = self.isHiddenViewOptions;
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
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text else { return true }
		//let newLength = text.characters.count + string.characters.count - range.length
		let newLength = text.count + string.count - range.length
		return newLength <= self.maxLength.intValue // Bool
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.notes.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tblViewNotes.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell;
		
		let noteSnapshot: DataSnapshot! = self.notes[indexPath.row];
		guard let note = noteSnapshot.value as? [String:String] else { return cell; }
		
		let name = note[Constants.NoteFields.name] ?? "";
		let text = note[Constants.NoteFields.text] ?? "";
		let sbText = name + ": " + text;
		
		if let imageURL = note[Constants.NoteFields.imageURL] {
			if imageURL.hasPrefix("gs://") {
				Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) { (data, error) in
					if let error = error {
						print("Error descargando imageURL \(error.localizedDescription)");
						cell.setData(dataImg: nil, textCell: sbText);
					}else{
						DispatchQueue.main.async {
							cell.setData(dataImg: data, textCell: sbText);
						}
					}
				}
			}else if let url = URL(string: imageURL) {
				do {
					let data = try Data(contentsOf: url);
					cell.setData(dataImg: data, textCell: sbText);
				} catch let error as NSError {
					print ("Error obteniendo data de imageURL: \(error.localizedDescription)");
					cell.setData(dataImg: nil, textCell: sbText);
				}
			}
		}else if let photoURL = note[Constants.NoteFields.photoURL], let url = URL(string: photoURL) {
			do {
				let data = try Data(contentsOf: url);
				cell.setData(dataImg: data, textCell: sbText);
			} catch let error as NSError {
				print ("Error obteniendo data de photoURL: \(error.localizedDescription)");
				cell.setData(dataImg: nil, textCell: sbText);
			}
		}else{
			cell.setData(dataImg: nil, textCell: sbText);
		}
		
		return cell;
	}
	
	func sendNote(data: [String: String]) {
		var mdata = data
		mdata[Constants.NoteFields.name] = Auth.auth().currentUser?.displayName;
		if let photoURL = Auth.auth().currentUser?.photoURL {
			mdata[Constants.NoteFields.photoURL] = photoURL.absoluteString;
		}
		//Se envian datos a la base de datos de Firebase
		self.refDatabase.child(Constants.ChildsDatabase.notes).childByAutoId().setValue(mdata);
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion:nil)
		guard let uid = Auth.auth().currentUser?.uid else { return }
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		let imageData = image.jpegData(compressionQuality: 0.8);
		let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg";
		let metadata = StorageMetadata();
		metadata.contentType = "image/jpeg";
		self.refStorage.child(imagePath)
			.putData(imageData!, metadata: metadata) { (metadata, error) in
				if let error = error {
					print("Error cargando foto: \(error.localizedDescription)");
					return;
				}
				self.sendNote(data: [Constants.NoteFields.imageURL: self.refStorage.child((metadata?.path)!).description]);
		}
	}
	
	func loadAd() {
		self.viewAds.adUnitID = Constants.AdMob.adUnitID;
		self.viewAds.rootViewController = self
		self.viewAds.load(GADRequest())
	}
	
	func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
		if let error = error {
			print("Error en la invitación \(error.localizedDescription)");
			MeasurementAnalytics.shareApp(params: ["email_user":self.sbEmailUser, "send_invite":false]);
		}else{
			print("Invitación enviada");
			MeasurementAnalytics.shareApp(params: ["email_user":self.sbEmailUser, "send_invite":true]);
		}
	}
	
	@IBAction func onBtnSendNote(_ sender: Any) {
		if let text = self.txtNote.text, !text.isEmpty{
			let data = [Constants.NoteFields.text: text]
			self.sendNote(data: data);
			MeasurementAnalytics.sendNoteEvent(params: ["email_user":self.sbEmailUser, "note_length":text.count]);
			self.txtNote.text = "";
			self.dismissKeyborad();
		}
	}
	
	@IBAction func onBtnCamera(_ sender: Any) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = UIImagePickerController.SourceType.camera
		MeasurementAnalytics.openCamera();
		present(picker, animated: true, completion:nil)
	}
	
	@IBAction func onBtnCrash(_ sender: Any) {
		//Se envía la información del usuario con el fallo
		Crashlytics.sharedInstance().setUserEmail(self.sbEmailUser);
		Crashlytics.sharedInstance().setUserIdentifier(self.sbEmailUser);
		Crashlytics.sharedInstance().setUserName(self.sbNameUser);
		//Se realiza crash generico de prueba
		//Crashlytics.sharedInstance().crash();
		//Se realiza registro de excepcion personalizada de prueba (Usado para errores no fatales)
		var dictParams:Dictionary = Dictionary<String, Any>();
		dictParams["sbMessageError"] = "Fallo detectado en MisNotas";
		dictParams["dateError"] = Date();
		dictParams["idUser"] = 123456;
		dictParams["sbCotentError"] = "Error cargando foto de URL \(self.sbPhotoUser)";
		let error:NSError = NSError(domain: "HomeViewController_onBtnCrash", code: 20000, userInfo: dictParams);
		Crashlytics.sharedInstance().recordError(error);
		
	}
	
	@IBAction func onBtnRefresh(_ sender: Any) {
		self.fetchRemoteConfig();
	}
	
	@IBAction func onBtnShare(_ sender: Any) {
		if let invite = Invites.inviteDialog() {
			invite.setInviteDelegate(self);
			// NOTA: Debe tener la ID de la tienda de aplicaciones establecida en el proyecto de la
			//consola de desarrollador para que las invitaciones se envíen correctamente.
			
			//El mensae se manifiesta de manera diferente según el tipo de invitación recibida.
			//Por ejemplo, en una invitación por correo electrónico esto aparece como el asunto.
			invite.setMessage("Prueba esta app!\n -\(Auth.auth().currentUser?.displayName ?? "")")
			//Titulo del dialog
			invite.setTitle("MisNotas")
			invite.setDeepLink("app_url")
			invite.setCallToActionText("Instalar!")
			invite.setCustomImage(self.sbPhotoUser)
			invite.open()
		}
	}
	
	@IBAction func onBtnLogOut(_ sender: Any) {
		let firebaseAuth = Auth.auth()
		do {
			GIDSignIn.sharedInstance()?.signOut();
			FBSDKLoginManager().logOut();
			try firebaseAuth.signOut();
			MeasurementAnalytics.sendLogoutEvent(params: ["email_user":self.sbEmailUser]);
			self.dismiss(animated: true, completion: nil);
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
	}


}
