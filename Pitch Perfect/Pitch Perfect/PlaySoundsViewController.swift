//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kinan Turjman on 3/4/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // declare variables
    var audioPlayer:AVAudioPlayer!;
    var receivedAudio:RecordedAudio!;
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // initiate audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        audioPlayer.enableRate = true;
        
        // initiate audioEngine
        audioEngine = AVAudioEngine()
        
        // initiate audioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // play slow
        playWithVariableSpeed(0.5);
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // play fast
        playWithVariableSpeed(1.5);
    }
    
    func playWithVariableSpeed(rate: Float){
        
        stopAndResetSounds();
        
        // set rate and play
        audioPlayer.rate = rate;
        audioPlayer.play();
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAndResetSounds();
        
        // create new audioPlayerNode and attach to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create the AVAudioUnitTimePitch variable for the pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        
        // set the pitch
        changePitchEffect.pitch = pitch
        
        // attach the changePitchEffect node to audioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // schedule the file to be played
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // start engine
        audioEngine.startAndReturnError(nil)
        
        // start playback
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // play with high pitch
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // play with low pitch
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playWithReverb(sender: UIButton) {
        
        stopAndResetSounds();
        
        // create new audioPlayerNode and attach to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create the AVAudioUnitReverb variable for the reverb effect
        var reverbEffect = AVAudioUnitReverb()
        
        // set the wetDryMix property for the reverb effect
        reverbEffect.wetDryMix = 75;
        
        // attach the reverbEffect node to audioEngine
        audioEngine.attachNode(reverbEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        // schedule the file to be played
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // start playback
        audioPlayerNode.play()
    }
    
    @IBAction func playWithDistortion(sender: UIButton) {
        
        stopAndResetSounds();
        
        // create new audioPlayerNode and attach to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create the AVAudioUnitDistortion variable for the distortion effect
        var distortionEffect = AVAudioUnitDistortion()
        
        // set the wetDryMix and preGain properties for the distortion effect
        distortionEffect.wetDryMix = 25;
        distortionEffect.preGain = 20;
        
        // attach the distortionEffect node to audioEngine
        audioEngine.attachNode( distortionEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to:  distortionEffect, format: nil)
        audioEngine.connect( distortionEffect, to: audioEngine.outputNode, format: nil)
        
        // schedule the file to be played
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // start playback
        audioPlayerNode.play()
    }
    
    func stopAndResetSounds(){
        // stop and reset audioPlayer
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0;
        
        // stop and reset audioEngine
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        stopAndResetSounds();
    }

}
