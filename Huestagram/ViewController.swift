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
    
    var pageViewController :UIPageViewController!
    var pageImageDataArr = Array<NSData>()
    var pageColorArr = Array<UIColor>()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        
        for i in 0 ..< 5 {
            initData(i)
        }
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        let viewController = NSArray(object:startVC)
        
        self.pageViewController.setViewControllers(viewController as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func initData(index:Int){
        
        var imageUrl:NSURL!
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
        }
    }
    
    func viewControllerAtIndex(index : Int)->ContentViewController{
        if((self.pageImageDataArr.count == 0) || (index >= self.pageImageDataArr.count)){
            return ContentViewController()
        }
       

        let vc :ContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.imageData = pageImageDataArr[index] 
        vc.color = pageColorArr[index]
        vc.pageIndex = index
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        
        index-=1
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            return nil
        }
        
        index+=1
        
        if (index == self.pageImageDataArr.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImageDataArr.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}


