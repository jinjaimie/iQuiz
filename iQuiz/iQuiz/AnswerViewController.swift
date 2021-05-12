//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Jaimie Jin on 5/11/21.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var _data : String? = nil
          open var data : String? {
            get { return self._data }
            set(value) {
                self._data = value
            }
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func changeLabel() {
        label.text = data!
    }
    
    func changeData(_ new: String) {
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
