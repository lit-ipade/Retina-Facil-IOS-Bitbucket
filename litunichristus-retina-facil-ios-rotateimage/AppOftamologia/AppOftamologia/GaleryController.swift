//
//  GaleryController.swift
//  AppOftamologia
//
//  Created by Jagni Dasa Horta Bezerra on 02/01/2018.
//  Copyright © 2018 Felipe Martins. All rights reserved.
//

import Foundation
import SCLAlertView
import Photos
import AVFoundation
import CarbonKit
import Firebase
import STPopup
import INSPhotoGallery


class GaleryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [Image]()
    var photos = [INSPhotoViewable] ()
    var selectedIndexes = [IndexPath]()
    var editionMode = false
    
    @IBOutlet weak var bar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        bar.title = currentPatient.name
        //bar.leftBarButtonItem
        
        self.photos = [INSPhotoViewable] ()
    }
    
    func updateImages(){
        
        let userID = Auth.auth().currentUser!.uid
        firebaseRef!.child("users/\(userID)/patients/\(currentPatient.id)/galeria").observe(DataEventType.value) { (snap : DataSnapshot) in
            self.images = []
            var titles = [String]()
            if snap.hasChildren(){
                let dic = snap.value as! [String : NSMutableDictionary]
                for key in dic.keys{
                    self.images.append(Image(dic[key]!, id: key))
                    titles.append(key)
                }
                self.images.sort(by: { (p1, p2) -> Bool in
                    return p1.date!.compare(p2.date!) == ComparisonResult.orderedAscending
                })
            }
            
            firebaseRef?.removeAllObservers()
            
            self.photos = [INSPhotoViewable] ()
            
            for image in self.images{
                
                self.photos.append(INSPhoto(image: image.image, thumbnailImage: image.image))
            }
            
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.view.setNeedsLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.navigationController?.view.layoutIfNeeded()
        })
        updateImages()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if(editionMode == true){
            cell.selectionIndicator.isHidden = false
            
            let index = selectedIndexes.index(of: indexPath)
            if index != nil {
                cell.selectionIndicator.backgroundColor = appOrangeColor
            } else {
                cell.selectionIndicator.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            }
        } else {
            cell.selectionIndicator.isHidden = true
        }
        
        if photos.count != 0{
            cell.populateWithPhoto(photos[(indexPath as NSIndexPath).row])
        }
        
        return cell
    }
    
    let spacing : CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    var numberOfItemsPerRow: CGFloat = 3
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width
        
        var itemSize = CGSize()
        if height < width{
            itemSize = CGSize(width:height,height:height)
        } else {
            itemSize = calculateCellSize(width: width)
        }
        
        return itemSize
    }
    
    func calculateCellSize(width: CGFloat) -> CGSize {
        let calculatedWidth = (width/numberOfItemsPerRow)-((spacing/numberOfItemsPerRow)*(numberOfItemsPerRow-1))
        return CGSize(width: calculatedWidth, height: calculatedWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(editionMode == true){
            let index = selectedIndexes.index(of: indexPath)
            if index == nil {
                selectedIndexes.append(indexPath)
            } else {
                selectedIndexes.remove(at: index!)
            }
            collectionView.reloadItems(at: [indexPath])
        } else {
            
            self.performSegue(withIdentifier: "showPhoto", sender: self.photos[indexPath.row].image)
            
            //            let currentPhoto = photos[indexPath.row]
            //            let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
            //
            //            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            //                if let index = self?.photos.index(where: {$0 === photo}) {
            //                    let indexPath = IndexPath(item: index, section: 0)
            //                    return collectionView.cellForItem(at: indexPath) as? CollectionViewCell
            //                }
            //                return nil
            //            }
            //            present(galleryPreview, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "camera"{
            let destination = segue.destination as! CameraController
            destination.completionBlock = { (image) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "addGalleryExam") as! AddGalleryExamController
                
                controller.image = image
                let popupController = STPopupController(rootViewController: controller)
                popupController.navigationBar.backgroundColor = appMainColor
                popupController.navigationBar.tintColor = UIColor.white
                popupController.navigationBar.barTintColor = appMainColor
                popupController.present(in: self)
            }
        }
        else {
            let destination = segue.destination as! ImagemExamesViewController
            destination.image = sender as! UIImage
        }
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem?) {
        
        let actionSheet = UIAlertController(title: nil, message: NSLocalizedString("Escolher foto", comment: ""), preferredStyle: .actionSheet)
        
        actionSheet.view.tintColor = appMainColor
        actionSheet.toolbarItems?.append(sender!)
        
        let cameraAction = createCameraAction()
        
        let galleryAction = createGalleryAction()
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancelar", comment: ""), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController{
            
            popoverController.barButtonItem = sender
        }
        
        //        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
        //            actionSheet.popoverPresentationController?.sourceView = sender
        //            actionSheet.popoverPresentationController?.sourceRect = sender!.bounds.insetBy(dx: sender!.bounds.width/2, dy: sender!.bounds.height/2).offsetBy(dx: 0, dy: sender!.bounds.height/2)
        //            actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        //        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func createCameraAction() -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Câmera", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let authorization = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            
            switch authorization {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        self.presentPicker(source: .photoLibrary)
                    }
                }
            case .denied:
                self.showAlertForDeniedCamera()
            case .authorized:
                self.presentPicker(source: .camera)
            case .restricted:
                self.showAlertForDeniedCamera()
            }
        })
    }
    
    func showAlertForDeniedCamera() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton(NSLocalizedString("OK", comment: ""), action: {
            })
            alertView.showTitle("Atenção", subTitle: "Este app não está autorizado a acessar sua câmera! Vá ao app de Ajustes -> Privacidade -> Câmera para autorizar o acesso.", style: SCLAlertViewStyle.error, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
        }
    }
    
    func createGalleryAction() -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Biblioteca de Fotos", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let authorization = PHPhotoLibrary.authorizationStatus()
            
            switch authorization {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized {
                        self.presentPicker(source: .photoLibrary)
                    }
                })
            case .denied:
                self.showAlertForDeniedGallery()
            case .authorized:
                self.presentPicker(source: .photoLibrary)
            case .restricted:
                self.showAlertForDeniedGallery()
            case .limited:
                self.presentPicker(source: .photoLibrary)
            }
        })
    }
    
    func showAlertForDeniedGallery() {
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton(NSLocalizedString("OK", comment: ""), action: {
            })
            
            alertView.showTitle("Atenção", subTitle: "Este app não está autorizado a acessar sua galeria! Vá ao app de Ajustes -> Privacidade -> Galeria para autorizar o acesso.", style: SCLAlertViewStyle.error, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xF4F4F9, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
        }
    }
    
    func presentPicker(source: UIImagePickerControllerSourceType) {
        DispatchQueue.main.async {
            
            if source == .camera {
                self.performSegue(withIdentifier: "camera", sender: nil)
            } else {
                let picker = UIImagePickerController()
                picker.allowsEditing = false
                picker.delegate = self
                
                picker.sourceType = source
                
                self.present(picker, animated: true, completion: nil)
                
                picker.navigationBar.barTintColor = appMainColor
                picker.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.isTranslucent = false
                picker.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor:UIColor.white]
            }
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismiss(animated: true) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "addGalleryExam") as! AddGalleryExamController
            
            controller.image = image
            let popupController = STPopupController(rootViewController: controller)
            popupController.navigationBar.backgroundColor = appMainColor
            popupController.navigationBar.tintColor = UIColor.white
            popupController.navigationBar.barTintColor = appMainColor
            popupController.present(in: self)
        }
        
    }
    
    @IBAction func tapEdit(_ sender: UIBarButtonItem){
        
        editionMode = true
        self.collectionView.reloadSections([0])
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didTapCancel(_:)))
        
        let delete = UIBarButtonItem(title: "Deletar", style: .done, target: self, action: #selector(self.didTapDelete(_:)))
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = cancel
        self.navigationItem.rightBarButtonItems = [delete]
        
    }
    
    func resetNavigation() {
        editionMode = false
        self.selectedIndexes = []
        self.collectionView.reloadSections([0])
        self.navigationItem.hidesBackButton = false
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.tapEdit(_:)))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPhoto(_:)))
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [add, edit]
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem){
        resetNavigation()
    }
    
    @IBAction func didTapDelete(_ sender: UIBarButtonItem){
        var newPhotos = [INSPhotoViewable]()
        var newImages = [Image]()
        for index in 0...photos.count-1{
            if !selectedIndexes.contains(IndexPath(item: index, section: 0) ) {
                newPhotos.append(photos[index])
                newImages.append(images[index])
            } else {
                print("index: \(index) image: \(self.images[index].id!) id: \(currentPatient.id)")
                FirebaseHelper.deleteImage(self.images[index], patientId: currentPatient.id)
            }
        }
        self.photos = newPhotos
        self.images = newImages
        self.collectionView.deleteItems(at: selectedIndexes)
        resetNavigation()
    }
}
