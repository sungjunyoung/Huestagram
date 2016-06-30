//
//  ContentViewController.swift
//  Huestagram
//
//  Created by 성준영 on 2016. 6. 29..
//  Copyright © 2016년 JUNYOUNG. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContentViewController: UIViewController {

    var pageIndex : Int!
    var imageData : NSData!
    var text : String!
    var color : UIColor!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(data:imageData!)
        self.colorView.backgroundColor = color
        self.textView.text = text
        
        colorView.backgroundColor = color
        
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        
        red = (red > 0.04045) ? pow((red + 0.055) / (1.0 + 0.055), 2.4) : (red / 12.92)
        green = (green > 0.04045) ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92)
        blue = (blue > 0.04045) ? pow((blue + 0.055) / (1.0 + 0.055), 2.4) : (blue / 12.92)
        
        let X = red * 0.490 + green * 0.310 + blue * 0.200
        let Y = red * 0.177 + green * 0.813 + blue * 0.011
        let Z = red * 0.0000000 + green * 0.010 + blue * 0.990
        
        let x = X / (X + Y + Z), y = Y / (X + Y + Z)
        
        let parameters: [String: AnyObject] = ["on":true, "sat":254, "bri":254,"hue":101010,"xy":[x,y]]
        
        let hueUrl = "http://172.30.1.7/api/H-jjdPINe0I19x1grnv9rlvyDnclBS7pL6ZtHqu3/lights/4/state"
        Alamofire.request(.PUT,hueUrl,parameters: parameters, encoding: .JSON).responseJSON{
            response in
            print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
