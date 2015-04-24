//
//  ViewController.swift
//  pitchperfect
//
//  Created by Amorn Apichattanakul on 4/15/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var re_recordBtn: UIButton!
    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordAudio:RecordedAudio!
    var flagResume:Bool!;
    var filePathTemp:NSURL!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        flagResume = false;

        stopBtn.hidden = true;
        playBtn.hidden = true;
        recording.text = "Tap to record";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("record audio");
        stopBtn.hidden = false;
        recordBtn.enabled = false;
        recording.text = "Recording";
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String;
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        filePathTemp = filePath;
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord();
        audioRecorder.record();
        
        println("recording");
    }
    
    
    @IBAction func stopAudio(sender:UIButton)
    {
        if(!flagResume)
        {
            println("pause audio");

            audioRecorder.pause();
            
            stopBtn.hidden = false;
            re_recordBtn.hidden = false;
            playBtn.hidden = false;
            
            flagResume = true;
            
            recording.text = "Paused"
        }
        else
        {
            println("resume audio");

            audioRecorder.record();
            flagResume = false;
            
            recording.text = "Recording"
        }
        
    }
    
    @IBAction func playSound(sender: UIButton) {
        audioRecorder.stop();
        stopBtn.hidden = true;
        recordBtn.enabled = true;
        re_recordBtn.hidden = true;

    }
    @IBAction func rerecord(sender: UIButton) {
        if(NSFileManager.defaultManager().fileExistsAtPath(filePathTemp.path!))
        {
            println("file exist, prepare to delete file");
            audioRecorder.stop();
            if(audioRecorder.deleteRecording())
            {
                recordBtn.enabled = true;
                stopBtn.hidden = true;
                re_recordBtn.hidden = true;
                playBtn.hidden = true;
                flagResume = false;
            }
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag && NSFileManager.defaultManager().fileExistsAtPath(filePathTemp.path!))
        {
            println("done recording");
            recordAudio = RecordedAudio(path: recorder.url, title: recorder.url.lastPathComponent!);
            self.performSegueWithIdentifier("stopRecording", sender: recordAudio);
        }
        else
        {
            println("something went wrong with record audio");
            stopBtn.hidden = true;
            recordBtn.enabled = true;
            recording.text = "Tap to record"
        }
      
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording")
        {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController;
            let data = sender as! RecordedAudio;
            println(data.filePathUrl);
            playSoundVC.receive = data;
        }
    }
    
    

}

