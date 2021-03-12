//
//  ViewController.swift
//  RepositionMiniGame
//
//  Created by User on 3/12/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    func objectTapped() {
        guard isGameActive else {
            return
        }
        repositionImageWithTimer()
        score += 1
    }
    
    private var score = 0
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 0
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 1
    
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
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
    }
    private func stopGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Last score: \(score)"
    }
    
    private func repositionImageWithTimer(){
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
        gameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        if isGameActive {
            timeLabel.text = "Time left: \(Int(gameTimeLeft)) sec"
            actionButton.setTitle("Stop", for: .normal)
        } else {
            timeLabel.text = "Time: \(Int(stepper.value)) sec"
            actionButton.setTitle("Start", for: .normal)
        }
    }
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        if gameTimeLeft <= 0 {
            stopGame()
        } else {
           updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.backgroundColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        updateUI()
        gameFieldView.shapeHitHandler = { [weak self] in
                    self?.objectTapped()
                }
    }
}
