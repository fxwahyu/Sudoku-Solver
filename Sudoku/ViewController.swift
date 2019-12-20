//
//  ViewController.swift
//  Sudoku
//
//  Created by Wahyu Herdianto on 15/11/19.
//  Copyright © 2019 Wahyu Herdianto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: OUTLET
    @IBOutlet var boardCell: [UILabel]!
    @IBOutlet var optionNumbers: [UILabel]!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    // MARK: VARIABLES
    var chosenLabel: UILabel!
    var chosenIndex: Int!
    var sudoku: SudokuHelper = SudokuHelper()
    var originalBoard = [[String]]() // filled with original numbers (static)
    var updatedBoard = [[String]]() // updated everytime player fill a new one
    var answeredBoard = [[String]]() // filled when player chose the right number
    var hour: Int = 0
    var minute: Int = 5
    var second: Int = 0
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTouchGesture()
        setupBoard()
        startTimer()
    }
    
    func startTimer(){
        hour = 0
        minute = 5
        second = 0
        updateTimerLabel()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrementCounter), userInfo: nil, repeats: true)
    }
    
    func updateTimerLabel(){
        if hour < 10 {
            hourLabel.text = "0\(hour)"
        } else {
            hourLabel.text = "\(hour)"
        }
        
        if minute < 10 {
            minuteLabel.text = "0\(minute)"
        } else {
            minuteLabel.text = "\(minute)"
        }
        
        if second < 10 {
            secondLabel.text = "0\(second)"
        } else {
            secondLabel.text = "\(second)"
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @objc func decrementCounter(){
        if hourLabel.text == "00" && minuteLabel.text == "00" && secondLabel.text == "00"{
            timer.invalidate()
            showAlert(type: "time's up")
        } else{
            if second == -1 {
                second = 59
                minute -= 1
            }
            
            if minute == -1 {
                minute = 59
                hour -= 1
            }
            
            updateTimerLabel()
            
            second -= 1
        }
    }
    
    func showAlert(type: String){
        var title: String = ""
        var message: String = ""
        
        if type == "time's up"{ // if the time's out
            title = "Game Over"
            message = "The time's up!"
        } else if type == "succeed"{ // if game done
            title = "You Won"
            message = "You have completed the board!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
            self.startTimer()
            self.clearBoard()
            self.setupBoard()
        }))

        self.present(alert, animated: true)
    }
    
    func setupBoard(){
        let number = Int.random(in: 1 ... 3)
        for i in 0 ... boardCell.count - 1{
            boardCell[i].text = sudoku.setupBoard(number: number, index: i)
            boardCell[i].layer.cornerRadius = 2
        }
        
        originalBoard = sudoku.fill2DArray(number: number)
        updatedBoard = originalBoard
        answeredBoard = originalBoard
    }
    
    func setupTouchGesture(){
        // gesture for cell
        for i in 0 ... boardCell.count - 1{
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fieldTapped))
            gestureRecognizer.numberOfTapsRequired = 1
            boardCell[i].addGestureRecognizer(gestureRecognizer)
        }
        
        // gesture for options
        for i in 0 ... optionNumbers.count - 1{
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionTapped))
            gestureRecognizer.numberOfTapsRequired = 1
            optionNumbers[i].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func fieldTapped(recognizer: UITapGestureRecognizer){
        let tapped = recognizer.view as! UILabel
        
        if let chosen = chosenLabel{ // if there is tapped field before
            if tapped != chosenLabel{ // if the new tapped field is different from previous
                chosenLabel.layer.borderWidth = 0
                chosenLabel = tapped
                chosenIndex = chosenLabel.tag
                chosenLabel.layer.borderWidth = 2.0
                chosenLabel.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.4784313725, blue: 0.2509803922, alpha: 1)
            } else{ // if the new tapped field same from previous
                chosenLabel.layer.borderWidth = 0
                chosenIndex = -1
                chosenLabel = nil
            }
        } else{ // if there is no tapped field
            chosenLabel = tapped
            chosenIndex = chosenLabel.tag
            chosenLabel.layer.borderWidth = 2.0
            chosenLabel.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.4784313725, blue: 0.2509803922, alpha: 1)
        }
    }
    
    func getIndex(chosen: Int) -> (Int, Int){
        var counter = 0
        for i in 0 ... 8{
            for j in 0 ... 8{
                if counter == chosen{ //the exact place
                    return (i, j)
                }
                counter += 1
            }
        }
        return (-1,-1)
    }
    
    @objc func optionTapped(recognizer: UITapGestureRecognizer){
        let tapped = recognizer.view as! UILabel
        
        if let chosen = chosenLabel{ // if the player already selected the field
            let (row, column) = getIndex(chosen: chosenIndex)
            
            if originalBoard[row][column] == "" { // if chosen field is not static number
                
                if updatedBoard[row][column] != ""{ // empty the previous number
                    updatedBoard[row][column] = ""
                    answeredBoard[row][column] = ""
                }
                
                let checker: Bool = sudoku.checker(row: row, column: column, board: updatedBoard, filledNumber: Int(tapped.text!)!)
                
                chosenLabel.text = tapped.text
                boardCell[chosenIndex] = chosenLabel
                updatedBoard[row][column] = tapped.text!
                
                if checker == true{
                    chosenLabel.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                    answeredBoard[row][column] = String(tapped.text!)
                } else{ // if number wrong
                    chosenLabel.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                }
                
                if isDone() == true{
                    timer.invalidate()
                    showAlert(type: "succeed")
                }
                
            } else{ //if chosen field is static number
                
            }
        } else{
            
        }
    }
    
    func isDone() -> Bool{
        for i in 0 ... 8{
            for j in 0 ... 8{
                if answeredBoard[i][j] == ""{
                    print("not done yet")
                    return false
                }
            }
        }
        
        print("done")
        return true
    }
    

    @IBAction func solveMe(_ sender: Any) {
        timer.invalidate()
        if sudoku.solveSudoku(board_: originalBoard){
            updatedBoard = sudoku.solvedSudoku
            var counter = 0
            for i in 0 ... 8{
                for j in 0 ... 8{
                    boardCell[counter].text = updatedBoard[i][j]
                    if updatedBoard[i][j] != originalBoard[i][j]{
                        boardCell[counter].textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                    }
                    counter += 1
                }
            }
        }
    }
    
    @IBAction func newGame(_ sender: Any) {
        timer.invalidate()
        self.startTimer()
        self.clearBoard()
        self.setupBoard()
    }
    
    func clearBoard(){
        originalBoard.removeAll()
        for i in 0 ... boardCell.count - 1 {
            boardCell[i].text = ""
            boardCell[i].textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        if let chosen = chosenLabel{
            if let chosen_ = chosenIndex{
                chosenLabel.layer.borderWidth = 0
                chosenLabel = nil
                chosenIndex = nil
            }
        }
    }
}

