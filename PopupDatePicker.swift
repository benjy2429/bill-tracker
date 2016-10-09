import UIKit

protocol PopupDatePickerDelegate {
    func didFinish(_ controller: PopupDatePicker, date: Date)
}

class PopupDatePicker: PopupView {
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: PopupDatePickerDelegate! = nil
    var date: Date = Date()

    init() {
        super.init(nib: String(describing: PopupDatePicker.self))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showInView(view: UIView) {
        datePicker.date = date
        super.showInView(view: view)
    }

    @IBAction func pickerChanged(_ sender: AnyObject) {
        date = sender.date
    }

    @IBAction func finish(_ sender: AnyObject) {
        hide({
            self.delegate.didFinish(self, date: self.date)
        })
    }

    @IBAction func clear(_ sender: AnyObject) {
        hide({})
    }
}
