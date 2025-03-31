//
//  StatisticsViewContoller.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import UIKit
import Combine

class StatisticsViewController: UIViewController {
    private let viewModel: StatisticsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .systemGray6
        stack.layer.cornerRadius = Constants.UI.cornerRadius
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private lazy var winsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var lossesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var drawsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
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
    init(viewModel: StatisticsViewModel = StatisticsViewModel()) {
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
        Task {
            await viewModel.fetchStats()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Statistics"
        
        view.addSubview(statsStackView)
        view.addSubview(logoutButton)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        statsStackView.addArrangedSubview(winsLabel)
        statsStackView.addArrangedSubview(lossesLabel)
        statsStackView.addArrangedSubview(drawsLabel)
        statsStackView.addArrangedSubview(totalLabel)
        
        NSLayoutConstraint.activate([
            statsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            statsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            statsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.$stats
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stats in
                self?.updateStats(stats)
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
    }
    
    // MARK: - Actions
    private func updateStats(_ stats: GameStats?) {
        guard let stats = stats else { return }
        
        winsLabel.text = "Wins: \(stats.wins ?? 0)"
        lossesLabel.text = "Losses: \(stats.losses ?? 0)"
        drawsLabel.text = "Draws: \(stats.draws ?? 0)"
        totalLabel.text = "Total Games: \(stats.getTotalGames())"
    }
    
    @objc private func logoutTapped() {
        Task {
            await viewModel.logout()
            let loginVC = LoginViewController()
            navigationController?.setViewControllers([loginVC], animated: true)
        }
    }
}
