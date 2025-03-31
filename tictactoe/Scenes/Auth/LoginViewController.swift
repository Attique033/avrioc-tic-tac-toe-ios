//
//  LoginViewController.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.UI.cornerRadius
        button.isEnabled = !viewModel.isLoading
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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
    init(viewModel: LoginViewModel = LoginViewModel()) {
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
        title = "Login"
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(registerButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHeight),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
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
        
        viewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.navigateToGame()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func loginTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        Task {
            await viewModel.login(email: email, password: password)
        }
    }
    
    @objc private func registerTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // MARK: - Navigation
    private func navigateToGame() {
        let gameVC = GameViewController()
        navigationController?.setViewControllers([gameVC], animated: true)
    }
}
