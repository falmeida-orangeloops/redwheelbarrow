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
#import "Red_Wheelbarrow-Swift.h"

NSString *const NOTE_CELL_IDENTIFIER = @"NoteCell";
NSString *const NOTE_CELL_NIB_NAME = @"NoteCell";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NOTE_CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:NOTE_CELL_IDENTIFIER];
    
    _refreshControl = [[RefreshControl alloc] init];
    //[_refreshControl addTarget:self action:@selector(reloadNotes) forControlEvents:UIControlEventValueChanged];
    
    __weak id weakSelf = self;
    [_refreshControl addToScrollView:self.tableView withRefreshBlock:^{
        [weakSelf reloadNotes];
    }];
    
    [self reloadNotes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Repository sharedRepository].notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    Note *note = [[Repository sharedRepository].notes objectAtIndex:indexPath.row];
    [cell fillForNote:note];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditNoteViewController *editNoteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditNoteViewController"];
    editNoteViewController.note = [Repository sharedRepository].notes[indexPath.row];
    
    [self.navigationController pushViewController:editNoteViewController animated:true];
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
    EditNoteViewController *editNoteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditNoteViewController"];
    [self.navigationController pushViewController:editNoteViewController animated:true];
}

@end
