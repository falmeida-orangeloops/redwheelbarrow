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
#import "Cell.h"
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((Repository *)[Repository sharedRepository]).notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    Note *note = [((Repository *)[Repository sharedRepository]).notes objectAtIndex:indexPath.row];
    [cell fillForNote:note];
    
    return cell;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsViewController.delegate = self;
    [detailsViewController loadView:self.notes[[indexPath row]]];
    [self.navigationController pushViewController:detailsViewController animated:true];
}

- (IBAction)addNote:(id)sender {
    Note *newNote = [[Note alloc] initWithIdentifier:[[NSUUID UUID] UUIDString] title:@"" content:@"" createdDate:[NSDate date] category:self.categories[@"0"]];
    [self.notes insertObject:newNote atIndex:0];
    
    [self.tableView reloadData];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
