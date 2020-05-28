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
import Vision

class EffectViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var effectView: UIView!
    var url: URL?
    //@IBOutlet weak var effectCollection: UICollectionView!
    var names = ["Blur", "Old Film", "Black & White", "Test1", "Test2", "Test3"]
    var vidWidth: CGFloat?
    var vidHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effectView.backgroundColor = .black
        setupNavigationBar()
        playVideo()
    }
    
    //NOT WORKING**
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNavigationBar(){
        //navigationItem.hidesBackButton = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func playVideo(){
        vidWidth = effectView.frame.width
        vidHeight = vidWidth! * 16 / 9
        
        let asset = AVAsset(url: url!)
        let comp = applyEffect(asset: asset, effect: "Conv")
        
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = comp
        
        //Create PlaybackView
        let videoFrame = CGRect(x: 0, y: 45, width: vidWidth!, height: vidHeight!)
        let videoView = PlaybackView(frame: videoFrame, item: item)
        
        effectView.addSubview(videoView)
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
        case "Distort":
            return effectDistort(raw: asset)
        case "Conv":
            return effectConv9(raw: asset)
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
    
    //Going for Retro VHS look
    func effectConv9(raw: AVAsset) -> AVVideoComposition {
        let filter1 = CIFilter(name: "CIConvolution9Vertical", parameters: [
            kCIInputWeightsKey: CIVector(values: [0, -2, 0, -2, 9, -2, 0, -2, 0], count: 9)
        ])!
        
        let filter2 = CIFilter(name: "CIBloom")!
        filter2.setValue(1, forKey: kCIInputIntensityKey)
        
        return effectSingleFilter(raw: raw, filter: filter1)
        //return effectMultipleFilters(raw: raw, filters: [filter1, filter2])
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
    
    func effectDistort(raw: AVAsset) -> AVVideoComposition {
        let filter = CIFilter(name: "CIBumpDistortion")!
        filter.setValue(CIVector(x: vidWidth!, y: vidHeight!), forKey: kCIInputCenterKey)
        filter.setValue(1.0, forKey: kCIInputScaleKey)
        
        return effectSingleFilter(raw: raw, filter: filter)
    }
    
    //Helper for applying face filters to video
    func effectFaceFilter(raw: AVAsset, filter: CIFilter) -> AVVideoComposition {
        
        let comp = AVVideoComposition(asset: raw, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            print("testtestestestsetset")
            
            filter.setValue(source, forKey: kCIInputImageKey)
            
            let output = filter.outputImage!
            
            request.finish(with: output, context: nil)
        })
        
        return comp
        
    }
    
    func detectFace(){
        let faceRequest = VNDetectFaceRectanglesRequest { (req, err) in
    
            if let err = err {
                print("Face detect failed:", err)
                return
            }
            req.results?.forEach({ (res) in
                guard let faceObs = res as? VNFaceObservation else { return }
                print(faceObs.boundingBox)
            })
        }
        /*
        guard let cgImg = source.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImg, options: [:])
        do {
            try handler.perform([faceRequest])
        } catch let reqErr {
            print("Failed to perform request", reqErr)
        }
        */
    }
    
    //Helper for applying filter to raw video
    func effectSingleFilter(raw: AVAsset, filter: CIFilter) -> AVVideoComposition {
        let comp = AVVideoComposition(asset: raw, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            let output = filter.outputImage!
            
            request.finish(with: output, context: nil)
        })
        return comp
    }
    
    func effectMultipleFilters(raw: AVAsset, filters: [CIFilter]) -> AVVideoComposition {
        let comp = AVVideoComposition(asset: raw, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            
            var output: CIImage? = source
            
            filters.forEach { fil in
                fil.setValue(output, forKey: kCIInputImageKey)
                output = fil.outputImage!
            }
            
            request.finish(with: output!, context: nil)
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
