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
import FontAwesome_swift

protocol CategoryCollectionViewControllerDelegate {
    func didSelectCategory(_ controller: CategoryCollectionViewController, category: Category)
}

class CategoryCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var delegate: CategoryCollectionViewControllerDelegate!
    var context: NSManagedObjectContext!

    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest(entityName: "Category")
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
        collectionView!.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        collectionView!.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = fetchedResultsController.object(at: indexPath)

        cell.iconLabel!.font = UIFont.fontAwesomeOfSize(36)
        cell.iconLabel!.text = category.icon

        cell.circleView.layer.cornerRadius = 45
        cell.circleView.backgroundColor = category.colour

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        delegate?.didSelectCategory(self, category: category)
    }
}
