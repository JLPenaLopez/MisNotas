//
//  PreViewController.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 6/6/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit

class PreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		print("PreViewController viewDidLoad");
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		print("PreViewController viewWillAppear");
	}
	
	@IBAction func onBtnNext(_ sender: Any) {
		let vC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController;
		self.navigationController?.pushViewController(vC, animated: true);
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
