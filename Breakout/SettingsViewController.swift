//
//  SettingsViewController.swift
//  Breakout
//
//  Created by Jack Wright on 11/19/16.
//  Copyright © 2016 Jack Wright. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController
{
	
	fileprivate let settings = Settings.sharedInstance
	
	@IBOutlet fileprivate weak var bricksCountStepper: UIStepper! {
		didSet {
			bricksCountStepper.minimumValue = Double(BricksConstants.minRows * BricksConstants.bricksPerRow)
			bricksCountStepper.maximumValue = Double(BricksConstants.maxRows * BricksConstants.bricksPerRow)
			bricksCountStepper.stepValue = Double(BricksConstants.bricksPerRow)
			bricksCountStepper.value = Double(settings.numberOfRows * BricksConstants.bricksPerRow)
		}
	}
	
	@IBAction private func bricksCountChanged(_ sender: UIStepper) {
		settings.numberOfRows = (Int)(sender.value) / BricksConstants.bricksPerRow
		bricksCountLabel.text = "\(settings.numberOfRows * BricksConstants.bricksPerRow)"
	}
	
	@IBOutlet private weak var bricksCountLabel: UILabel! {
		didSet {
			bricksCountLabel.text = "\(settings.numberOfRows * BricksConstants.bricksPerRow)"
		}
	}
	
	@IBOutlet private weak var numberOfBallsSegment: UISegmentedControl! {
		didSet {
			numberOfBallsSegment.selectedSegmentIndex = settings.numberOfBalls - 1	// zero-based index
		}
	}
	
	@IBAction private func numberOfBallsChanged(_ sender: UISegmentedControl) {
		settings.numberOfBalls = sender.selectedSegmentIndex + 1
	}
	
	
	@IBOutlet private weak var ballBounceSlider: UISlider! {
		didSet {
			ballBounceSlider.value = Float(settings.ballBounciness)
		}
	}
	@IBAction fileprivate func ballBounceSliderChanged(_ sender: UISlider) {
		settings.ballBounciness = Double(sender.value)
	}
	
	
	@IBOutlet private weak var gravityOnSwitch: UISwitch! {
		didSet {
			gravityOnSwitch.isOn = settings.gravityIsOn
		}
	}
	@IBAction func gravitySwitchChanged(_ sender: UISwitch) {
		settings.gravityIsOn = sender.isOn
	}
	
	@IBOutlet private weak var gravitySlider: UISlider! {
		didSet {
			gravitySlider.value = Float(settings.gravity)
		}
	}
	@IBAction func gravitySliderChanged(_ sender: UISlider) {
		settings.gravity = Double(sender.value)
	}
}
