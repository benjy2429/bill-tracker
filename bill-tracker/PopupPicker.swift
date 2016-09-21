import UIKit

protocol PopupPickerDelegate {
    func didChooseOption(controller: PopupPicker, selection: Int)
    func didCancelPopupPicker(controller: PopupPicker)
}

class PopupPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var view: UIView!
    @IBOutlet weak var picker: UIPickerView!

    var delegate: PopupPickerDelegate! = nil
    var options: [String]! = [String]()
    var selectedOption: Int! = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PopupPicker", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        return view
    }

    func setup() {
        let view = loadNib()
        view.frame = bounds
        addSubview(self.view)
        picker.delegate = self
        show()
    }

    func show() {
        view.frame.origin.y += view.frame.height

        UIView.animateWithDuration(0.2, animations: {
            self.view.frame.origin.y -= self.view.frame.height
        })
    }

    func hide(callback: () -> ()) {
        UIView.animateWithDuration(0.2, animations: {
            self.view.frame.origin.y += self.view.frame.height
        }) { Void in
            callback()
        }
    }

    @IBAction func finish(sender: AnyObject) {
        hide({
            self.delegate.didChooseOption(self, selection: self.selectedOption)
        })
    }

    @IBAction func clear(sender: AnyObject) {
        hide({
            self.delegate.didCancelPopupPicker(self)
        })
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = row
    }
}