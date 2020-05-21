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
        playVideo()
    }
    
    private func playVideo(){
        let asset = AVAsset(url: url!)
        
        let filter = CIFilter(name: "CIColorControls", parameters: [
            kCIInputSaturationKey: 0
        ])!
        
        //let filter = CIFilter(name: "CIZoomBlur")!
        
        let comp = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            let output = filter.outputImage!
            
            request.finish(with: output, context: nil)
        })
        
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = comp
        let player = AVQueuePlayer(playerItem: item)
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        EffectViewController.layer.addSublayer(playerLayer)
        playerLayer.frame = EffectViewController.frame
        looper = AVPlayerLooper(player: player, templateItem: item)
        
        player.play()
        }
    
    func applyEffect(media: UIImage, effect: String) -> UIImage {
        switch effect {
        case "None":
            return media
        case "B&W":
            return imageEffectBW(image: media)
        case "Tile":
            return imageEffectAffineTile(image: media)
        case "Zoom":
            return imageEffectZoomBlur(image: media)
        default:
            return media
        }
    }
    
    func imageEffectBW(image: UIImage) -> UIImage {
        let convertedImage = CIImage(image: image)
        let filter = CIFilter(name: "CIColorControls", parameters: [
            kCIInputImageKey : convertedImage!,
            kCIInputSaturationKey: 0
        ])!

        return UIImage(ciImage: filter.outputImage!)
    }
    
    func imageEffectZoomBlur(image: UIImage) -> UIImage {
        let convertedImage = CIImage(image: image)
        let filter = CIFilter(name: "CIZoomBlur")!

        filter.setValue(convertedImage, forKey: kCIInputImageKey)
        
        return UIImage(ciImage: filter.outputImage!)
    }
    
    func imageEffectAffineTile(image: UIImage) -> UIImage {
        let convertedImage = CIImage(image: image)
        let filter = CIFilter(name: "CIAffineTile")!
        
        filter.setValue(convertedImage, forKey: kCIInputImageKey)
        //filter.setValue(CIVector(x: rawImageView.frame.width, y: rawImageView.frame.height), forKey: kCIAttributeTypePosition)
        //filter.setValue(5.0, forKey: kCIAttributeTypeDistance)

        return UIImage(ciImage: filter.outputImage!)
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
