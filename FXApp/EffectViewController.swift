//
//  EffectViewController.swift
//  FXApp
//
//  Created by Aboudi Rai on 5/11/20.
//  Copyright © 2020 Shackamaxon Technologies. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class EffectViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var EffectViewController: UIView!
    var url: URL?
    //@IBOutlet weak var effectCollection: UICollectionView!
    var names = ["Blur", "Old Film", "Black & White", "Test1", "Test2", "Test3"]
    var looper: AVPlayerLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        playVideo()
    }
    
    private func setupNavigationBar(){
        navigationItem.hidesBackButton = true
    }
    
    private func playVideo(){
        let asset = AVAsset(url: url!)
        
        let comp = applyEffect(asset: asset, effect: "Pixel")
        
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = comp
        let player = AVQueuePlayer(playerItem: item)
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        EffectViewController.layer.addSublayer(playerLayer)
        playerLayer.frame = EffectViewController.frame
        looper = AVPlayerLooper(player: player, templateItem: item)
        
        player.play()
    }
    
    private func applyEffect(asset: AVAsset, effect: String) -> AVVideoComposition {
        switch effect {
        case "None":
            return effectNone(raw: asset)
        case "B&W":
            return effectBW(raw: asset)
        case "Tile":
            return effectAffineTile(raw: asset)
        case "Zoom":
            return effectZoomBlur(raw: asset)
        case "Pixel":
            return effectPixellate(raw: asset)
        default:
            return effectNone(raw: asset)
        }
    }
}

//Effects
extension EffectViewController {
    
    func effectNone(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIColorControls")!

        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    func effectBW(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIColorControls", parameters: [
            kCIInputSaturationKey: 0
        ])!

        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    func effectZoomBlur(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIZoomBlur")!

        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    func effectPixellate(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIPixellate")!

        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    func effectAffineTile(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIAffineTile")!
        
        //filter.setValue(CIVector(x: rawImageView.frame.width, y: rawImageView.frame.height), forKey: kCIAttributeTypePosition)
        //filter.setValue(5.0, forKey: kCIAttributeTypeDistance)

        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    func effectSingleFilter(raw: AVAsset, filter: CIFilter) -> AVVideoComposition {
        let comp = AVVideoComposition(asset: raw, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            let output = filter.outputImage!
            
            request.finish(with: output, context: nil)
        })
        return comp
    }
}

/*
    func registerNib() {
        let nib = UINib(nibName: EffectCollectionViewCell.nibName, bundle: nil)
        effectCollection?.register(nib, forCellWithReuseIdentifier: EffectCollectionViewCell.reuseIdentifier)
        
    }
}


extension EffectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectCollectionViewCell.reuseIdentifier, for: indexPath) as? EffectCollectionViewCell {
            
            let name = names[indexPath.row]
            cell.configureCell(name: name)
            return cell
        }
        return UICollectionViewCell()
    }
}
*/
