//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Jack Wright on 11/19/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, BreakoutGame
{
	@IBOutlet var gameView: BreakoutView! {
		didSet {
				gameView.delegate = self
			gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(BreakoutView.movePaddle(_:))))
			
			gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: #selector(BreakoutView.pushBalls(_:))))
		}
	}
	
	@IBAction func startStopButtonPressed(_ sender: UIBarButtonItem) {
		gameInProgress = !gameInProgress
	}
	
	@IBOutlet weak var startStopButton: UIBarButtonItem!

	// MARK: - ViewController Delegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if Settings.sharedInstance.gravityIsOn {
			gameView.setGravityMagnitude(CGFloat(Settings.sharedInstance.gravity))
		} else {
			gameView.setGravityMagnitude(0)
		}
		
		gameView.setBallBounciness(CGFloat(Settings.sharedInstance.ballBounciness))
		
		gameView.resumeGame()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		gameView.pauseGame()
	}
	
	func setGravityMagnitude(_ mag: CGFloat)
	{
		gameView.setGravityMagnitude(mag)
	}
	
	// MARK: - Private
	
	var gameInProgress: Bool = false {
		didSet {
			if gameInProgress {
				startStopButton?.title = "Stop"
				startNewGame()
			} else {
				startStopButton?.title = "Start"
				stopGame()
			}
		}
	}
	
	func gameOver(didWin: Bool)
	{
		let title = "Game Over"
		let msg = "You \(didWin ? "WIN" : "LOSE")!"
//		print("\(title) - \(msg)")
		
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		
		let newGameAction = UIAlertAction(title: "New Game", style: .default, handler: { (action) in
			
			self.gameView.stopGame()
			self.gameView.startNewGame()
		})
		
		alert.addAction(newGameAction)
		
		present(alert, animated: true, completion: nil)

	}
	
	fileprivate func startNewGame()
	{
		gameView.startNewGame()
	}
	
	fileprivate func stopGame()
	{
		gameView.stopGame()
	}
	

}
