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
@property (weak, nonatomic) IBOutlet UIView *filterSubView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *categoryFilterSubView;
@property (weak, nonatomic) IBOutlet UILabel *categoryFilterLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearCategoryFilterButton;
@property (strong, nonatomic) IBOutlet UIView *noNotesFoundView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NOTE_CELL_NIB_NAME bundle:nil] forCellReuseIdentifier:NOTE_CELL_IDENTIFIER];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(reloadNotes) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    
    [self applyTextFilter:@""];
    [self applyCategoryFilter:nil];
    
    [self.searchBar.searchTextField addTarget:self action:@selector(didSearchBarTextChange) forControlEvents:UIControlEventEditingChanged];
    
    [self reloadNotes];
    self.tableView.backgroundView = self.noNotesFoundView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSArray<Note *> *)notes {
    if (self.textFilter.length == 0 && !self.categoryFilter) {
        return [Repository sharedRepository].notes;
    }
    
    else {
        return self.filteredNotes;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self notes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [[self notes] objectAtIndex:indexPath.row];
    
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NOTE_CELL_IDENTIFIER];
    [cell fillForNote:note];
    cell.categoryFilterChangedCallback = ^() {
        [self applyCategoryFilter:note.category];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsViewController.note = [self notes][indexPath.row];
    
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

- (void)updateFilteredNotes {
    if (self.textFilter.length == 0 && !self.categoryFilter) {
        _filteredNotes = nil;
    }
    
    else {
        _filteredNotes = [[Repository sharedRepository].notes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^bool(id object, NSDictionary *bindings) {
            Note *note = (Note *)object;
            
            bool titleMatches = self.textFilter.length == 0 || [note.title rangeOfString:self.textFilter options:NSCaseInsensitiveSearch].length > 0;
            bool contentMatches = self.textFilter.length == 0 || [note.content rangeOfString:self.textFilter options:NSCaseInsensitiveSearch].length > 0;
            bool categoryMatches = !self.categoryFilter || note.category == self.categoryFilter;
            
            return (titleMatches || contentMatches) && categoryMatches;
        }]];
        
        if (_filteredNotes.count == 0) {
            self.tableView.backgroundView = self.noNotesFoundView;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        else {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    }
}

- (void)updateFilterSubView {
    if (self.categoryFilter) {
        self.categoryFilterLabel.text = [NSString stringWithFormat:@"Showing items in '%@'.", self.categoryFilter.title];
    }
    
    self.categoryFilterSubView.hidden = !self.categoryFilter;
    
    if (self.textFilter.length > 0 || self.categoryFilter) {
        self.filterSubView.hidden = false;
    }
}

- (IBAction)toggleFilterSubview:(id)sender {
    if (self.filterSubView.isHidden) {
        self.filterSubView.hidden = false;
        [self.searchBar becomeFirstResponder];
    }
    
    else {
        self.filterSubView.hidden = true;
    }
}

- (void)applyTextFilter:(NSString *)newFilter {
    self.textFilter = newFilter;
    
    [self updateFilteredNotes];
    [self updateFilterSubView];
    [self.tableView reloadData];
}

- (void)applyCategoryFilter:(NoteCategory *)newFilter {
    self.categoryFilter = newFilter;
    
    [self updateFilteredNotes];
    [self updateFilterSubView];
    [self.tableView reloadData];
}

- (void)didSearchBarTextChange {
    [self applyTextFilter:self.searchBar.text];
}

- (IBAction)clearCategoryFilter:(id)sender {
    [self applyCategoryFilter:nil];
}

- (IBAction)addNote:(id)sender {
    [[Repository sharedRepository] addEmptyNote];
    
    [self.tableView reloadData];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
