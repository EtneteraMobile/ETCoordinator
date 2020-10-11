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
    var onPresentCoordAction: (() -> Void)?

    private let pushDetailButton = UIButton()
    private let presentDetailButton = UIButton()
    private let presentCustomCoordButton = UIButton()

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

        title = "Home"

        view.addSubview(pushDetailButton)
        pushDetailButton.translatesAutoresizingMaskIntoConstraints = false
        pushDetailButton.setTitle("Push Detail", for: .normal)
        pushDetailButton.setTitleColor(.darkText, for: .normal)
        pushDetailButton.addTarget(self, action: #selector(pushDetail), for: .touchUpInside)

        view.addSubview(presentDetailButton)
        presentDetailButton.translatesAutoresizingMaskIntoConstraints = false
        presentDetailButton.setTitle("Present Detail", for: .normal)
        presentDetailButton.setTitleColor(.darkText, for: .normal)
        presentDetailButton.addTarget(self, action: #selector(presentDetail), for: .touchUpInside)

        view.addSubview(presentCustomCoordButton)
        presentCustomCoordButton.translatesAutoresizingMaskIntoConstraints = false
        presentCustomCoordButton.setTitle("Present Custom Coord", for: .normal)
        presentCustomCoordButton.setTitleColor(.darkText, for: .normal)
        presentCustomCoordButton.addTarget(self, action: #selector(presentCustomCoord), for: .touchUpInside)

        NSLayoutConstraint.activate([
            pushDetailButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            pushDetailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            pushDetailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pushDetailButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            presentDetailButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            presentDetailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            presentDetailButton.topAnchor.constraint(equalTo: pushDetailButton.bottomAnchor, constant: 10),
            presentDetailButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            presentCustomCoordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            presentCustomCoordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            presentCustomCoordButton.topAnchor.constraint(equalTo: presentDetailButton.bottomAnchor, constant: 10),
            presentCustomCoordButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc
    func pushDetail() {
        print("HOMEVC: Pushing")
        onPushAction?()
    }

    @objc
    func presentDetail() {
        print("HOMEVC: Presenting")
        onPresentAction?()
    }

    @objc
    func presentCustomCoord() {
        print("HOMEVC: Presenting Custom Coord")
        onPresentCoordAction?()
    }
}
