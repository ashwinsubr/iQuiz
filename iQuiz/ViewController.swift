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
        Quiz(title: "Mathematics", desc: "Math questions, ready to do calculus?", img: "math-icon", questions: [Question(text: "What is 2+2?", answer: "1", answers: ["4", "22", "An irrational number", "Nobody knows"]), Question(text: "What is 4+4?", answer: "2", answers: ["42", "8", "kanji tatsumi", "ryuji sakamoto"])]),
        Quiz(title: "Marvel Super Heroes", desc: "Your favorite superheroes!", img: "hero-icon", questions: [Question(text: "Who is Iron Man?", answer: "1", answers: ["Tony Stark", "Obadiah Stane", "A rock hit by Megadeth", "Nobody knows"])]),
        Quiz(title: "Science", desc: "Science questions, volcano goes boom!", img: "science-icon", questions: [Question(text: "What is fire?", answer: "1", answers: ["One of the four classical elements", "A Magical reaction given to us by God", "A band that hasn't yet been discovered", "Fire! Fire! Fire! heh-heh"])])
    ];
}

class ViewController: UIViewController, PopoverDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var quizTopics: [Quiz] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url: URL?
        if let settingsURL: String = UserDefaults.standard.string(forKey: "quizURL") {
            if !settingsURL.isEmpty {
                url = URL(string: settingsURL)
                print("URL taken from settings: \(settingsURL)")
            } else {
                url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
            }
        } else {
            url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        }
        
        guard let requestURL = url else {
            print("Invalid URL")
            loadOfflineContent()
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if error == nil, let data = data {
                do {
                    let fileURL = self.getDocumentsDirectory().appendingPathComponent("quizzes.json")
                    try data.write(to: fileURL)
                    
                    let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                    DispatchQueue.main.async {
                        Quizzes.quizzes = quizzes
                        self.quizTopics = quizzes
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    self.loadOfflineContent()
                }
            } else {
                print("Network error or offline")
                self.loadOfflineContent()
            }
        }.resume()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadOfflineContent() {
        DispatchQueue.main.async {
            let fileURL = self.getDocumentsDirectory().appendingPathComponent("quizzes.json")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                    Quizzes.quizzes = quizzes
                    self.quizTopics = quizzes
                    self.tableView.reloadData()
                    
                    let alert = UIAlertController(title: "Offline Mode",
                                                 message: "You are currently offline. Using locally stored quizzes.",
                                                 preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } catch {
                    print("Error loading from local storage: \(error)")
                }
            } else {
                // No local storage found, use default quizzes
                self.quizTopics = Quizzes.quizzes
                self.tableView.reloadData()
                
                let alert = UIAlertController(title: "No Connection",
                                             message: "No network connection and no locally stored quizzes found. Using default quizzes.",
                                             preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveQuizzesToLocalStorage() {
        do {
            let fileURL = getDocumentsDirectory().appendingPathComponent("quizzes.json")
            let data = try JSONEncoder().encode(Quizzes.quizzes)
            try data.write(to: fileURL)
            print("Quizzes saved to local storage")
        } catch {
            print("Error saving quizzes: \(error)")
        }
    }
    
    func loadQuizzesFromLocalStorage() -> [Quiz]? {
        do {
            let fileURL = getDocumentsDirectory().appendingPathComponent("quizzes.json")
            let data = try Data(contentsOf: fileURL)
            let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
            return quizzes
        } catch {
            print("Error loading quizzes: \(error)")
            return nil
        }
    }
    
    func checkNowPress() {
        quizTopics = Quizzes.quizzes
        tableView.reloadData()
    }
    
    func alertInvalid() {
        let alert = UIAlertController(title: "Error", message: "Invalid URL. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTopicList(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsClick(_ sender: UIButton) {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
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
