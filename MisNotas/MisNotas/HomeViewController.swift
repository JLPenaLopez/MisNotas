//
//  HomeViewController.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func onBtnLogOut(_ sender: Any) {
			let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			self.dismiss(animated: true, completion: nil);
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
