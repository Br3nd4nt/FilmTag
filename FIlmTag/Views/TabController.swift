//
//  TabController.swift
//  FilmTag
//
//  Created by br3nd4nt on 09.03.2024.
//

import UIKit

class TabController : UITabBarController {
    private let defaults = UserDefaults.standard
    private let loginVC = LoginViewController()
    static let functionCallNotification = Notification.Name("UserDidLogout")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFunctionCall), name: TabController.functionCallNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkDefaults()
    }
    
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeViewController())
        let search = self.createNav(with: "Search", and: UIImage(systemName: "magnifyingglass"), vc: SearchViewController())
        let list = self.createNav(with: "My list", and: UIImage(systemName: "list.bullet"), vc: UserListViewController())
        let settings = self.createNav(with: "Settings", and: UIImage(systemName: "gear"), vc: SettingsViewController())
        
        self.setViewControllers([home, search, list, settings], animated: true)
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = Colors.dark
        self.tabBar.tintColor = Colors.white
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
    private func checkDefaults() {
        let login = defaults.string(forKey: Constraints.loginKey)
        let hash = defaults.string(forKey: Constraints.passwordKey)
        if (login == nil || hash == nil || login!.isEmpty || hash!.isEmpty) {
            loginVC.modalPresentationStyle = .overFullScreen
            loginVC.isModalInPresentation = true
            present(loginVC, animated: true, completion: nil)
        } else {
            Auth.loginWithHash(login: login!, passwordHash: hash!, completion: { response, error in
                var failed:Bool = false
                if let error = error {
                    print("Error during login: \(error.localizedDescription)")
                    failed = true
                } else if let response = response {
                    print(response)
                    failed = response.login.isEmpty || response.passwordHash.isEmpty
                    
                } else {
                    failed = true
                    print("Unexpected response during login")
                }
                if (failed) {
                    DispatchQueue.main.async{
                        self.loginVC.modalPresentationStyle = .overFullScreen
                        self.loginVC.isModalInPresentation = true
                        self.present(self.loginVC, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @objc func handleFunctionCall() {
        print("notification accepted")
        defaults.setValue("", forKey: Constraints.loginKey)
        defaults.setValue("", forKey: Constraints.passwordKey)
        self.selectedIndex = 0
        self.checkDefaults()
    }
}
