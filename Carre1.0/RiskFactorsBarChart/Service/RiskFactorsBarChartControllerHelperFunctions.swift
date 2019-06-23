//
//  RiskFactorsBarChartControllerHelperFunctions.swift
//  Carre1.0
//
//  Created by Nikolas on 18/06/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import Foundation
import UIKit
import Charts


extension RiskFactorsBarChartController {

        
    func checkIfStringContainsParenthesis(forStringToCheck stringToCheck: String) -> Bool {
        
        if stringToCheck.contains("( ") {
            
            return true
        } else {
            
            return false
        }
    }
    
    
    func checkIfStringContainsApostrophe(forStringToCheck stringToCheck: String) -> Bool {
        
        if stringToCheck.contains("'") {
            
            return true
        } else {
            
            return false
        }
    }
    
    
    func removeParenthesisFromString(forOriginalString originalString: String) -> String {
        
        var originalStringSeparatedArray = originalString.components(separatedBy: CharacterSet.init(charactersIn: " ()"))
        var returnedString = String()
        
        for originalStringSeparatedArrayElement in originalStringSeparatedArray {
            
            if originalStringSeparatedArrayElement != "" {
                
                returnedString = "\(returnedString) \(originalStringSeparatedArrayElement)"
            }
        }
        let i = returnedString.firstIndex(of: " ")
        returnedString.remove(at: i!)
//        returnedString.remove
        
        return returnedString
    }
    
    
    func removeApostropheFromString(forOriginalString originalString: String) -> String {
        
        let returnedString = originalString.replacingOccurrences(of: "'", with: "")
        
        return returnedString
    }
    

