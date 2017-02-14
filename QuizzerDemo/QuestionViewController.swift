//
//  QuestionViewController.swift
//  QuizzerDemo
//
//  Created by Stephen Lu on 12/14/14.
//  Copyright (c) 2014 LineBreak. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var score: Int!
    var done: Bool = false
    
    @IBOutlet var scoreView: UITextView!
    

    @IBAction func truePressed(_ sender: AnyObject) {
        self.determineJudgement(true)
    }
    
    @IBAction func falsePressed(_ sender: AnyObject) {
        self.determineJudgement(false)
    }
    
    var questionViews: [QuestionView] = []
    var currentQuestionView: QuestionView!
    
    
    // Create a variable called data.  (String, Bool) -> Statement, Answer
    var data: [(String, Bool)] = [
        ("The color orange is named after the fruit.", true),
        ("You can legally drink alcohol while driving in mississippi", true),
        ("George Washington has wooden teeth.", false),
        ("It is illegal to pee in the ocean in Portugal", true),
        ("The space between your eyebrows is called the rasceta.", false),
        ("You can lead a cow down stairs but not upstairs.", false),
        ("The sky is blue.", true)
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start with a 0 score
        score = 0
        
        for (question, answer) in self.data {
            currentQuestionView = QuestionView(
                frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.width - 50),
                question: question,
                answer: answer,
                center: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 3)
            )
            self.questionViews.append(currentQuestionView)
        }
        
        for questionView in self.questionViews {
            self.view.addSubview(questionView)
        }
       
        // Add Pan Gesture Recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(QuestionViewController.handlePan(_:)))
        self.view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineJudgement(_ answer: Bool) {
        
        // If its the right answer, set the score
        if self.currentQuestionView.answer == answer && !self.done{
            self.score = self.score + 1
            self.scoreView.text = "Score: \(self.score)"
        }
        
        // Run the swipe animation
        self.currentQuestionView.swipe(answer)
        
        // Handle when we have no more matches
        self.questionViews.remove(at: self.questionViews.count - 1)
        if self.questionViews.count - 1 < 0 {
            let noMoreView = QuestionView(
                frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.width - 50),
                question: "No More Questions :(",
                answer: false,
                center: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 3)
            )
            self.questionViews.append(noMoreView)
            self.view.addSubview(noMoreView)
            self.done = true
            return
        }
        
        // Set the new current question to the next one
        self.currentQuestionView = self.questionViews.last!
        
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        // Is this gesture state finished??
        if gesture.state == UIGestureRecognizerState.ended {
            // Determine if we need to swipe off or return to center
            _ = gesture.location(in: self.view)
            if self.currentQuestionView.center.x / self.view.bounds.maxX > 0.8 {
                self.determineJudgement(true)
            }
            else if self.currentQuestionView.center.x / self.view.bounds.maxX < 0.2 {
                self.determineJudgement(false)
            }
            else {
                self.currentQuestionView.returnToCenter()
            }
        }
        let translation = gesture.translation(in: self.currentQuestionView)
        self.currentQuestionView.center = CGPoint(x: self.currentQuestionView!.center.x + translation.x, y: self.currentQuestionView!.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
}
