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
import AVKit
import AVFoundation
import MobileCoreServices
import CoreLocation

class AddPostViewController: UIViewController {
    
    
    //MARK: - IBOulets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    
    //MARK: - Acctions
    @IBAction func openPreviewAction() {
        guard let currentVideoURL = currentVideoURL else {
            return
        }
        let avPlayer = AVPlayer(url: currentVideoURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true){
            avPlayerController.player?.play()
        }
    }
    
    @IBAction func addPostAction(){
        if currentVideoURL != nil{
            uploadVideoToFirebase()
        }
        
        if previewImageView.image !=  nil {
            uploadPhotoToFirebase()
        }
        
        savePost(imageUrl: nil, videoUrl: nil)

    }
    
    @IBAction func openCameraAction() {
        
        let alert = UIAlertController(title: "Cámara", message: "Selecciona una opción", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openVideoCamera()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil ))

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(){
        dismiss(animated: true, completion: nil)
    }
    
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    private func requestLocation(){
        // validar gps activo y disponible
        guard CLLocationManager.locationServicesEnabled() else{
            return
        }
        
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager?.requestAlwaysAuthorization()
        
        locationManager?.startUpdatingLocation()
    }
    
    private func openVideoCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
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
        videoButton.isHidden = true
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
                        let downloadUrl = url?.absoluteString ?? ""
                        
                        self.savePost(imageUrl: downloadUrl, videoUrl: nil)
                    }
                }
            }
        }
    }
    
    
    ///volver esta dos funciones una sola TODO
    private func uploadVideoToFirebase(){
        // asegurar que el video existe y convertir el data en video
        guard
            let currenVideoSaveURL = currentVideoURL,
            let videoData: Data = try? Data(contentsOf: currenVideoSaveURL) else{
                return
        }
        
        SVProgressHUD.show()
        // configuracion para guardar la foto en firebase
        let metaDataConfig = StorageMetadata()
        
        metaDataConfig.contentType = "video/MP4"
        
        // reerencia al storage de firebase
        
        let storage = Storage.storage()
        
        // nombre de la imagen
        let videoName = Int.random(in: 100...1000)
        
        // referencia a la carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "videos-tweets/\(videoName).mp4")
        
        //subir la foto a firebase
        
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                DispatchQueue.main.async {
                    //detener la carga
                    SVProgressHUD.dismiss()
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .warning).show()
                        return
                    }
                    
                    // obtener la URL de la descarga
                    
                    folderReference.downloadURL { (url: URL?,error: Error?) in
                        let downloadUrl = url?.absoluteString ?? ""
                        
                        self.savePost(imageUrl: nil,videoUrl: downloadUrl)
                    }
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?){
        // request de localizacion
        var postLocation: PostRequestLocation?

        if let userLocation = userLocation {
            postLocation = PostRequestLocation(latitude: userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude)
        }
        
        
        let request = PostRequest(text: postTextView.text,
                                  imageUrl: imageUrl,
                                  videoUrl: videoUrl,
                                  location: postLocation)
        
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
        
        //capturar imagen
        if info.keys.contains(.originalImage){
            previewImageView.isHidden = false
            
            // get the image
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL{
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
    }
}

extension AddPostViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last else {
            return
        }
        
        userLocation = bestLocation
    }
}
