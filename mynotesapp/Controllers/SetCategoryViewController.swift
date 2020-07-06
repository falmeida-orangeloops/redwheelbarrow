//
//  SetCategoryViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class SetCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let CategoryCellIdentifier = "CategoryCellIdentifier"
    var categories = [NoteCategory]()
    var currentCategory: NoteCategory?
    weak var delegate: DetailsViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        
        self.currentCategory = delegate!.note!.category
        self.categories = Array((Repository.shared().categories as! [String:NoteCategory]).values)
        self.categories.sort(by: {$0.title < $1.title})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoryCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellIdentifier, for: indexPath)
        
        if (self.categories[indexPath.row] == self.currentCategory) {
            cell.backgroundColor = UIColor.secondarySystemFill
        }
        
        cell.textLabel?.text = self.categories[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let newCategory = self.categories[indexPath.row]
        delegate?.setCategory(newCategory)
        
        self.navigationController?.popViewController(animated: true)
    }
}
