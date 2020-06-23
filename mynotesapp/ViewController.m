//
//  ViewController.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/3/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//



#import "ViewController.h"
#import "Models/Note.h"
#import "Models/NoteCategory.h"
#import "Cell.h"
#import "mynotesapp-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.df = [[NSDateFormatter alloc] init];
    [self.df setDateFormat:@"MM/dd/yyyy"];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(updateNotes) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    
    [self updateNotes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    [tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:identifier];
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
 
    Note *note = [self.notes objectAtIndex:indexPath.row];
    cell.titleLabel.text = note.title;
    cell.contentLabel.text = note.content;
    [cell.categoryButton setTitle:note.category.title forState:UIControlStateNormal];
    cell.createdDateLabel.text = [self.df stringFromDate:note.createdDate];
    
    return cell;
}

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

- (void)updateNotes {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"notes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data
    options:kNilOptions error:nil];
    
    self.notes = [[NSMutableArray<Note*> alloc] init];
    self.categories = [[NSMutableDictionary<NSString*,NoteCategory*> alloc] init];
    
    for (id item in dict[@"categories"])
    [self.categories setObject:[[NoteCategory alloc] initWithDict:item] forKey:item[@"id"]];
    
    for (id item in dict[@"notes"])
        [self.notes addObject:[[Note alloc] initWithDict:item category:self.categories[item[@"categoryId"]]]];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (IBAction)addNote:(id)sender {
    Note *newNote = [[Note alloc] initWithIdentifier:[[NSUUID UUID] UUIDString] title:@"" content:@"" createdDate:[NSDate date] category:self.categories[@"0"]];
    [self.notes insertObject:newNote atIndex:0];
    
    [self.tableView reloadData];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
