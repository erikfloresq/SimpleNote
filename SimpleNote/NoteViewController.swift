//
//  ViewController.swift
//  SimpleNote
//
//  Created by Erik Flores on 23/9/21.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var textArea: UITextView!
    var doneBarButton = UIBarButtonItem(title: "Done",
                                    style: .done,
                                    target: self,
                                    action: #selector(doneAction))

    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self
        let note = fetchNote()
        textArea.text = note?.text ?? ""
        textArea.autocapitalizationType = .none
        textArea.autocorrectionType = .no
        addLinkAttribute(in: textArea)
    }

    @objc func doneAction() {
        textArea.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        if textArea.text.isEmpty {
            return
        }
        managedObjectContext.performChanges { [weak self] in
            guard let self = self else { return }
            if let note = self.fetchNote() {
                note.update(text: self.textArea.text)
            } else {
                _ = Note.insert(context: self.managedObjectContext, text: self.textArea.text)
            }
        }
    }

    func addLinkAttribute(in textView: UITextView) {
        guard let text = textView.text else { return }
        let attribute = NSMutableAttributedString(string: text)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            attribute.addAttribute(.link, value: url, range: match.range)
        }
        textView.attributedText = attribute
    }

    func fetchNote() -> Note? {
        let notesFetchRequest = Note.sortedFetchRequest
        let notes = try? managedObjectContext.fetch(notesFetchRequest)
        return notes?.first
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = doneBarButton
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        addLinkAttribute(in: textView)
    }
}

