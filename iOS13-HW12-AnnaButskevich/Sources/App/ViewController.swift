//
//  ViewController.swift
//  iOS13-HW12-AnnaButskevich
//
//  Created by Анна Буцкевич on 18.06.24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController, CAAnimationDelegate {

    // MARK: - UI

    var isWorkTime = true
    var isStarted = false
    var timer = Timer()
    var count = 10
    let workTime = 10
    let restTime = 5

    var isAnimationStarted = false

    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

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

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(timerLabel)
        stack.addArrangedSubview(startPauseButton)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.distribution = .fillProportionally
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        drawsShapeLayer()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        [stateLabel, stackView].forEach {view.addSubview($0)}
    }

    private func setupLayout() {

        stateLabel.snp.makeConstraints {make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }

        stackView.snp.makeConstraints {make in
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
        }
    }

    // MARK: - Action

    private func addImage(_ name: String) -> UIImage? {
        let image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: CGFloat(28)))
        return image
    }

    @objc private func buttonPressed() {
        if !isStarted {
            drawsTrackLayer()
            startResumeAnimation()
            isStarted = true
            startPauseButton.setImage(addImage("pause.fill"), for: .normal)
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(timerCounter),
                userInfo: nil,
                repeats: true)
        } else {
            pauseAnimation()
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
            stopAnimation()
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

    private func drawsShapeLayer() {
        shapeLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
            radius: 150,
            startAngle: -90.degreesToRadians,
            endAngle: 270.degreesToRadians,
            clockwise: true).cgPath
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 14
        view.layer.addSublayer(shapeLayer)
    }

    private func drawsTrackLayer() {
        trackLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
            radius: 150,
            startAngle: -90.degreesToRadians,
            endAngle: 270.degreesToRadians,
            clockwise: true
        ).cgPath
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.lineWidth = 10
        view.layer.addSublayer(trackLayer)
    }

    private func startResumeAnimation() {
        !isAnimationStarted ? startAnimation() : resumeAnimation()
    }

    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        trackLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(count)
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = .forwards
        trackLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func pauseAnimation() {
        let pause = trackLayer.convertTime(CACurrentMediaTime(), from: nil)
        trackLayer.speed = 0.0
        trackLayer.timeOffset = pause
    }

    private func resumeAnimation() {
        let pause = trackLayer.timeOffset
        trackLayer.speed = 1.0
        trackLayer.timeOffset = 0.0
        trackLayer.beginTime = 0.0
        let timeSincePaused = trackLayer.convertTime(CACurrentMediaTime(), from: nil) - pause
        trackLayer.beginTime = timeSincePaused
    }

    private func stopAnimation() {
        trackLayer.removeAnimation(forKey: "strokeEnd")
        isAnimationStarted = false
    }

    func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}
