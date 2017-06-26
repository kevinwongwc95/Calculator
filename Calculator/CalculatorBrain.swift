//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kevin on 6/25/17.
//  Copyright © 2017 Calculator. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    
    //on initializtion accumulator is NOT SET, use optional
    private var accumulator: Double?
    
    mutating func performOperation(_ symbol: String) {
        switch symbol {
        case "π" : accumulator = Double.pi
        
        case "√" :
            if let operand = accumulator {
                accumulator = sqrt(operand)
            }
            
        default:
            break
            
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    //getter variable
    var result: Double? {
        get {
            return accumulator
        }
    }
}
