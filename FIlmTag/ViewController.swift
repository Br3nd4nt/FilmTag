//
//  ViewController.swift
//  FIlmTag
//
//  Created by br3nd4nt on 07.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var tmp = UIButton();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var tmp = UILabel();
//        view.addSubview(tmp)
//        tmp.text = "CUM";
//        tmp.textColor = .white;
//        tmp.pinCenter(to: view);

        tmp.setTitle("CUM", for: .normal)
        
        tmp.backgroundColor = .systemPink;
        tmp.setTitleColor(.cyan, for: .normal)
        tmp.addTarget(self, action: #selector(tmpFunc), for: .touchUpInside)
        
        view.addSubview(tmp);
        tmp.pinCenter(to: view);
        
        
        
        
    }
    
    @objc
    private func tmpFunc() {
        present(LoginViewController(), animated: true);
    }
}

