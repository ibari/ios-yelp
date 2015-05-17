//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Ian on 5/15/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters selectedFilters: [String:AnyObject])
}

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var filters = SearchFilters()
  var dealStates = [Int:Bool]()
  var categoryStates = [Int:Bool]()
  var selectedRadius: Int?
  var selectedSort: Int?
  weak var delegate: FiltersViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onCancelButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onSearchButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    
    var selectedFilters = [String: AnyObject]()
    var selectedCategories = [String]()

    // set category selections
    for (row, isSelected) in categoryStates {
      if isSelected {
        selectedCategories.append(filters.categories[row]["code"]!)
      }
    }
    
    if selectedCategories.count > 0 {
      selectedFilters["categories"] = selectedCategories
    }
    
    // set deal selection
    selectedFilters["deal"] = dealStates[0] ?? nil
    
    // set radius selection
    selectedFilters["radius"] = selectedRadius
    
    if let radiusIndex = selectedRadius {
      selectedFilters["radius"] = filters.radiuses[radiusIndex as Int]["value"]!
    }

    // set sort selection
    selectedFilters["sort"] = selectedSort
  
    delegate?.filtersViewController?(self, didUpdateFilters: selectedFilters)
  }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return filters.sections.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return filters.sections[section]["title"]!
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var rows: Int
    
    if section == 0 {
      rows = filters.deals.count
    } else if section == 1 {
      rows = filters.radiuses.count
    } else if section == 2 {
      rows = filters.sorts.count
    } else if section == 3 {
      rows = filters.categories.count
    } else {
      rows = 0
    }
  
    return rows
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cellIdentifier = filters.sections[indexPath.section]["name"]!
    
    if indexPath.section == 0 {
      let dealCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

      dealCell.switchLabel.text = filters.deals[0]["name"]
      dealCell.delegate = self
      dealCell.onSwitch.on = dealStates[indexPath.row] ?? false
      dealCell.switchIdentifier = cellIdentifier
      
      return dealCell
    } else if indexPath.section == 1 {
      let radiusCell = tableView.dequeueReusableCellWithIdentifier("CheckMarkCell", forIndexPath: indexPath) as! CheckMarkCell
      
      radiusCell.descriptionLabel.text = filters.radiuses[indexPath.row]["name"] as? String
      radiusCell.delegate = self
      radiusCell.checkIdentifier = cellIdentifier

      return radiusCell
    } else if indexPath.section == 2 {
      let sortCell = tableView.dequeueReusableCellWithIdentifier("CheckMarkCell", forIndexPath: indexPath) as! CheckMarkCell
      
      sortCell.descriptionLabel.text = filters.sorts[indexPath.row]["name"] as? String
      sortCell.delegate = self
      sortCell.checkIdentifier = cellIdentifier
      
      return sortCell
    } else if indexPath.section == 3 {
      let categoryCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      
      categoryCell.switchLabel.text = filters.categories[indexPath.row]["name"]
      categoryCell.delegate = self
      categoryCell.onSwitch.on = categoryStates[indexPath.row] ?? false
      categoryCell.switchIdentifier = cellIdentifier
      
      return categoryCell
    }
    
    return tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension FiltersViewController: SwitchCellDelegate {
  func switchCell(switchCell: SwitchCell, toggleIdenfifier: AnyObject, didChangeValue value: Bool) {
    let indexPath = tableView.indexPathForCell(switchCell)
  
    if let identifier = toggleIdenfifier as? String {
      if identifier == "deal" {
        dealStates[indexPath!.row] = value
      } else if identifier == "category" {
        categoryStates[indexPath!.row] = value
      }
    }
  }
}

extension FiltersViewController: CheckMarkCellDelegate {
  func checkMarkCell(checkMarkCell: CheckMarkCell, toggleIdenfifier: AnyObject, didChangeValue value: Bool) {
    let indexPath = tableView.indexPathForCell(checkMarkCell)
    
    if let identifier = toggleIdenfifier as? String {
      if value == true {
        if identifier == "radius" {
          selectedRadius = indexPath!.row
        } else if identifier == "sort" {
          selectedSort = indexPath!.row
        }
      }
    }
  }
}

