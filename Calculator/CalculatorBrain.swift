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
    
    
    private enum Operation {
        case unaryOperation((Double)->Double)
        case constant(Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let firstOperand : Double
        let function: (Double, Double) -> Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    var resultIsPending : Bool {
        get {
            return pendingBinaryOperation == nil ? false :  true
            
        }
    }
    
    var description : String = "0"
    
    
    //dictionary of operation string name to the double value
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "tan" : Operation.unaryOperation(tan),
        "±" : Operation.unaryOperation({(op1) in return -op1}),
        "×" : Operation.binaryOperation({(op1, op2) in return op1 * op2}),
        "+" : Operation.binaryOperation({(op1, op2) in return op1 + op2}),
        "-" : Operation.binaryOperation({(op1, op2) in return op1 - op2}),
        "÷" : Operation.binaryOperation({(op1, op2) in return op1/op2}),
        "=" : Operation.equals
    ]
    
    mutating func performPendingBinaryOperation() {
        if(pendingBinaryOperation != nil && accumulator != nil) {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            
            //done calculating binary operation
            pendingBinaryOperation = nil
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let x = operations[symbol] {
            switch x {
            case .unaryOperation(let function) :
                if let p = accumulator {
                    accumulator = function(p)
                }
                
            case .constant(let a) :
                accumulator = a
                
            case .binaryOperation(let a) :
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator!, function: a)
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
            }
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
    
    mutating func clear() {
        description = "0"
        pendingBinaryOperation = nil
    }
}
