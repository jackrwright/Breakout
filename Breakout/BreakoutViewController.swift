//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Jack Wright on 11/19/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController
{
	@IBOutlet var gameView: BreakoutView! {
		didSet {
			gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(BreakoutView.movePaddle(_:))))
			
			gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: #selector(BreakoutView.pushBalls(_:))))
		}
	}
	
	@IBAction func startStopButtonPressed(_ sender: UIBarButtonItem) {
		gameInProgress = !gameInProgress
	}
	
	@IBOutlet weak var startStopButton: UIBarButtonItem!

	
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
	
	fileprivate func newGameAlert()
	{
		let alertController = UIAlertController(title: "Start a New Game", message: nil, preferredStyle: UIAlertControllerStyle.alert)
		
		
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
			// start a new game
			self.startNewGame()
		}
		
		alertController.addAction(okAction)
		
		present(alertController, animated: true, completion: nil)
		
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
