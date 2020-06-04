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

- (NoteCategory *) categoryWithId:(NSString *)id {
    NSArray *categories = self.categories;
    
    for (int i = 0; i < self.categories.count; i++) {
        if ([((NoteCategory*)categories[i]).id isEqualToString:id])
            return self.categories[i];
    }
    
    return nil;
}

- (void) updateNotesAndCategories {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"notes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *jsonNotes = dict[@"notes"];
    NSArray *jsonCategories = dict[@"categories"];
    id newNotes[jsonNotes.count];
    id newCategories[jsonCategories.count];
    
    for (int i = 0; i < jsonNotes.count; i++)
        newNotes[i] = [[Note alloc] initWithDict:jsonNotes[i]];
    
    for (int i = 0; i < jsonCategories.count; i++)
        newCategories[i] = [[NoteCategory alloc] initWithDict:jsonCategories[i]];
    
    self.notes = [NSArray arrayWithObjects:newNotes count:jsonCategories.count];
    self.categories = [NSArray arrayWithObjects:newCategories count:jsonCategories.count];
}

- (void) updateTextView {
    [self updateNotesAndCategories];
    
    NSString *newText = [NSString string];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    for (Note *note in self.notes) {
        newText = [NSString stringWithFormat:@"%@title: %@\ncontent: %@\ncreated date: %@\ncategory: %@\n\n", newText, note.title, note.content, [df stringFromDate:note.createdDate], [self categoryWithId:note.categoryId].title];
    }
    
    self.textView.text = newText;
}

@end
