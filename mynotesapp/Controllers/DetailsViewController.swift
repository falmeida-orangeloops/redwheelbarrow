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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    
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
        guard isMovingFromParent, let note = self.note, let title = titleTextField.text else {
            return
        }
        
        note.title = title
        note.content = contentTextView.text
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
            Repository.shared().notes.remove(self.note)
            self.navigationController?.popViewController(animated: true)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
}
