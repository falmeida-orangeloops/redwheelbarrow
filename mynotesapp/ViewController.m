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
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTextView];
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

- (void) updateTextView {
    [self updateNotesAndCategories];
    
    NSString *newText = [NSString string];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    for (Note *note in self.notes) {
        newText = [NSString stringWithFormat:@"%@title: %@\ncontent: %@\ncreated date: %@\ncategory: %@\n\n", newText, note.title, note.content, [df stringFromDate:note.createdDate], self.categories[note.categoryId].title];
    }
    
    self.textView.text = newText;
}

@end
