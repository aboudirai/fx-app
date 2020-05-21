//
//  ViewController.swift
//  FXApp
//
//  Created by Aboudi Rai on 5/11/20.
//  Copyright © 2020 Shackamaxon Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var ViewController: UIView!
    @IBAction func captureMedia(sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    @IBAction func selectFromLibrary(sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
        
    let picker = UIImagePickerController()
    var chosenFile: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenFile = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
        
        let fxVC = EffectViewController()
        fxVC.url = chosenFile
        
        navigationController?.pushViewController(fxVC, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

