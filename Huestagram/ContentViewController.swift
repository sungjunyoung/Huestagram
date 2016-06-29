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
    var color : UIColor!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(data:imageData!)
        self.colorView.backgroundColor = color
        
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
