//
//  AnswerController.swift
//  iQuiz
//
//  Created by Ashwin Subramanian on 5/11/25.
//

import UIKit

class AnswerController: UIViewController {
    
    var isCorrect: Bool = false
    var selectedOption: String = ""
    var correctAnswer: String = ""
    var questionText: String = ""
    var isLastQuestion: Bool = false
    var correctAnswersCount: Int = 0
    var totalQuestions: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        questionLabel.text = questionText
        correctAnswerLabel.text = correctAnswer
        
        if isCorrect {
            resultLabel.text = "Your answer was correct!"
        } else {
            resultLabel.text = "Your answer was incorrect."
        }
    }
    
    @objc func handleSwipeLeft() {
        performSegue(withIdentifier: "unwindToTopicList", sender: self)
    }
    
    @objc func handleSwipeRight() {
        nextButtonTapped(nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let destinationVC = segue.destination as? ResultController {
                destinationVC.correctAnswersCount = self.correctAnswersCount
                destinationVC.totalQuestions = self.totalQuestions
            }
        }
    }

    @IBAction func nextButtonTapped(_ sender: Any?) {
        if isLastQuestion {
            performSegue(withIdentifier: "showResults", sender: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
