//
//  SetCategoryViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class SetCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var categories = [NoteCategory]()
    var currentCategory: NoteCategory?
    weak var delegate: DetailsViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell";
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);

        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        let category = self.categories[indexPath.row]
        
        if (category == self.currentCategory) {
            cell?.backgroundColor = UIColor.secondarySystemFill
        }
        
        cell?.textLabel?.text = self.categories[indexPath.row].title;
        
        return cell!;
    }
    
    override func loadView() {
        super.loadView();
        
        self.currentCategory = delegate!.note!.category
        self.categories = delegate?.delegate?.categories.allValues as! [NoteCategory]
        self.categories.sort(by: {$0.title < $1.title})
    }
    
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let newCategory = self.categories[indexPath.row]
        delegate?.setCategory(newCategory)
        
        self.navigationController?.popViewController(animated: true)
    }
}
