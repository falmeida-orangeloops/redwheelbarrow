//
//  EditCategoriesViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

let CategoryCellIdentifier = "CategoryCell"
let CategoryCellNib = UINib(nibName: "CategoryCell", bundle: nil)

@objc class EditCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var renameAlert: UIAlertController?
    
    var categories = [NoteCategory]()
    var currentCategory: NoteCategory?
    
    override func loadView() {
        super.loadView()
        
        self.reloadCategories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryCellNib, forCellReuseIdentifier: CategoryCellIdentifier)
        
        renameAlert = UIAlertController(title: "Rename category", message: "Enter a new name.", preferredStyle: .alert)
        renameAlert?.addAction(UIAlertAction(title: "Rename", style: .default, handler: {(action: UIAlertAction!) in
            guard let currentCategory = self.currentCategory, let newTitle = self.renameAlert?.textFields?[0].text else {
                return
            }
            
            currentCategory.title = newTitle
            
            self.tableView.reloadData()
        }))
        renameAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
            
        }))
        renameAlert?.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Name"
            textField.delegate = self
        })
    }
    
    func reloadCategories() {
        self.categories = Array((Repository.shared().categories as! [String:NoteCategory]).values)
        self.categories.sort(by: {$0.title < $1.title})
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = self.categories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.fillForCategory(category: category)
        cell.renameHandler = {
            self.renameCategory(category: category)
        }
        cell.deleteHandler = {
            self.deleteCategory(category: category)
        }
        
        return cell
    }
    
    func renameCategory(category: NoteCategory) {
        guard let renameAlert = self.renameAlert else {
            return
        }
        
        currentCategory = category
        
        renameAlert.title = String(format: "Rename '%@'", category.title)
        renameAlert.textFields?[0].text = category.title
        
        present(renameAlert, animated: true, completion: nil)
    }
    
    func deleteCategory(category: NoteCategory) {
        let confirmationAlert = UIAlertController(title: String(format: "Delete '%@'", category.title), message: "Are you sure? This can't be undone.", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(action: UIAlertAction!) in
            Repository.shared().removeCategory(category)
            self.reloadCategories()
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }
        
        let finalText = text.replacingCharacters(in: textRange, with: string)
        
        renameAlert?.actions[0].isEnabled = finalText.count > 0
        
        return true
    }
}
