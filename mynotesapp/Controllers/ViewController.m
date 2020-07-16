//
//  ViewController.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/3/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "ViewController.h"
#import "../Models/Note.h"
#import "../Models/NoteCategory.h"
#import "../Models/Repository.h"
#import "./AlertController.h"
#import "NoteCell.h"
#import "mynotesapp-Swift.h"

NSString *const NOTE_CELL_IDENTIFIER = @"NoteCell";
NSString *const NOTE_CELL_NIB_NAME = @"NoteCell";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NOTE_CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:NOTE_CELL_IDENTIFIER];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(reloadNotes) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    
    [self reloadNotes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [Repository sharedRepository].pinnedNotes.count;
    }
    
    else  {
        return [Repository sharedRepository].notes.count;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        if ([Repository sharedRepository].pinnedNotes.count > 0) {
//            return @"Pinned notes";
//        }
//
//        else {
//            return nil;
//        }
//    }
//
//    else {
//        if ([Repository sharedRepository].notes.count > 0) {
//            return @"Notes";
//        }
//
//        else {
//            return nil;
//        }
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    
    Note *note;
    
    if (indexPath.section == 0) {
        note = [Repository sharedRepository].pinnedNotes[indexPath.row];
        [cell fillForNote:note pinnedHint:true];
    }
    
    else {
        note = [Repository sharedRepository].notes[indexPath.row];
        [cell fillForNote:note pinnedHint:false];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Note *note = [Repository sharedRepository].pinnedNotes[indexPath.row];
        
        return note.archived ? 0 : -1;
    }
    
    else {
        Note *note = [Repository sharedRepository].notes[indexPath.row];
        
        return note.pinned || note.archived ? 0 : -1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsViewController.note = [Repository sharedRepository].notes[indexPath.row];
    
    [self.navigationController pushViewController:detailsViewController animated:true];
}

- (void)reloadNotes {
    [[Repository sharedRepository] reloadNotesAndCategories:^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReloadNotes:error];
        });
    }];
}

- (void)didReloadNotes:(NSError *)error {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    if (error == nil)
        return;
    
    NSString *errorMessage = nil;
    
    if ([error.domain isEqualToString:@"NSURLErrorDomain"])
        errorMessage = [NSString stringWithFormat:@"The JSON file could not be retrieved: %@", error.userInfo[@"NSLocalizedDescription"]];
    
    else
        errorMessage = [NSString stringWithFormat:@"The JSON file could not be parsed: %@", error.userInfo[@"NSDebugDescription"]];

    AlertController *alert = [[AlertController alloc] initWithTitle:@"Problem when loading notes" message:errorMessage];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)addNote:(id)sender {
    [[Repository sharedRepository] addEmptyNote];
    
    [self.tableView reloadData];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
