//
//  CheckMarkCell.swift
//  Yelp
//
//  Created by Ian on 5/17/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class CheckMarkCell: UITableViewCell {
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var switchIdentifier: AnyObject = ""
  var isChecked: Bool = false {
    didSet {
      if isChecked {
        self.accessoryType = .Checkmark
      } else {
        self.accessoryType = .None
      }
    }
  }
  
  //weak var delegate: ToggleCellDelegate?

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    if selected && !self.selected {
      super.setSelected(true, animated: true)
      isChecked = !isChecked
      //delegate?.toggleCellDidToggle(self, toggleIdenfifier: switchIdentifier, newValue: isChecked)
      super.setSelected(false, animated: true)
    }
  }
}