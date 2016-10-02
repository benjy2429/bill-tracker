import UIKit
import CoreData

class OverviewViewController: UIViewController, BillDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var swapIcon: UIBarButtonItem!
    @IBOutlet weak var headerDateLabel: UILabel!
    @IBOutlet weak var headerStatsLabel: UILabel!

    enum TableViews {
        case upcoming
        case past
    }

    var context: NSManagedObjectContext!
    var upcomingBills = [Bill]()
    var pastBills = [Bill]()
    var currentView: TableViews = .upcoming

    override func viewDidLoad() {
        super.viewDidLoad()
        swapIcon.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesomeOfSize(20)], for: .normal)
        tableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        updateTitle()
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<Bill> = NSFetchRequest(entityName: "Bill")

        do {
            let fetchedBills = try context.fetch(fetchRequest)

            let calendar = NSCalendar.current
            let currentDate = Date()

            upcomingBills = fetchedBills.filter({
                let comparison = calendar.compare($0.nextDueDate, to: currentDate, toGranularity: .day)
                return comparison == .orderedSame || comparison == .orderedDescending
            })
            pastBills = fetchedBills.filter({
                let comparison = calendar.compare($0.nextDueDate, to: currentDate, toGranularity: .day)
                return comparison == .orderedAscending
            })

            upcomingBills.sort(by: { $0.nextDueDate.compare($1.nextDueDate as Date) == .orderedAscending })
            pastBills.sort(by: { $0.nextDueDate.compare($1.nextDueDate as Date) == .orderedAscending })

            configureHeader()

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func updateTitle() {
        if (currentView == .upcoming) {
            title = "Due Soon"
            swapIcon.title = String.fontAwesomeIconWithName(.CalendarCheckO)
        } else {
            title = "Past Bills"
            swapIcon.title = String.fontAwesomeIconWithName(.Calendar)
        }
    }

    func upcomingSection() -> Bool {
        return currentView == .upcoming
    }

    func configureHeader() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        headerDateLabel.text = dateFormatter.string(from: Date())

        let monthBills = Bill.billsDueThisMonth(upcomingBills)
        let monthAmount = monthBills.reduce(0) { $0 + ($1.amount?.doubleValue)! }

        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        let monthAmountString = currencyFormatter.string(from: NSNumber(value: monthAmount))!

        headerStatsLabel.text = "\(monthBills.count) bills due this month, totalling \(monthAmountString)"
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingSection() ? upcomingBills.count : pastBills.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell") as! OverviewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]
            context.delete(bill)

            do {
                try context.save()
            } catch {
                fatalError("Error deleting bill: \(error)")
            }

            if upcomingSection() {
                upcomingBills.remove(at: indexPath.row)
            } else {
                pastBills.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func configureCell(_ cell: OverviewCell, atIndexPath indexPath: IndexPath) {
        let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]

        cell.nameLabel!.text = bill.name
        cell.amountLabel!.text = bill.amountHumanized
        cell.dateLabel!.text = bill.nextDueDateHumanized

        cell.categoryIcon.setCategory(bill.category)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bill = upcomingSection() ? upcomingBills[indexPath.row] : pastBills[indexPath.row]

        performSegue(withIdentifier: "editBill", sender: bill)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addBill" || segue.identifier == "editBill") {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! BillDetailViewController

            controller.delegate = self
            controller.context = context

            if (segue.identifier == "editBill") {
                controller.editingBill = sender as! Bill
            }
        }
    }

    @IBAction func swapButtonPressed(_ sender: AnyObject) {
        currentView = currentView == .upcoming ? .past : .upcoming
        updateTitle()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    // MARK: - BillDetailViewControllerDelegate

    func didCancel(_ controller: BillDetailViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    func didSaveBill(_ controller: BillDetailViewController, bill: Bill) {
        do {
            try context.save()
        } catch {
            fatalError("Error saving bill: \(error)")
        }

        self.dismiss(animated: true, completion: nil)
        fetchData()
        tableView.reloadData()
    }
}
