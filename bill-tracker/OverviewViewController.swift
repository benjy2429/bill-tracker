import UIKit
import CoreData
import FontAwesome_swift

class OverviewViewController: UIViewController, BillDetailViewControllerDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var context: NSManagedObjectContext!

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Bill")
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
        title = "Bill Tracker"
        tableView.registerNib(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }

        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }

        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as! OverviewCell
        let bill = fetchedResultsController.objectAtIndexPath(indexPath) as! Bill

        cell.nameLabel!.text = bill.name
        cell.amountLabel!.text = bill.amountHumanized
        cell.dateLabel!.text = bill.nextDueDateHumanized

        cell.iconLabel!.font = UIFont.fontAwesomeOfSize(20)
        cell.iconLabel!.text = bill.category?.icon
        cell.iconBackground!.layer.cornerRadius = 20
        cell.iconBackground!.backgroundColor = bill.category!.colour

        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let bill = fetchedResultsController.objectAtIndexPath(indexPath) as! Bill
            context.deleteObject(bill)

            do {
                try context.save()
            } catch {
                fatalError("Error deleting bill: \(error)")
            }
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
//        case .Update:
//            if let indexPath = indexPath {
//                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ToDoCell
//                configureCell(cell, atIndexPath: indexPath)
//            }
//            break
//        case .Move:
//            if let indexPath = indexPath {
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            }
//
//            if let newIndexPath = newIndexPath {
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
//            }
//            break
        default:
            break
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addBill") {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! BillDetailViewController

            controller.delegate = self
            controller.context = context
        }
    }

    // MARK: - BillDetailViewControllerDelegate

    func didCancel(controller: BillDetailViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func didAddBill(controller: BillDetailViewController, bill: Bill) {
        do {
            try context.save()
        } catch {
            fatalError("Error saving bill: \(error)")
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
