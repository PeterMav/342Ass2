//
//  ViewController.swift
//  342Ass2
//
//  Created by Peter Mavridis on 2/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let sbm = ScrapbookModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create collection A and B
        let collectionA = sbm.AddCollection("A")
        let collectionB = sbm.AddCollection("B")
       
        // Creates three clips
        let clipA = sbm.AddClipping("1 foo",image: UIImage(named: "myDesk")!)
        let clipB = sbm.AddClipping("2 foo",image: UIImage(named: "myDesk")!)
        let clipC = sbm.AddClipping("3 bar",image: UIImage(named: "myDesk")!)
        
        // Prints the list of collections
        let collections = sbm.returnCollections()
        print("List Of All Collections")
        for collection in collections{
            print(collection.name)
        }
        
        // Prints the list of clips
        let clips = sbm.returnClippings()
        print("List Of All Clippings")
        for clips in clips{
            print(clips.notes)
        }
        
        // Adds clips A and B to collection A
        sbm.addClipToCollection(clipA, collection: collectionA)
        sbm.addClipToCollection(clipB, collection: collectionA)
        
        // Prints clips in collection A
        print("Show clippings in collection A")
        if let clips = collectionA.clips{
            for clip in clips {
                print(clip.notes)
            }
        }
        
        
        // Deletes clipA
        sbm.deleteClipping(clipA)
        
        // Prints collection after deletion
        print("Prints collection after clipA deleted")
        if let clippings = collectionA.clips{
            for clipping in clippings {
                print(clipping.notes)
            }
        }
        
        // Prints clippings with bar
        print("Result from bar search")
        let query = sbm.searchClips("bar")
        for result in query {
            print(result.notes)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

