//
//  UIView+Extension.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 21.02.25.
//

import UIKit


extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
