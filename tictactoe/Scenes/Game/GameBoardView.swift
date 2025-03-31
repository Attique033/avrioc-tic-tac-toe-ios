//
//  GameBoard.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import UIKit

protocol GameBoardViewDelegate: AnyObject {
    func gameBoardView(_ view: GameBoardView, didTapCellAt row: Int, column: Int)
}

class GameBoardView: UIView {
    weak var delegate: GameBoardViewDelegate?
    
    private var buttons: [[UIButton]] = []
    private let boardSize = 3
    private var currentBoard: [[Int]] = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
    ]
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupBoard() {
        backgroundColor = .systemBackground
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for row in 0..<boardSize {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8
            
            var buttonRow: [UIButton] = []
            for column in 0..<boardSize {
                let button = createButton(row: row, column: column)
                buttonRow.append(button)
                rowStackView.addArrangedSubview(button)
            }
            buttons.append(buttonRow)
            mainStackView.addArrangedSubview(rowStackView)
        }
        
        updateBoard(currentBoard)
    }
    
    private func createButton(row: Int, column: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.tag = row * boardSize + column
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        let constraint = NSLayoutConstraint(item: button,
                                          attribute: .height,
                                          relatedBy: .equal,
                                          toItem: button,
                                          attribute: .width,
                                          multiplier: 1.0,
                                          constant: 0)
        button.addConstraint(constraint)
        
        return button
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        let row = sender.tag / boardSize
        let column = sender.tag % boardSize
        delegate?.gameBoardView(self, didTapCellAt: row, column: column)
    }
    
    // MARK: - Public Methods
    func updateBoard(_ board: [[Int]]) {
        currentBoard = board

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for row in 0..<self.boardSize {
                for column in 0..<self.boardSize {
                    let value = board[row][column]
                    let button = self.buttons[row][column]
                    let enabled = (value == 0)
                    switch value {
                    case -1:
                        button.setTitle("X", for: .normal)
                        button.setTitleColor(.systemBlue, for: .normal)
                    case 1:
                        button.setTitle("O", for: .normal)
                        button.setTitleColor(.systemRed, for: .normal)
                    default:
                        button.setTitle("", for: .normal)
                    }
                    
                    button.isEnabled = enabled
                    button.alpha = enabled ? 1.0 : 0.8
                    button.setTitle(button.title(for: .normal), for: .disabled)
                    button.setTitleColor(button.titleColor(for: .normal), for: .disabled)
                }
            }
        }
    }
}
