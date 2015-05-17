//
//  SwitchCell.swift
//  Yelp
//
//  Created by Ian on 5/15/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
  optional func switchCell(switchCell: SwitchCell, toggleIdenfifier: AnyObject, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var onSwitch: UISwitch!
  
  weak var delegate: SwitchCellDelegate?
  var switchIdentifier: String = ""

  override func awakeFromNib() {
    super.awakeFromNib()
    
    onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func switchValueChanged() {
    delegate?.switchCell?(self, toggleIdenfifier: switchIdentifier, didChangeValue: onSwitch.on)
  }
}
