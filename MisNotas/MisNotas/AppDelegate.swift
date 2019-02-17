//
//  AppDelegate.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/10/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure();
		//Google Login
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID;
		GIDSignIn.sharedInstance()?.delegate = self;
		Auth.auth().useAppLanguage();
		//Facebook Login
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions);
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		
		let isGoogleURL = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: [:]);
		
		if isGoogleURL { return true; }
		
		let isFBURL = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options);
		
		if isFBURL { return true; }
		
		return false;
	}
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		//Se administra el acceso a la app
		if let error = error {
			print("Error1 Sing Google \(error)");
			return;
		}
		//Se obtiene un token de ID de Google y un token de acceso de Google del objeto, para obtener una credencial
		guard let authentication = user.authentication else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
													   accessToken: authentication.accessToken)
		Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
			if let error = error {
				print("Error2 Sing Google \(error)");
				return;
			}
			//El usuario accedió correctamente
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		//Si el usuario se desconecta de la app...
		print("User out app");
	}
}

