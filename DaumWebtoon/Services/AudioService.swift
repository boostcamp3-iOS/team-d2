//
//  FetchAudioService.swift
//  DaumWebtoon
//
//  Created by Tak on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import UIKit

@objc protocol AudioServiceDataSource: class {
    @objc optional func initializeTimeProgress(minimumTime: Float, maximumTime: Float)
    @objc optional func setTimeProgressInTimeInterval(time: Float, duration: String, currentTime: String)
    @objc optional func showTitle(alpha: CGFloat)
    func showLoading(alpha: CGFloat)
}

class AudioService: NSObject {
    
    static let shared = AudioService()

    weak var dataSource: AudioServiceDataSource?
    @objc dynamic var audioStatus: Int = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var avPlayer: AVPlayer?
    private var asset: AVAsset?
    private var isPaused = false
    
    override private init() { }
    
    func setupAndPlayAudio(audioUrl: String) {
        guard let audioUrl = URL(string: audioUrl) else { return }

        if avPlayer?.timeControlStatus == .playing {
            asset = nil
            avPlayer = nil
        }
        
        asset = AVAsset(url: audioUrl)
        guard let asset = asset else { return }
        
        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
            self.avPlayer?.automaticallyWaitsToMinimizeStalling = false
            self.avPlayer?.volume = 1.0
            self.avPlayer?.play()
        }
    }
    
    func stopAudio() {
        avPlayer = nil
    }
    
    func togglePlayPause() {
        if avPlayer?.timeControlStatus == .playing {
            avPlayer?.pause()
            isPaused = true
        } else {
            avPlayer?.play()
            isPaused = false
        }
    }
    
    func progressValueChanged(seconds: Float) {
        let seconds = Int64(seconds)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        
        avPlayer?.seek(to: targetTime)
        if isPaused == false {
            dataSource?.showLoading(alpha: 1)
        }
    }
    
    func timeInterval() {
        if avPlayer?.currentItem?.asset.duration != nil {
            guard let currentItem = avPlayer?.currentItem else { return }
            
            if avPlayer?.currentTime().seconds == 0.0 {
                dataSource?.showLoading(alpha: 1)
                dataSource?.showTitle?(alpha: 0)
            } else {
                dataSource?.showLoading(alpha: 0)
                dataSource?.showTitle?(alpha: 1)
            }
            
            let currentTime1 = currentItem.asset.duration
            let seconds1 = CMTimeGetSeconds(currentTime1)
            let time1 = Float(seconds1)
            
            dataSource?.initializeTimeProgress?(minimumTime: 0, maximumTime: time1)

            let currentTime = (self.avPlayer?.currentTime())!
            let seconds = CMTimeGetSeconds(currentTime)
            let time = Float(seconds)
            
            dataSource?.setTimeProgressInTimeInterval?(time: time,
                                                      duration: currentItem.asset.duration.formatTimeFromSeconds(),
                                                      currentTime: currentItem.currentTime().formatTimeFromSeconds())
        }
    }
    
    deinit {
        avPlayer?.removeObserver(self, forKeyPath: "timeControlStatus")
    }
}
