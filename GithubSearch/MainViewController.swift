//
//  MainViewController.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/6/10.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(navigateToVC))
    }

    @objc func navigateToVC() {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
