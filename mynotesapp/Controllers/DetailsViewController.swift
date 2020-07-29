//
//  DetailsViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/10/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class DetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @objc var note: Note?
    var unsavedNote: Note?
    var editionMode = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var editingLabel: UILabel!
    var editNoteBarButtonItem: UIBarButtonItem!
    var pinNoteBarButtonItem: UIBarButtonItem!
    var archiveNoteBarButtonItem: UIBarButtonItem!
    var deleteNoteBarButtonItem: UIBarButtonItem!
    var saveChangesBarButtonItem: UIBarButtonItem!
    var discardChangesBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNoteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditionMode))
        pinNoteBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(togglePinNote))
        archiveNoteBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleArchiveNote))
        deleteNoteBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        saveChangesBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        discardChangesBarButtonItem = UIBarButtonItem(title: "Discard", style: .plain, target: self, action: #selector(discardChanges))
        
        disableEditionMode()
        
        guard let note = self.note else {
            return
        }
        
        titleTextField.text = note.title
        contentTextView.text = note.content
        createdDateLabel.text = "Created on " + (note.createdDate as NSDate).shortString()
        categoryButton.setTitle(note.category.title, for: .normal)
        
        titleTextField.layer.borderColor = UIColor.darkGray.cgColor
        contentTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        pinNoteBarButtonItem.image = UIImage(systemName: note.pinned ? "pin.fill" : "pin")
        archiveNoteBarButtonItem.image = UIImage(systemName: note.archived ? "archivebox.fill" : "archivebox")
    }
    
    @IBAction func showSetCategoryViewController(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            return
        }
        
        let setCategoryViewController = storyboard.instantiateViewController(identifier: "SetCategoryViewController") as SetCategoryViewController
        
        setCategoryViewController.currentCategory = unsavedNote?.category
        setCategoryViewController.categorySelectedHandler = {(category: NoteCategory) in
            self.unsavedNote?.category = category
            self.categoryButton.setTitle(category.title, for: .normal)
        }
        setCategoryViewController.modalPresentationStyle = .popover
        
        self.present(setCategoryViewController, animated: true, completion: nil)
    }
    
    @objc func enableEditionMode(_ sender: Any) {
        guard let note = self.note else {
            return
        }
        
        unsavedNote = Note.init(note: note)
        editionMode = true
        
        titleTextField.isEnabled = true
        contentTextView.isEditable = true
        categoryButton.isEnabled = true
        
        navigationItem.rightBarButtonItems = [discardChangesBarButtonItem, saveChangesBarButtonItem]
        
        createdDateLabel.isHidden = true
        editingLabel.isHidden = false
        
        contentTextView.becomeFirstResponder()
    }
    
    func disableEditionMode() {
        unsavedNote = nil
        editionMode = false
        
        titleTextField.isEnabled = false
        contentTextView.isEditable = false
        categoryButton.isEnabled = false
        
        titleTextField.layer.borderWidth = 0
        contentTextView.layer.borderWidth = 0
        
        navigationItem.rightBarButtonItems = [deleteNoteBarButtonItem, archiveNoteBarButtonItem, pinNoteBarButtonItem, editNoteBarButtonItem]
        
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
        
        guard let title = titleTextField.text else {
            return
        }
        
        unsavedNote?.title = title
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.layer.borderWidth = 1
        contentTextView.backgroundColor = UIColor.systemGray4
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        contentTextView.layer.borderWidth = 0
        contentTextView.backgroundColor = nil
        
        unsavedNote?.content = contentTextView.text
    }
    
    @objc func saveChanges(_ sender: Any) {
        guard let unsavedNote = self.unsavedNote else {
            return
        }
        
        titleTextField.endEditing(true)
        contentTextView.endEditing(true)
        
        Repository.shared().updateNote(unsavedNote)
        note = unsavedNote
        
        disableEditionMode()
    }
    
     @objc func discardChanges(_ sender: Any) {
        titleTextField.text = note?.title
        contentTextView.text = note?.content
        categoryButton.setTitle(note?.category.title, for: .normal)
        
        disableEditionMode()
    }
    
    @objc func togglePinNote(_ sender: Any) {
        guard let note = self.note else {
            return
        }
        
        Repository.shared().togglePinNote(note)
        pinNoteBarButtonItem.image = UIImage(systemName: (note.pinned ? "pin.fill" : "pin"))
    }
    
    @objc func toggleArchiveNote(_ sender: Any) {
        guard let note = self.note else {
            return
        }
        
        Repository.shared().toggleArchiveNote(note)
        archiveNoteBarButtonItem.image = UIImage(systemName: (note.archived ? "archivebox.fill" : "archivebox"))
    }
    
    @objc func deleteNote(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Delete this note", message: "Are you sure? This can't be undone.", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(action: UIAlertAction!) in
            guard let note = self.note else {
                return
            }
            
            Repository.shared().removeNote(note)
            self.navigationController?.popViewController(animated: true)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
}
