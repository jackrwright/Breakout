//
//  Settings.swift
//  Breakout
//
//  Created by Jack Wright on 11/20/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

struct BricksConstants {
	static let bricksPerRow = 6
	static let minRows = 1
	static let maxRows = 6
	static let initialRows = 4
	static let margin = 2
}

class Settings: NSObject {
	
	// MARK: - Public API
	
	class var sharedInstance: Settings {
		struct Singleton {
			static let instance = Settings()
		}
		return Singleton.instance
	}
	
	var numberOfBalls: Int {
		get {
			if let savedNumberOfBalls = UserDefaults.standard.object(forKey: DefaultKeys.numberOfBalls) as? Int {
				_numberOfBalls = savedNumberOfBalls
			}
			return _numberOfBalls
		}
		set {
			_numberOfBalls = newValue
			UserDefaults.standard.set(_numberOfBalls, forKey: DefaultKeys.numberOfBalls)
		}
	}
	var numberOfRows: Int {
		get {
			if let savedNumberOfRows = UserDefaults.standard.object(forKey: DefaultKeys.numberOfRows) as? Int {
				_numberOfRows = savedNumberOfRows
			}
			return _numberOfRows
		}
		set {
			_numberOfRows = newValue
			UserDefaults.standard.set(_numberOfRows, forKey: DefaultKeys.numberOfRows)
		}
	}
	
	var numberOfBricks: Int {return _numberOfRows * BricksConstants.bricksPerRow}
	
	var ballBounciness: Double {
		get {
			if let savedBallBounciness = UserDefaults.standard.object(forKey: DefaultKeys.ballBounciness) as? Double {
				_ballBounciness = savedBallBounciness
			}
			return _ballBounciness
		}
		set {
			_ballBounciness = newValue
			UserDefaults.standard.set(_ballBounciness, forKey: DefaultKeys.ballBounciness)
		}
	}
	
	var gravityIsOn: Bool {
		get {
			if let savedGravityIsOn = UserDefaults.standard.object(forKey: DefaultKeys.gravityIsOn) as? Bool {
				_gravityIsOn = savedGravityIsOn
			}
			return _gravityIsOn
		}
		set {
			_gravityIsOn = newValue
			UserDefaults.standard.set(_gravityIsOn, forKey: DefaultKeys.gravityIsOn)
		}
	}
	
	var gravity: Double {
		get {
			if let savedGravity = UserDefaults.standard.object(forKey: DefaultKeys.gravity) as? Double {
				_gravity = savedGravity
			}
			return _gravity
		}
		set {
			_gravity = newValue
			UserDefaults.standard.set(_gravity, forKey: DefaultKeys.gravity)
		}
	}
	
	// MARK: - Private Implementation
	
	fileprivate struct DefaultKeys {
		static let numberOfRows = "numberOfRows"
		static let numberOfBalls = "numberOfBalls"
		static let ballBounciness = "ballBounciness"
		static let gravityIsOn = "gravityIsOn"
		static let gravity = "gravity"
	}
	
	fileprivate var _numberOfBalls = Defaults.numBalls
	fileprivate var _numberOfRows = Defaults.numRows
	fileprivate var _ballBounciness = Defaults.ballBounciness
	fileprivate var _gravityIsOn = Defaults.gravityIsOn
	fileprivate var _gravity = Defaults.gravity

//	enum BallsCount: Int {
//		case one = 1, two, three
//	}
	
	fileprivate struct Defaults {
		static let numRows = BricksConstants.initialRows
		static let numBalls = 1
		static let ballBounciness = 0.5
		static let gravityIsOn  = false
		static let gravity = 1.0
	}
	
}
