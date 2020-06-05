//
//  ViewController.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/3/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models/NoteCategory.h"
#import "Models/Note.h"

@interface ViewController : UIViewController
@property NSMutableArray<Note*> *notes;
@property NSMutableDictionary<NSString*,NoteCategory*> *categories;

- (void)updateNotesAndCategories;
- (void)updateTextView;
@end
