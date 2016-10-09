import UIKit
import CoreData

protocol BillDetailViewControllerDelegate {
    func didCancel(_ controller: BillDetailViewController)
    func didSaveBill(_ controller: BillDetailViewController, bill: Bill)
}

class BillDetailViewController: UITableViewController, UITextFieldDelegate, PopupDatePickerDelegate, PopupPickerDelegate, CategoryCollectionViewControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var payeeField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryIcon: CategoryIcon!

    var delegate: BillDetailViewControllerDelegate!
    var context: NSManagedObjectContext!
    var editingBill: Bill!

    var popupDatePicker: PopupDatePicker!
    var popupRepeatPicker: PopupPicker!

    var dueDate: Date!
    var repeatInterval: Int = 0
    var category: Category!

    override func viewDidLoad() {
        super.viewDidLoad()

        amountField.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(-CGFloat.leastNormalMagnitude, 0, 0, 0)

        if (editingBill == nil) {
            title = "Add Bill"
            dueDate = Date()
            categoryLabel.text = ""

        } else {
            title = "Edit Bill"
            nameField.text = editingBill.name
            amountField.text = String(describing: editingBill.amount!)
            payeeField.text = editingBill.payee
            dueDate = editingBill.dueDate
            category = editingBill.category
            categoryLabel.text = editingBill.category?.name
            categoryIcon.setCategory(category)
            repeatInterval = editingBill.repeatInterval as! Int
        }

        dueDateLabel.text = formatDate(dueDate)
        repeatLabel.text = RepeatInterval.getByID(repeatInterval)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    // MARK: - Validation

    func validate() -> (isValid: Bool, message: String?) {
        var message: String?
        if nameField.text?.characters.count == 0 {
            message = "Please enter a name"
        } else if amountField.text?.characters.count == 0 {
            message = "Please enter an amount"
        } else if Double(amountField.text!) == nil {
            message = "Invalid amount"
        } else if Double(amountField.text!)! < 0.0 {
            message = "Amount must be greater than zero"
        } else if category == nil {
            message = "Please select a category"
        }
        return message == nil ? (true, nil) : (false, message)
    }

    func showValidationError(_ error: String) {
        let alert = UIAlertController.init(
            title: "Error",
            message: error,
            preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) -> Void in
        }

        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions

    @IBAction func savePressed(_ sender: AnyObject) {
        let validationResult = validate()
        if !validationResult.isValid {
            showValidationError(validationResult.message!)
            return
        }

        let name = nameField.text!
        let amount = NSDecimalNumber(string: amountField.text!)
        let payee = payeeField.text!

        if (editingBill == nil) {
            let bill = Bill.create(context, params: (name, amount, payee, dueDate, category, repeatInterval))
            delegate?.didSaveBill(self, bill: bill)

        } else {
            editingBill.update((name, amount, payee, dueDate, category, repeatInterval))
            delegate?.didSaveBill(self, bill: editingBill)
        }
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        delegate?.didCancel(self)
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TODO: Reformat amount field to currency format
        return true
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)

        if indexPath.row == 3 && popupDatePicker == nil {
            // TODO: Extract nib heights into PopupDatePicker.class
            popupDatePicker = PopupDatePicker()
            popupDatePicker.delegate = self
            if (editingBill != nil) {
                popupDatePicker.date = editingBill.dueDate!
            }
//            navigationController!.view.addSubview(popupDatePicker)
            popupDatePicker.showInView(view: navigationController!.view)
            return
        }

        if indexPath.row == 4 && popupRepeatPicker == nil {
            // TODO: Extract nib heights into PopupDatePicker.class
            popupRepeatPicker = PopupPicker()
            popupRepeatPicker.delegate = self
            popupRepeatPicker.options = RepeatInterval.humanized()
            if (editingBill != nil) {
                popupRepeatPicker.selectedOption = editingBill.repeatInterval as! Int
            }
            navigationController!.view.addSubview(popupRepeatPicker)
            popupRepeatPicker.showInView(view: navigationController!.view)
            return
        }

        if indexPath.row == 5 {
            performSegue(withIdentifier: "selectCategory", sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.leastNormalMagnitude
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }


    // MARK: - PopupDatePickerDelegate

    func didFinish(_ controller: PopupDatePicker, date: Date) {
        popupDatePicker.removeFromSuperview()
        popupDatePicker = nil

        dueDate = date
        dueDateLabel.text = formatDate(date)
    }

    func didCancel(_ controller: PopupDatePicker) {
        popupDatePicker.removeFromSuperview()
        popupDatePicker = nil
    }

    // MARK: - PopupPickerDelegate

    func didChooseOption(_ controller: PopupPicker, selection: Int) {
        popupRepeatPicker.removeFromSuperview()
        popupRepeatPicker = nil

        repeatInterval = selection
        repeatLabel.text = RepeatInterval.getByID(selection)
    }

    func didCancelPopupPicker(_ controller: PopupPicker) {
        popupRepeatPicker.removeFromSuperview()
        popupRepeatPicker = nil
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectCategory") {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! CategoryCollectionViewController

            controller.context = context
            controller.delegate = self
        }
    }

    // MARK: - CategoryCollectionViewControllerDelegate

    func didSelectCategory(_ controller: CategoryCollectionViewController, category: Category) {
        self.category = category
        categoryLabel.text! = category.name!
        categoryIcon.setCategory(category)
        self.dismiss(animated: true, completion: nil)
    }
}
