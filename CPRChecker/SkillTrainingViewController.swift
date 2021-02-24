//
//  SkillTrainingViewController.swift
//  CPRChecker
//
//  Created by KEN on 2019/11/09.
//  Copyright © 2019 KEN. All rights reserved.
//

import UIKit
import AVFoundation


class SkillTrainingViewController: UIViewController,AVAudioPlayerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var tempoField: UILabel!
    @IBOutlet weak var timerMinLabel: UILabel!
    @IBOutlet weak var timerSecLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    
    
    
    var musicPlayer = AVAudioPlayer()
    var timer: Timer!
    var countTimer: Timer!
    var startTime = Date()
    
    var tempo:String = "110"
    var tempoIsOn = false
    
    
//    @IBAction func Return(_sender:Any) {
//        
//        self.dismiss(animated: true, completion: nil)
////        self.navigationController?.popViewController(animated: true)
//        
//        musicPlayer.stop()
//        timer?.invalidate()
//        countTimer?.invalidate()
//    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempoSlider.value = 110

        let timerSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "sound1", ofType: "mp3")!)
        
        musicPlayer = try! AVAudioPlayer(contentsOf: timerSoundURL)
        
        musicPlayer.delegate = self
        musicPlayer.prepareToPlay()
        
        navigationController?.delegate = self
        
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
           if viewController is ViewController {
            musicPlayer.stop()
            tempoIsOn = false
            timer?.invalidate()
            countTimer?.invalidate()
           }
       }
    
    @IBAction func startButton(_ sender: UIButton) {
       
        if tempoIsOn {
            
            tempoSlider.isEnabled = true
            
            tempoIsOn = false
            timer?.invalidate()
            countTimer?.invalidate()
            
            startButton.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
            startButton.setTitleColor(.white, for: UIControl.State())
            timerMinLabel.text = "00"
            timerSecLabel.text = "00"
        
        
        } else {
            tempoIsOn = true
            
            tempoSlider.isEnabled = false
        
            
            let timerInterval:TimeInterval = round(60.0/Double(tempo)! * 1000)/1000
            
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(soundSet), userInfo: nil, repeats: true)
            
            countTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCounter), userInfo: nil
                , repeats: true)
            
            startTime = Date()
            
            let dispatchTime = DispatchTime.now() + 0.358
            DispatchQueue.main.asyncAfter(deadline: dispatchTime){
                self.timer.fire()
            }
            countTimer.fire()
            
//            startButton.setTitle(NSLocalizedString("STOP", comment: "") , for: .normal)
            startButton.setTitle(NSLocalizedString("STOP", comment: ""), for: .normal)
            startButton.setTitleColor(.white, for: UIControl.State())
            
        }
    }
    
    @objc func soundSet() {
        musicPlayer.play()
    }
    
    @objc func timerCounter() {
        
        let currentTime = Date().timeIntervalSince(startTime)
        
        let minute = (Int)(fmod((currentTime/60), 60))
        let second = (Int)(fmod(currentTime, 60))
        
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d",second)
        
        timerMinLabel.text = sMinute
        timerSecLabel.text = sSecond
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        sender.addTarget(self, action: #selector(tempoChanged), for:.allTouchEvents)
        
        tempoField.text = String(Int(tempoSlider.value))
        
    }
    @objc func tempoChanged(_ sender: UISlider) {
        
        tempo = String(TimeInterval(tempoSlider.value))
//        tempo = String(Int(tempoSlider.value))

    }
    

}
    
    
    

