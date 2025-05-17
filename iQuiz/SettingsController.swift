//
//  SettingsController.swift
//  iQuiz
//
//  Created by Ashwin Subramanian on 5/16/25.
//

import UIKit

protocol PopoverDelegate: AnyObject {
    func checkNowPress()
    func alertInvalid()
}

class SettingsController : UIViewController {
    
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    weak var delegate: PopoverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = "";
    }
    
    
    @IBAction func checkNowTapped(_ sender: Any) {
        let url = URL(string: urlInput.text!)
        if url == nil {
            errorMessage.text = "Invalid URL. Please try again."
            self.dismiss(animated: true, completion: self.delegate?.alertInvalid)
         return
        }
        (URLSession.shared.dataTask(with: url!) {
            data, response, error in
                if error == nil {
                    if data == nil {
                        self.errorMessage.text = "No data found at this URL."
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        do {
                            let quizzes = try JSONDecoder().decode([Quiz].self, from: data!)
                            DispatchQueue.main.async {
                                Quizzes.quizzes = quizzes;
                                self.delegate?.checkNowPress()
                                self.errorMessage.text = "Data has been set."
                                self.dismiss(animated: true, completion: nil)
                            }
                        } catch {
                            self.errorMessage.text = "Something happened while trying to parse the JSON."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "Error", message: "There was a network issue. Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.errorMessage.text = "There was a network issue. Please try again."
                    }
                }
        }).resume()
    }
}
