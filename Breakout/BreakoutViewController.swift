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
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	fileprivate var gameInProgress: Bool = false {
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
	

	@IBOutlet var gameView: BreakoutView! {
		didSet {
			
		}
	}
	
	@IBAction func startStopButtonPressed(_ sender: UIBarButtonItem) {
		gameInProgress = !gameInProgress
	}
	
	@IBOutlet weak var startStopButton: UIBarButtonItem!
}
