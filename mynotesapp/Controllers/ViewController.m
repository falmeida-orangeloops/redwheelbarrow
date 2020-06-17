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
#import "../Models/NSDate+MyFormats.h"
#import "../Models/Repository.h"
#import "AlertController.h"
#import "Cell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(updateNotes) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    
    [self updateNotes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Repository sharedRepository].notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    [tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:identifier];
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
 
    Note *note = [[Repository sharedRepository].notes objectAtIndex:indexPath.row];
    cell.titleLabel.text = note.title;
    cell.contentLabel.text = note.content;
    [cell.categoryButton setTitle:note.category.title forState:UIControlStateNormal];
    cell.createdDateLabel.text = [note.createdDate shortString];
    
    return cell;
}

- (void) updateNotes {
    @try {
        [[Repository sharedRepository] reloadNotesAndCategories];
    }
    
    @catch(NSException *exception) {
        [AlertController showAlertWithTitle:@"Problem when loading notes" message:@"The JSON file could not be parsed." parent:self];
    }
    
    @finally {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
}

@end
