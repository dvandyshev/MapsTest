//
//  MenuViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import UIKit

class MenuViewController: UIViewController {

    lazy var router: MenuRouter = {
        let router = MenuRouter()
        router.controller = self
        return router
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onShowMapBtnTapped(_ sender: Any) {
        router.toMap()
    }
    
    @IBAction func onLogoutBtnTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
        } else {
            imagePickerController.sourceType = .savedPhotosAlbum
        }
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func saveImage(image: UIImage) {
        guard let data = image.pngData(),
              let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
        else { return }
        
        do {
            try data.write(to: directory.appendingPathComponent("avatar.png")!)
        } catch {
            print(error.localizedDescription)            
        }
    }
}

extension MenuViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = extractImage(from: info)
        picker.dismiss(animated: true)
        if let image = image {
            saveImage(image: image)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[.editedImage] as? UIImage {
            return image
        } else if let image = info[.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
