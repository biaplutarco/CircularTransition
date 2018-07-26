//
//  CircularTransition.swift
//  CircularTransition
//
//  Created by Ada 2018 on 25/07/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class CircularTransition: NSObject {
    
    // Configurações iniciais da transição
    
    var circle = UIView()
    
    var button = UIButton()
    
    var circleColor = UIColor.white
    
    var duration = 0.3
    
    enum CircularTransitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionMode: CircularTransitionMode = .present
    
    // Muda o centro do círculo quando a propriedade for modificada
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
   
}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // Realiza a animação durante a transição
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to){
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height/2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
//                UIView.animate(withDuration: duration, animations: {
//                    self.circle.transform = CGAffineTransform.identity
//                    presentedView.transform = CGAffineTransform.identity
//                    presentedView.alpha = 1
//                    presentedView.center = viewCenter
//
//                }) { (success: Bool) in
//                    transitionContext.completeTransition(success)
                
                UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.8, animations: {
                        self.button.frame.origin.x -= 300

                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: self.duration, relativeDuration: self.duration, animations: {
                        self.circle.transform = CGAffineTransform.identity
                        presentedView.transform = CGAffineTransform.identity
                        presentedView.alpha = 1
                        presentedView.center = viewCenter
                    })
                    
                }, completion: { (success: Bool) in
                    transitionContext.completeTransition(success)
                })
                
            }
        }else{
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to: UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey){
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height/2
                circle.center = startingPoint
                
//                UIView.animate(withDuration: duration, animations: {
//                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//                    returningView.center = self.startingPoint
//                    returningView.alpha = 0
//
//                    if self.transitionMode == .pop {
//                        containerView.insertSubview(returningView, belowSubview: returningView)
//                        containerView.insertSubview(self.circle, belowSubview: returningView)
//                    }
//
//                }) { (success: Bool) in
//                    returningView.center = viewCenter
//                    returningView.removeFromSuperview()
//
//                    self.circle.removeFromSuperview()
//
//                    transitionContext.completeTransition(success)
//                }
                
                UIView.animateKeyframes(withDuration: 0.9, delay: 0, options: .beginFromCurrentState, animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                        self.button.frame.origin.x += 300
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: self.duration, relativeDuration: self.duration, animations: {
                        self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        returningView.center = self.startingPoint
                        returningView.alpha = 0
                        
                        if self.transitionMode == .pop {
                            containerView.insertSubview(returningView, belowSubview: returningView)
                            containerView.insertSubview(self.circle, belowSubview: returningView)
                        }
                    })
                    
                }) { (success: Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect{
        let xLength = fmax(startingPoint.x, viewSize.width - startingPoint.x)
        let yLlength = fmax(startingPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLlength * yLlength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
