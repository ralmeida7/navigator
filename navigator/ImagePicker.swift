//
//  ImagePicker.swift
//  control-tower-app
//
//  Created by Roberto Almeida on 11/04/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    typealias UIViewControllerType = UIImagePickerController

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        #if !targetEnvironment(simulator)
            controller.sourceType = .camera
        #endif
        return controller
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(imagePicker: self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker: ImagePicker
    
    init(imagePicker: ImagePicker) {
        self.imagePicker = imagePicker
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.presentationMode.wrappedValue.dismiss()
        guard let image = info[.originalImage] as? UIImage else { return }
        imagePicker.image = image
    }
    
}
