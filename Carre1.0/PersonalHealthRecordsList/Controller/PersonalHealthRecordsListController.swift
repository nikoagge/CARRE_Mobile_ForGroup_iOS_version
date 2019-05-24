//
//  PersonalHealthRecordsController.swift
//  Carre1.0
//
//  Created by Nikolas on 09/01/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//

import UIKit
import SQLite

class PersonalHealthRecordsListController: UIViewController {

    
    @IBOutlet weak var availablePHRs: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var personalHealthRecordsTableView: UITableView!
    
    var personalHealthRecordsArrayOfDictionaries = [[String: Any]]()
    var personalHealthRecordsRiskElements = [String]()
    
    let segueToNewPersonalHealthRecordIdentifier = "segueToNewPersonalHealthRecord"
    let personalHealthRecordsListCustomCellIdentifier = "personalHealthRecordsListCustomCell"
    let reloadTableViewNotificationIdentifier = "reloadTableViewNotification"
    let segueToObservablesListIdentifier = "segueToObservablesList"
    
    var helpObservableName = String()
    var helpObservableValue = String()
    var helpDateAndTimeInsertionValue = Date()
    
    var personalHealthRecord: Table?
    
    static let shared = PersonalHealthRecordsListController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupNavigationBarTitle()
        customizeButton()
        
        personalHealthRecordsTableView.tableFooterView = UIView()
        
        CarreDatabaseService.shared.connectToDatabase()
        
        let reloadTableViewNotification = NSNotification.Name(reloadTableViewNotificationIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: reloadTableViewNotification, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        reloadTableView()
        
        CarreDatabaseService.shared.printPersonalHealthRecordsRiskElementId()
    }
    
    
    func setupNavigationBarTitle() {
        
        let title =  UILabel(frame: CGRect(x: 4, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height))
        title.text = "CARRE: Personal Health Records"
        title.textColor = .white
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 22)
        
        navigationBar.addSubview(title)
    }
    
    
    func customizeButton() {
        
        addButton.clipsToBounds = true
        addButton.backgroundColor = UIColor.rgbWithAlphaSetTo255(red: 255, green: 64, blue: 129)
        addButton.titleLabel?.textAlignment = .center
    }

    
    func showUpdateAndDeleteAlert() {
        
        let alert = UIAlertController(title: "Update/delete personal health record.", message: "Please upadte/delete personal health record you want.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (_) in
            
            NewPersonalHealthRecordController.shared.updateRecord = true
            
            self.getPersonalHealthRecord()
            
            self.performSegue(withIdentifier: self.segueToNewPersonalHealthRecordIdentifier, sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            self.getPersonalHealthRecord()
            
            guard let personalHealthRecordForDelete = PersonalHealthRecordsListController.shared.personalHealthRecord else { return }
            
            CarreDatabaseService.shared.deletePersonalHealthRecord(forPersonalHealthRecord: personalHealthRecordForDelete)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @objc func reloadTableView() {
        
        personalHealthRecordsArrayOfDictionaries = CarreDatabaseService.shared.getAllPersonalHealthRecords()
        
        //PersonalHealthRecordsListController.shared.personalHealthRecordsRiskElements = CarreDatabaseService.shared.getPersonalHealthRecordsRiskElements()
        
        //print(PersonalHealthRecordsListController.shared.personalHealthRecordsRiskElements)
        
        self.personalHealthRecordsTableView.reloadData()
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        NewPersonalHealthRecordController.shared.newRecord = true
        
        performSegue(withIdentifier: segueToObservablesListIdentifier, sender: self)
    }
    
    
    func getPersonalHealthRecord() {
        
        PersonalHealthRecordsListController.shared.personalHealthRecord = CarreDatabaseService.shared.getPersonalHealthRecord(forObservableName: PersonalHealthRecordsListController.shared.helpObservableName, forObservableValue: PersonalHealthRecordsListController.shared.helpObservableValue, forDateAndTimeValueInsertion: PersonalHealthRecordsListController.shared.helpDateAndTimeInsertionValue)
    }
    
    
    func getDateInString(forDate date: Date) -> String {
        
        var returnedString = String()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        returnedString = dateFormatter.string(from: date)
        
        return returnedString
    }
}


