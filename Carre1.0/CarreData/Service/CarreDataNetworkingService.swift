//
//  NetworkingService.swift
//  Carre1.0
//
//  Created by Nikolas on 16/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import Alamofire
import Unbox


class CarreDataNetworkingService {
    
    
    static let shared = CarreDataNetworkingService()
    
    let url_prefix = "https://devices.duth.carre-project.eu/sparql?default-graph-uri=http%3A%2F%2Fcarre.kmi.open.ac.uk%2F"
    let graph = "carreriskdata"
    let url_middle = "&query="
    let url_suffix = "&should-sponge=&format=application%2Fsparql-results%2Bjson&timeout=0&debug=on"
    
    
    func getRiskElements() {
        
        let sparql_risk_elements = url_prefix + graph + url_middle + "PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3EPREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3EPREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3EPREFIX+%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Fsensors.owl%23%3EPREFIX+risk%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Frisk.owl%23%3EPREFIX+carreManufacturer%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fmanufacturers%2F%3EPREFIX+carreUsers%3A+%3Chttps%3A%2F%2Fcarre.kmi.open.ac.uk%2Fusers%2F%3E%0D%0ASELECT+DISTINCT+%2A+FROM+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2F"+graph+"%3E+%0D%0AWHERE+%7B++%0D%0A++%7B++++%3Frisk_element+a+risk%3Arisk_element%3Brisk%3Ahas_risk_element_name+%3Fname%3B+risk%3Ahas_risk_element_modifiable_status+%3Fmodifiable.%0D%0AFILTER+%28lang%28%3Fname%29%3D%27en%27%29%7D%7D" + url_suffix
        
        Alamofire.request(sparql_risk_elements).responseData { (data) in
            
            guard let data = data.result.value else { return }
            
            self.processData(withData: data, forIdentifier: "RiskElements")
        }
    }
    
    
    func getObservables() {

        let sparql_observables = url_prefix + graph + url_middle + "PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3EPREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3EPREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3EPREFIX+%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Fsensors.owl%23%3EPREFIX+risk%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Frisk.owl%23%3EPREFIX+carreManufacturer%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fmanufacturers%2F%3EPREFIX+carreUsers%3A+%3Chttps%3A%2F%2Fcarre.kmi.open.ac.uk%2Fusers%2F%3E%0D%0ASELECT+%3Fobservable%2C+%3Fname%2C+%3Fmeasurement%2C+%3Fmodifiable%2C+%28COUNT%28%3Frisk_evidence%29+AS+%3FcountRV%29+FROM+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2F"+graph+"%3E+%0D%0AWHERE+%7B++%0D%0A++%7B++++%3Fobservable+a+risk%3Aobservable%3Brisk%3Ahas_observable_name+%3Fname%3B%0D%0Arisk%3Ahas_observable_measurement_type+%3Fmeasurement.+OPTIONAL+%7B+%3Fobservable+risk%3Ahas_observable_modifiable_status+%3Fmodifiable+%7D+OPTIONAL+%7B%3Frisk_evidence+risk%3Ahas_risk_evidence_observable+%3Fobservable+%7D+FILTER+%28lang%28%3Fname%29%3D%27en%27%29%7D%7D" + url_suffix

        Alamofire.request(sparql_observables).responseData { (data) in
            
            guard let data = data.result.value else { return }
            
            self.processData(withData: data, forIdentifier: "Observables")
        }
    }
    
    
    func getRiskEvidences() {
        
        let sparql_risk_evidences = url_prefix + graph + url_middle + "PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3EPREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3EPREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3EPREFIX+%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Fsensors.owl%23%3EPREFIX+risk%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Frisk.owl%23%3EPREFIX+carreManufacturer%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fmanufacturers%2F%3EPREFIX+carreUsers%3A+%3Chttps%3A%2F%2Fcarre.kmi.open.ac.uk%2Fusers%2F%3ESELECT+DISTINCT+%3Frisk_evidence+%3Fcondition+%3Fconfidence_interval_min+%3Fconfidence_interval_max+%3Frisk_evidence_ratio_value+%3Frisk_evidence_ratio_type+%3Frisk_factor+%3Fhas_risk_factor_source+%3Fhas_risk_factor_target+%3Fhas_risk_factor_association_type+FROM+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2F" + graph + "%3E+WHERE+%7B++%0D%0A++%3Frisk_evidence+a+risk%3Arisk_evidence+%3B++++%0D%0A+++risk%3Ahas_risk_factor+%3Frisk_factor%3B%0D%0A++++risk%3Ahas_risk_evidence_ratio_type+%3Frisk_evidence_ratio_type%3B+%0D%0A+++++++++risk%3Ahas_risk_evidence_ratio_value+%3Frisk_evidence_ratio_value.++++++%0D%0A+++++++++OPTIONAL+%7B+%3Frisk_evidence+risk%3Ahas_confidence_interval_max+%3Fconfidence_interval_max%3B+%0D%0A+++++++++++++risk%3Ahas_confidence_interval_min+%3Fconfidence_interval_min.+%7D++++++%0D%0A+++++++++++++%3Frisk_evidence+risk%3Ahas_risk_evidence_observable+%3Fob+%3B+%0D%0A+++++++++++++risk%3Ahas_observable_condition+%3Fcondition+.++++%0D%0A+++++++++++++%23details+for+risk+factor++++%0D%0A+++++++++++++%3Frisk_factor+risk%3Ahas_risk_factor_association_type+%3Fhas_risk_factor_association_type%3B++++%0D%0A+++++++++++++risk%3Ahas_risk_factor_source+%3Fhas_risk_factor_source%3B++++%0D%0A+++++++++++++risk%3Ahas_risk_factor_target+%3Fhas_risk_factor_target.++++++%7D" + url_suffix
        
        Alamofire.request(sparql_risk_evidences).responseData { (data) in
            
            guard let data = data.result.value else { return }
            
            self.processData(withData: data, forIdentifier: "RiskEvidences")
        }
    }
    
    
    func getMeasurementTypes() {
        
        
        let sparql_measurement_types = url_prefix + graph + url_middle + "PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3EPREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3EPREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3EPREFIX+%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Fsensors.owl%23%3EPREFIX+risk%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fontology%2Frisk.owl%23%3EPREFIX+carreManufacturer%3A+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2Fmanufacturers%2F%3EPREFIX+carreUsers%3A+%3Chttps%3A%2F%2Fcarre.kmi.open.ac.uk%2Fusers%2F%3E%0D%0ASELECT+DISTINCT+%2A+FROM+%3Chttp%3A%2F%2Fcarre.kmi.open.ac.uk%2F"+graph+"%3E+%0D%0AWHERE+%7B++%0D%0A++%7B++++%3Fmeasurement_type+a+risk%3Ameasurement_type%3B+risk%3Ahas_measurement_type_name+%3Fname%3B+risk%3Ahas_datatype+%3Fdatatype.+OPTIONAL+%7B+%3Fmeasurement_type+risk%3Ahas_enumeration_values+%3Fenum_values.+FILTER+%28lang%28%3Fenum_values%29%3D%27en%27%29%7D+OPTIONAL+%7B+%3Fmeasurement_type+risk%3Ahas_label+%3Flabel.+FILTER+%28lang%28%3Flabel%29%3D%27en%27%29%7D%0D%0AFILTER+%28lang%28%3Fname%29%3D%27en%27%29%7D%7D" + url_suffix
        
        Alamofire.request(sparql_measurement_types).responseData { (data) in
            
            guard let data = data.result.value else { return }
            
            self.processData(withData: data, forIdentifier: "MeasurementTypes")
        }
    }
    
    
    func processData(withData data: Data, forIdentifier identifier: String) {
        
        switch identifier {
            
        case "RiskElements":
            
            var riskElements = [[String: Any]]()
            
            let riskElementsData: RiskElementsModel = try! unbox(data: data)
            
            for riskElement in riskElementsData.riskElementsBindings {
                
                let helpDict = ["riskElementId": riskElement.riskElementId, "disease": riskElement.disease, "isModifiable": riskElement.isModifiable] as [String : Any]
                riskElements.append(helpDict)
            }

            CarreDatabaseService.shared.riskElements = riskElements
            
        case "Observables":
            
            var observables = [[String: Any]]()
            
            let observablesData: ObservablesModel = try! unbox(data: data)
            
            for observable in observablesData.observablesBindings {
                
                let helpDict = ["observableId": observable.observableId, "observableName": observable.observableName, "riskValue": observable.riskValue, "isModifiable": observable.isModifiable, "measurementElement": observable.measurementElement] as [String: Any]
                observables.append(helpDict)
            }
            
            CarreDatabaseService.shared.observables = observables
            
        case "RiskEvidences":
            
            var riskEvidences  = [[String: Any]]()
            
            let riskEvidencesData: RiskEvidencesModel = try! unbox(data: data)
            
            for riskEvidence in riskEvidencesData.riskEvidencesBindings {
                
                let helpDict = ["riskEvidenceId": riskEvidence.riskEvidenceId, "riskEvidenceCondition": riskEvidence.riskEvidenceCondition, "riskEvidenceConfidenceIntervalMax": riskEvidence.riskEvidenceConfidenceIntervalMax, "riskEvidenceConfidenceIntervalMin": riskEvidence.riskEvidenceConfidenceIntervalMin, "riskEvidenceHasRiskFactorAssociationType": riskEvidence.riskEvidenceHasRiskFactorAssociationType, "riskEvidenceHasRiskFactorSource": riskEvidence.riskEvidenceHasRiskFactorSource, "riskEvidenceHasRiskFactorTarget": riskEvidence.riskEvidenceHasRiskFactorTarget, "riskEvidenceRatioType": riskEvidence.riskEvidenceRatioType, "riskEvidenceRatioValue": riskEvidence.riskEvidenceRatioValue, "riskEvidenceRiskFactor": riskEvidence.riskEvidenceRiskFactor] as [String: Any]
                
                riskEvidences.append(helpDict)
            }

            CarreDatabaseService.shared.riskEvidences = riskEvidences
            
        case "MeasurementTypes":
            
            var measurementTypes = [[String: Any]]()
            
            let measurementTypesData: MeasurementTypesModel = try! unbox(data: data)
            
            for measurementType in measurementTypesData.measurementTypesBindings {
                
                let helpDict = ["measurementTypeId": measurementType.measurementTypeId, "measurementTypeDatatype": measurementType.measurementTypeDatatype, "measurementTypeLabel": measurementType.measurementTypeLabel, "measurementTypeEnumValues": measurementType.measurementTypeEnumValues, "measurementTypeName": measurementType.measurementTypeName]
                
                measurementTypes.append(helpDict)
            }
            
            CarreDatabaseService.shared.measurementTypes = measurementTypes
            
        default:
            break
        }
    }
    
    
    func getCarreElements() {
        
        self.getRiskElements()
        self.getObservables()
        self.getRiskEvidences()
        self.getMeasurementTypes()
    }
}
