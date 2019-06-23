//
//  CarreDatabaseService.swift
//  Carre1.0
//
//  Created by Nikolas on 22/03/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import SQLite


class CarreDatabaseService {
    
    
    static let shared = CarreDatabaseService()
    
    let defaults = UserDefaults.standard
    
    let personalHealthRecordsTableExistKey = "personalHealthRecordsTableExist"
    
    var databaseConnection: Connection!
    
    let riskElementsTable = Table("riskElements")
    let riskElementsTableId = Expression<Int>("riskElementsableId")
    let riskElementIdColumn = Expression<String>("riskElementId")
    let diseaseColumn = Expression<String>("disease")
    let riskElementIsModifiableColumn = Expression<String>("riskElementIsModifiable")
    
    let observablesTable = Table("observables")
    let observablesTableId = Expression<Int>("observablesTableId")
    let observableIdColumn = Expression<String>("observableId")
    let observableNameColumn = Expression<String>("observableName")
    let riskValueColumn = Expression<Int>("riskValue")
    let observableIsModifiableColumn = Expression<String>("observableIsModifiable")
    let measurementElementColumn = Expression<String>("measurementElement")
    
    let riskEvidencesTable = Table("riskEvidences")
    let riskEvidencesTableId = Expression<Int>("riskEvidencesTableId")
    let riskEvidenceIdColumn = Expression<String>("riskEvidenceId")
    let riskEvidenceConditionColumn = Expression<String>("riskEvidenceCondition")
    let riskEvidenceConfidenceIntervalMaxColumn = Expression<Double>("riskEvidenceConfidenceIntervalMax")
    let riskEvidenceConfidenceIntervalMinColumn = Expression<Double>("riskEvidenceConfidenceIntervalMin")
    let riskEvidenceHasRiskFactorAssociationTypeColumn = Expression<String>("riskEvidenceHasRiskFactorAssociationType")
    let riskEvidenceHasRiskFactorSourceColumn = Expression<String>("riskEvidenceHasRiskFactorSource")
    let riskEvidenceHasRiskFactorTargetColumn = Expression<String>("riskEvidenceHasRiskFactorTarget")
    let riskEvidenceRatioTypeColumn = Expression<String>("riskEvidenceRatioType")
    let riskEvidenceRatioValueColumn = Expression<Double>("riskEvidenceRatioValue")
    let riskEvidenceRiskFactorColumn = Expression<String>("riskEvidenceRiskFactor")
    
    let measurementTypesTable = Table("measurementTypes")
    let measurementTypesTableId = Expression<Int>("measurementTypesTableId")
    let measurementTypeIdColumn = Expression<String>("measurementId")
    let measurementTypeDatatypeColumn = Expression<String>("measurementTypeDatatype")
    let measurementTypeLabelColumn = Expression<String>("measurementTypeLabel")
    let measurementTypeEnumValuesColumn = Expression<String>("measurementTypeEnumValues")
    let measurementTypeNameColumn = Expression<String>("measurementTypeName")
    
    let personalHealthRecordsTable = Table("personalHealthRecords")
    let personalHealthRecordsTableId = Expression<Int>("personalHealthRecordsTableId")
    let personalHealthRecordObservableNameColumn = Expression<String>("personalHealthRecordObservableName")
    let personalHealthRecordObservableValueColumn = Expression<String>("personalHealthRecordObservableValue")
    let personalHealthRecordDateAndTimeValueInsertionColumn = Expression<Date>("personalHealthRecordDateAndTimeValueInsertion")
    let personalHealthRecordObservableIdValueColumn = Expression<String>("personalHealthRecordObservableId")
    let personalHealthRecordRiskElementIdColumn = Expression<String>("personalHealthRecordRiskElementId")
    
    var riskElements = [[String: Any]]()
    var observables = [[String: Any]]()
    var riskEvidences = [[String: Any]]()
    var measurementTypes = [[String: Any]]()
    
    var carreBasicTablesExist = Bool()
    var myHealthRecordsTableExists = Bool()
    
    let reloadTableViewNotification = NSNotification.Name("reloadTableViewNotification")
    
