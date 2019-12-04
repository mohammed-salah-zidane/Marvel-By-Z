//
//  String.swift
//  Marvel
//
//  Created by prog_zidane on 12/3/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
extension String {
    func subString(from: Int, to: Int) -> String {
        
        if from < 0 {
            return ""
        }
        if let indexRange = Range<String.Index>(NSRange(location: from, length: to - from), in: self) {
            return String(self[indexRange])
            
        }else {
            return ""
        }
        
    }
}
