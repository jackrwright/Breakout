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
	var gravity: UIGravityBehavior = {
		let gb = UIGravityBehavior()
		gb.magnitude = CGFloat(Settings.sharedInstance.gravity)
		return gb
	}()
	
	var itemBehavior: UIDynamicItemBehavior = {
		let dib = UIDynamicItemBehavior()
		dib.allowsRotation = false
		dib.elasticity = CGFloat(Settings.sharedInstance.ballBounciness)
		dib.resistance = 0.0
		dib.angularResistance = 0.0
		dib.friction = 0.0
		return dib
	}()
	
	var collider: UICollisionBehavior = {
		let collider = UICollisionBehavior()
//		collider.translatesReferenceBoundsIntoBoundary = true
		return collider
	}()
	
	func addBarrier(_ path: UIBezierPath, named name: String) {
		collider.removeBoundary(withIdentifier: name as NSCopying)
		collider.addBoundary(withIdentifier: name as NSCopying, for: path)
	}
	
	func removeBarrier(named: String) {
		collider.removeBoundary(withIdentifier: named as NSCopying)
	}
	
	override init() {
		super.init()
		addChildBehavior(gravity)
		addChildBehavior(collider)
		addChildBehavior(itemBehavior)
	}
	
	func addItem(_ item: UIDynamicItem) {
		gravity.addItem(item)
		collider.addItem(item)
		itemBehavior.addItem(item)
	}
	
	func removeItem(_ item: UIDynamicItem) {
		gravity.removeItem(item)
		collider.removeItem(item)
		itemBehavior.removeItem(item)
	}
}
