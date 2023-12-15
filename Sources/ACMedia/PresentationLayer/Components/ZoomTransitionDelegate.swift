//
//  ZoomTransitionDelegate.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

public protocol ZoomTransitionViewController {
    func getZoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView?
}

public enum ScreenTransitionState {
    case initial
    case final
}

public final class ZoomTransitionDelegate: NSObject {
    var durationOfTransition: TimeInterval = 0.6
    var navOperation: UINavigationController.Operation = .none
    
    private let scalingFactor: CGFloat = 15
    private let shrinkFactor: CGFloat = 0.75
    
    private func adjustViews(
        for status: ScreenTransitionState,
        containingView: UIView,
        backgroundController: UIViewController,
        backgroundImageInView: UIView,
        foregroundImageInView: UIView,
        snapshotView: UIView
    ) {
        switch status {
        case .initial:
            backgroundController.view.transform = CGAffineTransform.identity
            backgroundController.view.alpha = 1
            
            snapshotView.frame = containingView.convert(
                backgroundImageInView.frame,
                from: backgroundImageInView.superview)
            
        case .final:
            backgroundController.view.transform = CGAffineTransform(
                scaleX: shrinkFactor,
                y: shrinkFactor)
            
            backgroundController.view.alpha = 0
            
            snapshotView.frame = containingView.convert(
                foregroundImageInView.frame,
                from: foregroundImageInView.superview)
        }
    }
}

extension ZoomTransitionDelegate: UINavigationControllerDelegate {
    
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if fromVC is ZoomTransitionViewController && toVC is ZoomTransitionViewController {
                self.navOperation = operation
                return self
            } else {
                return nil
            }
        }
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        durationOfTransition
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        guard let originController = transitionContext.viewController(forKey: .from),
              let destinationController = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let container = transitionContext.containerView
        
        var backgroundColorController = originController
        var foregroundColorController = destinationController
        
        if navOperation == .pop {
            backgroundColorController = destinationController
            foregroundColorController = originController
        }
        
        let maybeBgImageView =
        (backgroundColorController as? ZoomTransitionViewController)?.getZoomingImageView(for: self)
        let maybeFgImageView =
        (foregroundColorController as? ZoomTransitionViewController)?.getZoomingImageView(for: self)
        
        guard let bgImageView = maybeBgImageView,
              let fgImageView = maybeFgImageView
        else {
            return
        }
        
        let snapshotView = UIImageView(image: bgImageView.image)
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.layer.masksToBounds = true
        
        bgImageView.isHidden = true
        fgImageView.isHidden = true
        
        let originalControllerBackgroundColor = foregroundColorController.view.backgroundColor
        foregroundColorController.view.backgroundColor = UIColor.clear
        
        container.backgroundColor = ACMediaConfiguration.shared.appearance.backgroundColor
        container.addSubview(backgroundColorController.view)
        container.addSubview(foregroundColorController.view)
        container.addSubview(snapshotView)
        
        let initialTransitionState: ScreenTransitionState = navOperation == .pop ? .final : .initial
        let finalTransitionState: ScreenTransitionState = navOperation == .pop ? .initial : .final
        
        adjustViews(
            for: initialTransitionState,
            containingView: container,
            backgroundController: backgroundColorController,
            backgroundImageInView: bgImageView,
            foregroundImageInView: fgImageView,
            snapshotView: snapshotView
        )
        
        foregroundColorController.view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: [],
            animations: { [weak self] in
                self?.adjustViews(
                    for: finalTransitionState,
                    containingView: container,
                    backgroundController: backgroundColorController,
                    backgroundImageInView: bgImageView,
                    foregroundImageInView: fgImageView,
                    snapshotView: snapshotView
                )
            },
            completion: { _ in
                backgroundColorController.view.transform = CGAffineTransform.identity
                snapshotView.removeFromSuperview()
                bgImageView.isHidden = false
                fgImageView.isHidden = false
                foregroundColorController.view.backgroundColor = originalControllerBackgroundColor
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
