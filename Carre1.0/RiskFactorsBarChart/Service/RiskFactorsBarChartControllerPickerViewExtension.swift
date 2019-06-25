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

        clearArrays()
        fillArrays(forRiskFactorSource: self.riskFactorsSourceMatched[row])
        
        print(self.riskFactorsAssociationTypeElevates)
        print(self.riskFactorsAssociationTypeReduces)
        print(self.riskFactorsAssociationTypeCauses)
        print(self.riskFactorsAssociationTypeIsAnIssueIn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            self.setupRiskFactorsBarChart(forRiskFactorsAssociationTypeIsAnIssueIn: self.riskFactorsAssociationTypeIsAnIssueIn, forRiskFactorsAssociationTypeCauses: self.riskFactorsAssociationTypeCauses, forRiskFactorsAssociationTypeReduces: self.riskFactorsAssociationTypeReduces, forRiskFactorsAssociationTypeElevates: self.riskFactorsAssociationTypeElevates)
        }
    }
    
    
    func fillArrays(forRiskFactorSource riskFactorSource: String) {
        
        self.riskEvidencesRatioValueMatched = fillRiskFactorsRatioValueMatched(forRiskFactorSource: riskFactorSource)
        self.riskFactorsTargetMatched = fillRiskFactorsTargetMatched(forRiskFactorSource: riskFactorSource)
        self.riskEvidencesHasRiskFactorAssociationTypeMatched = fillRiskFactorsHasAssociationTypeMatched(forRiskFactorSource: riskFactorSource)
        decideRiskFactorsColor()
    }
    
    
    func clearArrays() {
        
        self.riskFactorsAssociationTypeIsAnIssueIn.removeAll()
        self.riskFactorsAssociationTypeCauses.removeAll()
        self.riskFactorsAssociationTypeReduces.removeAll()
        self.riskFactorsAssociationTypeElevates.removeAll()
    }
}
