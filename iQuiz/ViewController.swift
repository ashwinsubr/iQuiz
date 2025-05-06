//
// ViewController.swift
// iQuiz
//
// Created by Ashwin Subramanian on 5/5/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let quizzes = [
        "Mathematics",
        "Science!",
        "Marvel Super Heroes"
    ]
    
    let categoryImages = [
        "math-icon",
        "science-icon",
        "hero-icon"
    ]
    
    let categoryDescriptions = [
        "Did you pass the third grade?",
        "Because SCIENCE!",
        "Avengers, Assemble!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func settingsClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = quizzes[indexPath.row]
        print(selectedCategory)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 75/255, green: 46/255, blue: 131/255, alpha: 0.2).cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.masksToBounds = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: categoryImages[indexPath.row])
        imageView.tintColor = UIColor(red: 75/255, green: 46/255, blue: 131/255, alpha: 1)
        
        let titleLabel = UILabel()
        titleLabel.text = quizzes[indexPath.row]
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = categoryDescriptions[indexPath.row]
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(imageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cell.contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -20)
        ])

        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(red: 230/255, green: 225/255, blue: 240/255, alpha: 1)
        cell.selectedBackgroundView = selectionView

        cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        cell.accessoryType = .none
        
        return cell
    }
}
