//
//  PhotoPickerView.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by wahaj on 13/04/2022.
//

import Foundation
import SwiftUI

struct PhotoPickerView: UIViewControllerRepresentable {
    // 1
    @Binding var photoData: Data?

    // 2
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // 3
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let parent: PhotoPickerView

        init(parent: PhotoPickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            let image = info[.originalImage] as? UIImage
            let imageData = image?.jpegData(compressionQuality: 1)
            // 4
            self.parent.photoData = imageData

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        // 5
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
