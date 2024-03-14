//
//  LoginView.swift
//  FilmTag
//
//  Created by br3nd4nt on 07.03.2024.
//

import UIKit

enum Colors {
    static let dark: UIColor = UIColor(displayP3Red: 38/255, green: 40/255, blue: 39/255, alpha: 1)
    static let blue: UIColor = UIColor(displayP3Red: 200/255, green: 251/255, blue: 246/255, alpha: 1)
    static let white: UIColor = UIColor(displayP3Red: 251/255, green: 1, blue: 254/255, alpha: 1)
    static let red: UIColor = UIColor(displayP3Red: 253/255, green: 110/255, blue: 143/255, alpha: 1)
    static let placeholderColor: UIColor = UIColor(displayP3Red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
}

enum Constraints {
    static let loginKey: String = "login key for userDefaults"
    static let passwordKey: String = "password key for userDefaults"
    
    static let serverIP: String = "79.137.203.25:8080"
    
    static let appTitle: String = "FilmTag"
    static let loginTitle: String = "Log in"
    static let registerTitle: String = "Sign up"
    
    static let appLogoTop: CGFloat = 40
    
    static let enterTitleSize: CGFloat = 40
    static let enterTitleTop: CGFloat = 30
    
    static let loginInputPlaceholder: String = "Input your login"
    static let loginInputLeft: CGFloat = 20
    static let loginInputTop: CGFloat = 30
    
    static let passwordInputPlaceholder: String = "Input your password"
    static let passwordInputLeft: CGFloat = 20
    static let passwordInputTop: CGFloat = 30
    
    static let inputFontSize: CGFloat = 25
    
    static let cornerRadius: CGFloat = 10

    static let loginButtonText: String = "   Log in   "
    static let registerButtonText: String = "   Sign up   "
    
    static let enterButtonTop: CGFloat = 40
    static let enterButtonTextSize: CGFloat = 30
    
    static let switchButtonLoginText: String = "Not Registered? Sign up"
    static let switchButtonRegisterText: String = "Already signed up? Log in"
    
    static let switchButtonTextSize: CGFloat = 15
    static let switchButtonTop: CGFloat = 10
}

final class LoginViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    private var isLoginSelected = true
    
    private let appLogo: UIImageView = UIImageView()
    private let loginTitle: UILabel = UILabel()
    private let registerTitle: UILabel = UILabel()
    private let loginInput: UITextField = UITextField()
    private let passwordInput: UITextField = UITextField()
    private let loginButton: UIButton = UIButton()
    private let registerButton: UIButton = UIButton()
    private let switchButton: UIButton = UIButton()
    
