//
//  HomeServicesViewController.swift
//  HomeTapHomie
//
//  Created by juan esteban chaparro on 28/07/17.
//  Copyright © 2017 Tres Astronautas. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import MBProgressHUD

class HomeServicesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ilustrationNoBooking: UIImageView!
    
    @IBOutlet weak var textNoBooking: UITextView!
    
    @IBOutlet weak var configureScheduleButton: UIButton!
    
    @IBOutlet weak var textBookings: UILabel!
    
    
    @IBOutlet weak var heigthImageConstraint: NSLayoutConstraint!
    
    var services:[Service] = []
    
    var ser : Service?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
         MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().addStateDidChangeListener(){auth, user in
            if user != nil {
                Homie.withID(id: (user?.uid)!, callback: {(homie) in
                    if homie == nil {
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                        self.performSegue(withIdentifier: "FillDataSeg", sender: self)
                    }
                    else{
                        K.User.homie = homie
                        K.User.inventory()
                        K.User.basePrice()
                        
                        if (K.User.homie?.blocked)!{
                             MBProgressHUD.hide(for: self.view, animated: true)
                            let alertController = UIAlertController(title: "Alerta", message: "Tu usuario aún no ha sido activado, debes esperar que lo activemos para poder utilizar la aplicación", preferredStyle: .alert)
                            self.present(alertController, animated: true, completion:nil)
                            
                            let listener = K.Database.ref().child("homies").child(K.User.homie!.uid!).child("blocked").observe(.value, with: { (snapshot) in
                                if let b = snapshot.value as? Bool {
                                    
                                    if(b == false){
                                        
                                    let cancelAction = UIAlertAction(title: "Continuar", style: .cancel) { (action:UIAlertAction!) in
                                    }
                                    alertController.addAction(cancelAction)
                                    }
                                    
                                    
                                }
                                
                            })
                            K.Database.ref().removeObserver(withHandle: listener)

                        }
                        
                        
                        
                        if let pending = K.User.homie?.notifications() {
                            for notification in pending {
                                switch notification.type! {
                                case 0:
                                    Service.withID(id: notification.uid!) { (service) in
                                        self.ser = service
                                        if (self.ser?.state == 0){
                                            
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerStartService") as! ViewControllerStartService
                                            controller.briefService = K.User.homie?.service_brief(serviceId: notification.uid!)
                                            controller.service = self.ser
                                            K.User.OnServiceId = notification.uid!
                                            
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        if (self.ser?.state == 1) {
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let controller = storyboard.instantiateViewController(withIdentifier: "ViewControllerEndService") as! ViewControllerEndService
                                            controller.briefService = K.User.homie?.service_brief(serviceId: notification.uid!)
                                            K.User.OnServiceId = notification.uid!
                                            controller.service = self.ser
                                            
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                    
                                default:
                                    break
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        if let token = Firebase.Messaging.messaging().fcmToken {
                            K.User.homie?.saveNotificationToken(token: token)
                        }
                        
                        if (K.User.homie?.services_brief()) != nil {
                            
                            K.User.homie = homie
                            self.services = (K.User.homie?.services_brief())!
                            self.tableView.reloadData()
                            
                             MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        else
                        {
                            self.tableView.alpha = 0
                            self.textBookings.alpha = 0
                            self.textNoBooking.alpha = 1
                            self.ilustrationNoBooking.alpha = 1
                            self.configureScheduleButton.alpha = 1
                            self.configureScheduleButton.isEnabled = true
                            
                            let screenSize = UIScreen.main.bounds
                            let screenHeighttt = screenSize.height
                            
                            if(screenHeighttt <= 480 ){
                                let he = self.heigthImageConstraint.constant
                                self.heigthImageConstraint.constant = (he/2)
                            
                            }
                             MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        
                         MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                })
            }else{
                
                 MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "AuthSeg", sender: self)
            }
            
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.configureScheduleButton.roundCorners(radius: K.UI.special_round_px)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            
            let obj = objectCell(brief: services[indexPath.row])
            
            
            cell.dayLable.text = String(obj.day)
            cell.monthLable.text = obj.month
            cell.hourLable.text = obj.hour
            cell.lastNameLable.text = obj.lastName
            cell.nameLable.text = obj.name
            cell.userImageView.circleImage()
            cell.userImageView.downloadedFrom(link: obj.imageClient , contentMode: .scaleAspectFill)
            cell.serviceValueLable.text = obj.price
            
            cell.mainBackground.addHomeCellShadow()
            cell.mainBackground.roundCorners(radius: K.UI.light_round_px)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            
            return cell
        } else {
            let vc = UIViewController.init(nibName: "CustomTableViewCell", bundle: nil)
            if let cell = vc.view as? CustomTableViewCell{
                
                
                let obj = objectCell(brief: services[indexPath.row])
                
                
                cell.dayLable.text = String(obj.day)
                cell.monthLable.text = obj.month
                cell.hourLable.text = obj.hour
                cell.lastNameLable.text = obj.lastName
                cell.nameLable.text = obj.name
                cell.userImageView.circleImage()
                cell.userImageView.downloadedFrom(link: obj.imageClient , contentMode: .scaleAspectFill)
                cell.serviceValueLable.text = obj.price
                cell.mainBackground.addHomeCellShadow()
                cell.mainBackground.roundCorners(radius: K.UI.light_round_px)
                
                
                return cell
            }
            else
            {
                return UITableViewCell()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    @IBAction func goToCalendar(_ sender: Any) {
        
        configureScheduleButton.tag = 1
        
        K.MaterialTapBar.TapBar?.tabBarTap( configureScheduleButton)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeSummaryServiceViewController") as! HomeSummaryServiceViewController
        controller.serviceBrief = services[indexPath.row]
        
        Service.withID(id: services[indexPath.row].uid!) { (service) in
            controller.service = service
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}
