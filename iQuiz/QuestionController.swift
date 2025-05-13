//
//  QuestionController.swift
//  iQuiz
//
//  Created by Ashwin Subramanian on 5/11/25.
//

import UIKit

class QuestionController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var quizTopic: QuizItem?
    var currentQuestionIndex: Int = 0
    var selectedOption: String = ""
    var correctAnswersCount: Int = 0
    
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        questionTextLabel.text = quizTopic?.questions[currentQuestionIndex].questionText
        submitButton.isEnabled = false
    }
    
    @objc func handleSwipeLeft() {
        performSegue(withIdentifier: "unwindToTopicList", sender: self)
    }
    
    @objc func handleSwipeRight() {
        if submitButton.isEnabled {
            submitAnswer(nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        optionsTableView.reloadData()
        questionTextLabel.text = quizTopic?.questions[currentQuestionIndex].questionText
        submitButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopic?.questions[currentQuestionIndex].options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            submitButton.isEnabled = true
            selectedOption = cell.textLabel?.text ?? ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        cell.textLabel?.text = quizTopic?.questions[currentQuestionIndex].options[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswer" {
            if let destinationVC = segue.destination as? AnswerController {
                if let senderData = sender as? (isCorrect: Bool, correctAnswer: String, selectedOption: String, questionText: String, isLastQuestion: Bool, totalQuestions: Int, correctAnswersCount: Int) {
                    destinationVC.isCorrect = senderData.isCorrect
                    destinationVC.correctAnswer = senderData.correctAnswer
                    destinationVC.selectedOption = senderData.selectedOption
                    destinationVC.questionText = senderData.questionText
                    destinationVC.isLastQuestion = senderData.isLastQuestion
                    destinationVC.totalQuestions = senderData.totalQuestions
                    destinationVC.correctAnswersCount = senderData.correctAnswersCount
                }
            }
        }
    }
    
    @IBAction func submitAnswer(_ sender: Any?) {
        let correctAnswerIndex = quizTopic?.questions[currentQuestionIndex].correctAnswerIndex ?? 0
        let correctAnswer = quizTopic?.questions[currentQuestionIndex].options[correctAnswerIndex] ?? ""
        
        if selectedOption == correctAnswer {
            correctAnswersCount += 1
        }
        
        let isLastQuestion = currentQuestionIndex + 1 >= quizTopic?.questions.count ?? 0
        let totalQuestions = quizTopic?.questions.count ?? 0
        
        performSegue(withIdentifier: "showAnswer", sender: (
            isCorrect: selectedOption == correctAnswer,
            correctAnswer: correctAnswer,
            selectedOption: selectedOption,
            questionText: quizTopic?.questions[currentQuestionIndex].questionText ?? "",
            isLastQuestion: isLastQuestion,
            totalQuestions: totalQuestions,
            correctAnswersCount: correctAnswersCount
        ))
        
        currentQuestionIndex += 1
    }
}
