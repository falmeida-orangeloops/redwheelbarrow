//
//  ViewController.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/3/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models/NoteCategory.h"

@interface ViewController : UIViewController
@property NSArray *notes;
@property NSArray *categories;

- (NoteCategory *)categoryWithId:(NSString *)id;
- (void)updateNotesAndCategories;
- (void)updateTextView;
@end

