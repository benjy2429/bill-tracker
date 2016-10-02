//
//  CategoryIcon.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 01/10/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import UIKit

@IBDesignable

class CategoryIcon: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconLabel: UILabel!

    var contentView : UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        contentView = loadViewFromNib()

        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        iconLabel.font = UIFont.fontAwesomeOfSize(18)
        backgroundView.layer.cornerRadius = (contentView?.frame.width)! / 2
        setCategory(nil)

        addSubview(contentView!)
    }

    func loadViewFromNib() -> UIView! {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

    func setCategory(_ category: Category?) {
        if (category == nil) {
            iconLabel.text = ""
            backgroundView.isOpaque = true

        } else {
            iconLabel.text = category!.icon
            backgroundView.isOpaque = false
            backgroundView.backgroundColor = category!.colour
        }
    }
}
