//
//  RiskFactorsBarChartController.swift
//  Carre1.0
//
//  Created by Nikolas on 19/04/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit
import Charts


class RiskFactorsBarChartController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var riskFactorsSourceTextField: UITextField!
    @IBOutlet weak var riskFactorsBarChartView: BarChartView!
    
    let riskFactorsSourcePickerView = UIPickerView()
    
    var initialRiskEvidencesCondition = [String]()
    var riskEvidencesCondition = [String]()
    var riskEvidencesRiskFactorSource = [String]()
    var riskEvidencesRiskFactorTarget = [[String]]()
    var riskEvidencesRatioValue = [[String]]()
    var personalHealthRecordsObservablesAndValues = [String]()
    var riskEvidencesConditionArrayOfArrays = [[String]]()
    var positions = [Int]()
    var riskFactorsSourceMatched = [String]()
    var riskFactorsTargetMatched = [String]()
    var riskEvidencesRatioValueMatched = [Double]()
    var riskElementsId = [String]()
    var riskElementsName = [String]()
    var riskFactorsSourceValuesForPickerView = [String]()
    
    static let shared = RiskFactorsBarChartController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBarTitle()
        setupRiskFactorsSourcePickerView()
        setupArraysToWork()
        
        CarreDatabaseService.shared.connectToDatabase()
        
        populateSpinner()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        populateSpinner()
        //setupRiskFactorsSourcePickerView()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.riskFactorsSourceTextField.text = ""
        self.riskFactorsBarChartView.clearValues()
    }
    
    
    func setupNavigationBarTitle() {
        
        let title =  UILabel(frame: CGRect(x: 4, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height))
        title.text = "CARRE: My Personal Risks"
        title.textColor = .white
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 22)
        
        navigationBar.addSubview(title)
    }

    
    func setupRiskFactorsSourcePickerView() {
        
        riskFactorsSourcePickerView.delegate = self
        riskFactorsSourcePickerView.dataSource = self
        
        riskFactorsSourceTextField.inputView = riskFactorsSourcePickerView
        
        createToolBar()
    }
    
    
    func createToolBar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RiskFactorsBarChartController.dismissKeyboard))
        
        //Customizations
        //        toolbar.barTintColor = .black
        //        toolbar.tintColor = .white //color of the text
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        riskFactorsSourceTextField.inputAccessoryView = toolbar
    }
    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
}
