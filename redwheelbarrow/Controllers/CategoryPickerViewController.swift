//
//  SetCategoryViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 6/11/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

@objc class CategoryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    var categories: [NoteCategory]!
    var selectedCategory: NoteCategory!
    var categorySelectedHandler: ((NoteCategory)->Void)?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        self.categories = Repository.shared().categories.allValues as? [NoteCategory]
        self.categories.sort(by: {$0.title < $1.title})
        
        guard let selectedCategory = self.selectedCategory, let currentCategoryIndex = self.categories.firstIndex(of: selectedCategory) else {
            return
        }
        
        pickerView.selectRow(currentCategoryIndex, inComponent: 0, animated: false)
        
        let tapToSelect = UITapGestureRecognizer(target: self, action: #selector(accept))
        tapToSelect.delegate = self
        pickerView.addGestureRecognizer(tapToSelect)
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.categories[row]
    }
    
    @objc func accept(tapRecognizer: UITapGestureRecognizer) {
        if let selectedCategory = self.selectedCategory, tapRecognizer.state == .ended {
            let rowHeight = self.pickerView.rowSize(forComponent: 0).height
            let selectedRowFrame = self.pickerView.bounds.insetBy(dx: 0, dy: (self.pickerView.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.pickerView))
            if userTappedOnSelectedRow {
                categorySelectedHandler?(selectedCategory)
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
