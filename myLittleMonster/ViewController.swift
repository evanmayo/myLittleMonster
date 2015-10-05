//
//  ViewController.swift
//  myLittleMonster
//
//  Created by Evan Leong on 10/1/15.
//  Copyright © 2015 Evan Leong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: MonsterImage!
    
    @IBOutlet weak var foodImage: DragImage!
    
    @IBOutlet weak var heartImage: DragImage!
    
    @IBOutlet var penalty1Img: UIImageView!
    
    @IBOutlet var penalty2Img: UIImageView!
    
    @IBOutlet var penalty3Img: UIImageView!
    
    @IBOutlet var playAgainBackground: UIImageView!
    
    @IBOutlet var restartButtonImage: UIButton!
    
    @IBOutlet var chooseGolemLabel: UILabel!
    
    @IBOutlet var golemSmallImage: UIButton!
    
    @IBOutlet var golemBigImage: UIButton!
    
    
    
    
    let DIM_ALPHA:CGFloat = 0.2
    let OPAQUE:CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem:UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    var chosenGolem = "Test"
    
    
    @IBAction func restartButton(sender: AnyObject) {
        
        restartGame()
    }
    
    @IBAction func golemSmallSelect(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "smallgolemSelect", object: nil))
        
        monsterImage.hidden = false
        
        hideStartAssets()
        
        startTimer()
    }
    
    
    @IBAction func golemBigSelect(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "golemSelect", object: nil))
        
        monsterImage.hidden = false
        
        hideStartAssets()
        
        startTimer()
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        
        
        
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.description)
        }
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        print("ItemDropped!")
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState () {
        
        if !monsterHappy {
            
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
                
            } else if penalties == 2 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
                
            } else if penalties == 3 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = OPAQUE
                
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                timer.invalidate()
                gameover()
            }
            
        }
        
        let rand = arc4random_uniform(2) //0 or 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
            
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameover() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeath.play()
        
        playAgainBackground.hidden = false
        restartButtonImage.hidden = false
        
        
    }
    
    func restartGame() {
        
        penalties = 0
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        playAgainBackground.hidden = true
        restartButtonImage.hidden = true
        
        monsterImage.idleAnimation()
        startTimer()
        
    }
    
    func startGame() {
        
        chooseGolemLabel.hidden = false
        golemBigImage.hidden = false
        golemSmallImage.hidden = false
    }
    
    func hideStartAssets() {
        
        chooseGolemLabel.hidden = true
        golemSmallImage.hidden = true
        golemBigImage.hidden = true
    }

}

