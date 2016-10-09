import UIKit

protocol PopupPickerDelegate {
    func didChooseOption(_ controller: PopupPicker, selection: Int)
}

class PopupPicker: PopupView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView!

    var delegate: PopupPickerDelegate! = nil
    var options: [String]! = [String]()
    var selectedOption: Int! = 0

    init() {
        super.init(nib: String(describing: PopupPicker.self))
        picker.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showInView(view: UIView) {
        super.showInView(view: view)
        picker.selectRow(selectedOption, inComponent: 0, animated: false)
    }


    @IBAction func finish(_ sender: AnyObject) {
        hide({
            self.delegate.didChooseOption(self, selection: self.selectedOption)
        })
    }

    @IBAction func clear(_ sender: AnyObject) {
        hide({})
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = row
    }
}
