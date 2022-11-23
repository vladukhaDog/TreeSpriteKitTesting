//
//  Double + extension.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 23.11.2022.
//

import Foundation
extension Double{
    var clean: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesSignificantDigits = false
        numberFormatter.groupingSeparator = ""
        // Rounding down drops the extra digits without rounding.
        numberFormatter.roundingMode = .down
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""//String(format: "%.2f", )// self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(self)
    }
}
