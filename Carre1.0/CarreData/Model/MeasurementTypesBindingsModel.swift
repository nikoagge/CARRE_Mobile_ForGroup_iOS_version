//
//  MeasurementTypesBindingsModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct MeasurementTypesBindingsModel: Unboxable {
    
    
    let measurementTypeDatatype: String
    let measurementTypeLabel: String
    let measurementTypeEnumValues: String
    let measurementTypeId: String
    let measurementTypeName: String
    let helpStringForLabel: String?
    let helpStringForEnumValues: String?
    
    init(unboxer: Unboxer) throws {
        
//        var helpMeasurementTypeDatatype = String()
//        helpMeasurementTypeDatatype = try unboxer.unbox(keyPath: "datatype.value")
//        self.measurementTypeDatatype = helpMeasurementTypeDatatype.replacingOccurrences(of: "http://www.w3.org/2001/XMLSchema#", with: "")
        self.measurementTypeDatatype = try unboxer.unbox(keyPath: "datatype.value")
        self.helpStringForLabel = unboxer.unbox(keyPath: "label.value")
        self.helpStringForEnumValues = unboxer.unbox(keyPath: "enum_values.value")
        self.measurementTypeLabel = self.helpStringForLabel ?? ""
        self.measurementTypeEnumValues = self.helpStringForEnumValues ?? ""
        //        var helpMeasurementTypeId = String()
//        helpMeasurementTypeId = try unboxer.unbox(keyPath: "measurement_type.value")
//        self.measurementTypeId = helpMeasurementTypeId.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/measurement_types/", with: "")
        self.measurementTypeId = try unboxer.unbox(keyPath: "measurement_type.value")
        self.measurementTypeName = try unboxer.unbox(keyPath: "name.value")
    }
}
