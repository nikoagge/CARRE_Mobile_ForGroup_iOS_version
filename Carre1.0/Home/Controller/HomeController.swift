//
//  HomeController.swift
//  Carre1.0
//
//  Created by Nikolas on 13/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//


import UIKit
import Charts


class HomeController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var riskElementsTotalForPieChart = Double()
    var observablesTotalForPieChart = Double()
    var riskEvidencesTotalForPieChart = Double()
    var measurementTypesTotalForPieChart = Double()
    var riskFactorsTotalForPieChart = Double()
    var firstTimeViewAppeared = true
    
    var date = Date()
    let defaults = UserDefaults.standard
    let oldDateKey = "oldDateKey"
    var differenceBetweenDatesInSeconds = Int()
    var oldDateInSeconds = Int()
    var newDateInSeconds = Int()
    
    var firstTimeViewAppearedAndNoInternet = true
    var firstTimeViewAppearedAndNoInternetKey = "firstTimeViewAppearedAndNoInternet"
    var firstTimeViewAppearedAndInternetOk = true
    var firstTimeViewAppearedAndInternetOkKey = "firstTimeViewAppearedAndInternetOk"
    
    var basicTablesExistIdentifier = "basicTablesExist"
    var basicTablesDontExistIdentifier = "basicTablesDontExist"
    
    var isNetworkAvailable = Bool()

    static let shared = HomeController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBarTitle()
        
        CarreDatabaseService.shared.connectToDatabase()

        if HomeController.shared.defaults.value(forKey: HomeController.shared.firstTimeViewAppearedAndNoInternetKey) == nil {

            NetworkManager.isUnreachable { (_) in

                if CarreDatabaseService.shared.checkIfCarreBasicTablesExist() {

                    self.showNetworkAlert(forIdentifier: self.basicTablesExistIdentifier)
                    self.setupValuesForPieChart()
                } else {

                    self.showNetworkAlert(forIdentifier: self.basicTablesDontExistIdentifier)
                }
            }
        }

        if HomeController.shared.defaults.value(forKey: HomeController.shared.firstTimeViewAppearedAndInternetOkKey) == nil {

            NetworkManager.isReachable { (_) in

                if CarreDatabaseService.shared.checkIfCarreBasicTablesExist() {

                    self.compareGapBetweenDates()
                } else {

                    CarreDataNetworkingService.shared.getCarreElements()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

                        CarreDatabaseService.shared.createAndFillBasicCarreTables()
                        self.setupValuesForPieChart()
                        
                    }
                }

                HomeController.shared.defaults.set(self.firstTimeViewAppearedAndInternetOk, forKey: HomeController.shared.firstTimeViewAppearedAndInternetOkKey)
            }
        }
        
        
        CarreDatabaseService.shared.getObservablesTableDistinctValues()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        if HomeController.shared.defaults.value(forKey: HomeController.shared.firstTimeViewAppearedAndNoInternetKey) == nil {

            NetworkManager.shared.reachability.whenReachable = { _ in

                if CarreDatabaseService.shared.checkIfCarreBasicTablesExist() {

                    self.compareGapBetweenDates()
                } else {

                    CarreDataNetworkingService.shared.getCarreElements()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                        CarreDatabaseService.shared.createAndFillBasicCarreTables()
                        self.setupValuesForPieChart()
                    }
                }
            }

            HomeController.shared.defaults.set(self.firstTimeViewAppearedAndNoInternet, forKey: HomeController.shared.firstTimeViewAppearedAndNoInternetKey)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        
        if HomeController.shared.defaults.value(forKey: HomeController.shared.firstTimeViewAppearedAndInternetOkKey) != nil {

            self.setupValuesForPieChart()
        }

        if HomeController.shared.defaults.value(forKey: HomeController.shared.firstTimeViewAppearedAndNoInternetKey) != nil {

            self.setupValuesForPieChart()
        }
    }
    
    
    func setupNavigationBarTitle() {
        
        let title =  UILabel(frame: CGRect(x: 4, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height))
        title.text = "CARRE: Database"
        title.textColor = .white
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 22)
        
        navigationBar.addSubview(title)
    }
    
    
    func setupValuesForPieChart() {
        
        self.riskElementsTotalForPieChart = Double(CarreDatabaseService.shared.getRowsOfTable(forIdentifier: "RiskElements"))
        self.observablesTotalForPieChart = Double(CarreDatabaseService.shared.getRowsOfTable(forIdentifier: "Observables"))
        self.riskEvidencesTotalForPieChart = Double(CarreDatabaseService.shared.getRowsOfTable(forIdentifier: "RiskEvidences"))
        self.measurementTypesTotalForPieChart = Double(CarreDatabaseService.shared.getRowsOfTable(forIdentifier: "MeasurementTypes"))
        self.riskFactorsTotalForPieChart = Double(CarreDatabaseService.shared.getRowsOfTable(forIdentifier: "RiskFactors"))
        self.setupPieChart(withNumberOfRiskElements: self.riskElementsTotalForPieChart, withNumberOfObservables: self.observablesTotalForPieChart, withNumberOfRiskEvidences: self.riskEvidencesTotalForPieChart, withNumberOfMeasurementTypes: self.measurementTypesTotalForPieChart, withNumberOfRiskFactors: self.riskFactorsTotalForPieChart)
    }
    
    
    func setupPieChart(withNumberOfRiskElements numberOfRiskElements: Double, withNumberOfObservables numberOfObservables: Double, withNumberOfRiskEvidences numberOfRiskEvidences: Double, withNumberOfMeasurementTypes numberOfMeasurementTypes: Double, withNumberOfRiskFactors numberOfRiskFactors: Double) {
        
        var carreDataEntries: [PieChartDataEntry] = Array()
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.alignment = .center
        
        pieChartView.chartDescription!.enabled = true
        pieChartView.centerAttributedText = NSAttributedString(string: "Medical\nKnowledge\nStatistics", attributes: [.paragraphStyle: mutableParagraphStyle])
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = true
        pieChartView.isUserInteractionEnabled = false
        pieChartView.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 0)
        pieChartView.legend.enabled = false
        pieChartView.drawEntryLabelsEnabled = true
        pieChartView.entryLabelColor = UIColor.white
        
        carreDataEntries.append(PieChartDataEntry(value: numberOfMeasurementTypes, label: "Measurement\nTypes"))
        carreDataEntries.append(PieChartDataEntry(value: numberOfRiskFactors, label: "Risk Factors"))
        carreDataEntries.append(PieChartDataEntry(value: numberOfObservables, label: "Observables"))
        carreDataEntries.append(PieChartDataEntry(value: numberOfRiskEvidences, label: "Risk Evidences"))
        carreDataEntries.append(PieChartDataEntry(value: numberOfRiskElements, label: "Risk Elements"))
        
        let dataSet = PieChartDataSet(values: carreDataEntries, label: "")
        let riskElementsColour = UIColor.rgbWithAlphaSetTo1(red: 64, green: 89, blue: 128)
        let riskEvidencesColour = UIColor.rgbWithAlphaSetTo1(red: 149, green: 165, blue: 124)
        let measurementTypesColour = UIColor.rgbWithAlphaSetTo1(red: 217, green: 184, blue: 162)
        let observablesColour = UIColor.rgbWithAlphaSetTo1(red: 179, green: 48, blue: 80)
        let riskFactorsColour = UIColor.rgbWithAlphaSetTo1(red: 191, green: 134, blue: 134)
        dataSet.colors = [measurementTypesColour, riskFactorsColour, observablesColour, riskEvidencesColour, riskElementsColour]
        dataSet.drawValuesEnabled = true
        dataSet.entryLabelColor = .white
        dataSet.entryLabelFont = UIFont.systemFont(ofSize: 11)
        dataSet.valueColors = [UIColor.black]
        dataSet.yValuePosition = .outsideSlice
        dataSet.xValuePosition = .insideSlice
        
        self.pieChartView.animate(yAxisDuration: 2, easingOption: ChartEasingOption.easeInOutQuad)
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
    
    
    func compareGapBetweenDates() {
        
        newDateInSeconds = Int(date.timeIntervalSince1970)
        
        if HomeController.shared.defaults.value(forKey: HomeController.shared.oldDateKey) == nil {
            
            HomeController.shared.defaults.set(newDateInSeconds, forKey: HomeController.shared.oldDateKey)
        } else {
            
            oldDateInSeconds = HomeController.shared.defaults.value(forKey: HomeController.shared.oldDateKey) as! Int
            HomeController.shared.defaults.set(newDateInSeconds, forKey: HomeController.shared.oldDateKey)
            differenceBetweenDatesInSeconds = newDateInSeconds - oldDateInSeconds
        }
        
        if differenceBetweenDatesInSeconds >= 432000 {
            
            CarreDatabaseService.shared.dropAllBasicTables()
            CarreDataNetworkingService.shared.getCarreElements()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                CarreDatabaseService.shared.createAndFillBasicCarreTables()
                self.setupValuesForPieChart()
            }
            
            HomeController.shared.defaults.set(nil, forKey: HomeController.shared.oldDateKey)
        } else {
            
            self.setupValuesForPieChart()
        }
    }
    
    
    private func showNetworkAlert(forIdentifier identifier: String) -> Void {
        
        switch identifier {
            
        case basicTablesExistIdentifier:
            
            DispatchQueue.main.async {
                
                let networkAlert = UIAlertController(title: "No network", message: "Please check your network to update Carre database if necessary.", preferredStyle: .alert)
                
                networkAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    
                    self.isNetworkAvailable = true
                }))
                networkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(networkAlert, animated: true)
            }
            
        case basicTablesDontExistIdentifier:
            
            DispatchQueue.main.async {
                
                let networkAlert = UIAlertController(title: "No network", message: "Please check your network to build Carre database.", preferredStyle: .alert)
                
                networkAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    
                    self.isNetworkAvailable = true
                }))
                networkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(networkAlert, animated: true)
            }
            
        default:
            
            break
        }
    }
}
