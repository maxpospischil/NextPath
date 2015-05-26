//
//  DefaultStopFromNYSelectTableViewController.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/25/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import UIKit

class DefaultStopFromNYSelectTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for cell in tableView.visibleCells() as! [UITableViewCell] {
            cell.accessoryType = .None
        }
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell?;
        
        println(currentCell!.textLabel!.text)
        currentCell!.accessoryType = .Checkmark
        currentCell!.setSelected(false, animated: true)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(currentCell!.textLabel!.text, forKey: "fromNYDefault")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for cell in table.visibleCells() as! [UITableViewCell] {
            let defaults = NSUserDefaults.standardUserDefaults()
            if cell.textLabel!.text == defaults.stringForKey("fromNYDefault") {
                cell.accessoryType = .Checkmark
            }
        }
        
    }
    
}