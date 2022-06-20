//
//  ViewController.swift
//  RockPaperSissors
//
//  Created by IACD-06 on 2022/06/06.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var outcomeLabel: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    var score = 0
    var opponentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func rockChoosen(_ sender: Any) {
        let opponentSelection: String = makeOpponentSelection()
            outcomeLabel.text = " "
        if opponentSelection == "Rock"{
            outcomeLabel.text = "Opponent choose Rock. You Tie"
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Scissors"{
            outcomeLabel.text = "Oppoent choose Scissors. You Win"
            score = score + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Paper"{
            outcomeLabel.text = "Opponent choose Paper. You Lose"
            opponentScore = opponentScore + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }
    }
    
    @IBAction func paperChoosen(_ sender: Any) {
        let opponentSelection: String = makeOpponentSelection()
        outcomeLabel.text = " "
        if opponentSelection == "Paper"{
            outcomeLabel.text = "Opponent choose Rock. You Win"
            score = score + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Scissors"{
            outcomeLabel.text = "Oppoent choose Scissors. You Lose"
            opponentScore = opponentScore + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Paper"{
            outcomeLabel.text = "Opponent choose Paper. You Tie"
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }
    }
    
    
    @IBAction func scissorsChoosen(_ sender: Any) {
        let opponentSelection: String = makeOpponentSelection()
        outcomeLabel.text = " "
        if opponentSelection == "Scissors"{
            outcomeLabel.text = "Opponent choose Rock. You Lose"
            opponentScore = opponentScore + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Scissors"{
            outcomeLabel.text = "Oppoent choose Scissors. You Tie"
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }else if opponentSelection == "Paper"{
            outcomeLabel.text = "Opponent choose Paper. You Win"
            score = score + 1
            scoreLabel.text = "You: \(score) vs Computer: \(opponentScore)"
        }
    }
    
    func makeOpponentSelection() -> String{
        var option: [String] = []
        option.append("Rock")
        option.append("Scissors")
        option.append("Paper")
        let randomNumber = Int(arc4random_uniform(3))
        return option[randomNumber]
    }
}

