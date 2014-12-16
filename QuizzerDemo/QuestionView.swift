//
//  QuestionView.swift
//  QuizzerDemo
//
//  Created by Stephen Lu on 12/14/14.
//  Copyright (c) 2014 LineBreak. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    let imageMarginSpace: CGFloat = 5.0
    var futura = UIFont(name: "Futura", size: CGFloat(36.0))
    var questionField: UITextView!
    var animator: UIDynamicAnimator!
    var originalCenter: CGPoint!
    var question: String!
    var answer: Bool!
    
    init(frame: CGRect, question: String, answer: Bool, center: CGPoint) {
        // Gives all the stuff Apple provides
        super.init(frame: frame)
        self.center = center
        self.answer = answer
        self.question = question
        
        // Set the background to white
        self.backgroundColor = UIColor.whiteColor()
        self.layer.shouldRasterize = true
        // Original
        self.originalCenter = center
        
        // Apple thing. For physics
        animator = UIDynamicAnimator(referenceView: self)
        // Question
        questionField = UITextView()
        questionField.text = question
        questionField.editable = false
        questionField.backgroundColor = UIColor(red: 232.0/255.0, green: 186.0/255.0, blue: 188/255.0, alpha: 1.0)
        questionField.textAlignment = NSTextAlignment.Center
        questionField.frame = CGRectIntegral(CGRectMake(
            0.0 + self.imageMarginSpace,
            0.0 + self.imageMarginSpace,
            self.frame.width - (2 * self.imageMarginSpace),
            self.frame.height - (2 * self.imageMarginSpace)
            ))
        questionField.font = self.futura
        questionField.textColor = UIColor.blackColor()
        questionField.layer.shouldRasterize = true
        self.addSubview(questionField)
        self.applyShadow()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyShadow() {
        self.layer.cornerRadius = 6.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
    }
    
    func swipe(answer: Bool) {
        animator.removeAllBehaviors()
        
        // If the answer is false, Move to the left
        // Else if the answer is true, move to the right
        let gravityX = answer ? 0.5 : -0.5
        let magnitude = answer ? 20.0 : -20.0
        let gravityBehavior:UIGravityBehavior = UIGravityBehavior(items: [self])
        gravityBehavior.gravityDirection = CGVectorMake(CGFloat(gravityX), 0)
        animator.addBehavior(gravityBehavior)
        
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [self], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = CGFloat(magnitude)
        animator.addBehavior(pushBehavior)
        
    }
    
    func returnToCenter() {
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.center = self.originalCenter
            }, completion: { finished in
                println("Finished Animation")}
        )
        
    }

}
