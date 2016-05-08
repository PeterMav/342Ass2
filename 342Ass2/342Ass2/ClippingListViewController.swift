//
//  ClippingListViewController.swift
//  342Ass2
//
//  Created by Peter Mavridis on 8/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit

class ClippingListViewController: UITableViewController {
    
    var sc:UISearchController!
    
    let documentsFolder: String = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)[0]
    
    let sbm = ScrapbookModel()
    
    var collection:Collection?
    var clippings = [Clipping]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sc = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if collection != nil {
            clippings = (collection?.clips!.allObjects)! as NSArray as! [Clipping]
            self.navigationItem.title = collection!.name
        } else {
            clippings = sbm.returnClippings()
            self.navigationItem.title = "All Clippings"
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clippings.count
    }
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("ClipCell", forIndexPath: indexPath) as! ClippingListViewController
//        
//        let row = indexPath.row
//        let clip = clippings[row]
//        
////        cell.clippingImage.image = UIImage(contentsOfFile: documentsFolder + clipping.image!)
////        cell.clippingNotes.text = clipping.notes
////        
////        let date = NSDateFormatter()
////        date.dateFormat = "YYYY-MM-dd HH:MM"
////        cell.clippingDate.text = date.stringFromDate(clipping.date_created!)
//        
//        
//        return cell
//    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let row = indexPath.row
            sbm.deleteClipping(clippings[row])
            clippings.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
        }
    }
    
    
    // MARK: - Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "goToClippingDetail"{
//            let row = tableView.indexPathForSelectedRow!.row
//            let vc = segue.destinationViewController as! ClippingDetailViewController
//            vc.clipping = clippings[row]
//        }
//    }
    
}

// MARK: Searching features
extension ClippingListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
        if let bundle = collection{
            clippings = sbm.searchClips(bundle, keyword: searchController.searchBar.text!)
        } else {
            clippings = sbm.searchClips(searchController.searchBar.text!)
        }
        
        if !searchController.active {
            if collection != nil {
                clippings = (collection?.clips!.allObjects)! as NSArray as! [Clipping]
            } else {
                clippings = sbm.returnClippings()
            }
        }
        
        tableView.reloadData()
    }
}

// MARK: Add new Clip
extension ClippingListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addNewClip(sender: AnyObject) {
        let image = UIImage(named: "placeholder")
        showActionSheet(image!)
        
    }
    
    func showActionSheet(image: UIImage){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Create New Clipping", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            imagePicker.sourceType = .Camera
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
        actionSheetController.addAction(cancelAction)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            actionSheetController.addAction(takePictureAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            actionSheetController.addAction(choosePictureAction)
        }
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        dismissViewControllerAnimated(true){
            self.showNotesTextField(image)
        }
    }
    
    func showNotesTextField(image: UIImage){
        
        let alert: UIAlertController = UIAlertController(title: "Notes for Clipping", message: nil, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.placeholder = "write your notes here."
        }
        
        let createAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            if let textField = alert.textFields?.first?.text {
                let clipping = self.sbm.AddClipping(textField, image: image)
                
                if(self.collection != nil) {
                    self.sbm.addClipToCollection(clipping, collection: self.collection!)
                }
                self.clippings.append(clipping)
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        alert.view.setNeedsLayout()
        presentViewController(alert, animated: true, completion:  nil)
        
    }
}
