//
//  PopupView.swift
//  bill-tracker
//
//  Created by Carr, Benjamin on 09/10/2016.
//  Copyright © 2016 Ben Carr. All rights reserved.
//

import UIKit

class PopupView: UIView {
    let animationDuration = 0.2

    var nibView: UIView?
    var nibHeight: CGFloat!

    init(nib: String) {
        super.init(frame: UIScreen.main.bounds)
        nibView = loadNib(name: nib)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        nibHeight = (nibView?.bounds.height)!
        nibView!.frame = CGRect(x: 0, y: bounds.maxY - nibHeight, width: bounds.width, height: nibHeight)

        addSubview(nibView!)
    }

    func loadNib(name: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func showInView(view: UIView) {
        view.addSubview(self)

        self.backgroundColor = UIColor(white: 0, alpha: 0)
        nibView?.frame.origin.y += nibHeight

        UIView.animate(withDuration: animationDuration, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.nibView?.frame.origin.y -= self.nibHeight
        })
    }

    func hide(_ callback: @escaping () -> ()) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.nibView?.frame.origin.y += self.nibHeight
        }, completion: { Void in
            self.removeFromSuperview()
            callback()
        })
    }
}
