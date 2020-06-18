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
#import "AlertController.h"
#import "NoteCell.h"

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
    [_refreshControl addTarget:self action:@selector(updateNotes) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    
    [self updateNotes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((Repository *)[Repository sharedRepository]).notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    Note *note = [((Repository *)[Repository sharedRepository]).notes objectAtIndex:indexPath.row];
    [cell fillForNote:note];
    
    return cell;
}

- (void) updateNotes {
    [[Repository sharedRepository] reloadNotesAndCategories:^(NSError *error){
            [AlertController showAlertWithTitle:@"Problem when loading notes" message:@"The JSON file could not be parsed." parent:self];
    }];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
