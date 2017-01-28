//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

/// This class will draw all bezier paths added to its **bezierPaths** array. Handy for debugging paths.
class NamedBezierPathsView: UIView
{
    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
//		UIColor.white.setStroke()
		UIColor.white.setFill()
        for (_, path) in bezierPaths {
//            path.stroke()
			path.fill()
        }
    }
}
