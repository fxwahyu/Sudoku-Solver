//
//  SudokuHelper.swift
//  Sudoku
//
//  Created by Wahyu Herdianto on 15/11/19.
//  Copyright © 2019 Wahyu Herdianto. All rights reserved.
//

import UIKit

class SudokuHelper: NSObject {

    var board_1: [[String]] = [
        ["","","","2","6","","7","","1"],
        ["6","8","","","7","","","9",""],
        ["1","9","","","","4","5","",""],
        ["8","2","","1","","","","4",""],
        ["","","4","6","","2","9","",""],
        ["","5","","","","3","","2","8"],
        ["","","9","3","","","","7","4"],
        ["","4","","","5","","","3","6"],
        ["7","","3","","1","8","","",""]
    ]
    
    var board_2: [[String]] = [
        ["","2","","","","","","",""],
        ["","","","","6","","","","3"],
        ["","7","4","","8","","","",""],
        ["","","","","","3","","","2"],
        ["","8","","","4","","","1",""],
        ["6","","","5","","","","",""],
        ["","","","","1","","7","8",""],
        ["5","","","","","9","","",""],
        ["","","","","","","","4",""]
    ]
    
    var board_3: [[String]] = [
        ["1","","","4","8","9","","","6"],
        ["7","3","","","5","","","4",""],
        ["4","6","","","","1","2","9","5"],
        ["3","8","7","1","2","","6","",""],
        ["5","","1","7","","3","","","8"],
        ["","4","6","","9","5","7","1",""],
        ["9","1","4","6","","","","8",""],
        ["","2","","","4","","","3","7"],
        ["8","","3","5","1","2","","","4"]
    ]
    
    var solvedSudoku = [[String]]()
    
    func setupBoard(number: Int, index: Int) -> String{
        var board: [[String]] = [[]]
        var counter = 0

        if number == 1{
            board = board_1
        } else if number == 2{
            board = board_2
        } else if number == 3{
            board = board_3
        }
        
        for i in 0 ... 8{
            for j in 0 ... 8{
                if index == counter{
                    return board[i][j]
                }
                counter += 1
            }
        }
        
        return ""
    }
    
    func fill2DArray(number: Int) -> [[String]]{
        if number == 1{
            return board_1
        } else if number == 2{
            return board_2
        } else if number == 3{
            return board_3
        }
        return board_1
    }
    
    func checker(row: Int, column: Int, board: [[String]], filledNumber: Int) -> Bool{
        
        for i in 0 ... 8{ //check by row
            if i != column{
                if board[row][i] != String(filledNumber){ // if the number hasn't existed and not itself
                } else { // if the number existed
//                    print("row already exist")
                    return false
                }
            }
        }
        
        for i in 0 ... 8{ //check by column
            if i != row{
                if board[i][column] != String(filledNumber){ // if the number hasn't existed and not itself
                } else { // if the number existed
//                    print("column already exist")
                    return false
                }
            }
        }
        
        //check by grid
        var r = row - (row % 3);
        var c = column - (column % 3);
        for i in r ... r + 3 - 1{
            for j in c ... c + 3 - 1{
                if board[i][j] == String(filledNumber){
//                    print("grid already exist")
                    return false
                }
            }
        }
        
        return true
    }
    
    func solveSudoku(board_: [[String]]) -> Bool{
        var board = board_
        for i in 0 ... 8{
            for j in 0 ... 8{
                if board[i][j] == ""{
                    for number in 1 ... 9{
//                        print(number)
                        if checker(row: i, column: j, board: board, filledNumber: number) == true{
                            board[i][j] = String(number)
                            
                            if solveSudoku(board_: board) == true{ //recursive
                                return true
                            } else{
                                board[i][j] = ""
                            }
                        }
                    }
                    return false
                }
            }
        }
        
        solvedSudoku = board
        
        return true
    }

}
