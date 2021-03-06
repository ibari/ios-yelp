//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var businesses: [Business]!
  var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    // initialize UISearchBar
    searchBar = UISearchBar()
    searchBar.delegate = self
    
    // add search bar to navigation bar
    searchBar.sizeToFit()
    navigationItem.titleView = searchBar
    
    let searchField = searchBar.valueForKey("searchField") as? UITextField
    searchField!.textColor = UIColor.grayColor()
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.tableView.reloadData()
      
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let navigationController = segue.destinationViewController as! UINavigationController
    let filtersViewController = navigationController.topViewController as! FiltersViewController
    
    filtersViewController.delegate = self
  }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
    
    cell.business = businesses[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if businesses != nil {
      return businesses.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension BusinessesViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(false, animated: true)
    return true;
  }
  
  func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
    searchBar.setShowsCancelButton(false, animated: true)
    return true;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    Business.searchWithTerm("Restaurants \(searchBar.text)", completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.tableView.reloadData()
      
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    })
  }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters selectedFilters: [String : AnyObject]) {
    var categories = selectedFilters["categories"] as? [String]
    var deal = selectedFilters["deal"] as? Bool
    var radius: Double?
    var sortMode = YelpSortMode(rawValue: 0)!
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    if let sort = selectedFilters["sort"] as? Int {
      sortMode = YelpSortMode(rawValue: sort)!
    }
    
    if let miles = selectedFilters["radius"] as? Double {
      radius = miles * 1609.34  // convert to meters
    }
    
    Business.searchWithTerm("Restaurants \(searchBar.text)", sort: sortMode, categories: categories, radius: radius, deals: deal, completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.tableView.reloadData()
      
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    })
  }
}
