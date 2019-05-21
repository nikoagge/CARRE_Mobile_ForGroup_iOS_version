//
//  RiskEvidencesModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct RiskEvidencesModel: Unboxable {
    
    
    let riskEvidencesBindings: [RiskEvidencesBindingsModel]
    
    init(unboxer: Unboxer) throws {
        
        self.riskEvidencesBindings = try unboxer.unbox(keyPath: "results.bindings")
    }
}
