//
//  DetailsViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/10/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class DetailsViewController: UIViewController {
    @objc var note: Note?
    var editionMode = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var discardChangesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        setCategoryViewController.delegate = self
        self.navigationController?.pushViewController(setCategoryViewController, animated: true)
        }
    
    func setCategory(_ category: NoteCategory) {
        note?.category = category
        categoryButton.setTitle(note?.category.title, for: .normal)
    }
    
    @IBAction func deleteNote(_ sender: Any) {
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
    
    @IBAction func enableEditionMode(_ sender: Any) {      titleTextField.isEnabled = true
        contentTextView.isEditable = true
        categoryButton.isEnabled = true
        
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.red.cgColor
        
        contentTextView.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.red.cgColor
        
        createdDateLabel.isHidden = true
        editBarButtonItem.isEnabled = false
        saveChangesButton.isHidden = false
        discardChangesButton.isHidden = false
        
        contentTextView.becomeFirstResponder()
        
        editionMode = true
    }
    
    func disableEditionMode() {
        titleTextField.isEnabled = false
        contentTextView.isEditable = false
        categoryButton.isEnabled = false
        
        titleTextField.layer.borderWidth = 0
        contentTextView.layer.borderWidth = 0
        
        createdDateLabel.isHidden = false
        editBarButtonItem.isEnabled = true
        saveChangesButton.isHidden = true
        discardChangesButton.isHidden = true
        
        editionMode = false
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let note = self.note, let title = titleTextField.text else {
            return
        }
        
        let newNote = Note.init(note: note)
        newNote.title = title
        newNote.content = contentTextView.text
        
        Repository.shared().updateNote(newNote)
        disableEditionMode()
    }
    
    @IBAction func discardChanges(_ sender: Any) {
        titleTextField.text = note?.title
        contentTextView.text = note?.content
        
        disableEditionMode()
    }
}
