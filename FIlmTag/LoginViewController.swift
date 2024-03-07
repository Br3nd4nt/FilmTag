//
//  LoginView.swift
//  FilmTag
//
//  Created by br3nd4nt on 07.03.2024.
//

import UIKit

enum Colors {
    static let dark: UIColor = UIColor(displayP3Red: 38/255, green: 40/255, blue: 39/255, alpha: 1);
    static let blue: UIColor = UIColor(displayP3Red: 200/255, green: 251/255, blue: 246/255, alpha: 1);
    static let white: UIColor = UIColor(displayP3Red: 251/255, green: 1, blue: 254/255, alpha: 1);
    static let red: UIColor = UIColor(displayP3Red: 253/255, green: 110/255, blue: 143/255, alpha: 1);
    static let placeholderColor: UIColor = UIColor(displayP3Red: 140/255, green: 140/255, blue: 140/255, alpha: 1);
}

enum Constraints {
    static let appTitle: String = "FilmTag";
    static let loginTitle: String = "Log in";
    static let registerTitle: String = "Sign up";
    
    static let appTitleSize: CGFloat = 60;
    static let appTitleTop: CGFloat = 40;
    
    static let enterTitleSize: CGFloat = 40;
    static let enterTitleTop: CGFloat = 30;
    
    static let loginInputPlaceholder: String = "Input your login";
    static let loginInputLeft: CGFloat = 20;
    static let loginInputTop: CGFloat = 30;
    
    static let passwordInputPlaceholder: String = "Input your password";
    static let passwordInputLeft: CGFloat = 20;
    static let passwordInputTop: CGFloat = 30;
    
    static let inputFontSize: CGFloat = 25;
    
    static let cornerRadius: CGFloat = 10;

    static let loginButtonText: String = "   Log in   ";
    static let registerButtonText: String = "   Sign up   ";
    
    static let enterButtonTop: CGFloat = 40;
    static let enterButtonTextSize: CGFloat = 30;
    
    static let switchButtonLoginText: String = "Not Registered? Sign up"
    static let switchButtonRegisterText: String = "Already signed up? Log in"
    
    static let switchButtonTextSize: CGFloat = 15;
    static let switchButtonTop: CGFloat = 10;
}

final class LoginViewController: UIViewController {
    private let saltForPassword = "TheQuickBrownFoxJumpsOverTheLazyDog";
    
    
    private let defaults = UserDefaults.standard;
    
    private var isLoginSelected = true;
    
