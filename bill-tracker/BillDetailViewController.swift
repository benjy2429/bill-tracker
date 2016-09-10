import UIKit
import CoreData

protocol BillDetailViewControllerDelegate {
    func didCancel(controller: BillDetailViewController);
    func didAddBill(controller: BillDetailViewController, bill: Bill);
}

class BillDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!

    var delegate: BillDetailViewControllerDelegate!
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Bill"
        amountField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }

    // MARK: - Validation

    func validationErrors() -> [String] {
        var errors = [String]()
        if nameField.text?.characters.count == 0 {
            errors.append("Please enter a name")
        }
        if amountField.text?.characters.count == 0 {
            errors.append("Please enter an amount")
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
        let bill = Bill.create(context, name: name)

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
}
