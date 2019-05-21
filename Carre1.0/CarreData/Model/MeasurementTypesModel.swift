//
//  MeasurementTypesModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct MeasurementTypesModel: Unboxable {
    
    
    let measurementTypesBindings: [MeasurementTypesBindingsModel]
    
    init(unboxer: Unboxer) throws {
        
        self.measurementTypesBindings = try unboxer.unbox(keyPath: "results.bindings")
    }
}
