//
//  ViewController.swift
//  XYPad
//
//  Created by Cem Olcay on 7/7/21.
//

import UIKit

class ViewController: UIViewController {
    var xyPad = XYPad()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xyPad)
        xyPad.translatesAutoresizingMaskIntoConstraints = false
        xyPad.widthAnchor.constraint(equalToConstant: 200).isActive = true
        xyPad.heightAnchor.constraint(equalToConstant: 200).isActive = true
        xyPad.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        xyPad.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        xyPad.addTarget(self, action: #selector(xyPadValueChanged(sender:)), for: .valueChanged)
    }

    @IBAction func xyPadValueChanged(sender: XYPad) {
        print(sender.xValue, sender.yValue)
    }
}
