import UIKit

protocol PopupDatePickerDelegate {
    func didFinish(_ controller: PopupDatePicker, date: Date)
    func didCancel(_ controller: PopupDatePicker)
}

class PopupDatePicker: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: PopupDatePickerDelegate! = nil
    var date: Date = Date()

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
        let nib = UINib(nibName: "PopupDatePicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func setup() {
        let view = loadNib()
        view.frame = bounds
        setShadow()
        addSubview(self.view)
    }

    func setShadow() {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.2
    }

    func show() {
        datePicker.date = date

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

    @IBAction func pickerChanged(_ sender: AnyObject) {
        date = sender.date
    }

    @IBAction func finish(_ sender: AnyObject) {
        hide({
            self.delegate.didFinish(self, date: self.date)
        })
    }

    @IBAction func clear(_ sender: AnyObject) {
        hide({
            self.delegate.didCancel(self)
        })

    }

}
