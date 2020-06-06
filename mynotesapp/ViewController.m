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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.df = [[NSDateFormatter alloc] init];
    [self.df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    [self updateNotesAndCategories];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
 
    Note *note = [self.notes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"title: %@\ncontent: %@\ncreated date: %@\ncategory: %@", note.title, note.content, [self.df stringFromDate:note.createdDate], self.categories[note.categoryId].title];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void) updateNotesAndCategories {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"notes" ofType:@"json"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
    
    self.notes = [[NSMutableArray<Note*> alloc] init];
    self.categories = [[NSMutableDictionary<NSString*,NoteCategory*> alloc] init];
    
    for (id item in dict[@"notes"])
        [self.notes addObject:[[Note alloc] initWithDict:item]];
    
    for (id item in dict[@"categories"])
        [self.categories setObject:[[NoteCategory alloc] initWithDict:item] forKey:item[@"id"]];
}

@end
