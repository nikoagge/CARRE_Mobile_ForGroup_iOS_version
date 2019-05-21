//
//  PageController.swift
//  Carre1.0
//
//  Created by Nikolas on 15/12/2018.
//  Copyright © 2018 Nikolas Aggelidis. All rights reserved.
//

import UIKit


class PageController: UIPageViewController {
    
    
    var pageControl = UIPageControl()
    
    var pageSBIdentifier = "Page"
    var homeSBRIDIdentifier = "HomeSBRID"
    var personalHealthRecordsListSBRIDIdentifier = "PersonalHealthRecordsListSBRID"
    var riskFactorsBarChartSBRIDIdentifier = "RiskFactorsBarChartSBRID"
    
    static let shared = PageController()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        
        return [self.newViewController(withStoryboardId: self.homeSBRIDIdentifier), self.newViewController(withStoryboardId: self.personalHealthRecordsListSBRIDIdentifier), self.newViewController(withStoryboardId: self.riskFactorsBarChartSBRIDIdentifier)]
    }()
    
    
    private func newViewController(withStoryboardId storyboardId: String) -> UIViewController {
        
        return UIStoryboard(name: self.pageSBIdentifier, bundle: nil).instantiateViewController(withIdentifier: storyboardId)
    }
    
    
    func configurePageControl() {
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 10, width: UIScreen.main.bounds.width, height: 0))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        if let homeViewController = orderedViewControllers.first {

            setViewControllers([homeViewController], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
    }
}
