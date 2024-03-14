//
//  ChangePasswordViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 12.03.2024.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    private let viewTitle: UILabel = UILabel()
    private let loginTitle: UILabel = UILabel()
    private let loginField: UITextField = UITextField()
    private let oldPasswordTitle: UILabel = UILabel()
    private let oldPasswordField: UITextField = UITextField()
    private let newPasswordLabel: UILabel = UILabel()
    private let newPasswordField: UITextField = UITextField()
    private let changeButton: UIButton = UIButton()
    
    private let loginOkAlert: UIAlertController = UIAlertController(title: "Success!", message: "Your password has been changed!", preferredStyle: .alert)
    private let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        loginOkAlert.addAction(okAction)
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(viewTitle)
        viewTitle.text = "Change Password:"
        viewTitle.font = UIFont.boldSystemFont(ofSize: 40)
        viewTitle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        viewTitle.pinLeft(to: view, 20)
        
        view.addSubview(loginTitle)
        loginTitle.text = "Input your old login: "
        loginTitle.font = UIFont.systemFont(ofSize: 20)
        loginTitle.pinTop(to: viewTitle.bottomAnchor, 40)
        loginTitle.pinLeft(to: view, 20)
        
        view.addSubview(loginField)
        loginField.attributedPlaceholder = NSAttributedString(string: " Input your login here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        loginField.pinTop(to: loginTitle.bottomAnchor, 5)
        loginField.pinLeft(to: view, 20)
        loginField.pinRight(to: view, 20)
        loginField.backgroundColor = Colors.white
        loginField.textColor = Colors.dark
        loginField.layer.cornerRadius = 10
        loginField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(oldPasswordTitle)
        oldPasswordTitle.text = "Input your password: "
        oldPasswordTitle.font = UIFont.systemFont(ofSize: 20)
        oldPasswordTitle.pinTop(to: loginField.bottomAnchor, 40)
        oldPasswordTitle.pinLeft(to: view, 20)
        
        view.addSubview(oldPasswordField)
        oldPasswordField.attributedPlaceholder = NSAttributedString(string: " Input your new login here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        oldPasswordField.pinTop(to: oldPasswordTitle.bottomAnchor, 5)
        oldPasswordField.pinLeft(to: view, 20)
        oldPasswordField.pinRight(to: view, 20)
        oldPasswordField.backgroundColor = Colors.white
        oldPasswordField.textColor = Colors.dark
        oldPasswordField.layer.cornerRadius = 10
        oldPasswordField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(newPasswordLabel)
        newPasswordLabel.text = "Input your new password: "
        newPasswordLabel.font = UIFont.systemFont(ofSize: 20)
        newPasswordLabel.pinTop(to: oldPasswordField.bottomAnchor, 40)
        newPasswordLabel.pinLeft(to: view, 20)
        
        view.addSubview(newPasswordField)
        newPasswordField.attributedPlaceholder = NSAttributedString(string: " Input your new password here...", attributes: [NSAttributedString.Key.foregroundColor: Colors.placeholderColor])
        newPasswordField.pinTop(to: newPasswordLabel.bottomAnchor, 5)
        newPasswordField.pinLeft(to: view, 20)
        newPasswordField.pinRight(to: view, 20)
        newPasswordField.backgroundColor = Colors.white
        newPasswordField.textColor = Colors.dark
        newPasswordField.layer.cornerRadius = 10
        newPasswordField.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(changeButton)
        changeButton.pinCenterX(to: view)
        changeButton.pinTop(to: newPasswordField.bottomAnchor, 40)
        changeButton.setTitle("   Change password   ", for: .normal)
        changeButton.backgroundColor = Colors.blue
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func changeButtonPressed() {
        let login = loginField.text ?? ""
        let oldPassword = oldPasswordField.text ?? ""
        let newPassword = newPasswordField.text ?? ""
        
        if (login.isEmpty) {
            loginField.backgroundColor = Colors.red
            oldPasswordField.backgroundColor = Colors.white
            newPasswordField.backgroundColor = Colors.white
            return
        }
        
        if (oldPassword.isEmpty) {
            loginField.backgroundColor = Colors.white
            oldPasswordField.backgroundColor = Colors.red
            newPasswordField.backgroundColor = Colors.white
            return
        }
        
        if (newPassword.isEmpty) {
            loginField.backgroundColor = Colors.white
            oldPasswordField.backgroundColor = Colors.white
            newPasswordField.backgroundColor = Colors.red
            return
        }
        
        Auth.changePassword(login: login, oldPassword: oldPassword, newPassword: newPassword, completion: { response, error in
          if let error = error {
            print("Error during changing login: \(error.localizedDescription)")
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
                return
            } else {
            }
            self.defaults.set(login, forKey: Constraints.loginKey)
            self.defaults.set(hash, forKey: Constraints.passwordKey)
            self.loginField.text = ""
            self.oldPasswordField.text = ""
            self.newPasswordField.text = ""
            
            self.present(self.loginOkAlert, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
