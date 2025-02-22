//
//  GestureHandler.swift
//  test-task-human-apps
//
//  Created by Александр Янчик on 22.02.25.
//

import UIKit


final class GestureHandler {
    private weak var targetView: UIView?
    
    init(targetView: UIView) {
        self.targetView = targetView
    }
    
    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(handlePinchGesture(_:))
        )
        let rotationGesture = UIRotationGestureRecognizer(
            target: self,
            action: #selector(handleRotationGesture(_:))
        )
        
        targetView?.addGestureRecognizer(panGesture)
        targetView?.addGestureRecognizer(pinchGesture)
        targetView?.addGestureRecognizer(rotationGesture)
        
        targetView?.isUserInteractionEnabled = true
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        let translation = gesture.translation(in: view.superview)
        let newCenter = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        
        let halfWidth = view.bounds.width / 2
        let halfHeight = view.bounds.height / 2
        
        let minX = halfWidth
        let maxX = view.superview?.bounds.width ?? 0 - halfWidth
        let minY = halfHeight
        let maxY = view.superview?.bounds.height ?? 0 - halfHeight
        
        let clampedX = max(minX, min(newCenter.x, maxX))
        let clampedY = max(minY, min(newCenter.y, maxY))
        
        view.center = CGPoint(x: clampedX, y: clampedY)
        gesture.setTranslation(.zero, in: view.superview)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        }
    }
    
    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
}
