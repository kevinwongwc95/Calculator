//
//  ViewController.swift
//  Calculator
//
//  Created by Kevin on 3/29/17.
//  Copyright © 2017 Calculator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var steps: UILabel!
    
    
    var userIsInTheMiddleOfTyping = false
    
    var decimalClicked = false
    
    //computed property
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        
        if userIsInTheMiddleOfTyping {
            
            //check if the digit clicked was the decimal point
            
            if digit == "." {
                if decimalClicked == false {
                    decimalClicked = true
                    let textCurrentlyInDisplay = display.text
                    display.text = textCurrentlyInDisplay! + digit
                }
            }
            
            else {
                
                let textCurrentlyInDisplay = display.text
                display.text = textCurrentlyInDisplay! + digit
            }
            
        
        }
            
        else {
            
            //check to see if digit is a decimal point
            
            if digit != "." {
                display.text = digit
                userIsInTheMiddleOfTyping = true
            }
            
            
        }
        
    }
    

    
    @IBAction func performOperation(_ sender: UIButton) {
        
        decimalClicked = false
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        
        if let mathemeticalSymbol = sender.currentTitle {
            brain.performOperation(operation: mathemeticalSymbol)
            print(mathemeticalSymbol)
        }
        
        let evaluate = brain.evaluate()
        
        print(evaluate.isPending)
        
        if let result = evaluate.result {
            displayValue = result
            print(displayValue)
        }
        
        
        
        userIsInTheMiddleOfTyping = false;
        
        steps.text! = evaluate.isPending ? evaluate.description + " ..." : evaluate.description + " = "
        
    }
    
    @IBAction func clearScreen(_ sender: UIButton) {
        decimalClicked = false
        userIsInTheMiddleOfTyping = false
        
        display.text = "0"
        steps.text = " "
    }
    
}

