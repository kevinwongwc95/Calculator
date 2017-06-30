//
//  ViewController.swift
//  Calculator
//
//  Created by Kevin on 3/29/17.
//  Copyright © 2017 Calculator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
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
            let textCurrentlyInDisplay = display.text
            display.text = textCurrentlyInDisplay! + digit
        }
            
        else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    
    private var brain = CalculatorBrain()

    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathemeticalSymbol = sender.currentTitle {
            brain.performOperation(mathemeticalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
        userIsInTheMiddleOfTyping = false;
        
    }
    
    
    
}

