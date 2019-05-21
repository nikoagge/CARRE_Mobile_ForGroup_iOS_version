//
//  ObservablesBindingsModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct ObservablesBindingsModel: Unboxable {
    
    
    var observableName: String
    var riskValue: Int
    var measurementElement: String
    var isModifiable: String
    var observableId: String
    
    init(unboxer: Unboxer) throws {
        
        self.observableName = try unboxer.unbox(keyPath: "name.value")
        self.riskValue = try unboxer.unbox(keyPath: "countRV.value")
//        var measurementElementHelpString = String()
//        measurementElementHelpString = try unboxer.unbox(keyPath: "measurement.value")
//        self.measurementElement = measurementElementHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/measurement_types/", with: "")
        self.measurementElement = try unboxer.unbox(keyPath: "measurement.value")
        self.isModifiable = try unboxer.unbox(keyPath: "modifiable.value")
//        var observableIdHelpString = String()
//        observableIdHelpString = try unboxer.unbox(keyPath: "observable.value")
//        self.observableId = observableIdHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/observables/", with: "")
        self.observableId = try unboxer.unbox(keyPath: "observable.value")
    }
}
