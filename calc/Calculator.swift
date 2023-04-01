//
//  Calculator.swift
//  calc
//
//  Created by Syafa Sofiena on 25/3/23.
//  Copyright © 2023 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    // Check if string is an operator
    func isOperator(_ op: String) -> Bool {
        return ["+", "-", "x", "/", "%"].contains(op)
    }
    
    // Get precedence of an operator
    func getPrecedence(_ op: String) -> Int {
        switch op {
        case "x", "/", "%":
            return 2
        case "+", "-":
            return 1
        default:
            return 0
        }
    }
    
    // Process operator on two integer numbers and return result
    // Checks for integer overflow and divide by zero errors
    func processOperator(_ op: String, _ lhs: Int, _ rhs: Int) throws -> Int {
        let result: Int
        switch op {
        case "+":
            result = lhs + rhs
        case "-":
            result = lhs - rhs
        case "x":
            result = lhs * rhs
        case "/":
            if rhs == 0 {
                throw ProgramError.divideByZero
            }
            result = lhs / rhs
        case "%":
            if rhs == 0 {
                throw ProgramError.divideByZero
            }
            result = lhs % rhs
        default:
            throw ProgramError.invalidExpression
        }
        if result > Int.max || result < Int.min {
            throw ProgramError.outOfBounds
        }
        return result
    }
    
    // Main calculation using the Shunting-Yard Algorithm - method to parse mathematical expressions
    /// Step 1: Convert infix expression to postfix (or Reverse Polish Notation)
    /// Step 2: Evaluate postfix expression and return result

    func convertToPostfix(_ infix: [String]) -> [String] {
        var postfix: [String] = []
        var operatorArray: [String] = []
        for token in infix {
            if !isOperator(token) { // if token is a number, push to output array
                postfix.append(token)
            } else {
                // while the operator array is not empty, and the top operator has higher or equal precedence than current operator
                while !operatorArray.isEmpty && getPrecedence(operatorArray.last ?? "") >= getPrecedence(token) {
                    postfix.append(operatorArray.popLast() ?? "") // pop the top operator and push to output array
                }
                operatorArray.append(token) // push current operator to operator array
            }
        }
        while !operatorArray.isEmpty { // pop any remaining operators and push to output array
            postfix.append(operatorArray.popLast() ?? "")
        }
        return postfix
    }
    
    func evaluatePostfix(_ postfix: [String]) throws -> Int {
        var resultArray: [Int] = []
        for token in postfix {
            if !isOperator(token) { // if token is a number, push to result array
                resultArray.append(Int(token) ?? 0)
            } else { // pop the top two operands from result array and process the operator
                guard let rhs = resultArray.popLast() else { return 0 }
                guard let lhs = resultArray.popLast() else { return 0 }
                let result: Int = try processOperator(token, lhs, rhs)
                resultArray.append(result) // push result to result array
            }
        }
        return resultArray[0] // return final result after all tokens in postfix have been processed
    }
    
    func calculate(_ args: [String]) throws -> Int {
        let postfix = convertToPostfix(args)
        return try evaluatePostfix(postfix)
    }
    
}

