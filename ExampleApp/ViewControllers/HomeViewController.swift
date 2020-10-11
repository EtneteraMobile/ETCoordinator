//
//  HomeViewController.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import LifetimeTracker
import UIKit

class HomeViewController: UIViewController, LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "HomeViewController")
    }

    var onPushAction: (() -> Void)?
    var onPresentAction: (() -> Void)?

    private let buttonA = UIButton()
    private let buttonB = UIButton()

    init() {
        super.init(nibName: nil, bundle: nil)

        trackLifetime()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(buttonA)
        buttonA.translatesAutoresizingMaskIntoConstraints = false
        buttonA.setTitle("Push something", for: .normal)
        buttonA.setTitleColor(.darkText, for: .normal)
        buttonA.addTarget(self, action: #selector(push), for: .touchUpInside)

        view.addSubview(buttonB)
        buttonB.translatesAutoresizingMaskIntoConstraints = false
        buttonB.setTitle("Present something", for: .normal)
        buttonB.setTitleColor(.darkText, for: .normal)
        buttonB.addTarget(self, action: #selector(presentSomething), for: .touchUpInside)

        NSLayoutConstraint.activate([
            buttonA.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            buttonA.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            buttonA.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonA.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            buttonB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            buttonB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            buttonB.topAnchor.constraint(equalTo: buttonA.bottomAnchor, constant: 10),
            buttonB.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc
    func push() {
        print("HOMEVC: Pushing")
        onPushAction?()
    }

    @objc
    func presentSomething() {
        print("HOMEVC: Presenting")
        onPresentAction?()
    }
}
