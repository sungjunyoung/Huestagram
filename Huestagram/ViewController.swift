//
//  ViewController.swift
//  Huestagram
//
//  Created by junyoung on 2016. 6. 16..
//  Copyright (c) 2016 JUNYOUNG. All rights reserved.
//


import UIKit
import ChameleonFramework
import SwiftyHue
import Gloss
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    var image : UIImage!
    var color : UIColor!
    

    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        var imageUrl:NSURL!
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=2208353345.5e673c6.bb9a60eedb8d461eac9dd99108fd3ced"
        var finishFlag = 0
        Alamofire.request(.GET,url).responseJSON { response in
            var json = JSON(data: response.data!)
            if response.result.isSuccess{
                if let stringUrl = json["data"][0]["images"]["standard_resolution"]["url"].rawString() {
                    //Do something you want
                    imageUrl = NSURL(string: stringUrl)
                    finishFlag = 1
                }
            } else{
                print ("no")
                finishFlag = 0
            }
            
            
        }
    
        while(finishFlag == 0){
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
       
        print (imageUrl)
        let myData = NSData(contentsOfURL:imageUrl)
        imageView.image = UIImage(data:myData!)
        image = UIImage(data:myData!)
        
        color = AverageColorFromImage(image)
        colorView.backgroundColor = color
        
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        red = red/255
        green = green/255
        blue = blue/255
        
        red = (red > 0.04045) ? pow((red + 0.055) / (1.0 + 0.055), 2.4) : (red / 12.92)
        green = (green > 0.04045) ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92)
        blue = (blue > 0.04045) ? pow((blue + 0.055) / (1.0 + 0.055), 2.4) : (blue / 12.92)
        
        let X = red * 0.649926 + green * 0.103455 + blue * 0.197109
        let Y = red * 0.234327 + green * 0.743075 + blue * 0.022598
        let Z = red * 0.0000000 + green * 0.053077 + blue * 1.035763
        
        let x = X / (X + Y + Z), y = Y / (X + Y + Z)

        let parameters: [String: AnyObject] = ["on":true, "sat":254, "bri":254,"hue":101010,"xy":[x,y]]
        
        let hueUrl = "http://172.30.1.7/api/H-jjdPINe0I19x1grnv9rlvyDnclBS7pL6ZtHqu3/lights/1/state"
        Alamofire.request(.PUT,hueUrl,parameters: parameters, encoding: .JSON).responseJSON{
            response in
            print(response)
        }

    }
    
}


