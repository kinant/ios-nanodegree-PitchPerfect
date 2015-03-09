//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kinan Turjman on 3/4/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // declare variables
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide the stop button
        stopButton.hidden = true;
        recordButton.enabled = true;
        recordingLabel.text = "Tap to Record"
        resumeButton.hidden = true;
        pauseButton.hidden = true;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        // stop audio recording
        audioRecorder.stop();
        
        // create AVAudioSession variable
        var audioSession = AVAudioSession.sharedInstance();
        
        // set audio session to not active
        audioSession.setActive(false, error: nil);
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        // change button visibility and label text
        pauseButton.hidden = false;
        recordingLabel.text = "recording in progress";
        stopButton.hidden = false;
        recordButton.enabled = false;
        
        //TODO: Record user's voice
        // obtain the path for the file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // get the current date
        let currentDateTime = NSDate()
        
        // create date formatter
        let formatter = NSDateFormatter()
        
        // format the date
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        // set the name for the current recording session
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        // create the path array with the directory path and the recording name
        let pathArray = [dirPath, recordingName]
        
        // obtain the file path
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // create a AVAudioSession session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // initiate audioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        // set the delegate
        audioRecorder.delegate = self
        
        // record the user's voice
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        
        // pause recording
        audioRecorder.pause();
        
        // set button visibility and label text
        pauseButton.hidden = true;
        resumeButton.hidden = false;
        recordingLabel.text = "Recording Paused!";
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        
        // resume recording sound
        audioRecorder.record();
        
        // set button visibility and label text
        resumeButton.hidden = true;
        pauseButton.hidden = false;
        recordingLabel.text = "recording in progress";
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            
            // save recorded audio
            recordedAudio = RecordedAudio(path: recorder.url, title: recorder.url.lastPathComponent);
        
            // move to the next scene (aka perform segue)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // go to the next scene
        if(segue.identifier == "stopRecording"){
            // set the variable for the destination view controller, in this case the playSounds VC
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController;
            
            // set the data from the recorded audio
            let data = sender as RecordedAudio;
            
            // pass data into the next scene
            playSoundsVC.receivedAudio = data;
        }
    }
    
    
}

