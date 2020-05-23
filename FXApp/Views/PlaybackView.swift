//
//  PlaybackView.swift
//  FXApp
//
//  Created by Aboudi Rai on 5/23/20.
//  Copyright © 2020 Shackamaxon Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackView: UIView {
    var looper: AVPlayerLooper?
    var player: AVQueuePlayer?
    var isPlaying: Bool = true
    
    init(frame: CGRect, item: AVPlayerItem){
        super.init(frame: frame)
        
        backgroundColor = .black
        
        //Adding Pause/Play Tap Gesture
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(self.pauseGestureHandler(sender:)))
        addGestureRecognizer(pauseGesture)
        
        //Playing Video on Loop
        player = AVQueuePlayer(playerItem: item)
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect //Scale video
        playerLayer.cornerRadius = 15
        playerLayer.masksToBounds = true
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        looper = AVPlayerLooper(player: player!, templateItem: item)
        
        player!.play()
    }
    
    @objc func pauseGestureHandler(sender: UITapGestureRecognizer){
        if isPlaying {
            player!.pause()
        }
        else{
            player!.play()
        }
        isPlaying = !isPlaying
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
