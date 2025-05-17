//
// ViewController.swift
// iQuiz
//
// Created by Ashwin Subramanian on 5/5/25.
//

import UIKit

struct Quiz: Codable {
    let title : String
    let desc : String
    let img : String?
    let questions : [Question]
}

struct Question: Codable {
    let text : String
    let answer : String
    let answers : [String]
}

class Quizzes {
    static var quizzes : [Quiz] = [
        Quiz(title: "Mathematics", desc: "Math questions, ready to do calculus?", img: "math", questions: [Question(text: "What is 2+2?", answer: "1", answers: ["4", "22", "An irrational number", "Nobody knows"]), Question(text: "What is 4+4?", answer: "2", answers: ["42", "8", "kanji tatsumi", "ryuji sakamoto"])]),
        Quiz(title: "Marvel Super Heroes", desc: "Your favorite superheroes!", img: "venom", questions: [Question(text: "Who is Iron Man?", answer: "1", answers: ["Tony Stark", "Obadiah Stane", "A rock hit by Megadeth", "Nobody knows"])]),
        Quiz(title: "Science", desc: "Science questions, volcano goes boom!", img: "science", questions: [Question(text: "What is fire?", answer: "1", answers: ["One of the four classical elements", "A Magical reaction given to us by God", "A band that hasn't yet been discovered", "Fire! Fire! Fire! heh-heh"])])
    ];
}

class ViewController: UIViewController, PopoverDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var quizTopics: [Quiz] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let quizURL = "https://tednewardsandbox.site44.com/questions.json"
        let url = URL(string: quizURL)
        
        (URLSession.shared.dataTask(with: url!) {
            data, response, error in
                if error == nil {
                    if data == nil {
                        print("No data")
                    } else {
                        do {
                            let quizzes = try JSONDecoder().decode([Quiz].self, from: data!)
                            DispatchQueue.main.async {
                                Quizzes.quizzes = quizzes
                                self.checkNowPress()
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Network error")
                    }
                }
        }).resume()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func checkNowPress() {
        quizTopics = Quizzes.quizzes
        tableView.reloadData()
        print("reloaded from delegate function")
    }
    
    func alertInvalid() {
        let alert = UIAlertController(title: "Error", message: "Invalid URL. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTopicList(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsClick(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestion" {
            if let destinationVC = segue.destination as? QuestionController,
               let quizTopic = sender as? Quiz {
                destinationVC.topic = quizTopic
            }
        }
        
        if segue.identifier == "showSettings" {
            if let destination = segue.destination as? SettingsController {
                destination.delegate = self
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
        cell.detailTextLabel?.text = quizTopics[indexPath.row].desc
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        // Simplified image handling
        if quizTopics[indexPath.row].img == nil {
            if quizTopics[indexPath.row].title == "Science!" || quizTopics[indexPath.row].title == "Marvel Super Heroes" || quizTopics[indexPath.row].title == "Mathematics" {
                cell.imageView?.image = UIImage(named: quizTopics[indexPath.row].title)
            } else {
                cell.imageView?.image = UIImage(named: "quiz")
            }
        } else {
            cell.imageView?.image = UIImage(named: quizTopics[indexPath.row].img!)
        }
        
        return cell
    }
}
