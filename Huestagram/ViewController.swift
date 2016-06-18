//
//  ViewController.swift
//  Huestagram
//
//  Created by junyoung on 2016. 6. 16..
//  Copyright (c) 2016 JUNYOUNG. All rights reserved.
//


import UIKit
import ChameleonFramework


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    var image : UIImage!
    var color : UIColor!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        
        image = UIImage(named:"Image1")!
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTap))
        
        imageView.addGestureRecognizer(tap)
        imageView.userInteractionEnabled = true
        
        imageView.image = image
        color = AverageColorFromImage(image)
        colorView.backgroundColor = color
    }

    func imageTap()
    {
        image = UIImage(named: "Image\(arc4random_uniform(3) + 1).jpg")!
        imageView.image = image
        color = AverageColorFromImage(image)
        colorView.backgroundColor = color

        print("Tapped on Image")
        
        
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }




}
