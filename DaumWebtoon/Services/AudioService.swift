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

protocol AudioServiceDataSource: class {
    func initializeTimeProgress(minimumTime: Float, maximumTime: Float)
    func setTimeProgressInTimeInterval(time: Float, duration: String, currentTime: String)
    func showLoading(alpha: CGFloat)
}

class AudioService {
    
    static let shared = AudioService()

    weak var dataSource: AudioServiceDataSource?
    
    private var audioPlayer: AVAudioPlayer?
    
    private var avPlayer: AVPlayer?
    private var isPaused = false
    
    private init() { }
    
    func setupAndPlay(audioUrl: String) {
        guard let audioUrl = URL(string: audioUrl) else { return }
    
        avPlayer = AVPlayer(playerItem: AVPlayerItem(url: audioUrl))
        avPlayer?.automaticallyWaitsToMinimizeStalling = false
        avPlayer?.volume = 1.0
        avPlayer?.play()
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
            
            if isPaused == false {
                if avPlayer?.rate == 0 {
                    avPlayer?.play()
                    dataSource?.showLoading(alpha: 1)
                } else {
                    dataSource?.showLoading(alpha: 0)
                }
            }
            
            let currentTime1 = currentItem.asset.duration
            let seconds1 = CMTimeGetSeconds(currentTime1)
            let time1 = Float(seconds1)
            
            dataSource?.initializeTimeProgress(minimumTime: 0, maximumTime: time1)

            let currentTime = (self.avPlayer?.currentTime())!
            let seconds = CMTimeGetSeconds(currentTime)
            let time = Float(seconds)
            
            dataSource?.setTimeProgressInTimeInterval(time: time,
                                                      duration: currentItem.asset.duration.formatTimeFromSeconds(),
                                                      currentTime: currentItem.currentTime().formatTimeFromSeconds())
        }
    }
    
    func invalidateAVPlayer() {
        avPlayer = nil
    }
    
    private func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    
}
