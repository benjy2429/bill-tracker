import UIKit
import CoreData

class OverviewViewController: UIViewController, BillDetailViewControllerDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var bills = [Bill]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest = NSFetchRequest(entityName: "Bill")

        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
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
        let bill = Bill.create(managedObjectContext, name: name)
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addBill") {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! BillDetailViewController

            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
        }
    }

    func BillDetailViewControllerDidCancel(controller: BillDetailViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
