//
//  RiskFactorsBarChartController.swift
//  Carre1.0
//
//  Created by Nikolas on 19/04/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit


class RiskFactorsBarChartController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBarTitle()
    }
    
    
    func setupNavigationBarTitle() {
        
        let title =  UILabel(frame: CGRect(x: 4, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height))
        title.text = "CARRE: My Personal Risks"
        title.textColor = .white
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 22)
        
        navigationBar.addSubview(title)
    }
}
