import UIKit

protocol PopupDatePickerDelegate {
    func didFinish(_ controller: PopupDatePicker, date: Date)
    func didCancel(_ controller: PopupDatePicker)
}

class PopupDatePicker: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!

    var nibView: UIView?

    var delegate: PopupDatePickerDelegate! = nil
    var date: Date = Date()

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
    }

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopupDatePicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func showInView(view: UIView) {
        view.addSubview(self)
        datePicker.date = date

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
