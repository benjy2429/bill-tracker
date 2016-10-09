import UIKit

protocol PopupPickerDelegate {
    func didChooseOption(_ controller: PopupPicker, selection: Int)
    func didCancelPopupPicker(_ controller: PopupPicker)
}

class PopupPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView!

    var nibView: UIView?

    var delegate: PopupPickerDelegate! = nil
    var options: [String]! = [String]()
    var selectedOption: Int! = 0

    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func setup() {
        nibView = loadNib()

        let currentHeight = nibView?.bounds.height
        nibView!.frame = CGRect(x: 0, y: bounds.maxY - currentHeight!, width: bounds.width, height: currentHeight!)

        addSubview(nibView!)
        picker.delegate = self
    }

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopupPicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func showInView(view: UIView) {
        view.addSubview(self)
        picker.selectRow(selectedOption, inComponent: 0, animated: false)

        self.backgroundColor = UIColor(white: 0, alpha: 0)
        nibView?.frame.origin.y += (nibView?.frame.height)!

        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.nibView?.frame.origin.y -= (self.nibView?.frame.height)!
        })
    }

    func hide(_ callback: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.nibView?.frame.origin.y += (self.nibView?.frame.height)!
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
