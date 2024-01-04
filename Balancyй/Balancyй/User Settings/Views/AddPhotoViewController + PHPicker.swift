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

        firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self?.addPhotoButton.setImage(image, for: .normal)
            }
            self?.savePhotoToFileManager(image)
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
    
    
    func savePhotoToFileManager(_ photo: UIImage) {
        let fileName = UUID().uuidString + ".jpg"
        
        let manager = FileManager.default

        guard let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        print(documentsDirectory.path)

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        guard let imageData = photo.jpegData(compressionQuality: 1.0) else {
            return
        }

        do {
            try imageData.write(to: fileURL)
            print("Photo saved to file manager: \(fileURL)")
        } catch {
            print("Error saving photo to file manager: \(error)")
        }
    }
}
