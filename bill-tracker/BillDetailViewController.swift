import UIKit
import CoreData

protocol BillDetailViewControllerDelegate {
    func didCancel(controller: BillDetailViewController)
    func didAddBill(controller: BillDetailViewController, bill: Bill)
}

class BillDetailViewController: UITableViewController, UITextFieldDelegate, PopupDatePickerDelegate, CategoryCollectionViewControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var delegate: BillDetailViewControllerDelegate!
    var context: NSManagedObjectContext!
    var popupDatePicker: PopupDatePicker!
    var dueDate: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Bill"
        amountField.delegate = self

        dueDate = NSDate()
        dueDateLabel.text = formatDate(dueDate)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }

    func formatDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        return formatter.stringFromDate(date)
    }

    // MARK: - Validation

    func validationErrors() -> [String] {
        var errors = [String]()
        if nameField.text?.characters.count == 0 {
            errors.append("Please enter a name")
        }
        if amountField.text?.characters.count == 0 {
            errors.append("Please enter an amount")
            return errors
        }
        let amountValue = Double(amountField.text!)
        if amountValue == nil {
            errors.append("Invalid amount")
            return errors
        }
        if amountValue < 0 {
            errors.append("Amount must be greater than zero")
        }
        return errors
    }

    func showValidationError(errors: [String]) {
        let alert = UIAlertController.init(
            title: "Error",
            message: errors.joinWithSeparator("\n"),
            preferredStyle: .Alert)

        let dismissAction = UIAlertAction(title: "OK", style: .Default) {
            (action: UIAlertAction) -> Void in
        }

        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions

    @IBAction func savePressed(sender: AnyObject) {
        let errors = validationErrors()
        if !errors.isEmpty {
            showValidationError(errors)
            return
        }

        let name = nameField.text!
        let amount = NSDecimalNumber(string: amountField.text!)
        let bill = Bill.create(context, params: (name, amount, dueDate))

        delegate?.didAddBill(self, bill: bill)
    }


    @IBAction func cancelPressed(sender: AnyObject) {
        delegate?.didCancel(self)
    }

    // MARK: - UITextFieldDelegate

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // TODO: Reformat amount field to currency format
        return true
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == 2 && popupDatePicker == nil {
            // TODO: Extract nib heights into PopupDatePicker.class
            popupDatePicker = PopupDatePicker(frame: CGRectMake(0, view.frame.height - 262, view.frame.width, 262))
            popupDatePicker.delegate = self
            navigationController!.view.addSubview(popupDatePicker)
            return
        }

        if indexPath.row == 3 {
            performSegueWithIdentifier("selectCategory", sender: self)
        }
    }


    // MARK: - PopupDatePickerDelegate

    func didFinish(controller: PopupDatePicker, date: NSDate) {
        popupDatePicker.removeFromSuperview()
        popupDatePicker = nil

        dueDate = date
        dueDateLabel.text = formatDate(date)
    }

    func didCancel(controller: PopupDatePicker) {
        popupDatePicker.removeFromSuperview()
        popupDatePicker = nil
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectCategory") {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! CategoryCollectionViewController

            controller.context = context
            controller.delegate = self

        }
    }

    // MARK: - CategoryCollectionViewControllerDelegate

    func didSelectCategory(controller: CategoryCollectionViewController, category: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
