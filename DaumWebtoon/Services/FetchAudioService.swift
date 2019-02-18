//
//  FetchAudioService.swift
//  DaumWebtoon
//
//  Created by Tak on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioFetchStatus {
    case success
    case failure
}

class FetchAudioService: NSObject {
    
    static let shared = FetchAudioService()

    private var audioPlayer: AVAudioPlayer?
    
    override private init() { }
    
    func execute(audioUrl: String, completion: @escaping (AudioFetchStatus) -> Void) {
        guard let audioUrl = URL(string: audioUrl) else { return }
    
        let configuration = URLSessionConfiguration.default
        let manqueue = OperationQueue.main
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: manqueue)
        session.dataTask(with: URLRequest(url: audioUrl)) { [weak self] (data, response, error) in
            guard let self = self, let _data = data else {
                completion(AudioFetchStatus.failure)
                return
            }
            
            if let error = error {
                print(error)
                return
            }

            DispatchQueue.main.async {
                self.setupAudioPlayer(data: _data)
                completion(AudioFetchStatus.success)
            }
        }.resume()
    }
    
    func getMaximumValue() -> Float {
        return Float(audioPlayer?.duration ?? 0.0)
    }
    
    func getCurrentValue() -> TimeInterval {
        return audioPlayer?.currentTime ?? 0.0
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    private func setupAudioPlayer(data: Data) {
        do {
            try self.audioPlayer = AVAudioPlayer.init(data: data)
                self.audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
    }
}
