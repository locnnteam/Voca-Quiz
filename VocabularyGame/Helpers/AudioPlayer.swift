//
//  AudioPlayer.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 8/15/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlayerDelegate {
    func finishedGameSouds(successfully flag: Bool)
}
class AudioPlayer: NSObject, AVAudioPlayerDelegate{
    var bombSoundEffect: AVAudioPlayer! //local audio
    var player: AVPlayer? //online audio
    var delegate: AudioPlayerDelegate?
    
    // MARK: Play audio vocabulary
    func playAudioLocal(audio: String){
        let url = URL(fileURLWithPath: audio)
        
        stopAudioLocal()
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect = sound
            sound.play()
        } catch {
            fatalError("Can not load audio file")
        }
    }
    
    func stopAudioLocal(){
        if bombSoundEffect != nil {
            bombSoundEffect.stop()
            bombSoundEffect = nil
        }
    }
    
    // MARK: Play game sounds
    func playGameSounds(audio: String){
        let url = URL(fileURLWithPath: audio)
        stopAudioLocal()
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect = sound
            sound.delegate = self
            sound.play()
        } catch {
            fatalError("Can not load audio file")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate?.finishedGameSouds(successfully: flag)
    }
    
}
