import UIKit

protocol PopupDatePickerDelegate {
    func didFinish(controller: PopupDatePicker, date: NSDate)
    func didCancel(controller: PopupDatePicker)
}

class PopupDatePicker: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: PopupDatePickerDelegate! = nil
    var date: NSDate = NSDate()

    override init(frame: CGRect) {
        super.init(frame: frame)
        print(self)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PopupDatePicker", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        return view
    }

    func setup() {
        let view = loadNib()
        view.frame = bounds
        addSubview(self.view)
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

    @IBAction func pickerChanged(sender: AnyObject) {
        date = sender.date
    }

    @IBAction func finish(sender: AnyObject) {
        hide({
            self.delegate.didFinish(self, date: self.date)
        })
    }

    @IBAction func clear(sender: AnyObject) {
        hide({
            self.delegate.didCancel(self)
        })

    }

}