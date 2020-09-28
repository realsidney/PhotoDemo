//
//  ViewController.swift
//  PhotoDemo
//
//  Created by sidney on 2020/9/25.
//

import UIKit
import ProgressHUD
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        imageView.addGestureRecognizer(longPress)
        
    }
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
//        let index = arc4random() % 4
//        imageView.image = UIImage(named: "pengyuyan\(index)")
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        config.filter = PHPickerFilter.images
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
 
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save to Photo Library", style: .default) { [self] (action) in
            let imageView = sender.view as! UIImageView
            let image = imageView.image;
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { [self] (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[.originalImage] as? UIImage {
//            imageView.image = image
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    @objc func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        print("Image Saved")
        
        ProgressHUD.showSucceed()
        
    }
    
}

