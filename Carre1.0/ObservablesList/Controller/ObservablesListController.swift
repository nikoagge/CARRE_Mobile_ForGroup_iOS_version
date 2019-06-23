//
//  ObjectivesListController.swift
//  Carre1.0
//
//  Created by Nikolas on 29/03/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit


class ObservablesListController: UIViewController {

    
    @IBOutlet weak var observablesListTableView: UITableView!
    
    var observableNames = [String]()
    var observablesMeasurementType = [String]()
    var observableName = String()
    var observableMeasurementType = String()
    var observablesData = [[String: Any]]()
   
    let observablesListTableviewCellIdentifier = "observablesListTableviewCell"
    let segueToNewPersonalHealthRecordIdentifier = "segueToNewPersonalHealthRecord"
    let hasNewPersonalHealthRecordViewControllerAppearedNotificationIdentifier = "hasNewPersonalHealthRecordViewControllerAppearedNotification"
    
    static let shared = ObservablesListController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        observableNames = CarreDatabaseService.shared.getAllObservablesNames()
        observablesMeasurementType = CarreDatabaseService.shared.getObservablesMeasurementType()
        
        observablesListTableView.tableFooterView = UIView()
        
        let hasNewPersonalHealthRecordViewControllerAppearedNotification = NSNotification.Name(hasNewPersonalHealthRecordViewControllerAppearedNotificationIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissObservablesList), name: hasNewPersonalHealthRecordViewControllerAppearedNotification, object: nil)
    }
    
    
    @objc func dismissObservablesList() {
        
        self.dismiss(animated: false)
    }
}
