//
//  EditNoteViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/10/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class EditNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @objc var note: Note?
    var unsavedNote: Note?
    var editionEnabled = false

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var editingLabel: UILabel!
    var editNoteBarButtonItem: UIBarButtonItem!
    var deleteNoteBarButtonItem: UIBarButtonItem!
    var saveChangesBarButtonItem: UIBarButtonItem!
    var discardChangesBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        editNoteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEdition))
        deleteNoteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        saveChangesBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        discardChangesBarButtonItem = UIBarButtonItem(title: "Discard", style: .plain, target: self, action: #selector(discardChanges))

        titleTextField.layer.borderColor = UIColor.darkGray.cgColor
        contentTextView.layer.borderColor = UIColor.darkGray.cgColor

        titleTextField.text = self.note?.title ?? ""
        contentTextView.text = self.note?.content ?? ""
        createdDateLabel.text = "Created on " + ((self.note?.createdDate as NSDate?) ?? NSDate()).shortString()
        categoryButton.setTitle(self.note?.category?.title ?? "(No category)", for: .normal)

        if self.note != nil {
            disableEdition()
        }

        else {
            enableEdition()
        }
    }

    @IBAction func showCategoryPickerViewController(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            return
        }

        let categoryPickerViewController = storyboard.instantiateViewController(identifier: "CategoryPickerViewController") as CategoryPickerViewController
        categoryPickerViewController.selectedCategory = unsavedNote?.category
        categoryPickerViewController.categorySelectedHandler = { (category: NoteCategory) in
            self.unsavedNote?.category = category
            self.categoryButton.setTitle(category.title, for: .normal)
        }
        categoryPickerViewController.modalPresentationStyle = .popover

        self.present(categoryPickerViewController, animated: true, completion: nil)
    }

    @objc func deleteNote(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Delete this note", message: "Are you sure? This can't be undone.", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            guard let note = self.note else {
                return
            }

            Repository.shared().removeNote(note)
            self.navigationController?.popViewController(animated: true)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(confirmationAlert, animated: true, completion: nil)
    }

    @objc func enableEdition() {
        if let note = self.note {
            unsavedNote = Note(note: note)
        }

        else {
            unsavedNote = Note(identifier: UUID().uuidString, title: "", content: "", createdDate: Date(), category: nil)
        }

        editionEnabled = true

        titleTextField.isEnabled = true
        contentTextView.isEditable = true
        categoryButton.isEnabled = true
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = [discardChangesBarButtonItem, saveChangesBarButtonItem]

        createdDateLabel.isHidden = true
        editingLabel.isHidden = false

        contentTextView.becomeFirstResponder()
    }

    func disableEdition() {
        unsavedNote = nil
        editionEnabled = false

        titleTextField.isEnabled = false
        contentTextView.isEditable = false
        categoryButton.isEnabled = false

        titleTextField.layer.borderWidth = 0
        contentTextView.layer.borderWidth = 0

        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItems = [deleteNoteBarButtonItem, editNoteBarButtonItem]

        createdDateLabel.isHidden = false
        editingLabel.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleTextField.layer.borderWidth = 1
        titleTextField.backgroundColor = UIColor.systemGray4
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        titleTextField.layer.borderWidth = 0
        titleTextField.backgroundColor = nil
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.layer.borderWidth = 1
        contentTextView.backgroundColor = UIColor.systemGray4
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        contentTextView.layer.borderWidth = 0
        contentTextView.backgroundColor = nil
    }

    @objc func saveChanges(_ sender: Any) {
        guard let unsavedNote = self.unsavedNote else {
            return
        }
        
        if let title = titleTextField.text {
            unsavedNote.title = title
        }
        
        unsavedNote.content = contentTextView.text

        if unsavedNote.isEmpty() {
            let confirmationAlert = UIAlertController(title: "Save an empty note", message: "You are about to save an empty note. Are you sure?", preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
                Repository.shared().updateNote(unsavedNote)
                self.note = unsavedNote
                self.disableEdition()
            }))
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(confirmationAlert, animated: true, completion: nil)
        }

        else {
            Repository.shared().updateNote(unsavedNote)
            self.note = unsavedNote
            disableEdition()
        }
    }

    @objc func discardChanges(_ sender: Any) {
        if let note = self.note {
            titleTextField.text = note.title
            contentTextView.text = note.content

            if let categoryTitle = note.category?.title {
                categoryButton.setTitle(categoryTitle, for: .normal)
            }

            else {
                categoryButton.setTitle("(No category)", for: .normal)
            }
        }

        else {
            self.navigationController?.popViewController(animated: true)
        }

        disableEdition()
    }
}
