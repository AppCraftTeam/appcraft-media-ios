//
//  ACZoomTransitionDelegate.swift
//  ACMedia-iOS
//
//  Copyright © 2023 AppCraft. All rights reserved.
//

import UIKit

public protocol ACZoomTransitionViewController {
    func getZoomingImageView(for transition: ACZoomTransitionDelegate) -> UIImageView?
}

/// State of the screen transition
fileprivate enum ScreenTransitionState {
    case initial
    case final
}

/// Animation of transition to full screen photo opening
open class ACZoomTransitionDelegate: NSObject {
    
    /// Picker configuration.
    var configuration: ACMediaConfiguration
    
    /// The duration of the transition animation.
    var durationOfTransition: TimeInterval = 0.6
    
    /// The navigation operation type
    var navOperation: UINavigationController.Operation = .none
    
    /// The scaling factor used during the zoom transition.
    private let scalingFactor: CGFloat = 15
    
    /// The shrink factor used during the zoom transition.
    private let shrinkFactor: CGFloat = 0.75
    
    /// Initializes a new `ACZoomTransitionDelegate` instance with the specified configuration.
    ///
    /// - Parameter configuration: Picker configuration.
    public init(configuration: ACMediaConfiguration) {
        self.configuration = configuration
    }
    
    /// Setting the frame for the container
    /// - Parameters:
    ///   - status: Transition status
    ///   - containingView: Container for transition
    ///   - backgroundController: Origin transition controller
    ///   - backgroundImageInView: Image view in background
    ///   - foregroundImageInView: Image view in foreground
    ///   - snapshotView: Snapshot
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

extension ACZoomTransitionDelegate: UINavigationControllerDelegate {
    
    open func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            if fromVC is ACZoomTransitionViewController && toVC is ACZoomTransitionViewController {
                self.navOperation = operation
                return self
            } else {
                return nil
            }
        }
}

extension ACZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        durationOfTransition
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
        (backgroundColorController as? ACZoomTransitionViewController)?.getZoomingImageView(for: self)
        let maybeFgImageView =
        (foregroundColorController as? ACZoomTransitionViewController)?.getZoomingImageView(for: self)
        
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
        
        container.backgroundColor = configuration.appearance.colors.backgroundColor
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
