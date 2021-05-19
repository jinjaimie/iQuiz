//
//  ViewController.swift
//  iQuiz
//
//  Created by Jaimie Jin on 5/5/21.
//

import UIKit

struct Subject: Codable {
    var title: String
    var desc: String
    var questions: [Question] = []
}

struct Question: Codable {
    var text: String
    var answers: [String]
    var answer: String

}

class TableData: NSObject, UITableViewDataSource {
    static var data: [Subject] = []
    static var selected: [Question]? = nil
    static let CELL_NAME = "topicCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableData.CELL_NAME, for: indexPath)
        cell.textLabel?.text = TableData.data[indexPath.row].title
        cell.detailTextLabel?.text = TableData.data[indexPath.row].desc
        return cell
    }
}

class SubjectSelector: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt: IndexPath) -> IndexPath? {
        TableData.selected = TableData.data[willSelectRowAt.row].questions
        return willSelectRowAt
    }
    
    
}

class ViewController: UIViewController {
    var answer: AnswerViewController? = nil
    var question: QuestionViewController? = nil
    var finish: FinishViewController? = nil
    let subjectData = TableData()
    let selector = SubjectSelector()
    var curr = 0;
    var score = 0;
    var urlString: String = UserDefaults.standard.string(forKey: "questionurl_preference") ?? "https://tednewardsandbox.site44.com/questions.json"
    
    @IBOutlet var subjectTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //NSLog("\(UserDefaults.standard.string(forKey: "questionurl_preference")!)")
        //UserDefaults.standard.set("https://tednewardsandbox.site44.com/questions.json", forKey: "questionurl_preference")
        // HTTP PULL & SAVE
        getQuestions()
        if (subjectTable != nil) {
        subjectTable.dataSource = subjectData
        subjectTable.delegate = selector
        getQuestions()
            self.subjectTable.reloadData()
        } else {
            score = 0
            buildJ()
            buildK()
            switchViewController(nil, to: question)
        }
    }
    
    @IBAction func setting(_ sender: Any) {
        let alertController = UIAlertController(title: "Settings", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            self.urlString = (alertController.textFields?[0].text)!
            UserDefaults.standard.set(self.urlString, forKey: "questionurl_preference")
            
            self.getQuestions()
        }
        
        let checkAction = UIAlertAction(title: "Check Now", style: .default) { (_) in
            self.getQuestions()
            self.subjectTable.reloadData()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter new URL to get questions from"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
       
        alertController.addAction(confirmAction)
        alertController.addAction(checkAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet var button: UIButton!
    @IBAction func switchNext(_ sender: Any) {
        buildK()
        buildJ()
        buildL()
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.easeInOut)
                
        if question != nil &&
            question!.view.superview != nil {
            UIView.setAnimationTransition(.flipFromRight, for: view, cache: true)
            answer!.view.frame = view.frame
            button.setTitle("Next", for: .normal)
            switchViewController(question, to: answer)
            if (question?.selectedButton?.titleLabel?.text == TableData.selected![curr - 1].answers[Int(TableData.selected![curr - 1].answer)! - 1]) {
                score += 1
                answer!.changeData("Correct!")
            } else {
                answer!.changeData("Incorrect. The correct answer is \(TableData.selected![curr - 1].answers[Int(TableData.selected![curr - 1].answer)! - 1])")
            }
        }
        else {
            UIView.setAnimationTransition(.flipFromLeft, for: view, cache: true)
            if (TableData.selected!.count == curr) {
                finish!.view.frame = view.frame
                button.isHidden = true;
                switchViewController(answer, to: finish)
                curr = 0
            } else {
                question!.view.frame = view.frame
                button.setTitle("Submit", for: .normal)
                switchViewController(answer, to: question)
            }
        }
        UIView.commitAnimations()
    }
    
    fileprivate func switchViewController(_ from: UIViewController?, to: UIViewController?) {
            if from != nil {
                from!.willMove(toParent: nil)
                from!.view.removeFromSuperview()
                from!.removeFromParent()
            }
            
            if to != nil {
                self.addChild(to!)
                self.view.insertSubview(to!.view, at: 0)
                to!.didMove(toParent: self)
                if (to == question) {
                    question!.changeData(TableData.selected![curr])
                    curr += 1
                } else if (to == finish && finish != nil) {
                        finish!.changeData("\(String(score)) out of \(String(TableData.selected!.count))")
                }
            }
        }
    
    fileprivate func buildK() {
        if answer == nil {
            answer = storyboard?.instantiateViewController(identifier: "answer") as? AnswerViewController
            answer!.data = "Incorrect!"
        }
    }
    
    fileprivate func buildJ() {
        if question == nil {
            question = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController
            question!.data = TableData.selected![curr]
        }
    }
    
    fileprivate func buildL() {
        if finish == nil {
            finish = storyboard?.instantiateViewController(identifier: "finish") as? FinishViewController
            finish!.data = "\(String(score)) out of \(String(TableData.selected!.count))"
        }
    }
    
    fileprivate func getQuestions() {
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url,
                                                  completionHandler:{ (data, response, err) in
                if err != nil || data == nil {
                    //pop up error alert
                    self.showError()
                    let jsonData = UserDefaults.standard.object(forKey: "questionitem_preference") as! Data
                    TableData.data = try! JSONDecoder().decode([Subject].self, from: jsonData)
                } else {
                    do {
                        let responseText = String.init(data: data!, encoding: .ascii)
                        let jsonData = responseText!.data(using: .utf8)!
                        let info = try JSONDecoder().decode([Subject].self, from: jsonData)
                        UserDefaults.standard.set(jsonData, forKey: "questionitem_preference")
                        TableData.data = info
                    } catch {
                        self.showError()
                    }
                }
            })
            
            task.resume()
            do {
                let jsonData = UserDefaults.standard.object(forKey: "questionitem_preference") as! Data
                TableData.data = try JSONDecoder().decode([Subject].self, from: jsonData)
            } catch {
                showError()
            }
        }
    }
    
    fileprivate func showError() {
        let alertController = UIAlertController(title: "Uh-Oh! Something went wrong", message: "Please check your url and make sure the Network Unavailable", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
        }
        
       
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

