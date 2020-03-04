//
//  DetailViewController.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var onCloseAction: (() -> Void)?

    private let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.darkText, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc func close() {
        print("DETAILVC: Closing")
        onCloseAction?()
    }
}
