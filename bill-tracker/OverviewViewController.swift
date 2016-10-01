import UIKit
import CoreData

class OverviewViewController: UIViewController, BillDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var swapIcon: UIBarButtonItem!
    @IBOutlet weak var headerDateLabel: UILabel!
    @IBOutlet weak var headerStatsLabel: UILabel!

    enum TableViews {
        case Upcoming
        case Past
    }

    var context: NSManagedObjectContext!
    var upcomingBills = [Bill]()
    var pastBills = [Bill]()
    var currentView: TableViews = .Upcoming

    override func viewDidLoad() {
        super.viewDidLoad()
        swapIcon.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)], forState: .Normal)
        tableView.registerNib(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        updateTitle()
    }

    func fetchData() {
        let fetchRequest = NSFetchRequest(entityName: "Bill")

        do {
            let fetchedBills = try context.executeFetchRequest(fetchRequest) as! [Bill]

            upcomingBills = fetchedBills.filter({ $0.nextDueDate.compare(NSDate()) == .OrderedDescending })
            pastBills = fetchedBills.filter({ $0.nextDueDate.compare(NSDate()) == .OrderedAscending })

            upcomingBills.sortInPlace({ $0.nextDueDate.compare($1.nextDueDate) == .OrderedAscending })
            pastBills.sortInPlace({ $0.nextDueDate.compare($1.nextDueDate) == .OrderedAscending })

            configureHeader()

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func updateTitle() {
        if (currentView == .Upcoming) {
            title = "Due Soon"
            swapIcon.title = String.fontAwesomeIconWithName(.CalendarCheckO)
        } else {
            title = "Past Bills"
            swapIcon.title = String.fontAwesomeIconWithName(.Calendar)
        }
    }

    func upcomingSection() -> Bool {
        return currentView == .Upcoming
    }

    func configureHeader() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        headerDateLabel.text = dateFormatter.stringFromDate(NSDate())

        let monthBills = Bill.billsDueThisMonth(upcomingBills)
        let monthAmount = monthBills.reduce(0) { $0 + ($1.amount?.doubleValue)! }

        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        let monthAmountString = currencyFormatter.stringFromNumber(monthAmount)!

        headerStatsLabel.text = "\(monthBills.count) bills due this month, totalling \(monthAmountString)"
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingSection() ? upcomingBills.count : pastBills.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as! OverviewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]
            context.deleteObject(bill)

            do {
                try context.save()
            } catch {
                fatalError("Error deleting bill: \(error)")
            }

            upcomingSection() ? upcomingBills.removeAtIndex(indexPath.row) : pastBills.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    func configureCell(cell: OverviewCell, atIndexPath indexPath: NSIndexPath) {
        let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]

        cell.nameLabel!.text = bill.name
        cell.amountLabel!.text = bill.amountHumanized
        cell.dateLabel!.text = bill.nextDueDateHumanized

        cell.categoryIcon.setCategory(bill.category)
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]

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

    @IBAction func swapButtonPressed(sender: AnyObject) {
        currentView = currentView == .Upcoming ? .Past : .Upcoming
        updateTitle()
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        fetchData()
        tableView.reloadData()
    }
}
