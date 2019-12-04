//
//  Commons.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


struct  Commons {
   static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    static let apiPublicKey = "1951bc8fc24c16592930f688c6df1581"
   static let apiPrivateKey = "76cb8d0bd88b49abe3e4d049e6064518062f998c"
   static let baseUrl = "https://gateway.marvel.com:443/v1/public/"
   static let characterUrl = baseUrl + "characters"
   static let comicsUrl = baseUrl + "comics"
   static let seriesUrl = baseUrl + "series"
   static let eventsUrl = baseUrl + "events"
   static let storiesUrl = baseUrl + "stories"
}
//b764ea16460209cd4d6eeab3a5955965
//private : a541787e669a846a7514378ea62c68910db84b1b