    func decideOperator(forGivenString givenString: String) -> Int {
        
        switch givenString {
        case "=":
            return 0
            
        case ">":
            return 1
            
        case "<":
            return 2
            
        case ">=":
            return 3
            
        case "<=":
            return 4
            
        default:
            return 5
        }
    }

    
    func removeParenthesesFromRiskEvidencesConditionArray(forRiskEvidencesConditionArray riskEvidencesConditionArray: [String]) -> [String] {
        
        var riskEvidencesConditionArrayWithoutParentheses = riskEvidencesConditionArray
        for riskEvidenceCondition in riskEvidencesConditionArrayWithoutParentheses {
            
            if checkIfStringContainsParenthesis(forStringToCheck: riskEvidenceCondition) {
                
                riskEvidencesConditionArrayWithoutParentheses[riskEvidencesConditionArrayWithoutParentheses.firstIndex(of: riskEvidenceCondition)!] = removeParenthesisFromString(forOriginalString: riskEvidenceCondition)
            }
        }
        
        return riskEvidencesConditionArrayWithoutParentheses
    }

    
    func removeApostropheFromRiskEvidencesConditionArray(forRiskEvidencesConditionArray riskEvidencesConditionArray: [String]) -> [String] {
        
        var riskEvidencesConditionArrayWithoutApostrophe = riskEvidencesConditionArray
        for riskEvidenceCondition in riskEvidencesConditionArrayWithoutApostrophe {
            
            if checkIfStringContainsApostrophe(forStringToCheck: riskEvidenceCondition) {
                
                riskEvidencesConditionArrayWithoutApostrophe[riskEvidencesConditionArrayWithoutApostrophe.firstIndex(of: riskEvidenceCondition)!] = removeApostropheFromString(forOriginalString: riskEvidenceCondition)
            }
        }
        
        return riskEvidencesConditionArrayWithoutApostrophe
    }

    
    func separateElementsOfRiskEvidencesConditionArray(forRiskEvidencesConditionArray riskEvidencesConditionArray: [String]) -> [[String]] {
        
        var riskEvidencesConditionSeparated = [[String]]()
        var helpStr = String()
        let separator = CharacterSet.whitespaces
        
        for riskEvidenceCondition in riskEvidencesConditionArray {
            
            let riskEvidenceConditionSeparated = riskEvidenceCondition.components(separatedBy: separator)
            var helpArr = [String]()
            
            for riskEvidenceConditionSeparatedComponent in riskEvidenceConditionSeparated {
                
                switch riskEvidenceConditionSeparatedComponent {
                    
                case "AND":
                    
                    let i = helpStr.firstIndex(of: " ")
                    
                    if i != nil {
                        
                        helpStr.remove(at: i!)
                    }
                    
                    helpArr.append(helpStr)
                    helpStr = ""
                    let operatorValue = "AND"
                    helpArr.append(operatorValue)
                    
                case "OR":
                    
                    let i = helpStr.firstIndex(of: " ")
                    
                    if i != nil {
                        
                        helpStr.remove(at: i!)
                    }
                    
                    helpArr.append(helpStr)
                    helpStr = ""
                    let operatorValue = "OR"
                    helpArr.append(operatorValue)
                    
                default:
                    helpStr = "\(helpStr) \(riskEvidenceConditionSeparatedComponent)"
                }
                if riskEvidenceConditionSeparatedComponent == riskEvidenceConditionSeparated.last {
                    
                    let i = helpStr.firstIndex(of: " ")
                    helpStr.remove(at: i!)
                    helpArr.append(helpStr)
                    helpStr = ""
                    riskEvidencesConditionSeparated.append(helpArr)
                }
            }
        }
        
        return riskEvidencesConditionSeparated
    }
    
    
    func checkIfPHRsObservablesAndValuesMatchRVsCondition(forRiskEvidencesCondition riskEvidencesCondition: [[String]], forObservablesAndValues observablesAndValues: [String]) {
        
        for riskEvidenceConditionArray in riskEvidencesCondition {
            
            for riskEvidenceConditionElement in riskEvidenceConditionArray {
                
                if riskEvidenceConditionArray.count == 1 {
                    
                    let separator = CharacterSet.whitespaces
                    let riskEvidenceConditionElementSeparated = riskEvidenceConditionElement.components(separatedBy: separator)
                    
                    if !riskEvidenceConditionElementSeparated[2].containsOnlyNumbers() {
                        
                        for observableValue in observablesAndValues {
                            
                            let observableValueSeparated = observableValue.components(separatedBy: separator)
                            
                            if riskEvidenceConditionElementSeparated[0] == observableValueSeparated[0] && riskEvidenceConditionElementSeparated[2] == observableValueSeparated[2] {
                                
                                positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                break
                            }
                        }
                    } else {
                        var riskElementSeparatedIntValue = Int(riskEvidenceConditionElementSeparated[2])!
                        for observableValue in observablesAndValues {
                            
                            let observableValueSeparated = observableValue.components(separatedBy: separator)
                            
                            if observableValueSeparated[2].containsOnlyNumbers() {
                                
                                var observableValueSeparatedIntValue = Int(observableValueSeparated[2])!
                                
                                if observableValueSeparated[0] == riskEvidenceConditionElementSeparated[0] {
                                    
                                    let intToDecideOperator = decideOperator(forGivenString: riskEvidenceConditionElementSeparated[1])
                                    
                                    
                                    switch intToDecideOperator {
                                    case 0:
                                        if observableValueSeparatedIntValue == riskElementSeparatedIntValue {
                                            
                                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                        }
                                        
                                    case 1:
                                        if observableValueSeparatedIntValue > riskElementSeparatedIntValue {
                                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                        }
                                        
                                    case 2:
                                        if observableValueSeparatedIntValue < riskElementSeparatedIntValue {
                                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                        }
                                        
                                    case 3:
                                        if observableValueSeparatedIntValue >= riskElementSeparatedIntValue {
                                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                        }
                                        
                                    case 4:
                                        
                                        if observableValueSeparatedIntValue <= riskElementSeparatedIntValue {
                                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                        }
                                    default:
                                        print("don't care")
                                    }
                                }
                            }
                            
                        }
                    }
                } else {
                    var atLeastOneTrue = Bool()
                    var numberOfTrueChecks = 0
                    let helpArr = riskEvidenceConditionArray.filter { $0 == "AND" || $0 == "OR" }
                    
                    var goal = riskEvidenceConditionArray.count - helpArr.count
                    
                    for riskEvidenceConditionElement in riskEvidenceConditionArray {
                        
                        if riskEvidenceConditionElement == "OR" {
                            
                            if !atLeastOneTrue {
                                
                                continue
                            } else {
                                
                                positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                                break
                            }
                        }
                        
                        if riskEvidenceConditionElement != "AND" && riskEvidenceConditionElement != "OR" && riskEvidenceConditionElement != "" {
                            
                            let separator = CharacterSet.whitespaces
                            let riskEvidenceConditionElementSeparated = riskEvidenceConditionElement.components(separatedBy: separator)
                            
                            if !riskEvidenceConditionElementSeparated[2].containsOnlyNumbers() {
                                
                                for observableValue in observablesAndValues {
                                    
                                    let observableValueSeparated = observableValue.components(separatedBy: separator)
                                    
                                    if !observableValueSeparated[2].containsOnlyNumbers() &&  riskEvidenceConditionElementSeparated[0] == observableValueSeparated[0] && riskEvidenceConditionElementSeparated[2] == observableValueSeparated[2] {
                                        
                                        atLeastOneTrue = true
                                        numberOfTrueChecks = numberOfTrueChecks + 1
                                    }
                                }
                            } else {
                                var riskElementSeparatedFloatValue = Float(riskEvidenceConditionElementSeparated[2])!
                                for observableValue in observablesAndValues {
                                    
                                    let observableValueSeparated = observableValue.components(separatedBy: separator)
                                    
                                    if observableValueSeparated[2].containsOnlyNumbers() {
                                        
                                        var observableValueSeparatedFloatValue = Float(observableValueSeparated[2])!
                                        
                                        if observableValueSeparated[0] == riskEvidenceConditionElementSeparated[0] {
                                            
                                            let intToDecideOperator = decideOperator(forGivenString: riskEvidenceConditionElementSeparated[1])
                                            
                                            
                                            switch intToDecideOperator {
                                            case 0:
                                                if observableValueSeparatedFloatValue == riskElementSeparatedFloatValue {
                                                    
                                                    atLeastOneTrue = true
                                                    numberOfTrueChecks = numberOfTrueChecks + 1
                                                }
                                                
                                            case 1:
                                                if observableValueSeparatedFloatValue > riskElementSeparatedFloatValue {
                                                    
                                                    atLeastOneTrue = true
                                                    numberOfTrueChecks = numberOfTrueChecks + 1
                                                }
                                                
                                            case 2:
                                                if observableValueSeparatedFloatValue < riskElementSeparatedFloatValue {
                                                    
                                                    atLeastOneTrue = true
                                                    numberOfTrueChecks = numberOfTrueChecks + 1
                                                }
                                                
                                            case 3:
                                                if observableValueSeparatedFloatValue >= riskElementSeparatedFloatValue {
                                                    
                                                    atLeastOneTrue = true
                                                    numberOfTrueChecks = numberOfTrueChecks + 1
                                                }
                                                
                                            case 4:
                                                
                                                if observableValueSeparatedFloatValue <= riskElementSeparatedFloatValue {
                                                    
                                                    atLeastOneTrue = true
                                                    numberOfTrueChecks = numberOfTrueChecks + 1
                                                }
                                            default:
                                                print("don't care")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if numberOfTrueChecks == goal {
                            
                            positions.append(riskEvidencesCondition.firstIndex(of: riskEvidenceConditionArray)!)
                        }
                    }
                }
            }
        }
    }
    
    
    func setupArraysToWork() {
        
        self.initialRiskEvidencesCondition = CarreDatabaseService.shared.getRiskEvidencesConditionArray()
        self.riskEvidencesRiskFactorSource = CarreDatabaseService.shared.getRiskEvidencesRiskFactorSource()
        self.riskEvidencesRiskFactorTarget = CarreDatabaseService.shared.getRiskEvidencesRiskFactorTarget()
        self.riskEvidencesRatioValue = CarreDatabaseService.shared.getRiskEvidencesRatioValue()
        self.riskEvidencesCondition = removeParenthesesFromRiskEvidencesConditionArray(forRiskEvidencesConditionArray: self.initialRiskEvidencesCondition)
        self.riskEvidencesCondition = removeApostropheFromRiskEvidencesConditionArray(forRiskEvidencesConditionArray: self.riskEvidencesCondition)
        self.riskEvidencesConditionArrayOfArrays = separateElementsOfRiskEvidencesConditionArray(forRiskEvidencesConditionArray: self.riskEvidencesCondition)
        self.riskEvidencesRiskFactorSource = CarreDatabaseService.shared.getRiskEvidencesRiskFactorSource()
        
        self.riskElementsId = CarreDatabaseService.shared.getRiskElementsId()
        self.riskElementsName = CarreDatabaseService.shared.getRiskElementsName()
    }
    
    
    func matchIndexesWithRiskFactorsSourceRiskFactorsTargetAndRatioValue() {
        
        self.personalHealthRecordsObservablesAndValues = CarreDatabaseService.shared.getPersonalHealthRecordsObservablesAndValues()
        checkIfPHRsObservablesAndValuesMatchRVsCondition(forRiskEvidencesCondition: self.riskEvidencesConditionArrayOfArrays, forObservablesAndValues: self.personalHealthRecordsObservablesAndValues)

        for position in positions {
            
            if !self.riskFactorsSourceMatched.contains(riskEvidencesRiskFactorSource[position]) {

                self.riskFactorsSourceMatched.append(riskEvidencesRiskFactorSource[position])
            }
        }
    }
    
    
    func fillRiskFactorsSourceValuesForPickerView() {
        
        for riskFactorSource in riskFactorsSourceMatched {
            
            for riskElementId in riskElementsId {
                
                if riskFactorSource == riskElementId {
                   
                    let index = riskElementsId.firstIndex(of: riskElementId)!
                    if !riskFactorsSourceValuesForPickerView.contains(riskElementsName[index]) {
                        
                        riskFactorsSourceValuesForPickerView.append(riskElementsName[index])
                    }
                }
            }
        }
        
        self.riskFactorsSourcePickerView.reloadAllComponents()
    }
    
    
    func populateSpinner() {
       
        self.personalHealthRecordsObservablesAndValues.removeAll()
        self.riskFactorsSourceMatched.removeAll()
        riskFactorsSourceValuesForPickerView.removeAll()
        matchIndexesWithRiskFactorsSourceRiskFactorsTargetAndRatioValue()
        fillRiskFactorsSourceValuesForPickerView()
        self.riskFactorsSourcePickerView.reloadAllComponents()
    }
    
    
    func helpPopulateSpinnerFuncAfterUpdateOrDelete() {
        
        self.personalHealthRecordsObservablesAndValues.removeAll()
        self.riskFactorsSourceMatched.removeAll()
        riskFactorsSourceValuesForPickerView.removeAll()
        populateSpinner()
    }
    
    
    func setupRiskFactorsBarChart(forRiskFactorTargets riskFactorsTarget: [String], forRiskFactorsRatioValue riskFactorsRatioValue: [Double]) {
        
        riskFactorsBarChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<riskFactorsTarget.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: riskFactorsRatioValue[i])
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Risk ratio values")
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        riskFactorsBarChartView.data = chartData
    }
    
    
    func fillRiskFactorsTargetMatched(forRiskFactorSource riskFactorSource: String) -> [String] {
        
        var riskFactorsTarget = [String]()
        
        for arr in riskEvidencesRiskFactorTarget {
            
            if arr[0] == riskFactorSource {
                
                riskFactorsTarget.append(arr[1])
            }
        }
        
        return riskFactorsTarget
    }
    
    
    func fillRiskFactorsRatioValueMatched(forRiskFactorSource riskFactorSource: String) -> [Double] {
        
        var riskFactorsRatioValue = [Double]()
        
        for arr in riskEvidencesRatioValue {
            
            if arr[0] == riskFactorSource {
                
                riskFactorsRatioValue.append(Double(arr[1]) as! Double)
            }
        }
        
        return riskFactorsRatioValue
    }
}
