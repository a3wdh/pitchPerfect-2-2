//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by A Abdullah on 5/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI(isRecording : Bool){
        recordingLabel.text = isRecording ? "Recording in progress" : "Tab to record"
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
      //  recordingLabel.text="Recording in Progress"
       // stopRecordingButton.isEnabled = true
         //      recordButton.isEnabled = false
        
        configureUI(isRecording: true)
        
      let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
      let recordingName = "recordedVoice.wav"
      let pathArray = [dirPath, recordingName]
      let filePath = URL(string: pathArray.joined(separator: "/"))
      let session = AVAudioSession.sharedInstance()
      try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
      try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
      audioRecorder.delegate = self
      audioRecorder.isMeteringEnabled = true
      audioRecorder.prepareToRecord()
      audioRecorder.record()
    }
   @IBAction func stopRecording(_ sender: AnyObject) {
     //   recordButton.isEnabled = true
       // stopRecordingButton.isEnabled = false
       // recordingLabel.text = "Tap to Record"
    configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
