//
//  RiskEvidencesBindingsModel.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Unbox


struct RiskEvidencesBindingsModel: Unboxable {
    
    
    let riskEvidenceCondition: String
    let riskEvidenceConfidenceIntervalMax: Double
    let riskEvidenceConfidenceIntervalMin: Double
    let riskEvidenceHasRiskFactorAssociationType: String
    let riskEvidenceHasRiskFactorSource: String
    let riskEvidenceHasRiskFactorTarget: String //points to a risk element(RL_)
    let riskEvidenceId: String //RV_
    let riskEvidenceRatioType: String
    let riskEvidenceRatioValue: Double
    let riskEvidenceRiskFactor: String
    
    init(unboxer: Unboxer) throws {
        
        self.riskEvidenceCondition = try unboxer.unbox(keyPath: "condition.value")
        self.riskEvidenceConfidenceIntervalMax = try unboxer.unbox(keyPath: "confidence_interval_max.value") ?? 0.0
        self.riskEvidenceConfidenceIntervalMin = try unboxer.unbox(keyPath: "confidence_interval_min.value") ?? 0.0
        var riskEvidenceHasRiskFactorAssociationTypeHelpString = String()
        riskEvidenceHasRiskFactorAssociationTypeHelpString = try unboxer.unbox(keyPath: "has_risk_factor_association_type.value")
        self.riskEvidenceHasRiskFactorAssociationType = riskEvidenceHasRiskFactorAssociationTypeHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/ontology/risk.owl#", with: "")
        var riskEvidenceHasRiskFactorSourceHelpString = String()
        riskEvidenceHasRiskFactorSourceHelpString = try unboxer.unbox(keyPath: "has_risk_factor_source.value")
        self.riskEvidenceHasRiskFactorSource = riskEvidenceHasRiskFactorSourceHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/risk_elements/", with: "")
        var riskEvidenceHasRiskFactorTargetHelpString = String()
        riskEvidenceHasRiskFactorTargetHelpString = try unboxer.unbox(keyPath: "has_risk_factor_target.value")
        self.riskEvidenceHasRiskFactorTarget = riskEvidenceHasRiskFactorTargetHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/risk_elements/", with: "")
        var riskEvidenceIdHelpString = String()
        riskEvidenceIdHelpString = try unboxer.unbox(keyPath: "risk_evidence.value")
        self.riskEvidenceId = riskEvidenceIdHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/risk_evidences/", with: "")
        var riskEvidenceRatioTypeHelpString = String()
        riskEvidenceRatioTypeHelpString = try unboxer.unbox(keyPath: "risk_evidence_ratio_type.value")
        self.riskEvidenceRatioType = riskEvidenceRatioTypeHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/ontology/risk.owl#", with: "")
        self.riskEvidenceRatioValue = try unboxer.unbox(keyPath: "risk_evidence_ratio_value.value") ?? 0.0
        var riskFactorHelpString = String()
        riskFactorHelpString = try unboxer.unbox(keyPath: "risk_factor.value")
        self.riskEvidenceRiskFactor = riskFactorHelpString.replacingOccurrences(of: "http://carre.kmi.open.ac.uk/risk_factors/", with: "")
    }
}
