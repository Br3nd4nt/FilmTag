//
//  ChangeLoginViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 12.03.2024.
//

import UIKit

class ChangeLoginViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    private let viewTitle: UILabel = UILabel()
    private let oldLoginTitle: UILabel = UILabel()
    private let oldLoginField: UITextField = UITextField()
    private let newLoginTitle: UILabel = UILabel()
    private let newLoginField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordField: UITextField = UITextField()
    private let changeButton: UIButton = UIButton()
    
    private let loginOkAlert: UIAlertController = UIAlertController(title: "Success!", message: "Your login has been changed!", preferredStyle: .alert)
    private let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // Optional: Allow taps to go through to underlying views
        view.addGestureRecognizer(tapGesture)
        
        loginOkAlert.addAction(okAction)
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func configureUI() {
        view.addSubview(viewTitle)
        viewTitle.text = "Change Login:"
        viewTitle.font = UIFont.boldSystemFont(ofSize: 40)
        viewTitle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        viewTitle.pinLeft(to: view, 20)
        
        view.addSubview(oldLoginTitle)
        oldLoginTitle.text = "Input your old login: "
        oldLoginTitle.font = UIFont.systemFont(ofSize: 20)
        oldLoginTitle.pinTop(to: viewTitle.bottomAnchor, 40)
        oldLoginTitle.pinLeft(to: view, 20)
        
        view.addSubview(oldLoginField)
        oldLoginField.attributedPlaceholder = NSAttributedString(string: " Input your old login here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        oldLoginField.pinTop(to: oldLoginTitle.bottomAnchor, 5)
        oldLoginField.pinLeft(to: view, 20)
        oldLoginField.pinRight(to: view, 20)
        oldLoginField.backgroundColor = Colors.white;
        oldLoginField.textColor = Colors.dark;
        oldLoginField.layer.cornerRadius = 10
        oldLoginField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(newLoginTitle)
        newLoginTitle.text = "Input your new login: "
        newLoginTitle.font = UIFont.systemFont(ofSize: 20)
        newLoginTitle.pinTop(to: oldLoginField.bottomAnchor, 40)
        newLoginTitle.pinLeft(to: view, 20)
        
        view.addSubview(newLoginField)
        newLoginField.attributedPlaceholder = NSAttributedString(string: " Input your new login here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        newLoginField.pinTop(to: newLoginTitle.bottomAnchor, 5)
        newLoginField.pinLeft(to: view, 20)
        newLoginField.pinRight(to: view, 20)
        newLoginField.backgroundColor = Colors.white;
        newLoginField.textColor = Colors.dark;
        newLoginField.layer.cornerRadius = 10
        newLoginField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(passwordLabel)
        passwordLabel.text = "Input your password: "
        passwordLabel.font = UIFont.systemFont(ofSize: 20)
        passwordLabel.pinTop(to: newLoginField.bottomAnchor, 40)
        passwordLabel.pinLeft(to: view, 20)
        
        view.addSubview(passwordField)
        passwordField.attributedPlaceholder = NSAttributedString(string: " Input your password here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        passwordField.pinTop(to: passwordLabel.bottomAnchor, 5)
        passwordField.pinLeft(to: view, 20)
        passwordField.pinRight(to: view, 20)
        passwordField.backgroundColor = Colors.white;
        passwordField.textColor = Colors.dark;
        passwordField.layer.cornerRadius = 10
        passwordField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(changeButton)
        changeButton.pinCenterX(to: view)
        changeButton.pinTop(to: passwordField.bottomAnchor, 40)
        changeButton.setTitle("   Change password   ", for: .normal)
        changeButton.backgroundColor = Colors.blue
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func changeButtonPressed() {
        let oldLogin = oldLoginField.text ?? ""
        let newLogin = newLoginField.text ?? ""
        let password = passwordField.text ?? ""
        
        if (oldLogin.isEmpty) {
            oldLoginField.backgroundColor = Colors.red
            newLoginField.backgroundColor = Colors.white
            passwordField.backgroundColor = Colors.white
            return
        }
        
        if (newLogin.isEmpty) {
            oldLoginField.backgroundColor = Colors.white
            newLoginField.backgroundColor = Colors.red
            passwordField.backgroundColor = Colors.white
            return
        }
        
        if (password.isEmpty) {
            oldLoginField.backgroundColor = Colors.white
            newLoginField.backgroundColor = Colors.white
            passwordField.backgroundColor = Colors.red
            return
        }
        
        
        Auth.changeLogin(oldLogin: oldLogin, newLogin: newLogin, password: password, completion: { response, error in
          if let error = error {
            print("Error during changing login: \(error.localizedDescription)")
//              self.displayErrorMessage()
            // Handle error appropriately (e.g., display an error message)
          } else if let response = response {
            print(response)

            var failed = response.login.isEmpty || response.passwordHash.isEmpty;
            self.onServerResponse(login: response.login, hash: response.passwordHash, failed: failed)
          } else {
            // Handle unexpected scenario (shouldn't happen if error handling is proper)
            print("Unexpected response during login")
          }
        });
    }
    
    private func onServerResponse(login: String, hash: String, failed: Bool) {
        DispatchQueue.main.async {
            if (failed) {
                return;
            } else {
            }
            self.defaults.set(login, forKey: Constraints.loginKey);
            self.defaults.set(hash, forKey: Constraints.passwordKey);
            self.oldLoginField.text = ""
            self.newLoginField.text = ""
            self.passwordField.text = ""
            
            self.present(self.loginOkAlert, animated: true, completion: nil);
            
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // Resigns first responder status, dismissing keyboard
    }
    
}
