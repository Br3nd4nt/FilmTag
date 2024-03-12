//
//  ChangeLoginViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 12.03.2024.
//

import UIKit

class ChangeLoginViewController: UIViewController {
    
    private let viewTitle: UILabel = UILabel()
    private let oldLoginTitle: UILabel = UILabel()
    private let oldLoginField: UITextField = UITextField()
    private let newLoginTitle: UILabel = UILabel()
    private let newLoginField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordField: UILabel = UILabel()
    private let changeButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func configureUI() {
        view.addSubview(viewTitle)
        viewTitle.text = "Change Login:"
        viewTitle.font = UIFont.boldSystemFont(ofSize: 40)
        
    }
}
