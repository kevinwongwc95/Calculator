//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kevin on 6/25/17.
//  Copyright © 2017 Calculator. All rights reserved.
//

import Foundation

struct CalculatorBrain {


    
    
    private enum Operation {
        case unaryOperation((Double)->Double, (String)->String)
        case constant(Double)
        case binaryOperation((Double, Double)-> Double, (String, String)->String)
        case equals
    }
    
    private enum Element {
        case operation(String)
        case operand(Double)
        case variable(String)
    }
    
    private var stack = [Element]()
    
    
    
    //dictionary of operation string name to the double value
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, {(a)-> String in return "√( \(a) )"}),
        "sin" : Operation.unaryOperation(sin, {(a)-> String in return "sin(\(a))"}),
        "cos" : Operation.unaryOperation(cos, {(a)-> String in return "cos(\(a))"}),
        "tan" : Operation.unaryOperation(tan, {(a)-> String in return "tan(\(a))"}),
        "±" : Operation.unaryOperation({(op1) in return -op1}, {(a)-> String in return "-(\(a))"}),
        "×" : Operation.binaryOperation(*, {(a,b)-> String in return "\(a) * \(b)"}),
        "+" : Operation.binaryOperation(+, {(a,b)-> String in return "\(a) + \(b)"}),
        "-" : Operation.binaryOperation(-, {(a,b)-> String in return "\(a) - \(b)"}),
        "÷" : Operation.binaryOperation(/, {(a,b)-> String in return "\(a) ÷ \(b)"}),
        "=" : Operation.equals
    ]
    
    mutating func setOperand(operand named: Double) {
        stack.append(Element.operand(named))
    }
    
    mutating func performOperation(operation named: String) {
        stack.append(Element.operation(named))
    }
    
    mutating func setVariable(variable named : String) {
        stack.append(Element.variable(named))
    }
    
    func evaluate(using variable: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        
        //on initializtion accumulator is NOT SET, use optional
        var accumulator: (Double, String)?
        
        struct PendingBinaryOperation {
            let firstOperand : (Double,String)
            let function: (Double, Double) -> Double
            let description : (String, String) -> String
            
            func perform(with secondOperand: (Double, String)) -> (Double, String) {
                return (function(firstOperand.0, secondOperand.0), description(firstOperand.1,secondOperand.1))
            }
            
        }
        
        var pendingBinaryOperation : PendingBinaryOperation?
        
        var resultIsPending : Bool {
            get {
                return pendingBinaryOperation == nil ? false :  true
                
            }
        }
        
        func performPendingBinaryOperation() {
            if(pendingBinaryOperation != nil && accumulator != nil) {
                accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                pendingBinaryOperation = nil
            }
        }
        
        var result : Double? {
            if accumulator != nil {
                return accumulator!.0
            }
            
            return nil
        }
        
        var description : String? {
            
            if nil != pendingBinaryOperation {
                return pendingBinaryOperation!.description(pendingBinaryOperation!.firstOperand.1, accumulator?.1 ?? "")
            }
            
            else {
                return accumulator?.1
            }
        }
        


        
        
        for i in stack {
            switch i {
            case .operation(let symbol):
                if let x = operations[symbol] {
                    switch x {
                    case .unaryOperation(let function, let description) :
                        if let p = accumulator {
                            accumulator = (function(p.0), description(p.1))
                        }
                        
                    case .constant(let b) :
                        accumulator = (b,symbol)
                        
                    case .binaryOperation(let function, let description) :
                        performPendingBinaryOperation()
                        
                        if accumulator != nil {
                            pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator!, function: function, description: description)
                            accumulator = nil
                        }
                        
                    case .equals:
                        performPendingBinaryOperation()
                        
                    }
                }
                
            case .operand(let a):
                accumulator = (a, "\(a)")
           
            case .variable(let a):
                if let x = variable?[a] {
                    accumulator = (x, "\(x)")
                }
                
                else {
                    accumulator = (0, "0")
                }
            }
        }
        
        return (result, resultIsPending, description ?? "")
    }
    
    
}
