import UIKit
import CoreData

protocol BillDetailViewControllerDelegate {
    func BillDetailViewControllerDidCancel(controller: BillDetailViewController);
//    func BillDetailViewControllerDidFinishAddingBill(controller: BillDetailViewController, bill: Bill);
}

class BillDetailViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!

    var delegate: BillDetailViewControllerDelegate?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Bill"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func savePressed(sender: AnyObject) {
    }


    @IBAction func cancelPressed(sender: AnyObject) {
        if (delegate != nil) {
            delegate!.BillDetailViewControllerDidCancel(self)
        }
    }


    /*
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
     */
}
