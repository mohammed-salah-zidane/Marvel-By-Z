//
//  Array.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
