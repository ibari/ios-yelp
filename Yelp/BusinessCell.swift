//
//  BusinessCell.swift
//  Yelp
//
//  Created by Ian on 5/13/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var reviewsCountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  
  var business: Business! {
    didSet {
      nameLabel.text = business.name
      thumbImageView.setImageWithURL(business.imageURL)
      distanceLabel.text = business.distance
      ratingImageView.setImageWithURL(business.ratingImageURL)
      reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
      addressLabel.text = business.address
      categoriesLabel.text = business.categories
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    thumbImageView.layer.cornerRadius = 5
    thumbImageView.clipsToBounds = true
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
    categoriesLabel.preferredMaxLayoutWidth = categoriesLabel.frame.size.width
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
    categoriesLabel.preferredMaxLayoutWidth = categoriesLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
