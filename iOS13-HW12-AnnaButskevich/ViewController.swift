//
//  ViewController.swift
//  iOS13-HW12-AnnaButskevich
//
//  Created by Анна Буцкевич on 18.06.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    // MARK: - UI

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        [].forEach {view.addSubview($0)}
    }

    private func setupLayout() {
        
    }

    // MARK: - Action
}

