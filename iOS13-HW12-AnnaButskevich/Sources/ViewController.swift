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

    var isWorkTime = true
    var isStarted = false
    var timer = Timer()
    var count = 10
    let workTime = 10
    let restTime = 5

    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.textAlignment = .center
        return label
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:10"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textAlignment = .center
        return label
    }()

    private lazy var startPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(28))
        var icon = UIImage(systemName: "play.fill", withConfiguration: config)
        button.setImage(icon, for: .normal)
        button.tintColor = .gray
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        [stateLabel, timerLabel, startPauseButton].forEach {view.addSubview($0)}
    }

    private func setupLayout() {

        stateLabel.snp.makeConstraints {make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }

        timerLabel.snp.makeConstraints {make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }

        startPauseButton.snp.makeConstraints {make in
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Action

    private func addImage(_ name: String) -> UIImage? {
        let image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: CGFloat(28)))
        return image
    }

    @objc private func buttonPressed() {
        if !isStarted {
            isStarted = true
            startPauseButton.setImage(addImage("pause.fill"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            isStarted = false
            startPauseButton.setImage(addImage("play.fill"), for: .normal)
        }
    }

    @objc private func timerCounter() {
        count -= 1
        timerLabel.text = makeTimeString()

        if count <= 0 {
            timer.invalidate()
            stateLabel.text = isWorkTime ? "Rest" : "Work"
            startPauseButton.setImage(addImage("play.fill"), for: .normal)
            isWorkTime = !isWorkTime
            count = isWorkTime ? workTime : restTime
            isStarted = false
            timerLabel.text = makeTimeString()
        }
    }

    private func makeTimeString() -> String {
        let minutes = Int(count) / 60 % 60
        let seconds = Int(count) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

}

