//
//  Credentials.swift
//  KKid
//
//  Created by Justin Kumpe on 9/26/20.
//  Copyright © 2020 Justin Kumpe. All rights reserved.
//

import Foundation
import Keys

struct APICredentials {
    let kkid: KKid

// MARK: KKid Credentials
    struct KKid {
        static let username = KKidKeys().kKid_username
        static let apiPassword = KKidKeys().kKid_apiPassword
    }

// MARK: Google AdMob Creds
    struct GoogleAdMob {
        static let homeScreenBannerID = KKidKeys().googleAdMob_homeScreenBannerID
    }

}
