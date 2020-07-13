//
//  CategoryCell.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 7/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var renameButton: UIButton!
    
    var renameHandler: (() -> Void)?
    var deleteHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillForCategory(category: NoteCategory) {
        label.text = category.title
    }
    
    @IBAction func renameCategory(_ sender: Any) {
        renameHandler?()
    }
    
    @IBAction func deleteCategory(_ sender: Any) {
        deleteHandler?()
    }
}
