//
//  RiskElementsModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct RiskElementsModel: Unboxable {
    
    
    let riskElementsBindings: [RiskElementsBindingsModel]
    
    init(unboxer: Unboxer) throws {
        
        self.riskElementsBindings = try unboxer.unbox(keyPath: "results.bindings")
    }
}
