
//
//  MaterialTapBarViewController.swift
//  HomeTapHomie
//
//  Created by juan esteban chaparro on 15/08/17.
//  Copyright © 2017 Tres Astronautas. All rights reserved.
//

import UIKit

class MaterialTapBarViewController: UIViewController {
    
    
    
    @IBOutlet weak var tabBarBackground: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgIcon1: UIImageView!
    @IBOutlet weak var imgIcon2: UIImageView!
    @IBOutlet weak var imgIcon3: UIImageView!
    @IBOutlet weak var imgIcon4: UIImageView!
    @IBOutlet weak var imgIcon5: UIImageView!
    
    @IBOutlet weak var tabTitle1: UILabel!
    @IBOutlet weak var tabTitle2: UILabel!
    @IBOutlet weak var tabTitle3: UILabel!
    @IBOutlet weak var tabTitle4: UILabel!
    @IBOutlet weak var tabTitle5: UILabel!
    
    @IBOutlet weak var constraintIcon2: NSLayoutConstraint!
    @IBOutlet weak var constraintIcon3: NSLayoutConstraint!
    @IBOutlet weak var constraintIcon4: NSLayoutConstraint!
    @IBOutlet weak var constraintIcon5: NSLayoutConstraint!
    
    var images: [UIImageView] = []
    var labels: [UILabel] = []
    
    var selectedIndex = -1
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        images = [imgIcon1, imgIcon2, imgIcon3, imgIcon4, imgIcon5]
        labels = [tabTitle1, tabTitle2, tabTitle3, tabTitle4, tabTitle5]
        
        let inventoryViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InventoryView")
        let calendarViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarView")
        let homeViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView")
        let historyViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryView")
        let profileViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView")
        
        
        viewControllers = [inventoryViewController,calendarViewController, homeViewController, historyViewController, profileViewController]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        K.MaterialTapBar.TapBar = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarBackground.addInvertedShadow()
        
        if selectedIndex == -1 {
            selectedIndex = 2
            let home = viewControllers[2]
            self.addChildViewController(home)
            self.view.insertSubview(home.view, aboveSubview: self.mainView)
            home.view.frame = self.mainView.bounds
            home.didMove(toParentViewController: self)
            images[selectedIndex].isHighlighted = true
            labels[selectedIndex].textColor = K.UI.main_color
        }
    }
    
    public func reloadViewController() {
        var reloadedViewController: UIViewController = UIViewController()
        switch selectedIndex {
        case 0:
            reloadedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InventoryView")
        case 1:
            reloadedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarView")
        case 2:
            reloadedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView")
        case 3:
            reloadedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryView")
        case 4:
            reloadedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView")
        default:
            return
        }
        
        let previous_vc = self.viewControllers[selectedIndex]
        previous_vc.dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.3, animations: {() in
            previous_vc.view.alpha = 0
        })
        
        previous_vc.willMove(toParentViewController: nil)
        previous_vc.view.removeFromSuperview()
        previous_vc.removeFromParentViewController()
        
        self.view.insertSubview(reloadedViewController.view, aboveSubview: self.mainView)
        
        reloadedViewController.view.alpha = 0
        
        self.addChildViewController(reloadedViewController)
        reloadedViewController.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.3, animations: {() in
            self.view.layoutIfNeeded()
            reloadedViewController.view.alpha = 1
            reloadedViewController.view.frame = self.mainView.bounds
        })
        
        self.viewControllers[selectedIndex] = reloadedViewController
        
    }
    
    @IBAction func tabBarTap(_ sender: UIButton) {
        if(sender.tag == selectedIndex) {
            //reloadViewController()
            return
        }
        
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        UIView.animate(withDuration: 0.3, animations: {() in
            self.labels[self.selectedIndex].alpha = 0
        })
        
        
        switch selectedIndex {
        case 0:
            self.constraintIcon2 = self.constraintIcon2.setMultiplier(multiplier: 0.95)
            self.constraintIcon3 = self.constraintIcon3.setMultiplier(multiplier: 0.95)
            self.constraintIcon4 = self.constraintIcon4.setMultiplier(multiplier: 0.95)
            self.constraintIcon5 = self.constraintIcon5.setMultiplier(multiplier: 0.95)
        case 1:
            self.constraintIcon2 = self.constraintIcon2.setMultiplier(multiplier: 1.2)
            self.constraintIcon3 = self.constraintIcon3.setMultiplier(multiplier: 0.95)
            self.constraintIcon4 = self.constraintIcon4.setMultiplier(multiplier: 0.95)
            self.constraintIcon5 = self.constraintIcon5.setMultiplier(multiplier: 0.95)
        case 2:
            self.constraintIcon2 = self.constraintIcon2.setMultiplier(multiplier: 0.95)
            self.constraintIcon3 = self.constraintIcon3.setMultiplier(multiplier: 1.2)
            self.constraintIcon4 = self.constraintIcon4.setMultiplier(multiplier: 0.95)
            self.constraintIcon5 = self.constraintIcon5.setMultiplier(multiplier: 0.95)
        case 3:
            self.constraintIcon2 = self.constraintIcon2.setMultiplier(multiplier: 0.95)
            self.constraintIcon3 = self.constraintIcon3.setMultiplier(multiplier: 0.95)
            self.constraintIcon4 = self.constraintIcon4.setMultiplier(multiplier: 1.2)
            self.constraintIcon5 = self.constraintIcon5.setMultiplier(multiplier: 0.95)
        case 4:
            self.constraintIcon2 = self.constraintIcon2.setMultiplier(multiplier: 0.95)
            self.constraintIcon3 = self.constraintIcon3.setMultiplier(multiplier: 0.95)
            self.constraintIcon4 = self.constraintIcon4.setMultiplier(multiplier: 0.95)
            self.constraintIcon5 = self.constraintIcon5.setMultiplier(multiplier: 1.2)
            
        default:
            return
        }
        
        
        let previous_vc = self.viewControllers[previousIndex]
        previous_vc.willMove(toParentViewController: nil)
        previous_vc.view.removeFromSuperview()
        previous_vc.removeFromParentViewController()
        
        let selected_vc = self.viewControllers[selectedIndex]
        self.view.insertSubview(selected_vc.view, aboveSubview: self.mainView)
        
        let direction = CGFloat((selectedIndex - previousIndex)/abs(selectedIndex - previousIndex))
        
        selected_vc.view.frame = CGRect(x: self.mainView.bounds.origin.x + (direction * self.mainView.bounds.size.width), y: self.mainView.bounds.origin.y, width: self.mainView.bounds.size.width, height: self.mainView.bounds.size.height)
        
        self.addChildViewController(selected_vc)
        selected_vc.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.3, animations: {() in
            self.view.layoutIfNeeded()
            self.images[previousIndex].isHighlighted = false
            self.labels[previousIndex].textColor = K.UI.tab_color
            self.images[self.selectedIndex].isHighlighted = true
            self.labels[self.selectedIndex].textColor = K.UI.main_color
            self.labels[self.selectedIndex].alpha = 1
            selected_vc.view.frame = self.mainView.bounds
        })
        
    }
    
    
@objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            let b = UIButton()
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                b.tag = selectedIndex > 0 ? selectedIndex-1 : 0
            case UISwipeGestureRecognizerDirection.left:
                b.tag = selectedIndex < (viewControllers.count - 1) ? (selectedIndex+1) : (viewControllers.count - 1)
            default:
                break
            }
            tabBarTap(b)
        }
    }
    
}
