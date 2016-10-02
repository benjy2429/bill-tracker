import UIKit

protocol PopupPickerDelegate {
    func didChooseOption(_ controller: PopupPicker, selection: Int)
    func didCancelPopupPicker(_ controller: PopupPicker)
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopupPicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func setup() {
        let view = loadNib()
        view.frame = bounds
        setShadow()
        addSubview(self.view)
        picker.delegate = self
    }

    func setShadow() {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.2
    }

    func show() {
        picker.selectRow(selectedOption, inComponent: 0, animated: false)

        view.frame.origin.y += view.frame.height

        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y -= self.view.frame.height
        })
    }

    func hide(_ callback: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y += self.view.frame.height
        }, completion: { Void in
            callback()
        })
    }

    @IBAction func finish(_ sender: AnyObject) {
        hide({
            self.delegate.didChooseOption(self, selection: self.selectedOption)
        })
    }

    @IBAction func clear(_ sender: AnyObject) {
        hide({
            self.delegate.didCancelPopupPicker(self)
        })
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
