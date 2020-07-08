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
    var editNoteBarButtonItem: UIBarButtonItem!
    var deleteNoteBarButtonItem: UIBarButtonItem!
    var saveChangesBarButtonItem: UIBarButtonItem!
    var discardChangesBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNoteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditionMode))
        deleteNoteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if (!editionMode) {
//            return
//        }
//        
//        let confirmationAlert = UIAlertController(title: "Editing this note", message: "You are currently editing this note. What do you want to do?", preferredStyle: .alert)
//        confirmationAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction!) in
//            self.saveChanges(confirmationAlert)
//        }))
//        
//        confirmationAlert.addAction(UIAlertAction(title: "Discard", style: .cancel, handler: nil))
//        
//        //confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        present(confirmationAlert, animated: true, completion: nil)
    }
    
    @IBAction func showSetCategoryViewController(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            return
        }
        
        let setCategoryViewController = storyboard.instantiateViewController(identifier: "SetCategoryViewController") as SetCategoryViewController
        
        setCategoryViewController.categorySelectedHandler = {(category: NoteCategory) in
            self.unsavedNote?.category = category
            self.categoryButton.setTitle(category.title, for: .normal)
        }
        setCategoryViewController.modalPresentationStyle = .popover
        
        self.present(setCategoryViewController, animated: true, completion: nil)
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
    
    @objc func enableEditionMode(_ sender: Any) {
        guard let note = self.note else {
            return
        }
        
        unsavedNote = Note.init(note: note)
        editionMode = true
        
        titleTextField.isEnabled = true
        contentTextView.isEditable = true
        categoryButton.isEnabled = true
        
        titleTextField.layer.borderWidth = 1
        contentTextView.layer.borderWidth = 1
        
        navigationItem.rightBarButtonItems = [discardChangesBarButtonItem, saveChangesBarButtonItem]
        
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
        
        navigationItem.rightBarButtonItems = [deleteNoteBarButtonItem, editNoteBarButtonItem]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let title = titleTextField.text else {
            return
        }
        
        unsavedNote?.title = title
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
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
}
