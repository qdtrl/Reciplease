//
//  RecipleaseController.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import UIKit

class RecipleaseController: UIViewController {
    private let reciplease = RecipleaseService()
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        //        amountChoice.resignFirstResponder()
        //
        //        guard let amountResult = amountChoice.text else {
        //            return
        //        }
        //
        //        amount = amountResult
        //
        //        currency.getChangeFor(currency: currencyChoice, amount: amount) { (success, currencyChangeData) in
        //            guard let currencyChange = currencyChangeData, success == true else {
        //               return
        //            }
        //            DispatchQueue.main.async {
        //                self.changeRate.text = "\(currencyChange.result)$USD"
        //            }
        //         }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reciplease.getRecipe {(success, recipe) in
            
            
        }
//        if !networkManager.isReachable {
//            networkStatus.text = "Veuillez vous connectez à internet pour utiliser l'application"
//        } else {
//            networkStatus.isHidden = true
//            currencyPicker.dataSource = self
//            currencyPicker.delegate = self
//            currency.getSymbols { (success, symbolsData) in
//                guard let symbolsData = symbolsData, success == true else {
//                    return
//                }
//                self.updateSymbols(symbols: symbolsData)
//                DispatchQueue.main.async {
//                    self.currencyPicker.reloadAllComponents()
//                }
//                self.currency.getChangeFor(currency: self.currencyChoice, amount: self.amount) { (success, currencyChangeData) in
//                    guard let currencyChange = currencyChangeData, success == true else {
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        self.changeRate.text = "\(currencyChange.result)$USD"
//                    }
//                }
//            }
//        }
    }
    
//    private func updateSymbols(symbols: CurrencySymbols) -> Void {
//        currencyCodes = []
//
//        for code in symbols.symbols {
//            currencyCodes.append("\(code.key) - \(code.value)")
//        }
//
//        currencyCodes.sort()
//        guard let code = currencyCodes[0].split(separator: " ").first else {
//            return
//        }
//
//        currencyChoice = "\(code)"
//    }
}
