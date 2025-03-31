//
//  RegisterViewController.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.UI.padding
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.UI.cornerRadius
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
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    init(viewModel: RegisterViewModel = RegisterViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Register"
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.padding),
            
            registerButton.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHeight),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
                self?.errorLabel.isHidden = error == nil
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
    @objc private func registerTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            viewModel.error = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            viewModel.error = "Passwords do not match"
            return
        }
        
        Task {
            await viewModel.register(name: name, email: email, password: password)
        }
    }
    
    private func navigateToGame() {
        let gameVC = GameViewController()
        navigationController?.setViewControllers([gameVC], animated: true)
    }
}
