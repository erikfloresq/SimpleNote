//
//  ViewController.swift
//  SimpleNote
//
//  Created by Erik Flores on 23/9/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textArea: UITextView!
    var doneBarButton = UIBarButtonItem(title: "Done",
                                    style: .done,
                                    target: self,
                                    action: #selector(doneAction))

    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self

    }

    @objc func doneAction() {
        textArea.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = doneBarButton
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

