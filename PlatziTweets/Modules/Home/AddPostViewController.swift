//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 10/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import UIKit
import Simple_Networking
import NotificationBannerSwift
import SVProgressHUD
import FirebaseStorage

class AddPostViewController: UIViewController {

    
    //MARK: - IBOulets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var openCameraButton: UIButton!
    
    //MARK: - Acctions
    @IBAction func addPostAction(){
        savePost()
    }
        
    @IBAction func openCameraAction() {
        openCamera()
    }
    
    @IBAction func dismissAction(){
        dismiss(animated: true, completion: nil)
    }
    
    private var imagePicker: UIImagePickerController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    private func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupUI(){
        addPostButton.layer.cornerRadius = 25
        openCameraButton.layer.cornerRadius = 25
    }
    
    private func uploadPhotoToFirebase(){
        // asegurar and comprimir la imagen
        guard
            let imageSaved = previewImageView.image,
            let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else{
                return
        }
        SVProgressHUD.show()
        // configuracion para guardar la foto en firebase
        let metaDataConfig = StorageMetadata()
        
        metaDataConfig.contentType = "image/jpg"
        
        // reerencia al storage de firebase
        
        let storage = Storage.storage()
        
        // nombre de la imagen
        let imageName = Int.random(in: 100...1000)
        
        // referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "fotos-tweers/\(imageName).jpg")
        
        //subir la foto a firebase
        
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(imageSavedData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    //detener la carga
                    SVProgressHUD.dismiss()
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .warning).show()
                        return
                    }
                    
                    // obtener la URL de la descarga
                    
                    folderReference.downloadURL { (url: URL?,error: Error?) in
                        print(url?.absoluteString ?? "")
                    }
                }
            }
        }
    }
    private func savePost(){
        uploadPhotoToFirebase()
        return
        
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: Endpoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
           
            SVProgressHUD.dismiss()
            switch response {
              case .success:
                self.dismiss(animated: true, completion: nil)
              case .error(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                  
              case .errorResult(let entity):
                  NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
              }
        }
    }


}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //close camera
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage){
            previewImageView.isHidden = false
            
            // get the image
            previewImageView.image = info[.originalImage] as? UIImage
        }
    }
}
