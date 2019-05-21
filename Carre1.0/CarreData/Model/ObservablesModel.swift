//
//  ObservablesModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct ObservablesModel: Unboxable {
    
    
    let observablesBindings: [ObservablesBindingsModel]
    
    
    init(unboxer: Unboxer) throws {
        
        self.observablesBindings = try unboxer.unbox(keyPath: "results.bindings")
    }
}
