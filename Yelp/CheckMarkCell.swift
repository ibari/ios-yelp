//
//  CheckMarkCell.swift
//  Yelp
//
//  Created by Ian on 5/17/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

@objc protocol CheckMarkCellDelegate {
  optional func checkMarkCell(checkMarkCell: CheckMarkCell, toggleIdenfifier: AnyObject, didChangeValue value:Bool)
}

class CheckMarkCell: UITableViewCell {
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var checkIdentifier: AnyObject = ""
  var isChecked: Bool = false {
    didSet {
      if isChecked {
        self.accessoryType = .Checkmark
      } else {
        self.accessoryType = .None
      }
    }
  }
  
  weak var delegate: CheckMarkCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    if selected && !self.selected {
      super.setSelected(true, animated: true)
      isChecked = !isChecked
      delegate?.checkMarkCell?(self, toggleIdenfifier: checkIdentifier, didChangeValue: isChecked)
      super.setSelected(false, animated: true)
    }
  }
}