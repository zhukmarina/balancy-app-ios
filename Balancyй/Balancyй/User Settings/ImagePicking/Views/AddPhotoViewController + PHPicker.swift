//
//  AddPhotoViewController + PHPicker.swift
//  Balancy
//
//  Created by  Toropov Oleksandr on 08.12.2023.
//

import UIKit
import PhotosUI

extension AddPhotoViewController: PHPickerViewControllerDelegate {
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        guard let firstResult = results.first else { return }
        
        guard let imageUrl = firstResult.itemProvider.suggestedName else { return }
        let imageName = URL(fileURLWithPath: imageUrl).lastPathComponent + ".jpg"
        
        selectedImageName = imageName
        
        firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
            guard let image = image as? UIImage else { return }
            self?.addPhotoButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - Private Methods
    
    private func addPhotoButtonTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    // MARK: - Public Methods
    
    func setupAddPhotoButton() {
        let action = UIAction { [weak self] _ in
            self?.addPhotoButtonTapped()
        }
        addPhotoButton.addAction(action, for: .touchUpInside)
    }
}