    private let errorAlert: UIAlertController = UIAlertController(title: "Error", message: "Something went wrong. Please try again.", preferredStyle: .alert)
    private let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    private let loginRegEx: String = "([(0-9)(A-Z)(!@#$%)]+)([a-z]*){4,15}"
    private let passwordRegEx: String = "([(0-9)(A-Z)(!@#$%ˆ&*+-=<>)]+)([a-z]*){8,20}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        errorAlert.addAction(okAction)
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = Colors.dark
        configureAppLogo()
        configureEnterTitles()
        configureLoginInput()
        configurePasswordInput()
        configureEnterButtons()
        configureSwitchButton()
    }
    
    private func configureAppLogo() {
        appLogo.image = UIImage(named: "appLogo")
        let newWidth = self.view.frame.width - 80
        let ratio = appLogo.image!.size.width / appLogo.image!.size.height
        let newHeight = newWidth / ratio
        appLogo.image = appLogo.image?.resize(to: CGSize(width: newWidth, height: newHeight))
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appLogo)
        
        appLogo.pinCenterX(to: view)
        appLogo.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.appLogoTop)
    }
    
    private func configureEnterTitles() {
        loginTitle.translatesAutoresizingMaskIntoConstraints = false
        registerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        loginTitle.text = Constraints.loginTitle
        registerTitle.text = Constraints.registerTitle
        
        loginTitle.font = UIFont.boldSystemFont(ofSize: Constraints.enterTitleSize)
        registerTitle.font = UIFont.boldSystemFont(ofSize: Constraints.enterTitleSize)
        
        loginTitle.textColor = Colors.white
        registerTitle.textColor = Colors.white
        
        view.addSubview(loginTitle)
        view.addSubview(registerTitle)
        
        loginTitle.pinCenterX(to: view)
        registerTitle.pinCenterX(to: view)
        
        loginTitle.pinTop(to: appLogo.bottomAnchor, Constraints.enterTitleTop)
        registerTitle.pinTop(to: appLogo.bottomAnchor, Constraints.enterTitleTop)
        
        if (isLoginSelected) {
            registerTitle.isHidden = true
            loginTitle.isHidden = false
        } else {
            loginTitle.isHidden = true
            registerTitle.isHidden = false
        }
    }
    
    private func configureLoginInput() {
        loginInput.translatesAutoresizingMaskIntoConstraints = false
        loginInput.placeholder = Constraints.loginInputPlaceholder
        loginInput.attributedPlaceholder = NSAttributedString(string: loginInput.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        loginInput.backgroundColor = Colors.white
        loginInput.textColor = Colors.dark
        loginInput.font = UIFont.systemFont(ofSize: Constraints.inputFontSize)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: loginInput.frame.height))
        paddingView.backgroundColor = UIColor.clear
        loginInput.inputView?.setHeight(Constraints.inputFontSize * 5)
        loginInput.leftView = paddingView
        loginInput.leftViewMode = .always
        
        view.addSubview(loginInput)
        loginInput.pinCenterX(to: view)
        loginInput.pinLeft(to: view, Constraints.loginInputLeft)
        loginInput.pinTop(to: loginTitle.bottomAnchor, Constraints.loginInputTop)
        loginInput.layer.cornerRadius = Constraints.cornerRadius
        
    }
    
    private func configurePasswordInput() {
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.placeholder = Constraints.passwordInputPlaceholder
        passwordInput.attributedPlaceholder = NSAttributedString(string: passwordInput.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        passwordInput.backgroundColor = Colors.white
        passwordInput.textColor = Colors.dark
        passwordInput.font = UIFont.systemFont(ofSize: Constraints.inputFontSize)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordInput.frame.height))
        paddingView.backgroundColor = UIColor.clear
        passwordInput.leftView = paddingView
        passwordInput.leftViewMode = .always
        passwordInput.isSecureTextEntry = true
        view.addSubview(passwordInput)
        passwordInput.pinCenterX(to: view)
        passwordInput.pinLeft(to: view, Constraints.passwordInputLeft)
        passwordInput.pinTop(to: loginInput.bottomAnchor, Constraints.passwordInputTop)
        passwordInput.layer.cornerRadius = Constraints.cornerRadius
    }
    
    private func configureEnterButtons() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.layer.cornerRadius = Constraints.cornerRadius
        registerButton.layer.cornerRadius = Constraints.cornerRadius
        
        loginButton.setTitle(Constraints.loginButtonText, for: .normal)
        registerButton.setTitle(Constraints.registerButtonText, for: .normal)
        
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.enterButtonTextSize)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.enterButtonTextSize)
        
        loginButton.backgroundColor = Colors.blue
        registerButton.backgroundColor = Colors.blue
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.pinCenterX(to: view)
        registerButton.pinCenterX(to: view)
        
        loginButton.pinTop(to: passwordInput.bottomAnchor, Constraints.enterButtonTop)
        registerButton.pinTop(to: passwordInput.bottomAnchor, Constraints.enterButtonTop)
        
        if (isLoginSelected) {
            registerButton.isHidden = true
            registerButton.isEnabled = false
            loginButton.isHidden = false
            loginButton.isEnabled = true
        } else {
            loginButton.isHidden = true
            loginButton.isEnabled = false
            registerButton.isHidden = false
            registerButton.isEnabled = true
        }
    }
    
    private func configureSwitchButton() {
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.layer.cornerRadius = Constraints.cornerRadius
        switchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.switchButtonTextSize)
        switchButton.titleLabel?.textColor = Colors.white
        switchButton.backgroundColor = .clear
        switchButton.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
        
        if (isLoginSelected) {
            switchButton.setTitle(Constraints.switchButtonLoginText, for: .normal)
        } else {
            switchButton.setTitle(Constraints.switchButtonRegisterText, for: .normal)
        }
        
        view.addSubview(switchButton)
        switchButton.pinCenterX(to: view)
        switchButton.pinTop(to: loginButton.bottomAnchor, Constraints.switchButtonTop)
    }

    @objc
    private func switchButtonPressed() {
        isLoginSelected = !isLoginSelected
        
        if (isLoginSelected) {
            registerButton.isHidden = true
            registerButton.isEnabled = false
            loginButton.isHidden = false
            loginButton.isEnabled = true
            registerTitle.isHidden = true
            loginTitle.isHidden = false
            switchButton.setTitle(Constraints.switchButtonLoginText, for: .normal)
        } else {
            loginButton.isHidden = true
            loginButton.isEnabled = false
            registerButton.isHidden = false
            registerButton.isEnabled = true
            loginTitle.isHidden = true
            registerTitle.isHidden = false
            switchButton.setTitle(Constraints.switchButtonRegisterText, for: .normal)
        }
    }
    
    @objc
    private func loginButtonPressed() {
        loginInput.backgroundColor = Colors.white
        passwordInput.backgroundColor = Colors.white
        let login: String = loginInput.text!
        let password: String = passwordInput.text!
        
        if (login.isEmpty || textMatchesRegex(text: login, regexPattern: loginRegEx)) {
            loginInput.backgroundColor = Colors.red
            return
        }
        
        if (password.isEmpty || textMatchesRegex(text: password, regexPattern: passwordRegEx)) {
            passwordInput.backgroundColor = Colors.red
            return
        }
        
        Auth.login(login: login, password: password, completion: { response, error in
          if let error = error {
            print("Error during login: \(error.localizedDescription)")
              self.displayErrorMessage()
          } else if let response = response {
            print(response)
              let failed = response.login.isEmpty || response.passwordHash.isEmpty
            self.onServerResponse(login: response.login, hash: response.passwordHash, failed: failed)
          } else {
            print("Unexpected response during login")
          }
        })
        
    }
    
    @objc
    private func registerButtonPressed() {
        loginInput.backgroundColor = Colors.white
        passwordInput.backgroundColor = Colors.white
        let login: String = loginInput.text!
        let password: String = passwordInput.text!
        if (login.isEmpty || textMatchesRegex(text: login, regexPattern: loginRegEx)) {
            loginInput.backgroundColor = Colors.red
            return
        }
        
        if (password.isEmpty || textMatchesRegex(text: password, regexPattern: passwordRegEx)) {
            passwordInput.backgroundColor = Colors.red
            return
        }
        
        Auth.register(login: login, password: password, completion: { response, error in
          if let error = error {
            print("Error during login: \(error.localizedDescription)")
              self.displayErrorMessage()
          } else if let response = response {
            print(response)
              let failed = response.login.isEmpty || response.passwordHash.isEmpty
            self.onServerResponse(login: response.login, hash: response.passwordHash, failed: failed)
          } else {
            print("Unexpected response during login")
          }
        })
        
    }
    
    private func onServerResponse(login: String, hash: String, failed: Bool) {
        DispatchQueue.main.async {
            if (failed) {
                self.displayErrorMessage()
                return
            }
            self.defaults.set(login, forKey: Constraints.loginKey)
            self.defaults.set(hash, forKey: Constraints.passwordKey)
            self.passwordInput.text = ""
            self.dismiss(animated: true)
        }
    }
    
    private func displayErrorMessage(){
        DispatchQueue.main.async{
            self.present(self.errorAlert, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func textMatchesRegex(text: String, regexPattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(text.startIndex..., in: text)
            let matches = regex.firstMatch(in: text, options: [], range: range)
            return matches != nil
        } catch {
            print("Error creating regular expression: \(error)")
            return false
        }
    }
}
