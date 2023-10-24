//
//  UsefullFunc.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 02/10/2023.
//

import Foundation
import UIKit

func getTimeIntoString(time:Int16) -> String {
    var timeInString: String
    if time > 60 {
        timeInString = "\(time/60)h"
        if time % 60 < 10 {
            timeInString += "0\(time % 60)"
        } else {
            timeInString += "\(time % 60)"
        }
    } else {
        timeInString = "\(time)m"
    }
    return timeInString
}

