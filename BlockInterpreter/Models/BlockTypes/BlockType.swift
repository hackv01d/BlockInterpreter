//
//  BlockType.swift
//  BlockInterpreter
//

import Foundation

enum BlockType {
    case output
    case flow
    case variable
    case condition
    case loop(LoopType)
    case function
    case returnBlock
    case arrayMethod
    
    func isEqualTo(_ otherType: BlockType) -> Bool {
        switch (self, otherType) {
        case (.output, .output):
            return true
        case (.flow, .flow):
            return true
        case (.function, .function):
            return true
        case (.returnBlock, .returnBlock):
            return true
        case (.arrayMethod, .arrayMethod):
            return true
        case (.variable, .variable):
            return true
        case (.condition, .condition):
            return true
        case (.loop(.whileLoop), .loop(.whileLoop)):
            return true
        case (.loop(.forLoop), .loop(.forLoop)):
            return true
        default:
            return false
        }
    }
}
