//
//  ResultController.swift
//  iQuiz
//
//  Created by Ashwin Subramanian on 5/11/25.
//

import UIKit

class ResultController: UIViewController {
    
    var totalQuestions: Int = 0
    var correctAnswersCount: Int = 0
    
    @IBOutlet weak var scoreResultsLabel: UILabel!
    @IBOutlet weak var performanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        scoreResultsLabel.text = "You got \(correctAnswersCount) out of \(totalQuestions) correct."
        
        if correctAnswersCount == totalQuestions {
            performanceLabel.text = "Perfect! You answered all questions correctly."
        } else if correctAnswersCount == 0 {
            performanceLabel.text = "Better luck next time. You didn't get any questions correct."
        } else if Double(correctAnswersCount) / Double(totalQuestions) >= 0.7 {
            performanceLabel.text = "Great job! You answered most questions correctly."
        } else {
            performanceLabel.text = "Good effort! You answered some questions correctly."
        }
    }
    
    @objc func handleSwipeLeft() {
        performSegue(withIdentifier: "unwindToTopicList", sender: self)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToTopicList", sender: self)
    }
}
