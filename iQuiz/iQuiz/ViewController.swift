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
    
    
    init(subj: String, desc: String, img: UIImage?, question: Question?) {
        title = subj
        descrip = desc
        
        if (question != nil) {
            questions.append(question!)
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
        Subject(subj: "Mathematics", desc: "Test your math knowledge with this witty quiz", img: nil, question: nil),
        Subject(subj: "Marvel Super Heroes", desc: "Marvel fans, quiz yourself with out of the box questions!", img: nil, question: nil),
        Subject(subj: "Science", desc: "Test tubes, nature, and human bodies what do you know?", img: nil, question: nil)]
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

class ViewController: UIViewController, UITableViewDelegate {
    
    let subjectData = TableData()
    
    @IBOutlet weak var subjectTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        subjectTable.dataSource = subjectData
        subjectTable.delegate = self
    }
    
    @IBAction func setting(_ sender: Any) {
        let alertController = UIAlertController(title: "Settings go here", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     NSLog("You selected cell #\(indexPath.row)!")
    }

}