    private let appTitle: UILabel = UILabel();
    private let loginTitle: UILabel = UILabel();
    private let registerTitle: UILabel = UILabel();
    private let loginInput: UITextField = UITextField();
    private let passwordInput: UITextField = UITextField();
    private let loginButton: UIButton = UIButton();
    private let registerButton: UIButton = UIButton();
    private let switchButton: UIButton = UIButton();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureUI();
    }
    
    private func configureUI() {
        view.backgroundColor = Colors.dark;
        configureAppTitle();
        configureEnterTitles();
        configureLoginInput();
        configurePasswordInput();
        configureEnterButtons();
        configureSwitchButton();
    }
    
    private func configureAppTitle() {
        appTitle.translatesAutoresizingMaskIntoConstraints = false;
        appTitle.text = Constraints.appTitle;
        appTitle.font = UIFont.boldSystemFont(ofSize: Constraints.appTitleSize);
        appTitle.textColor = Colors.white;
        
        view.addSubview(appTitle);
        
        appTitle.pinCenterX(to: view);
        appTitle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constraints.appTitleTop);
    }
    
    private func configureEnterTitles() {
        loginTitle.translatesAutoresizingMaskIntoConstraints = false;
        registerTitle.translatesAutoresizingMaskIntoConstraints = false;
        
        loginTitle.text = Constraints.loginTitle;
        registerTitle.text = Constraints.registerTitle;
        
        loginTitle.font = UIFont.boldSystemFont(ofSize: Constraints.enterTitleSize)
        registerTitle.font = UIFont.boldSystemFont(ofSize: Constraints.enterTitleSize)
        
        loginTitle.textColor = Colors.white;
        registerTitle.textColor = Colors.white;
        
        view.addSubview(loginTitle);
        view.addSubview(registerTitle);
        
        loginTitle.pinCenterX(to: view);
        registerTitle.pinCenterX(to: view);
        
        loginTitle.pinTop(to: appTitle.bottomAnchor, Constraints.enterTitleTop);
        registerTitle.pinTop(to: appTitle.bottomAnchor, Constraints.enterTitleTop);
        
        if (isLoginSelected) {
            registerTitle.isHidden = true;
            loginTitle.isHidden = false;
        } else {
            loginTitle.isHidden = true;
            registerTitle.isHidden = false;
        }
    }
    
    private func configureLoginInput() {
        loginInput.translatesAutoresizingMaskIntoConstraints = false;
        
        loginInput.placeholder = Constraints.loginInputPlaceholder;
        loginInput.attributedPlaceholder = NSAttributedString(string: loginInput.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        loginInput.backgroundColor = Colors.white;
        loginInput.textColor = Colors.dark;
        loginInput.font = UIFont.systemFont(ofSize: Constraints.inputFontSize);
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: loginInput.frame.height))
        paddingView.backgroundColor = UIColor.clear
        
        loginInput.inputView?.setHeight(Constraints.inputFontSize * 5);
        
        
        loginInput.leftView = paddingView
        loginInput.leftViewMode = .always
        
        
        
        view.addSubview(loginInput);
        
        loginInput.pinCenterX(to: view);
        loginInput.pinLeft(to: view, Constraints.loginInputLeft);
        loginInput.pinTop(to: loginTitle.bottomAnchor, Constraints.loginInputTop);
        loginInput.layer.cornerRadius = Constraints.cornerRadius;
        
    }
    
    private func configurePasswordInput() {
        passwordInput.translatesAutoresizingMaskIntoConstraints = false;
        
        passwordInput.placeholder = Constraints.passwordInputPlaceholder;
        passwordInput.attributedPlaceholder = NSAttributedString(string: passwordInput.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        passwordInput.backgroundColor = Colors.white;
        passwordInput.textColor = Colors.dark;
        passwordInput.font = UIFont.systemFont(ofSize: Constraints.inputFontSize);
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordInput.frame.height))
        paddingView.backgroundColor = UIColor.clear
        
        passwordInput.leftView = paddingView
        passwordInput.leftViewMode = .always
        
        
        
        view.addSubview(passwordInput);
        
        passwordInput.pinCenterX(to: view);
        passwordInput.pinLeft(to: view, Constraints.passwordInputLeft);
        passwordInput.pinTop(to: loginInput.bottomAnchor, Constraints.passwordInputTop);
        passwordInput.layer.cornerRadius = Constraints.cornerRadius;
    }
    
    private func configureEnterButtons() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false;
        registerButton.translatesAutoresizingMaskIntoConstraints = false;
        
        loginButton.layer.cornerRadius = Constraints.cornerRadius;
        registerButton.layer.cornerRadius = Constraints.cornerRadius;
        
        loginButton.setTitle(Constraints.loginButtonText, for: .normal);
        registerButton.setTitle(Constraints.registerButtonText, for: .normal);
        
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.enterButtonTextSize);
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.enterButtonTextSize);
        
        loginButton.backgroundColor = Colors.blue;
        registerButton.backgroundColor = Colors.blue;
        
        //add targets
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        
        view.addSubview(loginButton);
        view.addSubview(registerButton);
        
        loginButton.pinCenterX(to: view)
        registerButton.pinCenterX(to: view)
        
        loginButton.pinTop(to: passwordInput.bottomAnchor, Constraints.enterButtonTop);
        registerButton.pinTop(to: passwordInput.bottomAnchor, Constraints.enterButtonTop);
        
        if (isLoginSelected) {
            registerButton.isHidden = true;
            registerButton.isEnabled = false;
            loginButton.isHidden = false;
            loginButton.isEnabled = true;
        } else {
            loginButton.isHidden = true;
            loginButton.isEnabled = false;
            registerButton.isHidden = false;
            registerButton.isEnabled = true;
        }
    }
    
    private func configureSwitchButton() {
        switchButton.translatesAutoresizingMaskIntoConstraints = false;
        switchButton.layer.cornerRadius = Constraints.cornerRadius;
        
        switchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constraints.switchButtonTextSize);
        
        switchButton.titleLabel?.textColor = Colors.white;
        
        switchButton.backgroundColor = .clear;
        
        switchButton.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside);
        
        if (isLoginSelected) {
            switchButton.setTitle(Constraints.switchButtonLoginText, for: .normal);
        } else {
            switchButton.setTitle(Constraints.switchButtonRegisterText, for: .normal);
        }
        
        view.addSubview(switchButton);
        
        switchButton.pinCenterX(to: view);
        switchButton.pinTop(to: loginButton.bottomAnchor, Constraints.switchButtonTop);
    }
    
    
    
    @objc
    private func switchButtonPressed() {
        isLoginSelected = !isLoginSelected;
        
        if (isLoginSelected) {
            registerButton.isHidden = true;
            registerButton.isEnabled = false;
            loginButton.isHidden = false;
            loginButton.isEnabled = true;
            
            registerTitle.isHidden = true;
            loginTitle.isHidden = false;
            
            switchButton.setTitle(Constraints.switchButtonLoginText, for: .normal);
        } else {
            loginButton.isHidden = true;
            loginButton.isEnabled = false;
            registerButton.isHidden = false;
            registerButton.isEnabled = true;
            
            loginTitle.isHidden = true;
            registerTitle.isHidden = false;
            
            switchButton.setTitle(Constraints.switchButtonRegisterText, for: .normal);
        }
    }
    
    @objc
    private func loginButtonPressed() {
        loginInput.backgroundColor = Colors.white;
        passwordInput.backgroundColor = Colors.white;
        let login: String = loginInput.text!;
        let password: String = passwordInput.text!;
        var failed: Bool = false;
        if (login.isEmpty) {
            loginInput.backgroundColor = Colors.red;
            return;
        }
        
        if (password.isEmpty) {
            passwordInput.backgroundColor = Colors.red;
            return;
        }
        let passwordHash: Int = (password + saltForPassword).hashValue;
        
        let urlString = "http://192.168.1.9:8080/users/login/" + login + "/" + String(passwordHash);
        
        guard let url = URL(string: urlString) else {
            failed = true;
            return;
        };
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching data: \(error)")
                    failed = true;
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    failed = true;
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(ServerResponse.self, from: data)
                    
                    let login:String = decodedData.login;
                    let hash:String = decodedData.passwordHash;
                    if (login.isEmpty || hash.isEmpty) {
                        failed = true;
                    }
                    self.onServerResponse(login: login, hash: hash, failed: failed)
                    
                } catch {
                    failed = true;
                }
            }
        }
        dataTask.resume()
    }
    
    @objc
    private func registerButtonPressed() {
        loginInput.backgroundColor = Colors.white;
        passwordInput.backgroundColor = Colors.white;
        let login: String = loginInput.text!;
        let password: String = passwordInput.text!;
        var failed: Bool = false;
        if (login.isEmpty) {
            loginInput.backgroundColor = Colors.red;
            return;
        }
        
        if (password.isEmpty) {
            passwordInput.backgroundColor = Colors.red;
            return;
        }
        let passwordHash: Int = (password + saltForPassword).hashValue;
        
        let urlString = "http://192.168.1.9:8080/users/register/" + login + "/" + String(passwordHash);
        
        guard let url = URL(string: urlString) else {
            failed = true;
            return;
        };
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching data: \(error)")
                    failed = true;
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    failed = true;
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(ServerResponse.self, from: data)
                    
                    let login:String = decodedData.login;
                    let hash:String = decodedData.passwordHash;
                    if (login.isEmpty || hash.isEmpty) {
                        failed = true;
                    }
                    self.onServerResponse(login: login, hash: hash, failed: failed)
                    
                } catch {
                    failed = true;
                }
            }
        }
        dataTask.resume()
    }
    
    private func onServerResponse(login: String, hash: String, failed: Bool) {
        if (failed) {
            self.appTitle.textColor = .red;
        } else {
            self.appTitle.textColor = .green;
        }
    }
}


private struct ServerResponse : Codable, Hashable {
    let login: String
    let passwordHash: String
}
