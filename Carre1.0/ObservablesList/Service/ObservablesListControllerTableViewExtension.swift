//
//  ObjectivesListControllerTableViewExtension.swift
//  Carre1.0
//
//  Created by Nikolas on 29/03/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//

import Foundation
import UIKit


extension ObservablesListController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return observableNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: observablesListTableviewCellIdentifier, for: indexPath)
        cell.textLabel?.text = observableNames[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        observableName = observableNames[indexPath.row]
        
        performSegue(withIdentifier: segueToNewPersonalHealthRecordIdentifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueToNewPersonalHealthRecordIdentifier {
            
            let newPersonalHealthRecordVC = segue.destination as? NewPersonalHealthRecordController
            newPersonalHealthRecordVC?.observableName = self.observableName
        }
    }
}
