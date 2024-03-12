//
//  SettingsViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 12.03.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let infoView: AppInfoViewController = AppInfoViewController()
    
    private let changeLoginButton: UIButton = UIButton()
    private let changePasswordButton: UIButton = UIButton()
    private let logoutButton: UIButton = UIButton()
    private let showInformationButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.dark
        
        configureUI()
    }

    private func configureUI() {
        // info button
        view.addSubview(showInformationButton)
        showInformationButton.translatesAutoresizingMaskIntoConstraints = false
        showInformationButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 30)
        showInformationButton.pinLeft(to: view, 60)
        showInformationButton.pinRight(to: view, 60)
        showInformationButton.setTitle("   See information about app   ", for: .normal)
        showInformationButton.backgroundColor = UIColor(white: 0.55, alpha: 1)
        showInformationButton.setTitleColor(Colors.dark, for: .normal)
        showInformationButton.layer.cornerRadius = 15
        showInformationButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        showInformationButton.addTarget(self, action: #selector(showInformationButtonPressed), for: .touchUpInside)
        
        //logout button
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.pinTop(to: view.centerYAnchor, 140)
        logoutButton.pinCenterX(to: view)
        logoutButton.setTitle("    Log Out    ", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        
        //change password
        view.addSubview(changePasswordButton)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        changePasswordButton.pinBottom(to: view.centerYAnchor, 40)
        changePasswordButton.pinCenterX(to: view)
        changePasswordButton.setTitle("   Change your password   ", for: .normal)
        changePasswordButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
        changePasswordButton.setTitleColor(Colors.dark, for: .normal)
        changePasswordButton.layer.cornerRadius = 10
        changePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
        
        //change login
        view.addSubview(changeLoginButton)
        changeLoginButton.translatesAutoresizingMaskIntoConstraints = false
        changeLoginButton.pinBottom(to: changePasswordButton.topAnchor, 20)
        changeLoginButton.pinCenterX(to: view)
        changeLoginButton.pinWidth(to: changePasswordButton)
        changeLoginButton.setTitle("   Change your login   ", for: .normal)
        changeLoginButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
        changeLoginButton.setTitleColor(Colors.dark, for: .normal)
        changeLoginButton.layer.cornerRadius = 10
        changeLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        changeLoginButton.addTarget(self, action: #selector(changeLoginButtonPressed), for: .touchUpInside)
        
    }
    
    @objc
    private func showInformationButtonPressed() {
        navigationController?.pushViewController(infoView, animated: true)
    }
    
    @objc
    private func logoutButtonPressed() {
        // call logout in TabController
        NotificationCenter.default.post(name: TabController.functionCallNotification, object: ["data": ""])
    }
    
    @objc
    private func changeLoginButtonPressed() {
        navigationController?.pushViewController(ChangeLoginViewController(), animated: true)
    }
    
    @objc 
    func changePasswordButtonPressed() {
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
}
