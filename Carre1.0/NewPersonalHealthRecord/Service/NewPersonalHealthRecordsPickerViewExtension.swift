//
//  NewPersonalHealthRecordsPickerViewExtension.swift
//  Carre1.0
//
//  Created by Nikolas on 04/04/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import UIKit


extension NewPersonalHealthRecordController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return enumValuesData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return enumValuesData[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        valueForObservableTextField.text = enumValuesData[row]
        enumValuesPicker.resignFirstResponder()
    }
}
