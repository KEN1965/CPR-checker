//
//  SkillCheckViewController.swift
//  ChestCompressions
//
//  Created by 高浜賢一 on 2017/09/03.
//  Copyright © 2017年 Kenichi Takahama. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class SkillCheckViewController: UIViewController, UIGestureRecognizerDelegate {

    var count:Int = 1
    
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func Return(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    fileprivate var samples:[Int] = []
    fileprivate var lastTapTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//         averageLabel.font = UIFont.systemFont(ofSize: 23)
//         countLabel.font = UIFont.systemFont(ofSize: 20)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        collectBPMSample(Date(), optionalLastSample: self.lastTapTime)
        updateAverage()
        showTouch(sender.location(in: self.view))
         averageLabel.font = UIFont.systemFont(ofSize: 75)

        if sender.state == .ended {
            countLabel.text = "\(count) " + NSLocalizedString("Times", comment: "")

//            countLabel.text = NSLocalizedString(" \(count)  times", comment: "")
            count += 1
            countLabel.font = UIFont.systemFont(ofSize: 35)
            print(count)

        }

    }
    
    @IBAction func reset(_ sender: UIButton) {
        
        self.samples = []
        self.lastTapTime = nil
        
        self.averageLabel.text = NSLocalizedString("Tap to Start!", comment: "")
//        averageLabel.text = "Tap to Start"
        averageLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        countLabel.text = NSLocalizedString("Namber of taps", comment: "")
//        countLabel.text = "Namber of taps"
        countLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        count = 1
    }
    
    fileprivate func showTouch(_ touchLocation : CGPoint) {
        let circle = UIView(frame: CGRect(x: 0,y: 0,width: 35,height:35))
        circle.center = touchLocation
        circle.layer.cornerRadius = circle.frame.size.width/2
        circle.backgroundColor = UIColor.randomColor(0.3)

        self.view.insertSubview(circle, belowSubview: averageLabel)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: { () -> Void in
                        circle.transform = CGAffineTransform(scaleX: 8, y: 8)
                        circle.alpha = 0
        }) { (completed) -> Void in
            circle.removeFromSuperview()
        }
    }
    
    fileprivate func collectBPMSample(_ now : Date, optionalLastSample : Date?) {
        if let lastSample = optionalLastSample {
            let bpm = Int(60/now.timeIntervalSince(lastSample))
            self.samples += [bpm]
        }
        self.lastTapTime = now
    }
    
    fileprivate func updateAverage() {
        let optionalAverage = averageBPM(self.samples)
        if let average = optionalAverage {
            self.averageLabel.text = String(average)
        } else {
            self.averageLabel.text = NSLocalizedString("Start", comment: "")

        }
    }
    
    fileprivate func averageBPM(_ samples: [Int]) -> Int? {
        if (samples.count == 0) {
            return nil
        }
        
        ///////////////////////////////////
        // This is an intuitive jump from the for-in version, and is perfectly reasonable
        // This is probably the preferred solution, in terms of readability. In real life, this is what we'd do.
        ///////////////////////////////////
        
        let sum = samples.reduce(0) { $0 + $1 }
        return sum/samples.count
        
        ///////////////////////////////////
        // But filter is more powerful than that. Math!
        // (Literally math, that's a lot of multiplication and division: this is slower to execute)
        ///////////////////////////////////
        
        //        let avg = samples.reduce((0.0, 0.0), combine: { (accAndCount: (acc: Double, count: Double), next) -> (Double, Double) in
        //            let newCount = accAndCount.count + 1.0
        //            let newAcc = accAndCount.acc * (newCount - 1.0)/newCount + Double(next)*1.0/newCount
        //            return (newAcc, newCount)
        //        })
        //        return Int(avg.0)
        
        ///////////////////////////////////
        // This is identical to the code above, but less verbose.
        ///////////////////////////////////
        
        //        let avg = samples.reduce((0.0, 0.0)) { ($0.0 * $0.1/($0.1 + 1.0) + Double($1)*1.0/($0.1 + 1.0), ($0.1 + 1.0))}.0
        //        return Int(avg)
    }
    
  }

