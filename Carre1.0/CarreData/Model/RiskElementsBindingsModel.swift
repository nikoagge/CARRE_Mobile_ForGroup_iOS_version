//
//  RiskElementsBindingsModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct RiskElementsBindingsModel: Unboxable {
    
    
    let disease: String
    let isModifiable: String
    let riskElementId: String
    
    init(unboxer: Unboxer) throws {
        
        self.disease = try unboxer.unbox(keyPath: "name.value")
        self.isModifiable = try unboxer.unbox(keyPath: "modifiable.value")
        self.riskElementId = try unboxer.unbox(keyPath: "risk_element.value")
    }
}
