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

class ViewController: UIViewController , UIPageViewControllerDataSource{
    @IBOutlet weak var mainColorView: UIView!
    
    var pageViewController :UIPageViewController!
    var pageImageDataArr = Array<NSData>()
    var pageColorArr = Array<UIColor>()
    var textArr = Array<String>()

    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        
        for i in 0 ..< 5 {
            initData(i)
        }
        self.mainColorView.backgroundColor = self.pageColorArr[0]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        let viewController = NSArray(object:startVC)
        
        self.pageViewController.setViewControllers(viewController as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        pageImageDataArr.removeAll()
        pageColorArr.removeAll()
        textArr.removeAll()
        super.viewDidAppear(false)
        for i in 0..<5{
            initData(i)
        }
    }
    
    func initData(index:Int){
        var imageUrl:NSURL!
        var userText:String!
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=2208353345.5e673c6.bb9a60eedb8d461eac9dd99108fd3ced"
        var finishFlag = 0
        Alamofire.request(.GET,url).responseJSON { response in
            var json = JSON(data: response.data!)
            if response.result.isSuccess{
                if let stringUrl = json["data"][index]["images"]["standard_resolution"]["url"].rawString() {
                    //Do something you want
                    imageUrl = NSURL(string: stringUrl)
                    finishFlag = 1
                }
                
                if let stringText = json["data"][index]["caption"]["text"].rawString() {
                    //Do something you want
                    userText = stringText
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
        
        if(finishFlag == 1){
            
            print (imageUrl)
            let myData = NSData(contentsOfURL:imageUrl)
            self.pageImageDataArr.append(myData!)
            
            let image = UIImage(data:myData!)
            let color = AverageColorFromImage(image!)
            self.pageColorArr.append(color)
            
            self.textArr.append(userText)
        }
    }
    
    func viewControllerAtIndex(index : Int)->ContentViewController{
        if((self.pageImageDataArr.count == 0) || (index >= self.pageImageDataArr.count)){
            return ContentViewController()
        }
       

        let vc :ContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
       
        vc.imageData = pageImageDataArr[index] 
        vc.color = pageColorArr[index]
        vc.text = textArr[index]
        
        vc.pageIndex = index
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        index-=1
        if(index+1 == 0 || index == NSNotFound){
            return nil
        }
        

        UIView.animateWithDuration(0.1, delay: 0.0, options:[UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowAnimatedContent], animations: {
            self.mainColorView.backgroundColor = self.pageColorArr[index]
            
            }, completion: nil)
        
       
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        index+=1
        if(index-1 == NSNotFound){
            return nil
        }
        if (index-1 == self.pageImageDataArr.count-1){
            return nil
        }
        UIView.animateWithDuration(0.1, delay: 0.0, options:[UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowAnimatedContent], animations: {
            self.mainColorView.backgroundColor = self.pageColorArr[index]
            
            }, completion: nil)
        
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImageDataArr.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}


