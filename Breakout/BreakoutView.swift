//
//  BreakoutView.swift
//  Breakout
//
//  Created by Jack Wright on 11/19/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class BreakoutView: NamedBezierPathsView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
	
	fileprivate lazy var animator: UIDynamicAnimator = {
		let animator = UIDynamicAnimator(referenceView: self)
		animator.delegate = self

//		// create a behavior with an action to detect when any ball is off the screen
//		let behavior = UIDynamicBehavior()
//		behavior.action = {
//			// check to see if any ball is off the screen
//			for ball in self.balls {
//				if !self.frame.intersects(ball.frame) {
//					// this ball is out of bounds
//					self.gameOver(didWin: false)
//				}
//			}
//		}
//		animator.addBehavior(behavior)

		return animator
	}()
	
	// MARK: - Game Control
	
	func startNewGame()
	{
		addBricks()
		
		addPaddle()
		
		addBalls()
		
		animating = true
	}
	
	func stopGame()
	{
		animating = false
		
		removeBricks()
		
		removePaddle()
		
		removeBalls()
	}
	
	fileprivate func gameOver(didWin: Bool)
	{
		animating = false
//		if let myWindow = window {
//			if let myVC = myWindow.rootViewController as? BreakoutViewController {
//				myVC.startStopButton.title = "Start"
//			}
//		}
	}
	
	// Interface for setting game parameters
	
	func setGravityMagnitude(_ mag: CGFloat)
	{
		ballBehavior.gravity.magnitude = mag
	}
	
	func setBallBounciness(_ bounce: CGFloat)
	{
		ballBehavior.itemBehavior.elasticity = bounce
	}
	
	var animating: Bool = false {
		didSet {
			if animating {
				animator.addBehavior(ballBehavior)
			} else {
				animator.removeBehavior(ballBehavior)
			}
		}
	}
	
	// MARK: - CollisionBehaviorDelegate
	
	func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
		if let boundaryId = identifier as? String {
			
			if boundaryId == PathNames.floorBarrier {
				gameOver(didWin: false)
			}
			
			else if boundaryId != PathNames.gameBarrier && boundaryId != PathNames.paddleBarrier {
				// must be a brick, remove its barrier
				ballBehavior.removeBarrier(named: boundaryId)
				
				// remove its view
				if let index = Int(boundaryId) {
					bricks[index]?.removeFromSuperview()
					
					// remove the brick from the bricks dictionary
					bricks[index] = nil
					
					if bricks.count <= 0 {
						gameOver(didWin: true)
					}
				}
			}
		}
	}
	
	func pushBalls(_ recognizor: UITapGestureRecognizer) {
		if recognizor.state == .ended {
			for ball in balls {
				let speed = CGFloat(300)
				let x = (CGFloat.random(2) - 0.5) * speed
				let y = (CGFloat.random(2) - 0.5) * speed
				ballBehavior.itemBehavior.addLinearVelocity(CGPoint(x: 0, y: 0), for: ball)
				ballBehavior.itemBehavior.addLinearVelocity(CGPoint(x: x, y: y), for: ball)
			}
		}
	}
	
	// MARK: - Game Collision Boundaries
	
	fileprivate func addGameBoundaries()
	{
		// the game play boundaries...
		
		let thick: CGFloat = 10
		let gamePath = UIBezierPath()
		gamePath.lineWidth = 4.0
		gamePath.move(to: CGPoint(x: 0, y: bounds.height))
		gamePath.addLine(to: CGPoint.zero)
		gamePath.addLine(to: CGPoint(x: bounds.width, y: 0))
		gamePath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
		
		gamePath.addLine(to: CGPoint(x: bounds.width + thick, y: bounds.height))
		gamePath.addLine(to: CGPoint(x: bounds.width + thick, y: -thick))
		gamePath.addLine(to: CGPoint(x: -thick, y: -thick))
		gamePath.addLine(to: CGPoint(x: -thick, y: bounds.height))
		
		ballBehavior.addBarrier(gamePath, named: PathNames.gameBarrier)
		bezierPaths[PathNames.gameBarrier] = gamePath
		
		// The floor boundary...
		let floorPath = UIBezierPath(rect: CGRect(x: 0, y: bounds.height, width: bounds.width, height: 10))
		ballBehavior.addBarrier(floorPath, named: PathNames.floorBarrier)
		bezierPaths[PathNames.floorBarrier] = floorPath
	}
	
	fileprivate struct PathNames {
		static let gameBarrier = "Game Barrier"
		static let paddleBarrier = "Paddle Barrier"
		static let floorBarrier = "Floor Barrier"
	}
	
	// MARK: - UIView delegate

	override func layoutSubviews() {
		super.layoutSubviews()
		
		addGameBoundaries()
	}
	
	// MARK: - The Balls
	
	fileprivate lazy var ballBehavior: BallBehavior = {
		let behavior = BallBehavior()
		behavior.collider.collisionDelegate = self
		return behavior
		
	}()
	
	fileprivate var balls = [UIView]()
	
	fileprivate var ballSize: CGSize {
		return CGSize(width: brickSize.height, height: brickSize.height)
	}
	
	fileprivate func addBalls()
	{
		var frame = CGRect(origin: CGPoint.zero, size: ballSize)
		
		// put the balls vertically between the bottom of the bricks and the paddle
		let bottomOfBricks = brickSize.height * CGFloat(Settings.sharedInstance.numberOfRows) + brickSize.height
		frame.origin.y = bottomOfBricks + brickSize.height
		
		// place each ball in a random location within a separate horizontal span
		let numBalls = Settings.sharedInstance.numberOfBalls
		let spanWidth = Int(bounds.width / CGFloat(numBalls))
		for b in 0..<numBalls {
			frame.origin.x = CGFloat(b * spanWidth) + CGFloat.random(spanWidth - (Int)(ballSize.width))
			
			let ball = UIView(frame: frame)
			ball.layer.cornerRadius = brickSize.width / 4	// make it a circle
			ball.backgroundColor = UIColor.yellow
			
			balls.append(ball)
			addSubview(ball)
			
			ballBehavior.addItem(ball)

			// give the ball an initial velocity towards the bottom of the screen
			let speed: CGFloat = 300	// points/second
			let x = speed * (CGFloat.random(Int(bounds.width)) / bounds.width)
			let y = speed
			ballBehavior.itemBehavior.addLinearVelocity(CGPoint(x: x, y: y), for: ball)
		}
	}
	
	fileprivate func removeBalls()
	{
		for b in balls {
			b.removeFromSuperview()
			ballBehavior.removeItem(b)
		}
		balls.removeAll()
	}
	
	// MARK: - The Paddle
	
	fileprivate var paddleSize: CGSize {
		return CGSize(width: brickSize.width * 1.5, height: brickSize.height/2)
	}
	
	fileprivate lazy var paddle: UIView = {
		var frame = CGRect(origin: CGPoint.zero, size: self.paddleSize)
		frame.origin.x = self.bounds.width / 2 - self.paddleSize.width / 2
		frame.origin.y = self.bounds.height - self.paddleSize.height * 2
		
		let paddle = UIView(frame: frame)
		paddle.backgroundColor = UIColor.white
		
		return paddle
	}()
	
	fileprivate func addPaddleBarrier()
	{
		// create a collision boundary for the paddle with its current frame
		let path = UIBezierPath(rect: paddle.frame)
		ballBehavior.addBarrier(path, named: PathNames.paddleBarrier)
	}
	
	fileprivate func addPaddle()
	{
		addPaddleBarrier()
		
		addSubview(paddle)
	}
	
	fileprivate func removePaddle()
	{
		paddle.removeFromSuperview()
	}
	
	// Pan gesture handler to move the paddle
	func movePaddle(_ recognizor: UIPanGestureRecognizer) {
		let translation = recognizor.translation(in: self)
		switch recognizor.state {
		case .changed:
			paddle.frame.origin.x += translation.x
			
			// re-add the collision barrier
			addPaddleBarrier()
			
			// zero the translation so it doesn't accumulate
			recognizor.setTranslation(CGPoint.zero, in: self)
		default:
			break
		}
	}
	
	// MARK: - The Bricks
	
	fileprivate var bricks = [Int:UIView]()
	
	fileprivate var brickSize: CGSize {
		let width = bounds.size.width / CGFloat(BricksConstants.bricksPerRow) - CGFloat(BricksConstants.margin) * 2
		return CGSize(width: width, height: width / 2)
	}
	
	fileprivate func addBricks()
	{
		let margin = CGFloat(BricksConstants.margin)
		var frame = CGRect(origin: CGPoint.zero, size: brickSize)
		var brickIndex = 0
		for r in 0..<Settings.sharedInstance.numberOfRows {
			frame.origin.y = CGFloat(r) * (brickSize.height + margin * 2) + margin
			for b in 0..<BricksConstants.bricksPerRow {
				frame.origin.x = CGFloat(b) * (brickSize.width + margin * 2) + margin

				let brick = UIView(frame: frame)
				brick.backgroundColor = UIColor.random
				
				bricks[brickIndex] = brick
				
				addSubview(brick)

				// add a collision barrier with the brick index as the name
				ballBehavior.addBarrier(UIBezierPath(rect: frame), named: "\(brickIndex)")
				
				brickIndex += 1
			}
		}
	}
	
	fileprivate func removeBricks()
	{
		var b = 0
		for brick in bricks {
			
			// remove the collision barrier for this brick
			ballBehavior.removeBarrier(named: "\(brick.key)")
			
			if let brickView = bricks[b] as UIView? {
				brickView.removeFromSuperview()
			}
			

			b += 1
		}
		print("Subviews = \(self.subviews)")
		bricks.removeAll()
	}
	
}
