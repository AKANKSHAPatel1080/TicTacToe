//
//  ViewController.swift
//  Tictactoe
//
//  Created by Akanksha Patel on 15/10/23.
//
import UIKit

class ViewController: UIViewController {
    
    var currentPlayer: Player = .x
    var board: [Player?] = Array(repeating: nil, count: 9)
    let winningCombinations: [[Int]] = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGameBoard()
    }

    func createGameBoard() {
        let gridSize = 3
        let buttonSize = CGSize(width: 100, height: 100)
        let margin: CGFloat = 10
        let xOffset = (view.frame.width - CGFloat(gridSize) * buttonSize.width - CGFloat(gridSize - 1) * margin) / 2
        let yOffset = (view.frame.height - CGFloat(gridSize) * buttonSize.height - CGFloat(gridSize - 1) * margin) / 2
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let x = xOffset + CGFloat(col) * (buttonSize.width + margin)
                let y = yOffset + CGFloat(row) * (buttonSize.height + margin)
                
                let button = UIButton(frame: CGRect(x: x, y: y, width: buttonSize.width, height: buttonSize.height))
                button.tag = row * gridSize + col
                
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                button.setTitleColor(.black, for: .normal)
                button.layer.borderWidth = 2
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                self.view.addSubview(button)
            }
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        if board[tag] == nil {
            board[tag] = currentPlayer
            sender.setTitle(currentPlayer.rawValue, for: .normal)

            if checkForWin() {
                showAlert(message: "\(currentPlayer.rawValue) wins!")
            } else if board.compactMap({ $0 }).count == 9 {
                showAlert(message: "It's a draw!")
            } else {
                currentPlayer = (currentPlayer == .x) ? .o : .x
            }
        }
    }

    func checkForWin() -> Bool {
        for combination in winningCombinations {
            if board[combination[0]] == currentPlayer && board[combination[1]] == currentPlayer && board[combination[2]] == currentPlayer {
                return true
            }
        }
        return false
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            self.resetGame()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }

    func resetGame() {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.setTitle("", for: .normal)
            }
        }
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
    }
}

enum Player: String {
    case x = "X"
    case o = "O"
}