    func connectToDatabase() {
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("carreDatabase").appendingPathExtension("sqlite3")
            
            let db = try Connection(fileUrl.path)
            
            databaseConnection = db
        } catch {
            
            print(error)
        }
    }
    
    
    func createAndFillBasicCarreTables() {
        
        let createRiskElementsTable = riskElementsTable.create { (table) in
            
            table.column(riskElementsTableId, primaryKey: true)
            table.column(riskElementIdColumn)
            table.column(diseaseColumn)
            table.column(riskElementIsModifiableColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createRiskElementsTable)
            
            print("RiskElements table created.")
        } catch {
            
            print(error)
        }
        
        for riskElementDictionary in self.riskElements {
            
            guard let riskElementId = riskElementDictionary["riskElementId"] as? String else { return }
            guard let riskElementDisease = riskElementDictionary["disease"] as? String else { return }
            guard let riskElementIsModifiable = riskElementDictionary["isModifiable"] as? String else { return }
            let insertRiskElement = self.riskElementsTable.insert(self.riskElementIdColumn <- riskElementId, self.diseaseColumn <- riskElementDisease, self.riskElementIsModifiableColumn <- riskElementIsModifiable)
            
            do {
                
                try self.databaseConnection.run(insertRiskElement)
                
            } catch {
                
                print(error)
            }
        }
        
        let createObservablesTable = observablesTable.create { (table) in
            
            table.column(observablesTableId, primaryKey: true)
            table.column(observableIdColumn)
            table.column(observableNameColumn)
            table.column(riskValueColumn)
            table.column(observableIsModifiableColumn)
            table.column(measurementElementColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createObservablesTable)
            
            print("Observables table created.")
        } catch {
            
            print(error)
        }
        
        for observableDictionary in self.observables {
            
            guard let observableId = observableDictionary["observableId"] as? String else { return }
            guard let observableName = observableDictionary["observableName"] as? String else { return }
            guard let riskValue = observableDictionary["riskValue"] as? Int else { return }
            guard let observableIsModifiable = observableDictionary["isModifiable"] as? String else { return }
            guard let measurementElement = observableDictionary["measurementElement"] as? String else { return }
            
            let insertObservable = self.observablesTable.insert(self.observableIdColumn <- observableId, self.observableNameColumn <- observableName, self.riskValueColumn <- riskValue, self.observableIsModifiableColumn <- observableIsModifiable, self.measurementElementColumn <- measurementElement)
            
            do {
                
                try self.databaseConnection.run(insertObservable)
            } catch {
                
                print(error)
            }
        }
        
        let createRiskEvidencesTable = riskEvidencesTable.create { (table) in
            
            table.column(riskEvidencesTableId, primaryKey: true)
            table.column(riskEvidenceIdColumn)
            table.column(riskEvidenceConditionColumn)
            table.column(riskEvidenceConfidenceIntervalMaxColumn)
            table.column(riskEvidenceConfidenceIntervalMinColumn)
            table.column(riskEvidenceHasRiskFactorAssociationTypeColumn)
            table.column(riskEvidenceHasRiskFactorSourceColumn)
            table.column(riskEvidenceHasRiskFactorTargetColumn)
            table.column(riskEvidenceRatioTypeColumn)
            table.column(riskEvidenceRatioValueColumn)
            table.column(riskEvidenceRiskFactorColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createRiskEvidencesTable)
            
            print("RiskEvidences table created.")
        } catch {
            
            print(error)
        }
        
        for riskEvidencesDictionary in self.riskEvidences {
            
            guard let riskEvidenceId = riskEvidencesDictionary["riskEvidenceId"] as? String else { return }
            guard let riskEvidenceCondition = riskEvidencesDictionary["riskEvidenceCondition"] as? String else { return }
            guard let riskEvidenceConfidenceIntervalMax = riskEvidencesDictionary["riskEvidenceConfidenceIntervalMax"] as? Double else { return }
            guard let riskEvidenceConfidenceIntervalMin = riskEvidencesDictionary["riskEvidenceConfidenceIntervalMin"] as? Double else { return }
            guard let riskEvidenceHasRiskFactorAssociationType = riskEvidencesDictionary["riskEvidenceHasRiskFactorAssociationType"] as? String else { return }
            guard let riskEvidenceHasRiskFactorSource = riskEvidencesDictionary["riskEvidenceHasRiskFactorSource"] as? String else { return }
            guard let riskEvidenceHasRiskFactorTarget = riskEvidencesDictionary["riskEvidenceHasRiskFactorTarget"] as? String else { return }
            guard let riskEvidenceRatioType = riskEvidencesDictionary["riskEvidenceRatioType"] as? String else { return }
            guard let riskEvidenceRatioValue = riskEvidencesDictionary["riskEvidenceRatioValue"] as? Double else { return }
            guard let riskEvidenceRiskFactor = riskEvidencesDictionary["riskEvidenceRiskFactor"] as? String else { return }
            
            let insertRiskEvidence = self.riskEvidencesTable.insert(self.riskEvidenceIdColumn <- riskEvidenceId, self.riskEvidenceConditionColumn <- riskEvidenceCondition, self.riskEvidenceConfidenceIntervalMaxColumn <- riskEvidenceConfidenceIntervalMax, self.riskEvidenceConfidenceIntervalMinColumn <- riskEvidenceConfidenceIntervalMin, self.riskEvidenceHasRiskFactorAssociationTypeColumn <- riskEvidenceHasRiskFactorAssociationType, self.riskEvidenceHasRiskFactorSourceColumn <- riskEvidenceHasRiskFactorSource, self.riskEvidenceHasRiskFactorTargetColumn <- riskEvidenceHasRiskFactorTarget, self.riskEvidenceRatioTypeColumn <- riskEvidenceRatioType, self.riskEvidenceRatioValueColumn <- riskEvidenceRatioValue, self.riskEvidenceRiskFactorColumn <- riskEvidenceRiskFactor)
            
            do {
                
                try self.databaseConnection.run(insertRiskEvidence)
            } catch {
                
                print(error)
            }
        }
        
        let createMeasurementTypesTable = measurementTypesTable.create { (table) in
            
            table.column(measurementTypesTableId, primaryKey: true)
            table.column(measurementTypeIdColumn)
            table.column(measurementTypeDatatypeColumn)
            table.column(measurementTypeLabelColumn)
            table.column(measurementTypeEnumValuesColumn)
            table.column(measurementTypeNameColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createMeasurementTypesTable)
            
            print("MeasurementTypes table created.")
        } catch {
            
            print(error)
        }
        
        for measurementTypeDictionary in self.measurementTypes {
            
            guard let measurementTypeId = measurementTypeDictionary["measurementTypeId"] as? String else { return }
            guard let measurementTypeDatatype = measurementTypeDictionary["measurementTypeDatatype"] as? String else { return }
            guard let measurementTypeLabel = measurementTypeDictionary["measurementTypeLabel"] as? String else { return }
            guard let measurementTypeEnumValues = measurementTypeDictionary["measurementTypeEnumValues"] as? String else { return }
            guard let measurementTypeName = measurementTypeDictionary["measurementTypeName"] as? String else { return }
            
            let insertMeasurementType = self.measurementTypesTable.insert(self.measurementTypeIdColumn <- measurementTypeId, self.measurementTypeDatatypeColumn <- measurementTypeDatatype, self.measurementTypeLabelColumn <- measurementTypeLabel, self.measurementTypeEnumValuesColumn <- measurementTypeEnumValues, self.measurementTypeNameColumn <- measurementTypeName)
            
            do {
                
                try self.databaseConnection.run(insertMeasurementType)
            } catch {
                
                print(error)
            }
        }
    }
    
    func getRowsOfTable(forIdentifier identifier: String) -> Int {
        
        var returnedNumberOfRows = Int()
        
        switch identifier {
            
        case "RiskElements":
            
            do {
                
                returnedNumberOfRows = try self.databaseConnection.scalar(self.riskElementsTable.select(riskElementsTableId.count))
            } catch {
                
                print(error)
            }
            
        case "Observables":
            
            do {
                
                returnedNumberOfRows = try self.databaseConnection.scalar(self.observablesTable.select(observablesTableId.count))
            } catch {
                
                print(error)
            }
            
        case "RiskEvidences":
            
            do {
                
                returnedNumberOfRows = try self.databaseConnection.scalar(self.riskEvidencesTable.select(riskEvidencesTableId.count))
            } catch {
                
                print(error)
            }
            
        case "MeasurementTypes":
            
            do {
                
                returnedNumberOfRows = try self.databaseConnection.scalar(self.measurementTypesTable.select(measurementTypesTableId.count))
            } catch {
                
                print(error)
            }
            
        case "RiskFactors":
            
            do {
                
                returnedNumberOfRows = try self.databaseConnection.scalar(self.riskEvidencesTable.select(riskEvidenceRiskFactorColumn.distinct.count))
            } catch {
                
                print(error)
            }
            
        default:
            
            break
        }
        
        return returnedNumberOfRows
    }
    
    
    func checkIfCarreBasicTablesExist() -> Bool {
        
        do {
           
            try self.databaseConnection.scalar(self.observablesTable.exists)
            
            carreBasicTablesExist = true
        } catch {
            
            carreBasicTablesExist = false
        }
        
        return carreBasicTablesExist
    }
    
    
    func dropAllBasicTables() {
        
        do {
            
            try self.databaseConnection.run(riskElementsTable.drop())
            try self.databaseConnection.run(observablesTable.drop())
            try self.databaseConnection.run(riskEvidencesTable.drop())
            try self.databaseConnection.run(measurementTypesTable.drop())
        } catch {
            
            print(error)
        }
    }
    
    
    func getAllObservablesNames() -> [String] {
        
        var returnArray = [String]()
        
        do {
            
            for observable in try databaseConnection.prepare(observablesTable) {
                
                returnArray.append(observable[observableNameColumn])
            }
        } catch {
            
            print(error)
        }
        
        return returnArray
    }
    
    
    func getMeasurementTypes() {
        
        do {
            
            for measurementType in try databaseConnection.prepare(measurementTypesTable) {
                
                print(measurementType[measurementTypeLabelColumn])
            }
        } catch {
            
            print(error)
        }
    }
    
    
    func checkIfPersonalHealthRecordsTableExist() -> Bool {
        
        var returnValue = Bool()
        
        do {
            
            try self.databaseConnection.scalar(self.personalHealthRecordsTable.exists)
            
            returnValue = true
        } catch {
            
            returnValue = false
        }
        
        return returnValue
    }
    
    
    func createPersonalHealthRecordsTable() {
        
        let createPersonalHealthRecordsTable = personalHealthRecordsTable.create { (table) in
            
            table.column(personalHealthRecordsTableId, primaryKey: true)
            table.column(personalHealthRecordObservableNameColumn)
            table.column(personalHealthRecordObservableValueColumn)
            table.column(personalHealthRecordDateAndTimeValueInsertionColumn)
            table.column(personalHealthRecordObservableIdValueColumn)
            table.column(personalHealthRecordRiskElementIdColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createPersonalHealthRecordsTable)
            
            print("Personal Health Records table created.")
        } catch {
            
            print(error)
        }
    }
    
    
    func insertNewPersonalHealthRecord(forObservableName observableName: String, forObservableValue observableValue: String, forDateAndTime dateAndTime: Date) {
        
        
        if !checkIfPersonalHealthRecordsTableExist() {
            
            createPersonalHealthRecordsTable()
        }
        
            let insertPersonalHealthRecord = self.personalHealthRecordsTable.insert(self.personalHealthRecordObservableNameColumn <- observableName, self.personalHealthRecordObservableValueColumn <- observableValue, self.personalHealthRecordDateAndTimeValueInsertionColumn <- dateAndTime, self.personalHealthRecordObservableIdValueColumn <- getObservableValueId(forObservableName: observableName), self.personalHealthRecordRiskElementIdColumn <- getRiskElementId(forObservableName: observableName))

            do {

                try self.databaseConnection.run(insertPersonalHealthRecord)
            } catch {

                print(error)
            }
    }
    
    
    func getAllPersonalHealthRecords() -> [[String: Any]] {
        
        var arrayOfDictionaries = [[String: Any]]()
        
        do {
            
            for selectAllColumnsQuery in try self.databaseConnection.prepare(personalHealthRecordsTable.select(*)) {
                
                let helpDict = ["personalHealthRecordObservableName": selectAllColumnsQuery[personalHealthRecordObservableNameColumn], "personalHealthRecordObservableValue": selectAllColumnsQuery[personalHealthRecordObservableValueColumn], "personalHealthRecordDateAndTimeValueInsertion": selectAllColumnsQuery[personalHealthRecordDateAndTimeValueInsertionColumn], "personalHealthRecordObservableIdValue": selectAllColumnsQuery[personalHealthRecordObservableIdValueColumn], "personalHealthRecordRiskElementId": selectAllColumnsQuery[personalHealthRecordRiskElementIdColumn]] as [String : Any]
                
                arrayOfDictionaries.append(helpDict)
            }
        } catch {
            
            print(error)
        }
        
        return arrayOfDictionaries
    }
    
    
    func printMeasurementTypesTable() {
        
        do {
            
            for measurementTypeTableRow in try databaseConnection.prepare(measurementTypesTable) {
                
                print("measurementTypeIdColumn: \(measurementTypeTableRow[measurementTypeIdColumn]), measurementTypeDatatypeColumn: \(measurementTypeTableRow[measurementTypeDatatypeColumn]), measurementTypeNameColumn: \(measurementTypeTableRow[measurementTypeNameColumn]), measurementTypeLabelColumn: \(measurementTypeTableRow[measurementTypeLabelColumn])")
            }
        } catch {
            
            print(error)
        }
    }
    
    
    var riskEvidencesCondition = [String]()
    func printRiskEvidenceConditionColumn() {
        
        do {
            
            for riskEvidenceTableRow in try databaseConnection.prepare(riskEvidencesTable) {
                
                riskEvidencesCondition.append(riskEvidenceTableRow[riskEvidenceConditionColumn])
                //print(" \(riskEvidenceTableRow[riskEvidenceConditionColumn])")
            }
            
            riskEvidencesCondition.sort()
            
            for riskEv in riskEvidencesCondition {

                print(riskEv)
            }
        } catch {
            
            print(error)
        }
    }
    
    
    func getLabelAndEnumValues(forObservableName observableName: String) -> [String: String] {
        
        var measurementTypeForObservableName = String()
        var returnDictionary = [String: String]()
        
        do {
            
            for queryForMeasurementTypeValueInObservablesTable in try self.databaseConnection.prepare(observablesTable.select(*).where(observableNameColumn == observableName)) {
                
                measurementTypeForObservableName = queryForMeasurementTypeValueInObservablesTable[measurementElementColumn]
            }
            
            for queryForLabelAndEnumValuesInMeasurementTypesTable in try self.databaseConnection.prepare(measurementTypesTable.select(*).where(measurementTypeIdColumn == measurementTypeForObservableName)) {

                returnDictionary = ["label": queryForLabelAndEnumValuesInMeasurementTypesTable[measurementTypeLabelColumn], "enumValues": queryForLabelAndEnumValuesInMeasurementTypesTable[measurementTypeEnumValuesColumn]]
            }
        } catch {
            
            print(error)
        }
        
        return returnDictionary
    }
    
    
    func getPersonalHealthRecord(forObservableName observableName: String, forObservableValue observableValue: String, forDateAndTimeValueInsertion dateAndTimeValueInsertion: Date) -> Table {
        
        let personalHealthRecord = personalHealthRecordsTable.filter(personalHealthRecordObservableNameColumn == observableName && personalHealthRecordObservableValueColumn == observableValue && personalHealthRecordDateAndTimeValueInsertionColumn == dateAndTimeValueInsertion)
        
        return personalHealthRecord
    }
    
    
    func updatePersonalHealthRecord(forPersonalHealthRecord personalHealthRecord: Table, forObservableName observableName: String, forObservableValue observableValue: String, forDateAndTimeValueInsertion dateAndTimeValueInsertion: Date) {
        
        let updatePersonalHealthRecordQuery = personalHealthRecord.update(personalHealthRecordObservableNameColumn <- observableName, personalHealthRecordObservableValueColumn <- observableValue, personalHealthRecordDateAndTimeValueInsertionColumn <- dateAndTimeValueInsertion, personalHealthRecordObservableIdValueColumn <- getObservableValueId(forObservableName: observableName), personalHealthRecordRiskElementIdColumn <- getRiskElementId(forObservableName: observableName))
        
        do {
            
            try self.databaseConnection.run(updatePersonalHealthRecordQuery)
        } catch {
            
            print(error)
        }
    }
    
    
    func deletePersonalHealthRecord(forPersonalHealthRecord personalHealthRecord: Table) {
        
        let deletePersonalHealthRecordQuery = personalHealthRecord.delete()
        
        do {
            
            try self.databaseConnection.run(deletePersonalHealthRecordQuery)
            NotificationCenter.default.post(name: self.reloadTableViewNotification, object: nil)
        } catch {
            
            print(error)
        }
        
        RiskFactorsBarChartController.shared.helpPopulateSpinnerFuncAfterUpdateOrDelete()
    }
    
    
    func getObservableValueId(forObservableName observableName: String) -> String {
        
        var observableValueId = String()
        
        let observableTableRow = observablesTable.filter(observableNameColumn == observableName)
        
        do {
            
            for observable in try databaseConnection.prepare(observableTableRow) {
                
                observableValueId = observable[observableIdColumn]
            }
        } catch {
            
            print(error)
        }
        
        return observableValueId
    }
    
    
    func getObservableName(forObservableIdValue observableIdValue: String) -> String {
        
        var observableName = String()
        
        let observableTableRow = observablesTable.filter(observableIdColumn == observableIdValue)
        
        do {
            
            for observable in try databaseConnection.prepare(observableTableRow) {
                
                observableName = observable[observableNameColumn]
            }
        } catch {
            
            print(error)
        }
        
        return observableName
    }
    
    
    func getRiskElementId(forObservableName observableName: String) -> String {
        
        var riskElementId = String()
        
        do {
            
            for riskElementsTableRow in try databaseConnection.prepare(riskElementsTable.select(*)) {
                
                if observableName.contains(riskElementsTableRow[diseaseColumn]) {
                    
                    riskElementId = riskElementsTableRow[riskElementIdColumn]
                }
            }
        } catch {
            
            print(error)
        }
        
        return riskElementId
    }
    
    
    func printPersonalHealthRecordsRiskElementId() {
        
        do {
            
            for personalHealthRecordsTableRow in try databaseConnection.prepare(personalHealthRecordsTable.select(*)) {
                
                print(personalHealthRecordsTableRow[personalHealthRecordRiskElementIdColumn])
            }
        } catch {
            
            print(error)
        }
    }
    
    
    func getObservablesTableDistinctValues() {
        
        var arr = [String]()
        do {
            
            for observablesTableDistinctValueRow in try databaseConnection.prepare(observablesTable.select(distinct: observableIdColumn)) {
                
                arr.append(observablesTableDistinctValueRow[observableIdColumn])
            }
            var newArr = arr.sorted()
            for arrValue in newArr {
                
                print(arrValue)
            }
            //print(newArr.count)
        } catch {
            
            print(error)
        }
    }
    
    
    func getRiskEvidencesConditionArray() -> [String] {
        
        var riskEvidencesConditionSortedArray = [String]()
        
        do {
            
            for riskEvidencesTableRow in try databaseConnection.prepare(riskEvidencesTable.select([riskEvidenceConditionColumn])) {

                riskEvidencesConditionSortedArray.append(riskEvidencesTableRow[riskEvidenceConditionColumn])

            }
        } catch {
            
            print(error)
        }
        
        return riskEvidencesConditionSortedArray
    }
    
    
    func getRiskEvidencesRiskFactorSource() -> [String] {
        
        var riskEvidencesRiskFactorSource = [String]()
        
        do {
            
            for riskEvidencesTableRow in try databaseConnection.prepare(riskEvidencesTable.select([riskEvidenceHasRiskFactorSourceColumn])) {

                riskEvidencesRiskFactorSource.append(riskEvidencesTableRow[riskEvidenceHasRiskFactorSourceColumn])
            }
        } catch {
            
            print(error)
        }
        
        return riskEvidencesRiskFactorSource
    }
    
    
    func getRiskEvidencesRiskFactorTarget() -> [[String]] {
        
        var riskEvidencesRiskFactorTarget = [[String]]()
        
        do {
            
            for riskEvidencesTableRow in try databaseConnection.prepare(riskEvidencesTable.select(riskEvidenceHasRiskFactorTargetColumn, riskEvidenceHasRiskFactorSourceColumn)) {
                
               var helpArr = [String]()
               helpArr.append(riskEvidencesTableRow[riskEvidenceHasRiskFactorSourceColumn])
                helpArr.append(riskEvidencesTableRow[riskEvidenceHasRiskFactorTargetColumn])
                riskEvidencesRiskFactorTarget.append(helpArr)
            }
        } catch {
            
            print(error)
        }
        
        return riskEvidencesRiskFactorTarget
    }
    
    
    func getRiskEvidencesRatioValue() -> [[String]] {
        
        var riskEvidencesRatioValue = [[String]]()
        
        
        do {
            
            for riskEvidencesTableRow in try databaseConnection.prepare(riskEvidencesTable.select(
                riskEvidenceRatioValueColumn, riskEvidenceHasRiskFactorSourceColumn)) {
                    
                var helpArr = [String]()
                helpArr.append( riskEvidencesTableRow[riskEvidenceHasRiskFactorSourceColumn])
                    
                let helpVar = String(riskEvidencesTableRow[riskEvidenceRatioValueColumn])
                helpArr.append(helpVar)
                riskEvidencesRatioValue.append(helpArr)
            }
        } catch {
            
            print(error)
        }
        
        return riskEvidencesRatioValue
    }
    
    
    func getPersonalHealthRecordsObservablesAndValues() -> [String] {
        
        var personalHealthRecordsObservablesAndValues = [String]()
        
        do {
            
            for personalHealthRecordsTableRow in try  self.databaseConnection.prepare(personalHealthRecordsTable.select(*)) {
                
                var personalHealthRecordObservableIdValueHelpString = personalHealthRecordsTableRow[personalHealthRecordObservableIdValueColumn].replacingOccurrences(of: "http://carre.kmi.open.ac.uk/observables/", with: "")
                personalHealthRecordObservableIdValueHelpString = personalHealthRecordObservableIdValueHelpString + " = "
             
                var stringToAppend = personalHealthRecordObservableIdValueHelpString + personalHealthRecordsTableRow[personalHealthRecordObservableValueColumn]
                
                personalHealthRecordsObservablesAndValues.append(stringToAppend)
            }
        } catch {
            
            print(error)
        }
        
        return personalHealthRecordsObservablesAndValues
    }
    
    
    func getRiskElementsId() -> [String] {
        
        var riskElementsId = [String]()
        
        do {
            
            for riskElementsTableRow in try databaseConnection.prepare(riskElementsTable.select([riskElementIdColumn])) {
                
                riskElementsId.append(riskElementsTableRow[riskElementIdColumn])
            }
        } catch {
            
            print(error)
        }
        
        return riskElementsId
    }
    
    
    func getRiskElementsName() -> [String] {
        
        var riskElementsName = [String]()
        
        do {
            
            for riskElementsTableRow in try databaseConnection.prepare(riskElementsTable.select([diseaseColumn])) {
                
                riskElementsName.append(riskElementsTableRow[diseaseColumn])
            }
        } catch {
            
            print(error)
        }
        
        return riskElementsName
    }
    
    
    func getObservablesMeasurementType() -> [String] {
        
        var observablesMeasurementType = [String]()
        
        do {
            
            for observablesTableRow in try databaseConnection.prepare(observablesTable.select(measurementElementColumn)) {
                
                observablesMeasurementType.append(observablesTableRow[measurementElementColumn])
            }
        } catch {
            
            print(error)
        }
        
        return observablesMeasurementType
    }
    
    
    func getMeasurementTypesIdAndDatatype() -> [[String]] {
        
        var measurementTypesIdAndDatatype = [[String]]()
        
        do {
            
            for measurementTypesTableRow in try databaseConnection.prepare(measurementTypesTable.select(measurementTypeIdColumn, measurementTypeDatatypeColumn)) {
               
                var helpArr = [String]()
                helpArr.append(measurementTypesTableRow[measurementTypeIdColumn])
                helpArr.append(measurementTypesTableRow[measurementTypeDatatypeColumn])
                
                measurementTypesIdAndDatatype.append(helpArr)
            }
        } catch {
            
            print(error)
        }
        
        return measurementTypesIdAndDatatype
    }
    
    
    func getObservablesNameAndMeasurementType() -> [[String]] {
        
        var observablesNameAndMeasurementType = [[String]]()
        
        do {
            
            for observablesTableRow in try databaseConnection.prepare(observablesTable.select(observableNameColumn, measurementElementColumn)) {
                
                var helpArr = [String]()
                helpArr.append(observablesTableRow[observableNameColumn])
                helpArr.append(observablesTableRow[measurementElementColumn])
                
                observablesNameAndMeasurementType.append(helpArr)
            }
        } catch {
            
            print(error)
        }
        
        return observablesNameAndMeasurementType
    }
}
