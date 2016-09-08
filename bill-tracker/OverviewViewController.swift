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

    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var bills = [Bill]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = NSFetchRequest(entityName: "Bill")

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            bills = results as! [Bill]
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
    }

    func saveBill(name: String) {
        let bill = Bill.create(managedContext, name: name)
        bills.append(bill)
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
