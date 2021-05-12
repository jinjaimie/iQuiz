//
//  ViewController.swift
//  iQuiz
//
//  Created by Jaimie Jin on 5/5/21.
//

import UIKit

class Subject {
    var title: String
    var descrip: String
    var image: UIImage?
    var questions: [Question] = []
    
    
    init(subj: String, desc: String, img: UIImage?, question: [Question]?) {
        title = subj
        descrip = desc
        
        if (question != nil) {
            questions = question!
        }
        if (image != nil) {
            image = img!
        }
    }
}

class Question {
    var q: String
    var c1: String
    var c2: String
    var c3: String
    var achoice: String
    
    init(question: String, answer: String, option1: String, option2: String, option3: String) {
        q = question
        achoice = answer
        c1 = option1
        c2 = option2
        c3 = option3
    }
}

class TableData: NSObject, UITableViewDataSource {
    static let data: [Subject] = [
        Subject(subj: "Mathematics", desc: "Test your math knowledge with this witty quiz", img: nil, question: [Question(question: "What is the first Question for Math?", answer: "Option 1", option1: "Option 2", option2: "Option 3", option3: "Option 4")]),
        Subject(subj: "Marvel Super Heroes", desc: "Marvel fans, quiz yourself with out of the box questions!", img: nil, question: [Question(question: "What is the first Question for Marvel?", answer: "Option 1", option1: "Option 2", option2: "Option 3", option3: "Option 4"), Question(question: "What is the second Question for Marvel?", answer: "Option 2", option1: "Option 3", option2: "Option 1", option3: "Option 4")]),
        Subject(subj: "Science", desc: "Test tubes, nature, and human bodies what do you know?", img: nil, question: [Question(question: "What is the first Question for Science?", answer: "Option 1", option1: "Option 2", option2: "Option 3", option3: "Option 4"), Question(question: "What is the second Question for Science?", answer: "Option 2", option1: "Option 3", option2: "Option 1", option3: "Option 4"), Question(question: "What is the third Question for Science?", answer: "Option 4", option1: "Option 2", option2: "Option 3", option3: "Option 1")])]
    static var selected: [Question]? = nil
    static let CELL_NAME = "topicCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableData.CELL_NAME, for: indexPath)
        cell.textLabel?.text = TableData.data[indexPath.row].title
        cell.detailTextLabel?.text = TableData.data[indexPath.row].descrip
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
    
    @IBOutlet var subjectTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (subjectTable != nil) {
        subjectTable.dataSource = subjectData
        subjectTable.delegate = selector
        } else {
            score = 0
            buildJ()
            buildK()
            switchViewController(nil, to: question)
        }
    }
    
    @IBAction func setting(_ sender: Any) {
        let alertController = UIAlertController(title: "Settings go here", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
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
            if (question?.selectedButton?.titleLabel?.text == TableData.selected![curr - 1].achoice) {
                score += 1
                NSLog("score");
                answer!.changeData("Correct!")
            } else {
                answer!.changeData("Incorrect. The correct answer is \(TableData.selected![curr - 1].achoice)")
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
}

