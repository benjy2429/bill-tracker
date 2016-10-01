import UIKit
import CoreData

class OverviewViewController: UIViewController, BillDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var context: NSManagedObjectContext!
    var bills = [Bill]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bill Tracker"
        tableView.registerNib(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = NSFetchRequest(entityName: "Bill")

        do {
            bills = try context.executeFetchRequest(fetchRequest) as! [Bill]
            bills.sortInPlace({ $0.nextDueDate.compare($1.nextDueDate) == .OrderedAscending })
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as! OverviewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let bill = bills[indexPath.row]
            context.deleteObject(bill)

            do {
                try context.save()
            } catch {
                fatalError("Error deleting bill: \(error)")
            }

            bills.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    func configureCell(cell: OverviewCell, atIndexPath indexPath: NSIndexPath) {
        let bill = bills[indexPath.row]

        cell.nameLabel!.text = bill.name
        cell.amountLabel!.text = bill.amountHumanized
        cell.dateLabel!.text = bill.nextDueDateHumanized

        cell.categoryIcon.setCategory(bill.category)
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bill = bills[indexPath.row]
        performSegueWithIdentifier("editBill", sender: bill)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addBill" || segue.identifier == "editBill") {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! BillDetailViewController

            controller.delegate = self
            controller.context = context

            if (segue.identifier == "editBill") {
                controller.editingBill = sender as! Bill
            }
        }
    }

    // MARK: - BillDetailViewControllerDelegate

    func didCancel(controller: BillDetailViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func didSaveBill(controller: BillDetailViewController, bill: Bill) {
        do {
            try context.save()
        } catch {
            fatalError("Error saving bill: \(error)")
        }

        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
}
