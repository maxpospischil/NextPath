//
//  SettingsViewController.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/25/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var fromNJCell: UITableViewCell!
    @IBOutlet weak var fromNYCell: UITableViewCell!
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        fromNJCell.detailTextLabel!.text = defaults.stringForKey("fromNJDefault")
        fromNYCell.detailTextLabel!.text = defaults.stringForKey("fromNYDefault")
    }

    
}
