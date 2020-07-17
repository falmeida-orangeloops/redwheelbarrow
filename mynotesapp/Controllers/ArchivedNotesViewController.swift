//
//  ArchivedNotesViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 7/16/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

let ArchivedNoteCellIdentifier = "ArchivedNoteCell"

class ArchivedNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(Cell.self, forCellReuseIdentifier: ArchivedNoteCellIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Repository.shared().archivedNotes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArchivedNoteCellIdentifier, for: indexPath) as! Cell
        
        let note = Repository.shared().archivedNotes[indexPath.row] as! Note
        cell.fill(for: note, pinnedHint: false)
        
        return cell
    }
}
