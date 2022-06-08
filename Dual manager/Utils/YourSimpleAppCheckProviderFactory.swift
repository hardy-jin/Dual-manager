//
//  YourSimpleAppCheckProviderFactory.swift
//  Dual
//
//  Created by Khoi Nguyen on 9/7/21.
//

import Foundation
import Firebase
import FirebaseAppCheck

class YourSimpleAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
          return AppAttestProvider(app: app)
        } else {
          return DeviceCheckProvider(app: app)
        }
      }
    
}
