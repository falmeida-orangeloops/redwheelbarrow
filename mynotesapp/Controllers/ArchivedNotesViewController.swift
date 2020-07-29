//
//  ArchivedNotesViewController.swift
//  mynotesapp
//
//  Created by Facundo Almeida on 7/16/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

import UIKit

let ArchivedNoteCellIdentifier = "ArchivedNoteCell"
let NoteCellNibName = "NoteCell"

class ArchivedNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noArchivedNotesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: NoteCellNibName, bundle: nil), forCellReuseIdentifier: ArchivedNoteCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        if Repository.shared().archivedNotes.count == 0 {
            tableView.backgroundView = noArchivedNotesView
            tableView.separatorStyle = .none
        }
        
        else {
            tableView.backgroundView = nil;
            tableView.separatorStyle = .singleLine
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = self.storyboard else {
            return
        }
        
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController") as DetailsViewController
        detailsViewController.note = Repository.shared().archivedNotes[indexPath.row] as? Note
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
