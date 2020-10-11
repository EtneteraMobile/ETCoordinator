//
//  DetailViewController.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import LifetimeTracker
import UIKit

class DetailViewController: UIViewController, LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "DetailViewController")
    }

    var onCloseAction: (() -> Void)?
    var onPushAction: (() -> Void)?
    var onPushNewCoordAction: (() -> Void)?

    private let closeButton = UIButton()
    private let pushButton = UIButton()
    private let pushCoordButton = UIButton()

    private var detailName: String {
        return Utils.randomString(length: 8)
    }

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

        title = "Detail " + detailName

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.darkText, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(pushButton)
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.setTitle("Push", for: .normal)
        pushButton.setTitleColor(.darkText, for: .normal)
        pushButton.addTarget(self, action: #selector(pushDetail), for: .touchUpInside)

        view.addSubview(pushCoordButton)
        pushCoordButton.translatesAutoresizingMaskIntoConstraints = false
        pushCoordButton.setTitle("Push coord", for: .normal)
        pushCoordButton.setTitleColor(.darkText, for: .normal)
        pushCoordButton.addTarget(self, action: #selector(pushCoord), for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            pushButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            pushButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            pushButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            pushButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            pushCoordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            pushCoordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            pushCoordButton.topAnchor.constraint(equalTo: pushButton.bottomAnchor, constant: 10),
            pushCoordButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc
    func close() {
        print("DETAILVC: Closing")
        onCloseAction?()
    }

    @objc
    func pushDetail() {
        print("DETAILVC: Pushing")
        onPushAction?()
    }

    @objc
    func pushCoord() {
        print("DETAILVC: Pushing new")
        onPushNewCoordAction?()
    }
}
