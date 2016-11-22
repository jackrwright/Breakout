//
//  BallBehavior.swift
//  Breakout
//
//  Created by Jack Wright on 11/20/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior
{
	let gravity = UIGravityBehavior()
	
	fileprivate let itemBehavior: UIDynamicItemBehavior = {
		let dib = UIDynamicItemBehavior()
		dib.allowsRotation = true
		dib.elasticity = CGFloat(Settings.sharedInstance.ballBounciness)
		return dib
	}()
	

}
