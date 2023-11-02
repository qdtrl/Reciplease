//
//  UsefullFunc.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 02/10/2023.
//

import Foundation
import UIKit

extension Int16 {
    func getTimeIntoString() -> String {
        var timeInString: String
        if self > 60 {
            timeInString = "\(self / 60)h"
            if self % 60 < 10 {
                timeInString += "0\(self % 60)"
            } else {
                timeInString += "\(self % 60)"
            }
        } else {
            timeInString = "\(self)m"
        }
        return timeInString
    }
}
