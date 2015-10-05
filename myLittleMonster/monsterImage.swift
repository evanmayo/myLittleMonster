//
//  monsterImage.swift
//  myLittleMonster
//
//  Created by Evan Leong on 10/3/15.
//  Copyright © 2015 Evan Leong. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "smallgolemSelected:", name: "smallgolemSelect", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "golemSelected:", name: "golemSelect", object: nil)
    }
    
    var golemChosen: String!
    
    func golemSelected(notif: AnyObject) {
        
        golemChosen = "golem"
        
        idleAnimation()
        
    }
    
    func smallgolemSelected(notif: AnyObject) {
        
        golemChosen = "smallgolem"
        
        idleAnimation()
        
    }
    
    
    
    func idleAnimation() {
        
        self.image = UIImage(named: "idle\(golemChosen)1.png")
        
        self.animationImages = nil
        
        //create the image array
        
        var imageArray = [UIImage]()
        
        //create a loop that makes a variable of each # for the images
        for var x = 1; x <= 4; x++ {
            let image = UIImage(named: "idle\(golemChosen)\(x).png")
            
            print("idle\(golemChosen)\(x).png")
            
            // add the image to the image array
            imageArray.append(image!)
        }
        
        //grab hte animations to imageArray, make the duration etc.  0 for repeat count will be infinite, start animating is the func
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "dead\(golemChosen)5.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 5; x++ {
            let image = UIImage(named: "dead\(golemChosen)\(x).png")
            
            imageArray.append(image!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
}

