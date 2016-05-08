//
//  CollectionListViewController.swift
//  342Ass2
//
//  Created by Peter Mavridis on 8/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit

class CollectionListViewController: UITableViewController {
    
    let sbm = ScrapbookModel()
    
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        collections = sbm.returnCollections()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return collections.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath)
        
        if indexPath.section == 0{
            cell.textLabel?.text = "All Clippings"
        } else {
            let row = indexPath.row
            let collection = collections[row]
            
            cell.textLabel?.text = collection.name
        }
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Collections"
        }
        return nil
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            sbm.deleteCollection(collections[indexPath.row])
            collections.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToClippingListView" {
            let indexPath = tableView.indexPathForSelectedRow
            if indexPath!.section != 0 {
                let vc = segue.destinationViewController as! ClippingListViewController
                vc.collection = collections[(indexPath?.row)!]
            }
        }
    }
    
    @IBAction func createCollectionClicked(sender: AnyObject) {
        var inputText = "New Collection"
        let alert = UIAlertController(title: "Create a new Collection", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter Collection name"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let textField = alert.textFields?.first?.text {
                if textField.characters.count > 0 {
                    inputText = textField
                }
            }
            
            let collection = self.sbm.AddCollection(inputText)
            self.collections.append(collection)
            self.tableView.reloadData()
        }))
        
        alert.view.setNeedsLayout()
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
