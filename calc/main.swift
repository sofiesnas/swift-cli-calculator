//
//  main.swift
//  calc
//
//  Created by Syafa Sofiena on 25/3/23.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

// Define enum for possible errors
enum ProgramError: Error {
    case outOfBounds
    case divideByZero
    case noArgumentsProvided
    case invalidArgument(String)
    case invalidExpression
    
    var message: String {
        switch self {
        case .outOfBounds:
            return "Numeric out of bounds"
        case .divideByZero:
            return "Division by zero"
        case .noArgumentsProvided:
            return "No arguments provided!\nFormat is [number operator ... number]. Integer numbers only. Operators include +,-,x,/,%."
        case .invalidArgument(let arg):
            return "Invalid argument \(arg)\nFormat is [number operator ... number]. Integer numbers only. Operators include +,-,x,/,%."
        case .invalidExpression:
            return "Invalid expression\nFormat should [number operator ... number]. Integer numbers only. Operators include +,-,x,/,%."
        }
    }
}

// Get command line arguments
var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

let inputValidation = InputValidation(args)
let calculator = Calculator()

// Validate input arguments, calculate, and print result while handling any errors thrown
do {
    try inputValidation.validate()
    let result = try calculator.calculate(args)
    print(result)
} catch let error as ProgramError {
    print("Error: \(error.message)")
    exit(1)
} catch {
    print("Unexpected error occurred")
    exit(1)
}
