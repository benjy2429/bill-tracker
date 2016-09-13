//
//  CategoryCollectionViewController.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 13/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CategoryCollectionViewControllerDelegate {
    // TODO: Replace AnyObject with Category
    func didSelectCategory(controller: CategoryCollectionViewController, category: AnyObject?)
}

class CategoryCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var delegate: CategoryCollectionViewControllerDelegate!
    var context: NSManagedObjectContext!

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let _fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        _fetchedResultsController.delegate = self

        return _fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Category"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath)

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        delegate?.didSelectCategory(self, category: nil)
    }
}