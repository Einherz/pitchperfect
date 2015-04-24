//
//  PlaySoundsViewController.swift
//  pitchperfect
//
//  Created by Amorn Apichattanakul on 4/15/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//
import UIKit
import AVFoundation
import Foundation

class PlaySoundsViewController: UIViewController {
    
    var audio:AVAudioPlayer!;
    var audioEcho:AVAudioPlayer!;
    var audioFile:AVAudioFile!;
    var receive:RecordedAudio!;
    var audioEngine: AVAudioEngine!

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        println("start view didload");
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receive.filePathUrl, error: nil)
        
        audio = AVAudioPlayer(contentsOfURL: receive.filePathUrl, error: nil);
        audioEcho = AVAudioPlayer(contentsOfURL: receive.filePathUrl, error: nil);


        audio.enableRate = true;

    }
    
    @IBAction func playFast(sender: UIButton) {
        stopSound();
        playSoundWithRate(2.0);
    }
    
    @IBAction func stopAllSound(sender: UIButton) {
        stopSound();
    }
    
    func stopSound()
    {
        audio.stop();
        audioEngine.stop()
        audioEngine.reset()
        audioEcho.stop();
    }
    func playSoundWithRate(rate:Float)
    {
        audio.rate = rate;
        audio.currentTime = 0.0;
        audio.play();
        
    }
    
    @IBAction func playSlow(sender: UIButton) {
        stopSound();
        playSoundWithRate(0.5);
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000);
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000);
    }
    
    @IBAction func playEchoSound(sender: UIButton) {
        stopSound();
        playSoundWithRate(1.0);
        
        let delay:NSTimeInterval = 0.2;
        var playtime:NSTimeInterval = audioEcho.deviceCurrentTime + delay;
        
        audioEcho.stop()
        audioEcho.currentTime = 0.0;
        audioEcho.volume = 0.8;
        audioEcho.playAtTime(playtime)
        
    }
    @IBAction func playReverbSound(sender: UIButton) {
        stopSound();
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverb = AVAudioUnitReverb();
        reverb.wetDryMix = 50;
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral);
        audioEngine.attachNode(reverb);
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

        
    }
    func playAudioWithVariablePitch(pitch: Float)
    {
        stopSound();
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch;
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
}
