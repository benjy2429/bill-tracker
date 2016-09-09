import UIKit
import CoreData

protocol BillDetailViewControllerDelegate {
    func didCancel(controller: BillDetailViewController);
    func didAddBill(controller: BillDetailViewController, bill: Bill);
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

    // MARK: - IBActions

    @IBAction func savePressed(sender: AnyObject) {
        let name = nameField.text!
        let bill = Bill.create(managedObjectContext!, name: name)

        delegate?.didAddBill(self, bill: bill)
    }


    @IBAction func cancelPressed(sender: AnyObject) {
        delegate?.didCancel(self)
    }
}
