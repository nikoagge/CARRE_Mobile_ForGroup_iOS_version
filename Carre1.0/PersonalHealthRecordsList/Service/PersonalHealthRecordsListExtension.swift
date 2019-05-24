//
//  PersonalHealthRecordsExtension.swift
//  Carre1.0
//
//  Created by Nikolas on 06/03/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import UIKit


extension PersonalHealthRecordsListController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personalHealthRecordsArrayOfDictionaries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let personalHealthRecordsListCustomCell = tableView.dequeueReusableCell(withIdentifier: personalHealthRecordsListCustomCellIdentifier, for: indexPath) as! PersonalHealthRecordsListCustomCell
        personalHealthRecordsListCustomCell.observableNameLabel.text = personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordObservableName"] as? String
        personalHealthRecordsListCustomCell.observableValueLabel.text = personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordObservableValue"] as? String
        personalHealthRecordsListCustomCell.dateValueLabel.text = getDateInString(forDate: personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordDateAndTimeValueInsertion"] as! Date) 
        
        return personalHealthRecordsListCustomCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showUpdateAndDeleteAlert()
        
        personalHealthRecordsTableView.deselectRow(at: indexPath, animated: true)
        PersonalHealthRecordsListController.shared.helpObservableName = personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordObservableName"]! as! String
        PersonalHealthRecordsListController.shared.helpObservableValue = personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordObservableValue"]! as! String
        PersonalHealthRecordsListController.shared.helpDateAndTimeInsertionValue = personalHealthRecordsArrayOfDictionaries[indexPath.row]["personalHealthRecordDateAndTimeValueInsertion"]! as! Date
    }
}
