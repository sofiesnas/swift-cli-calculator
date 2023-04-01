//
//  InputValidation.swift
//  calc
//
//  Created by Syafa Sofiena on 25/3/23.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

// Define class to evaluate input arguments as valid infix expression
class InputValidation {
    var args: [String]

    init (_ args: [String]) {
        self.args = args
    }
    
    func isNumber(_ i: Int) -> Bool {
        return Int(args[i]) != nil
    }
    
    func isOperator(_ i: Int) -> Bool {
        switch args[i] {
        case "+", "-", "x", "/", "%":
            return true
        default:
            return false
        }
    }
    
    // Validate input arguments
    func validate() throws {
        // Throw error if no arguments provided
        guard !args.isEmpty else { throw ProgramError.noArgumentsProvided }
        
        // Throw error if first arg is not a number
        guard isNumber(0) else { throw ProgramError.invalidExpression }
        // Check that each odd-indexed arg is operator and even-indexed is number
        var i = 1
        while i < args.count - 1 {
            guard isOperator(i) && isNumber(i + 1) else { throw ProgramError.invalidExpression }
            i += 2
        }
        
        var numberArray: [Int] = []
        var operatorArray: [String] = []
        for arg in args {
            if let number = Int(arg) {
                numberArray.append(number)
            } else if arg.count == 1 && "+-/x%".contains(arg) {
                operatorArray.append(arg)
            } else {
                throw ProgramError.invalidArgument(arg)
            }
        }
        // Throw error if number of operators is not one less than number of operands
        guard numberArray.count == operatorArray.count + 1 else { throw ProgramError.invalidExpression }
    }
}

