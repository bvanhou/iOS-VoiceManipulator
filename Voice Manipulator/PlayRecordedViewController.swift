//
//  PlayRecordedViewController.swift
//  Voice Manipulator
//
//  Created by Benjamin on 12/23/15.
//  Copyright © 2015 BenjaminVanHouten. All rights reserved.
//

import UIKit
import AVFoundation

class PlayRecordedViewController: UIViewController {

    @IBOutlet weak var stopPlayBack: UIButton!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        try! audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayRecordedSoundSlow(sender: UIButton) {
        manipulateAudioPlayer(0.5)
    }
    
    @IBAction func PlayRecordedSoundsFast(sender: UIButton) {
        manipulateAudioPlayer(2)
    }
    
    @IBAction func StopPlayBack(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    @IBAction func PlayAudioAsChipmunk(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func PlayAudioAsVader(sender: AnyObject) {
        playAudioWithPitch(-800)
    }
    
    
    func manipulateAudioPlayer(rate: Float){
        stopPlayBack.hidden = false
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.play()
    }
    
    func playAudioWithPitch(pitch: Float){
        stopPlayBack.hidden = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
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
