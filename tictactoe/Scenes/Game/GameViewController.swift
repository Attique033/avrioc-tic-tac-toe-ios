//
//  GameViewController.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//


import UIKit
import Combine

class GameViewController: UIViewController {
    private let viewModel: GameViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var gameBoardView: GameBoardView = {
        let view = GameBoardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start New Game", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Statistics", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(statsTapped), for: .touchUpInside)
        return button
    }()

    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(viewModel: GameViewModel = GameViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Tic Tac Toe"
        
        view.addSubview(gameBoardView)
        view.addSubview(newGameButton)
        view.addSubview(statsButton)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            
            gameBoardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameBoardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gameBoardView.heightAnchor.constraint(equalTo: gameBoardView.widthAnchor),
            
            
            newGameButton.topAnchor.constraint(equalTo: gameBoardView.bottomAnchor, constant: 40),
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
            statsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: statsButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.$board
            .receive(on: DispatchQueue.main)
            .sink { [weak self] board in
                self?.gameBoardView.updateBoard(board)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
            }
            .store(in: &cancellables)
        
        viewModel.$showResultAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
                if showAlert {
                    self?.showResultAlert()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func newGameTapped() {
        showNewGameAlert()
    }
    
    private func showNewGameAlert() {
        let alert = UIAlertController(
            title: "Would you like to play first move?",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            Task {
                await self?.viewModel.startNewGame(startWithPlayer: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .default) { [weak self] _ in
            Task {
                await self?.viewModel.startNewGame(startWithPlayer: false)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func statsTapped() {
        let statsVC = StatisticsViewController()
        navigationController?.pushViewController(statsVC, animated: true)
    }
    
    private func showResultAlert() {
        let alert = UIAlertController(
            title: "Game Over",
            message: viewModel.resultMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.showNewGameAlert()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - GameBoardViewDelegate
extension GameViewController: GameBoardViewDelegate {
    func gameBoardView(_ view: GameBoardView, didTapCellAt row: Int, column: Int) {

        if viewModel.sessionId == nil || viewModel.gameStatus != .ongoing {
            showNewGameAlert()
            return
        }

        Task {
            await viewModel.makeMove(at: row, column: column)
        }
    }
}
