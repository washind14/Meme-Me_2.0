//
//  ViewController.swift
//  Meme-Me-1.0
//
//  Created by Desha Washington on 12/12/20.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
   
    

 
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
        shareButton.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        
               
    }
    func setupTextField(_ textField: UITextField, text: String) {
    
           textField.delegate = self
           textField.defaultTextAttributes = memeTextAttributes
           textField.textAlignment = .center
           textField.text = text

       }
    
   
    
    
    @IBAction func pickImageViaCamera(_ sender: Any) {
        openImagePicker(source: .camera)
   }
    
   
   @IBAction func pickImageViaLibrary(_ sender: Any) {
        openImagePicker(source: .photoLibrary)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelToShareMeme(_ sender: Any) {
        
    }
    
    @IBAction func topTextField(_ sender: Any) {
        textFieldDidBeginEditing(topTextField)
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        textFieldDidBeginEditing(bottomTextField)
    }
    
    func openImagePicker(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            
        }
        else if let editedImage = info[.editedImage] as? UIImage {
            imagePickerView.image = editedImage
        }
           shareButton.isEnabled = true
                dismiss(animated: true, completion: nil)
    
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       dismiss(animated: true, completion: nil)
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField){
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM"){
            textField.text = " "
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
         textField.resignFirstResponder()
        return true
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]
    
    
    @objc func keyboardWillShow(_ notification:Notification){
        view.frame.origin.y -=  getKeyboardHeight(notification)
    }
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    struct Meme {
        let topText:String
        let bottomText:String
        let originalImage:UIImage
        let memedImage:UIImage
    }
    
    
    func save() {
       
        let memedImage = generateMemedImage()
 //              let _ = imagePickerView.image else {
//                  return
//
       
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:imagePickerView.image!,
    memedImage: memedImage)
        
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        appDelegate.memes.append(meme)
    
        
       
    }

    
   
    func generateMemedImage() -> UIImage {
       
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = false;

        return memedImage
    }

}


