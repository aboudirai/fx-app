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

    @IBOutlet var mainView: UIView!
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
        setupNavigationBar()
        picker.delegate = self
    }
    
    private func setupNavigationBar(){
        //self.navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 100, vertical: 0), for: UIBarMetrics.default) //NOT WORKING
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
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
