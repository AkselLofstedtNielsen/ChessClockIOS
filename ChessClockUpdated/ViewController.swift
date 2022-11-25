//
//  ViewController.swift
//  ChessClockUpdated
//
//  Created by Aksel Nielsen on 2022-11-24.
//

import UIKit

class ViewController: UIViewController {
    
    let settingsSegue = "settingsSegueView"
    
    @IBOutlet weak var player1CounterText: UILabel!
    @IBOutlet weak var player2CounterText: UILabel!
    var button1Counter = 0
    var button2Counter = 0

    @IBOutlet weak var player1TimerText: UILabel!
    @IBOutlet weak var player2TimerText: UILabel!
    var firstPlayerTime = 0
    var secondPlayerTime = 0
    var firstTimer = Timer()
    var secondTimer = Timer()
    //Fixar bugg med flera timers igång samtidigt
    var multipleTimerOne = false
    var multipleTimerTwo = false
    
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!
    //Start/Waiting
    var buttonOneTitle = false
    var buttonTwoTitle = false
    
    var resumeTapped = false
    var WCRRule = false
    var blitzRule = false
    var rapidPlayRule = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Roterar knapp och text
        player2TimerText.transform = CGAffineTransform(rotationAngle: 3.14)
        player2Button.transform = CGAffineTransform(rotationAngle: 3.14)
        player2CounterText.transform = CGAffineTransform(rotationAngle: 3.14)
    
        //Sätter skapad tid till varje spelare för nedräkning
        let startTime = 900
        setTimesAndLabels(time: startTime)
        
        
    }
    
    @IBAction func pausAndPlayButton(_ sender: Any) {
            firstTimer.invalidate()
            secondTimer.invalidate()
        
    }
    
    func setTimesAndLabels(time : Int){
        player1TimerText.text = timeString(time: time)
        player2TimerText.text = timeString(time: time)
        firstPlayerTime = time
        secondPlayerTime = time

    }
    func setCounters (count : Int){
        button1Counter = count
        button2Counter = count
        player1CounterText.text = String("Moves:\(button1Counter)")
        player2CounterText.text = String("Moves:\(button2Counter)")
        
    }
    func WCRrules(){
        //start WCR Rules
        if button1Counter == 0 && button2Counter == 0{
            setTimesAndLabels(time: 7200)
            }
        if button1Counter == 40 && button2Counter == 40{
            setTimesAndLabels(time: 3600)
            setCounters(count: 40)
        }
        if button1Counter == 60 && button2Counter == 60{
            setTimesAndLabels(time: 900)
            setCounters(count: 60)
        }
        
    }
    func blitzRules(){
        setTimesAndLabels(time: 300)
        
    }
    func rapidPlay(){
        setTimesAndLabels(time: 1800)
        
    }
    
    //starting settings view
    @IBAction func settingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: settingsSegue, sender: self)

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == settingsSegue{
            //Kommer åt objektet och nilcheckar
            if let destination = segue.destination as? SettingsViewController{
                //waiting for obj from other view
                destination.completionHandler = {InputTime,InputWCR,InputBlitz,InputRapidPlay in
                    if InputWCR == true{
                        self.setCounters(count: 0)
                        self.WCRRule = true
                        self.WCRrules()
                    }else if InputBlitz == true{
                        self.setCounters(count: 0)
                        self.blitzRule = true
                        self.blitzRules()
                    }else if InputRapidPlay == true{
                        self.setCounters(count: 0)
                        self.rapidPlayRule = true
                        self.rapidPlay()
                    }
                    else{
                        self.setTimesAndLabels(time: InputTime ?? 0)
                        self.setCounters(count: 0)
                    }
                }
            }
            
            
        }
    }
    @IBAction func playerOneButton(_ sender: Any) {
        button1Counter += 1
        player1CounterText.text = String("Moves:\(button1Counter)")
        
        if multipleTimerOne == false{
               runSecondTimer()
            firstTimer.invalidate()
            multipleTimerTwo = false
            player1Button.setTitle("Waiting", for: .normal)
            player2Button.setTitle("Continue", for: .normal)
            if WCRRule == true{
                if button1Counter > 60{
                    firstPlayerTime += 30
                    player1TimerText.text = timeString(time: firstPlayerTime)
                    
                }else{
                    WCRrules()
                }
            }
        }
    }
    @IBAction func playerTwoButton(_ sender: Any) {
        button2Counter += 1
        player2CounterText.text = String("Moves:\(button2Counter)")
        if multipleTimerTwo == false{
            runFirstTimer()
            secondTimer.invalidate()
            multipleTimerOne = false
            player2Button.setTitle("Waiting", for: .normal)
            player1Button.setTitle("Continue", for: .normal)
            if WCRRule == true{
                if button2Counter > 60{
                    secondPlayerTime += 30
                    player2TimerText.text = timeString(time: secondPlayerTime)
                }else{
                    WCRrules()
                }
            }
        }
    }
    func runFirstTimer (){
        firstTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updatePlayerOneTime)), userInfo: nil, repeats: true)
        multipleTimerTwo = true
    }
    func runSecondTimer (){
        secondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updatePlayerTwoTime)), userInfo: nil, repeats: true)
       multipleTimerOne = true
    }
    @objc func updatePlayerOneTime(){
        firstPlayerTime -= 1
        player1TimerText.text = timeString(time: firstPlayerTime)
        
    }
    @objc func updatePlayerTwoTime(){
        secondPlayerTime -= 1
        player2TimerText.text = timeString(time: secondPlayerTime)
      
    }
    func timeString(time:Int) -> String {
//         om man vill ha timmar också
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return NSString(format: "%02d:%02d:%02d", hours, minutes, seconds) as String
        
    }
    
}

