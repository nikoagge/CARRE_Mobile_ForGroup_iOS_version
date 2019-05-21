//
//  NewPersonalHealthRecordController.swift
//  Carre1.0
//
//  Created by Nikolas on 01/04/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit
import SQLite

class NewPersonalHealthRecordController: UIViewController {


    @IBOutlet weak var observableNameLabel: UILabel!
    @IBOutlet weak var valueForObservableTextField: UITextField!
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    
    var observableName = String()
    var observableValue = String()
    var dateAndTimeInsertionValue = String()
    
    var labelAndEnumValuesDictionary = [String: String]()
    
    let enumValuesPicker = UIPickerView()
    var enumValuesData = [String]()
    
    static let shared = NewPersonalHealthRecordController()

    let reloadTableViewNotification = NSNotification.Name("reloadTableViewNotification")
    let hasNewPersonalHealthRecordViewControllerAppearedNotification = NSNotification.Name("hasNewPersonalHealthRecordViewControllerAppearedNotification")
    
    var newRecord = Bool()
    var updateRecord = Bool()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        enumValuesPicker.delegate = self
        enumValuesPicker.dataSource = self
        
        CarreDatabaseService.shared.connectToDatabase()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if NewPersonalHealthRecordController.shared.newRecord {
            
            observableNameLabel.text = observableName
            
            //CarreDatabaseService.shared.printRiskElementId(forObservableName: observableNameLabel.text!)
            
            labelAndEnumValuesDictionary = CarreDatabaseService.shared.getLabelAndEnumValues(forObservableName: observableName)
            
            if labelAndEnumValuesDictionary["label"] != "" {
                
                valueForObservableTextField.placeholder = labelAndEnumValuesDictionary["label"]
            } else {
                
                enumValuesData = (labelAndEnumValuesDictionary["enumValues"]?.components(separatedBy: ";"))!
                
                valueForObservableTextField.text = enumValuesData[0]
                valueForObservableTextField.inputView = enumValuesPicker
                
                //createToolBar(forIdentifier: "enumValues")
            }
        }
        
        if NewPersonalHealthRecordController.shared.updateRecord {
            
            
            observableNameLabel.text = PersonalHealthRecordsListController.shared.helpObservableName
            valueForObservableTextField.text = PersonalHealthRecordsListController.shared.helpObservableValue
            dateAndTimeTextField.text = PersonalHealthRecordsListController.shared.helpDateAndTimeInsertionValue
            labelAndEnumValuesDictionary = CarreDatabaseService.shared.getLabelAndEnumValues(forObservableName: PersonalHealthRecordsListController.shared.helpObservableName)
            
            if labelAndEnumValuesDictionary["label"] == "" {
                
                enumValuesData = (labelAndEnumValuesDictionary["enumValues"]?.components(separatedBy: ";"))!
                enumValuesPicker.selectRow(enumValuesData.firstIndex(of: valueForObservableTextField.text!)!, inComponent: 0, animated: true)
                valueForObservableTextField.inputView = enumValuesPicker
                
                //createToolBar(forIdentifier: "enumValues")
            }
        }
        
        createToolBar(forIdentifier: "valueForObservableTextField")
    }
    
    
    func createToolBar(forIdentifier identifier: String) {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewPersonalHealthRecordController.dismissKeyboard))
        
        //Customizations
//        toolbar.barTintColor = .black
//        toolbar.tintColor = .white //color of the text
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        switch identifier {
            
        case "valueForObservableTextField":
            
            valueForObservableTextField.inputAccessoryView = toolbar
            
        case "dateAndTime":
            
            dateAndTimeTextField.inputAccessoryView = toolbar
            
        default:
            
            break
        }
    }
    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    
    @IBAction func dateAndTimeTextFieldEditing(_ sender: UITextField) {
        
        let dateAndTimePickerView = UIDatePicker()
        dateAndTimePickerView.datePickerMode = .dateAndTime
        sender.inputView = dateAndTimePickerView
        dateAndTimePickerView.addTarget(self, action: #selector(dateAndTimePickerValueChanged), for: .valueChanged)
        createToolBar(forIdentifier: "dateAndTime")
    }
    
    
    @objc func dateAndTimePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .short
        dateAndTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        setValuesToFalse()
        
        self.dismiss(animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            NotificationCenter.default.post(name: self.hasNewPersonalHealthRecordViewControllerAppearedNotification, object: nil)
        }
    }
    
    
    func giveValuesToAllTheFieldsAlert() {
        
        let alert = UIAlertController(title: "Fill in all the fields", message: "Please fill in all the fields.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if valueForObservableTextField.text == "" || dateAndTimeTextField.text == "" {
            
            giveValuesToAllTheFieldsAlert()
        } else {
            
            let date = getDateFromDateTextField()
            if NewPersonalHealthRecordController.shared.newRecord {
                
                CarreDatabaseService.shared.insertNewPersonalHealthRecord(forObservableName: observableNameLabel.text!, forObservableValue: valueForObservableTextField.text!, forDateAndTime: date)
                //CarreDatabaseService.shared.printRiskElementId(forObservableName: observableNameLabel.text!)
                actionsAfterInsertOrUpdatePersonalHealthRecord()
            }
            
            if NewPersonalHealthRecordController.shared.updateRecord {
               
                guard let personalHealthRecordForUpdate = PersonalHealthRecordsListController.shared.personalHealthRecord else { return }
                CarreDatabaseService.shared.updatePersonalHealthRecord(forPersonalHealthRecord: personalHealthRecordForUpdate, forObservableName: observableNameLabel.text!, forObservableValue: valueForObservableTextField.text!, forDateAndTimeValueInsertion: date)
                
                actionsAfterInsertOrUpdatePersonalHealthRecord()
            }
        }
        
        setValuesToFalse()
    }
    
    
    func setValuesToFalse() {
        
        NewPersonalHealthRecordController.shared.newRecord = false
        NewPersonalHealthRecordController.shared.updateRecord = false
    }
    
    
    func actionsAfterInsertOrUpdatePersonalHealthRecord() {
        
        self.dismiss(animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            NotificationCenter.default.post(name: self.reloadTableViewNotification, object: nil)
            NotificationCenter.default.post(name: self.hasNewPersonalHealthRecordViewControllerAppearedNotification, object: nil)
        }
    }
    
    
    func getDateFromDateTextField() -> Date {
        
        var returnedDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        returnedDate = dateFormatter.date(from: dateAndTimeTextField.text!)!
        
        return returnedDate
    }
}
