//
//  ViewController.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 08/09/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import UIKit
import CoreData

class OverviewViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var bills = [NSManagedObject]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Bill")

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            bills = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bill Tracker"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveBill(name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity = NSEntityDescription.entityForName("Bill", inManagedObjectContext: managedContext)
        let bill = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        bill.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            bills.append(bill)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let bill = bills[indexPath.row]

        cell!.textLabel!.text = bill.valueForKey("name") as? String
        return cell!
    }

    @IBAction func addBill(sender: AnyObject) {
        let alert = UIAlertController(title: "Bill name", message: "Create a new bill", preferredStyle: .Alert)

        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.saveBill(textField!.text!)
            self.tableView.reloadData()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }

        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        presentViewController(alert, animated: true, completion: nil)
    }
}
