//
//  RiskFactorsBarChartControllerPickerViewExtension.swift
//  Carre1.0
//
//  Created by Nikolas on 08/06/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import Foundation
import UIKit


extension RiskFactorsBarChartController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.riskFactorsSourceValuesForPickerView.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.riskFactorsSourceValuesForPickerView[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        riskFactorsSourceTextField.text = self.riskFactorsSourceValuesForPickerView[row]

        self.riskEvidencesRatioValueMatched = fillRiskFactorsRatioValueMatched(forRiskFactorSource: self.riskFactorsSourceMatched[row])
        self.riskFactorsTargetMatched = fillRiskFactorsTargetMatched(forRiskFactorSource: self.riskFactorsSourceMatched[row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

            self.setupRiskFactorsBarChart(forRiskFactorTargets: self.riskFactorsTargetMatched, forRiskFactorsRatioValue: self.riskEvidencesRatioValueMatched)
        }
    }
}
