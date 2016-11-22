//
//  BreakoutView.swift
//  Breakout
//
//  Created by Jack Wright on 11/19/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class BreakoutView: UIView {
	
	// MARK: - Game Control
	
	func startNewGame()
	{
		addBricks()
		
		addPaddle()
		
		addBalls()
	}
	
	func stopGame()
	{
		removeBricks()
		
		removePaddle()
		
		removeBalls()
	}
	
	var animating: Bool = false {
		didSet {
			
		}
	}
	
	// MARK: - The Balls
	
	fileprivate var balls = [UIView]()
	
	fileprivate var ballSize: CGSize {
		return CGSize(width: brickSize.height, height: brickSize.height)
	}
	
	fileprivate func addBalls()
	{
		var frame = CGRect(origin: CGPoint.zero, size: ballSize)
		
		// put the balls vertically between the bottom of the bricks and the paddle
		let bottomOfBricks = brickSize.height * CGFloat(Settings.sharedInstance.numberOfRows) + brickSize.height
		frame.origin.y = paddle.frame.origin.y - bottomOfBricks - ballSize.height/2
		
		// place each ball in a random location within a separate horizontal span
		let numBalls = Settings.sharedInstance.numberOfBalls
		let spanWidth = Int(bounds.width / CGFloat(numBalls))
		for b in 0..<numBalls {
			frame.origin.x = CGFloat(b * spanWidth) + CGFloat.random(spanWidth - (Int)(ballSize.width))
			
			let ball = UIView(frame: frame)
			ball.backgroundColor = UIColor.yellow
			
			balls.append(ball)
			
			addSubview(ball)
		}
	}
	
	fileprivate func removeBalls()
	{
		for b in balls {
			b.removeFromSuperview()
		}
		balls.removeAll()
	}
	
	// MARK: - The Paddle
	
	fileprivate var paddleSize: CGSize {
		return CGSize(width: brickSize.width * 1.5, height: brickSize.height)
	}
	
	fileprivate lazy var paddle: UIView = {
		var frame = CGRect(origin: CGPoint.zero, size: self.paddleSize)
		frame.origin.x = self.bounds.width / 2 - self.paddleSize.width / 2
		frame.origin.y = self.bounds.height - self.paddleSize.height * 2
		
		let paddle = UIView(frame: frame)
		paddle.backgroundColor = UIColor.white
		
		return paddle
	}()
	
	fileprivate func addPaddle()
	{
		addSubview(paddle)
	}
	
	fileprivate func removePaddle()
	{
		paddle.removeFromSuperview()
	}
	
	// MARK: - The Bricks
	
	fileprivate var bricks = [UIView]()
	
	fileprivate var brickSize: CGSize {
		let width = bounds.size.width / CGFloat(BricksConstants.bricksPerRow) - CGFloat(BricksConstants.margin) * 2
		return CGSize(width: width, height: width / 2)
	}
	
	fileprivate func addBrickWithFrame(_ frame:CGRect)
	{
		let brick = UIView(frame: frame)
		brick.backgroundColor = UIColor.random
		
		bricks.append(brick)
		
		addSubview(brick)
	}
	
	fileprivate func addBricks()
	{
		let margin = CGFloat(BricksConstants.margin)
		var frame = CGRect(origin: CGPoint.zero, size: brickSize)
		for r in 0..<Settings.sharedInstance.numberOfRows {
			frame.origin.y = CGFloat(r) * (brickSize.height + margin * 2) + margin
			for b in 0..<BricksConstants.bricksPerRow {
				frame.origin.x = CGFloat(b) * (brickSize.width + margin * 2) + margin
				addBrickWithFrame(frame)
			}
		}
	}
	
	fileprivate func removeBricks()
	{
		for brick in bricks {
			brick.removeFromSuperview()
		}
		bricks.removeAll()
	}
	
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
