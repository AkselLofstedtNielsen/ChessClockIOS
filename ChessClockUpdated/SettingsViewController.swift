//
//  SettingsViewController.swift
//  ChessClockUpdated
//
//  Created by Aksel Nielsen on 2022-11-24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var inputTimeText: UITextField!
    public var completionHandler : ((Int?,Bool?)-> Void)?
    var WCR = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }
    
    @IBAction func WCRButton(_ sender: UIButton) {
        if WCR == false{
            WCR = true
            inputTimeText.text = "WCR selected"
        }else{
            WCR = false
        }
        
        
    }
    @IBAction func saveButton(_ sender: Any) {
        let text = Int(inputTimeText.text ?? "")
        completionHandler?(text,WCR)
        
        dismiss(animated: true, completion: nil)
    
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
