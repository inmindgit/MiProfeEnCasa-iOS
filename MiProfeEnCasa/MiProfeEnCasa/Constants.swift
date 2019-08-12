//
//  Constants.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import Foundation

struct Constants {
    struct NotificationKey {

    }
    
    struct UserDefaults {
        static let kIsUserLoggedIn = "kIsUserLoggedIn"
    }
 
    struct Backend
    {
        static let kUrl = "https://dev.limit.cool/ws/"
        static let kPort = ""
        static let kEmail = ""
        static let kStoreUrl = ""
    }
    
    struct RequestStatus
    {
        static let kRequestNotReaded = 1
        static let kRequestReaded = 2
        static let kRequestAccepted = 3
        static let kRequestPendingPayment = 5
        static let kRequestEnded = 7
        static let kRequestExecuted = 8
        static let kRequestPreAccepted = 9
    }
}


