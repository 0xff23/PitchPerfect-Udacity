//
//  RecordSounds.swift
//  PitchPerfect
//
//  Created by Kirill on 4/11/16.
//  Copyright © 2016 Kirill. All rights reserved.
//

import UIKit
//Framework with audio functions
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        //Log each press on Record button
        print("Record button was pressed.")
        //Change lable text after pressing the Record button
        recordingLable.text = "Recording in progress..."
        // Hidde Record button after pressing it
        recordButton.hidden = true
        // Show Stop Recording Button after pressing Record button lol
        stopRecordingButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        let recordingName = "recorderVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopAudio(sender: AnyObject) {
        print("Stop button was pressed.")
        recordingLable.text = "Tap to Record"
        recordButton.hidden = false
        stopRecordingButton.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    override func viewWillAppear(animated: Bool) {
        //Stop recording button will be hidden before UIView will load
        stopRecordingButton.hidden = true
        print("viewWillApperaCode")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //Function to switch from first VC to another one after you tap on Stop button.
        print("AVAudioRecorder finished saving recording")
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

