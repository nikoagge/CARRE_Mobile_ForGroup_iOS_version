//
//  CheckIfStringcontainsOnlyNumberss.swift
//  Carre1.0
//
//  Created by Nikolas on 08/06/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import Foundation
import UIKit


extension String {
    
    
    func containsOnlyNumbers() -> Bool {
        
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums) ? true : false
    }
    
    
    func isNumeric() -> Bool {
        
        let numberRegEx = ".*[0-9]+.*"
        let testCase = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        
        return testCase.evaluate(with: self)
    }
    
    
    func containsExactValue(forStringToFind stringToFind: String, inStringToSearch stringToSearch: String) -> Bool {
        
        let expression = "\\b\(stringToFind)\\b"
        
        return stringToSearch.range(of: expression, options: .regularExpression) != nil
    }
    
    
    func containsExactString(forWord word: String) -> Bool {
        
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
    
    
    func convertStringToInt(forString string: String) -> Int {
        
        return Int(string)!
    }
}
