//
//  ViewController.swift
//  RepositionMiniGame
//
//  Created by User on 3/12/21.
//

import UIKit

final class ViewController: UIViewController {
    private var score = 0
    private let defaultStepperValue = 30.0
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 1
    
    @IBOutlet weak private var gameFieldView: GameFieldView!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var gameControl: GameControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameFieldView.layerAdditionalSetups()
        updateUI()
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
        gameControl.startStopHandler = { [weak self] in
            self?.actionButtonTapped()
        }
        gameControl.gameDuration = defaultStepperValue
    }
    
    func actionButtonTapped() {
        gameControl.isGameActive ? stopGame() : startGame()
    }
    
    func objectTapped() {
        guard gameControl.isGameActive else {
            return
        }
        repositionImageWithTimer()
        score += 1
    }
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true
        )
        gameControl.gameTimeLeft = gameControl.gameDuration
        gameControl.setGameStatus(true)
        updateUI()
    }
    
    private func stopGame() {
        gameControl.setGameStatus(false)
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Last score: \(score)"
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true)
        timer?.fire()
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !gameControl.isGameActive
    }
    
    @objc private func gameTimerTick() {
        gameControl.gameTimeLeft -= 1
        if gameControl.gameTimeLeft <= 0 {
            stopGame()
        } else {
           updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
}
