//
//  UIViewController+Extension.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit


extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setupNavigationBar(title: String) {
        navigationItem.title = title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Theme.backgroundNavigationBarPrimary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
