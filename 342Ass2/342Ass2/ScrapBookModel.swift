//
//  ScrapBookModel.swift
//  342Ass2
//
//  Created by Peter Mavridis on 2/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScrapbookModel {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func reload() -> Bool {
        do {
            try managedObjectContext.save()
            return true;
        } catch let error as NSError {
            print("Error: \(error)")
            return false;
        }
    }
    
    func AddCollection(name: String) -> Collection {
        let entity = NSEntityDescription.entityForName("Collection",inManagedObjectContext: managedObjectContext)
        let collection = Collection(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        collection.name = name
        return collection
    }
    
    func returnCollections() -> [Collection]{
        let collection = NSFetchRequest(entityName: "Collection")
        var collectionArray = [Collection]()
        do{
            collectionArray = try managedObjectContext.executeFetchRequest(collection) as! [Collection]
        } catch {
            print("Nothing found")
        }
        return collectionArray
    }
    
    func returnClippings() -> [Clipping] {
        let clip = NSFetchRequest(entityName: "Clipping")
        var clipArray: [Clipping] = []
        do{
            let moc = try managedObjectContext.executeFetchRequest(clip) as? [Clipping]
            if let results = moc {
                clipArray = results
            }
        } catch {
            print("Nothing found")
        }
        return clipArray
    }
    
    func AddClipping(notes: String, image: UIImage) -> Clipping {
        
        let entityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: managedObjectContext)
        let clipping = Clipping(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        clipping.notes = notes
        clipping.dateCreated = NSDate()
        let save: String = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)[0]
        clipping.image = "/\(clipping.dateCreated).jpg"
        let documentPath = save + clipping.image!
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            imageData.writeToFile(documentPath, atomically: true)
        } else {
            print("Image not saved")
        }
        return clipping
    }
    
    func addClipToCollection(clipping:Clipping, collection:Collection) -> Bool {
        collection.mutableSetValueForKey("clips").addObject(clipping)
        clipping.owner = collection
        return true
    }
    
    func deleteCollection(collection:Collection) -> Bool {
        if let clippings = collection.clips{
            for clipping in clippings {
                managedObjectContext.deleteObject(clipping as! NSManagedObject)
            }
        }
        managedObjectContext.deleteObject(collection)
        return true
    }
    
    
    func deleteClipping(clipping:Clipping) -> Bool {
        managedObjectContext.deleteObject(clipping)
        return true
    }
    
    func searchClips(keyword: String) -> [Clipping] {
        
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: managedObjectContext)
        request.entity = entityDescription
        let predicate = NSPredicate(format: "notes contains[c] %@", keyword)
        request.predicate = predicate
        do{
            let results = try managedObjectContext.executeFetchRequest(request)
            return results as! [Clipping]
        } catch {
            print("Error in search")
        }
        return []
    }
    
    func searchClips(collection:Collection, keyword: String) -> [Clipping] {
    
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        let keyWord = NSPredicate(format: "notes contains[c] %@", keyword)
        let collectionPredicate = NSPredicate(format: "myCollection == %@", collection)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [keyWord, collectionPredicate])
        fetchRequest.predicate = predicate
        do{
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results as! [Clipping]
        } catch {
            print("Search error from \(collection.name)")
        }
        return []
    }
}