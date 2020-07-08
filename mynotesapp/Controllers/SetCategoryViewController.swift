//
//  SetCategoryViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class SetCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let CategoryCellIdentifier = "CategoryCellIdentifier"
    var categories = [NoteCategory]()
    var currentCategory: NoteCategory?
    var categorySelectedHandler: ((NoteCategory)->Void)?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        self.categories = Array((Repository.shared().categories as! [String:NoteCategory]).values)
        self.categories.sort(by: {$0.title < $1.title})
        
        guard let currentCategory = self.currentCategory, let currentCategoryIndex = self.categories.firstIndex(of: currentCategory) else {
            return
        }
        
        pickerView.selectRow(currentCategoryIndex, inComponent: 0, animated: false)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelectedHandler?(categories[row])
        dismiss(animated: true, completion: nil)
    }
}
