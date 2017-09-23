//
//  HomeSummaryServiceViewController.swift
//  HomeTapHomie
//
//  Created by juan esteban chaparro on 10/08/17.
//  Copyright © 2017 Tres Astronautas. All rights reserved.
//

import UIKit
import GoogleMaps
class HomeSummaryServiceViewController: UIViewController {

    
    @IBOutlet weak var clientPhoto: UIImageView!
    
    
    @IBOutlet weak var clientName: UILabel!
    
    
    @IBOutlet weak var dateService: UILabel!
    
    
    @IBOutlet weak var hourService: UILabel!
    
    
    @IBOutlet weak var adressService: UILabel!
    
    
    @IBOutlet weak var comentsService: UILabel!
    
    
    @IBOutlet weak var extraServicesValue: UILabel!
    
    
    @IBOutlet weak var buttonHowToGo: UIButton!
    
    
    @IBOutlet weak var buttonCancelService: UIButton!
    
    @IBOutlet weak var stackViewIcons: UIStackView!
    
    @IBOutlet weak var stackViewServices: UIStackView!
    
    @IBOutlet weak var buttonInformationServ: UIButton!
    
    
    var serviceBrief: Service?
    var service : Service?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        if  service != nil {
            
            self.clientName.text = serviceBrief?.briefName
            self.clientPhoto.downloadedFrom(link: (serviceBrief?.briefPhoto)!, contentMode: UIViewContentMode.scaleAspectFill)
            self.dateService.text = service?.date?.toString(format: Date.DateFormat.Short)
           
            self.hourService.text = service?.date?.toString(format: .Time
            )
            
            self.adressService.text = service?.place?.address
            
            
            
            
            let val = ((service?.price)!-Double(65000))
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0

            if var formattedTipAmount = formatter.string(from: val as NSNumber) {
                
                formattedTipAmount.remove(at: formattedTipAmount.startIndex)
                
                self.extraServicesValue.text = formattedTipAmount + " COP"
                
            }
        
            self.comentsService.text = service?.comments
            
            if (service?.additionalServices()) != nil {

            
            for ser in  (service?.additionalServices())!{
                
                // image icon
                let imageName = "iconServiceChecked.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15)
                imageView.addConstraint(widthConstraint)
                let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15)
                
                imageView.addConstraint(heightConstraint)
                
                stackViewIcons.addArrangedSubview(imageView)
                
                // lable service
                let label = UILabel()
                label.text = ser.descriptionH
                label.font = UIFont(name: "Rubik-Light", size: 13)
                
                stackViewServices.addArrangedSubview(label)
            }
            
            
            }
            
            
            
            

            
        }
        else
        {
            print("el nil")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.buttonCancelService.roundCorners(radius: K.UI.special_round_px)
        self.buttonHowToGo.roundCorners(radius: K.UI.special_round_px)
        self.clientPhoto.circleImage()
        self.buttonInformationServ.roundCorners(radius: K.UI.round_to_circle)
    }

    
    @IBAction func dismis(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func whereGo(_ sender: Any) {
        
        print(service?.place?.lat ?? "no lat")
        
        print(service?.place?.long ?? "no lng")
        
        let lat = service?.place?.lat
        let lon = service?.place?.long
        
        print(lat ?? "no lat")
        
        print(lon ?? "no lng")
        
        if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "https://maps.google.com//?saddr=&daddr=\(Float(lat!)),\(Float(lon!))&directionsmode=driving")! as URL)
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
 
    }
                
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
