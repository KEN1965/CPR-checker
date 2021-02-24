//
//  SkillCheckTimeViewController.swift
//  CPRChecker
//
//  Created by KEN on 2019/11/09.
//  Copyright © 2019 KEN. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class SkillCheckTimeViewController: UIViewController,UIGestureRecognizerDelegate {

    
    var count: Int = 1
    
    var countTimer: Timer?
    var startTime = Date()
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var timerSecLabel: UILabel!
    @IBOutlet weak var timerMsecLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var tapImage: UIImageView!
    
    @IBAction func Return(_sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate var samples:[Int] = []
    fileprivate var lastTapTime: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapImage.image = UIImage(named: "TapImage")
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        
        collectBPMSample(Date(), optionalLastSample: self.lastTapTime)
        if count < 31 {
            updateAverage()
        }

        showTouch(_touchLocation: sender.location(in: self.view))
        averageLabel.font = UIFont.systemFont(ofSize: 75)
        
        
        if sender.state == .ended {
            if count < 31 {
                countLabel.text = "\(count) " + NSLocalizedString("Times", comment: "")
                count += 1
                countLabel.font = UIFont.systemFont(ofSize: 35)
                
            }
            
            if count == 31 {
                countTimer?.invalidate()
                countLabel.text = NSLocalizedString("30 Times", comment: "")
                
                trans()
            }
            if count == 2 {
                countTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                
                countTimer?.fire()
                
                startTime = Date()
            }
        }
    }
    
    @objc func timerCounter() {
          let currentTime = Date().timeIntervalSince(startTime)
          
          let minute = (Int)(fmod((currentTime/60), 60))
          let second = (Int)(fmod(currentTime, 60))
          let msec = (Int)((currentTime - floor(currentTime))*100)
          
          _ = String(format: "%02d", minute)
          let sSecond = String(format:"%02d", second)
          let sMsec = String(format:"%02d",msec)
          
          timerSecLabel.text = sSecond
          timerMsecLabel.text = sMsec
          
      }
    
    @IBAction func reset(_ sender: UIButton) {
        
        self.samples = []
                self.lastTapTime = nil
                
                self.averageLabel.text = NSLocalizedString("Tap to Start!", comment: "")
                averageLabel.font = UIFont.boldSystemFont(ofSize: 30)
                
                countLabel.text = NSLocalizedString("Namber of taps", comment: "")
                countLabel.font = UIFont.boldSystemFont(ofSize: 20)
                
                timerSecLabel.text = "00"
                timerSecLabel.font = UIFont.boldSystemFont(ofSize: 30)
                timerMsecLabel.text = "00"
                timerMsecLabel.font = UIFont.boldSystemFont(ofSize: 30)
                
                count = 1
                
                tapImage.image = UIImage(named: "TapImage")
                
                countTimer?.invalidate()
                timerSecLabel.text = "00"
                timerMsecLabel.text = "00"
    }
    
      fileprivate func showTouch(_touchLocation : CGPoint) {
        
            let circle = UIView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
            circle.center = _touchLocation
            circle.layer.cornerRadius = circle.frame.size.width/2
            circle.backgroundColor = UIColor.randomColor(0.4)
            self.view.insertSubview(circle, belowSubview:averageLabel)
            
            UIView.animate(withDuration:2.0,
                            delay:0.0,
                            options: .allowUserInteraction,
                            animations: { () -> Void in
                                circle.transform = CGAffineTransform(scaleX: 8, y: 8)
                                circle.alpha = 0
            }) { (completed) -> Void in
                circle.removeFromSuperview()
            }
        }
        
        fileprivate func collectBPMSample(_ now : Date,optionalLastSample : Date?){
            
            if let lastSample = optionalLastSample {
                let bpm = Int(60/now.timeIntervalSince(lastSample))
                self.samples += [bpm]
            }
            self.lastTapTime = now
        }

        fileprivate func updateAverage() {
            let optionalAverage = averageBPM(_samples: self.samples)
            if let average = optionalAverage {
                self.averageLabel.text = String(average)
            } else {
                self.averageLabel.text = NSLocalizedString("Start", comment: "")
            }
        }
        
        fileprivate func averageBPM(_samples:[Int]) -> Int? {
            if (samples.count == 0) {
                return nil
            }
            let sum = samples.reduce(0) { $0 + $1 }
            return sum/samples.count
        }
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        
        func trans() {
            
            let average:Int = Int(averageLabel.text!)!
            if average <= (120) && average >= 100 {
                UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseIn,.autoreverse], animations: {
                    self.tapImage.image = UIImage(named: "Good")
                    
                })
            } else  if average >= (120) || average <= 100 {
                UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseIn,.autoreverse], animations: {
                    self.tapImage.image = UIImage(named: "Bad")
                })
            }
    }
    

}
