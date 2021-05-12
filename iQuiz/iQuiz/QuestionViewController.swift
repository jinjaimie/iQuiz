//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Jaimie Jin on 5/11/21.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    var selectedButton: UIButton? = nil
    
    @IBOutlet var options: [UIButton]!
    var _data : Question? = nil
          open var data : Question? {
            get { return self._data }
            set(value) {
                self._data = value
            }
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for op in options {
            op.backgroundColor = UIColor.white
        }
        selectedButton = nil
        // Do any additional setup after loading the view.
    }
    
    func changeLabel() {
        questionLabel.text = data!.q
        options[0].setTitle(data!.achoice, for: .normal)
        options[1].setTitle(data!.c1, for: .normal)
        options[2].setTitle(data!.c2, for: .normal)
        options[3].setTitle(data!.c3, for: .normal)
    }
    @IBAction func selectOption(_ sender: UIButton) {
        sender.backgroundColor = UIColor.lightGray
        if (selectedButton != nil) {
            selectedButton!.backgroundColor = UIColor.white
        }
        selectedButton = sender
    }
    
    func changeData(_ new: Question) {
        for op in options {
            op.backgroundColor = UIColor.white
        }
        selectedButton = nil
        data = new
        changeLabel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
