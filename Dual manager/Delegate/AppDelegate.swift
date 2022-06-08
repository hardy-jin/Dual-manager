//
//  AppDelegate.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/16/21.
//

import UIKit
import Firebase
import Alamofire
import SendBirdSDK
import SendBirdCalls
import UserNotifications
import PushKit
import CallKit
import SendBirdUIKit
import GooglePlaces
import GoogleMaps
import FirebaseAppCheck

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let baseURLString: String = "https://desolate-woodland-21996.herokuapp.com/"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let providerFactory = YourSimpleAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        
        
        if Auth.auth().currentUser?.uid != nil {
            trackProfile()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    override init() {
        super.init()
        
        // Main API client configuration
        MainAPIClient.shared.baseURLString = baseURLString
              
    }
    
    
   func trackProfile() {
       
       let db = DataService.instance.mainFireStoreRef
       let uid = Auth.auth().currentUser?.uid
       
          profileDelegateListen = db.collection("Staff_account").whereField("userUID", isEqualTo: uid!).addSnapshotListener { [self] querySnapshot, error in
               guard let snapshot = querySnapshot else {
                   print("Error fetching snapshots: \(error!)")
                   return
               }
           
               snapshot.documentChanges.forEach { diff in
                   

                   if (diff.type == .modified) {
                      
                       refId = diff.document.documentID
                       
                       if let is_suspend = diff.document.data()["status"] as? Bool {
                           
                           if is_suspend == false {
                            
                               logoutandreset(text: "Your account is disabled, please contact our support for more information at support@dual.video.")
                            
                           }
                        
                       }
                    
                   } else if (diff.type == .added) {
                    
                    refId = diff.document.documentID
                    
                    if let is_suspend = diff.document.data()["status"] as? Bool {
                        
                        if is_suspend == false {
                         
                         
                            logoutandreset(text: "Your account is disbaled, please contact our support for more information at support@dual.video.")
                            
                        }
                        
                    }
             }
           }
       }
 
   }
    
    
    func logoutandreset(text: String) {
          
        if let vc = UIViewController.currentViewController() {
            
            if let uid = Auth.auth().currentUser?.uid, uid != "" {
                
                try? Auth.auth().signOut()
                removeAllListen()
                
                
                let alert = UIAlertController(title: "Notice!", message: text, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC {
                        
                        try? Auth.auth().signOut()
                        viewController.modalPresentationStyle = .fullScreen
                        
                        vc.present(viewController, animated: true, completion: nil)
                                           
                        
                    }
                    
                
                })
                
                
                
                alert.addAction(action)
                
                                                                                               
                vc.present(alert, animated: true, completion: nil)
                
                
            }
            
            
            
            
        } else {
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as? HomePageVC {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                if let window = self.window {
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
                    
                    
                    if let uid = Auth.auth().currentUser?.uid, uid != "" {
                       
                        try? Auth.auth().signOut()
                        
                        removeAllListen()
                       
                        imageStorage.async.removeAll(completion: { result in
                            print(result)
                            
                        })
                        
 
                        let alert = UIAlertController(title: "Notice!", message: text, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        
                        
                        alert.addAction(action)
                        
                        
                        viewController.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                }
                
        
                
                
            }
            
        }
        
    }


}

