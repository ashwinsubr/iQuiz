//
// ViewController.swift
// iQuiz
//
// Created by Ashwin Subramanian on 5/5/25.
//

import UIKit

struct QuizItem {
    let title: String
    let description: String
    let image: UIImage
    let questions: [QuizQuestion]
}

struct QuizQuestion {
    let questionText: String
    let correctAnswerIndex: Int
    let options: [String]
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let quizTopics: [QuizItem] = [
        QuizItem(title: "Mathematics", description: "Test your math skills!", image: UIImage(named: "math-icon")!, questions: [
            QuizQuestion(questionText: "What is 2+2?", correctAnswerIndex: 0, options: ["4", "22", "100", "242"]),
            QuizQuestion(questionText: "What is 5×5?", correctAnswerIndex: 2, options: ["10", "15", "25", "55"])
        ]),
        QuizItem(title: "Marvel Superheroes", description: "How well do you know Marvel?", image: UIImage(named: "hero-icon")!, questions: [
            QuizQuestion(questionText: "Who is Iron Man?", correctAnswerIndex: 0, options: ["Tony Stark", "Bruce Wayne", "Peter Parker", "Clark Kent"]),
            QuizQuestion(questionText: "Who is the first avenger?", correctAnswerIndex: 0, options: ["Captain America", "Dr. Strange", "Peter Parker", "Ashwin Subramanian"])
        ]),
        QuizItem(title: "Science", description: "For science enthusiasts!", image: UIImage(named: "science-icon")!, questions: [
            QuizQuestion(questionText: "What is H2O?", correctAnswerIndex: 1, options: ["Oxygen", "Water", "Hydrogen", "Carbon Dioxide"])
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func unwindToTopicList(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestion" {
            if let destinationVC = segue.destination as? QuestionController,
               let quizTopic = sender as? QuizItem {
                destinationVC.quizTopic = quizTopic
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            performSegue(withIdentifier: "showQuestion", sender: quizTopics[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Quiz Categories"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = quizTopics[indexPath.row].title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cell.detailTextLabel?.text = quizTopics[indexPath.row].description
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        cell.imageView?.image = quizTopics[indexPath.row].image
        
        return cell
    }
}
