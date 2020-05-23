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
    
    init(frame: CGRect, item: AVPlayerItem, player: AVQueuePlayer){
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        //playerLayer.cornerRadius = 20
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        player.play()
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
