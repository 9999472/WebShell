//
//  StringExtension.swift
//  WebShell
//
//  Created by Wesley de Groot on 17-01-16.
//  Copyright © 2016 WDGWV. All rights reserved.
//

import Foundation

/**
 Extensions for Strings
 */
public extension String {
    /**
     get string length
     */
    public var length: Int {
        get {
            return self.count
        }
    }
    
    /**
     contains
     - Parameter s: String to check
     - Returns: true/false
     */
    public func contains(_ s: String) -> Bool {
        return self.range(of: s) != nil ? true : false
    }
    
    /**
     Replace
     - Parameter target: String
     - Parameter withString: Replacement
     - Returns: Replaced string
     */
    public func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
     Character At Index
     - Parameter index: The index
     - Returns Character
     */
    func characterAtIndex(_ index: Int) -> Character! {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur += 1
        }
        return nil
    }
    
    /**
     Add subscript
     
     - Parameter i: Index
     */
    public subscript(i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    /**
     Add subscript
     
     - Parameter r: Range
     */
    public subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - 1)
            
            return String(self[startIndex..<endIndex])
        }
    }
    
    
    /**
     Add subscript (swift 3)
     
     - Parameter r: ClosedRange
     */
    public subscript(r: ClosedRange<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - 1)
            
            return String(self[startIndex..<endIndex])
        }
    }
}
